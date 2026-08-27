---
livello: Costituzione
stato: active
---

# 04 — Data layer

## Il modello mentale

Tre classi di dati, con proprietà diverse e regole diverse. Confonderle è la
causa della maggior parte dei problemi di caching.

| Classe | Chi la scrive | Come arriva | Se la perdi |
|---|---|---|---|
| **Catalogo** | Coachly, a build time | spedito nel bundle, aggiornato a delta | la riscarichi, nessun danno |
| **Dati utente** | l'utente, sul dispositivo | nasce locale, sale in outbox | **perdita irreversibile** |
| **Dati assegnati** | il coach, in futuro | scende dal server | la riscarichi |

Il flag di debug, i TTL, le policy di refresh non si applicano "alla cache": si
applicano a una di queste tre classi per volta.

## Il catalogo non si scarica

Il catalogo esercizi è dati di riferimento: grande, quasi statico, identico per
tutti gli utenti. Non ha senso che ogni installazione lo scarichi.

```
build time                     runtime
────────────                   ───────
BE  →  export  →  catalog.sqlite  →  asset nel bundle
                                          │
                            primo avvio:  copia su disco
                                          │
                            poi:          GET /catalog/delta?since=N
```

Regole:

1. `assets/db/catalog.sqlite` è generato in CI dal backend, versionato con un
   intero monotono `catalog_version`.
2. Al primo avvio viene copiato, non parsato. Nessun JSON, nessuna
   deserializzazione: una copia di file.
3. Gli aggiornamenti sono **delta versionati**, non ri-download completi.
   `GET /catalog/delta?since=<version>` ritorna solo le righe cambiate.
4. Il delta si applica al massimo **una volta per sessione applicativa**, e mai
   in modo bloccante per la UI.
5. Se il file asset manca o è corrotto, il fallback è un download completo. È un
   percorso di emergenza, non il percorso normale.

Questo elimina strutturalmente il download del catalogo a ogni foreground e il
`GET /exercises/filtered` con payload completo che oggi alimenta le liste.

## Schema

### Catalogo — server-authored, sostituibile

```
catalog_meta(version, applied_at)

exercises(
  id TEXT PK, code TEXT UNIQUE, catalog_status, exercise_kind,
  joint_class, force_type, mechanics_type, difficulty_level,
  technical_demand, stability_demand, spinal_loading,
  resistance_source, resistance_profile, kinetic_chain,
  unilateral BOOL, bodyweight BOOL,
  evidence_basis, confidence
)

muscles(id PK, code UNIQUE)
equipment(id PK, code UNIQUE)
movement_patterns(id PK, code UNIQUE)
joint_actions(id PK, joint_code, action_code)

exercise_muscles(exercise_id, muscle_id, involvement,
                 tension_lengthened, tension_midrange, tension_shortened)
exercise_equipment(exercise_id, equipment_id, required BOOL)
exercise_patterns(exercise_id, pattern_id, role)
exercise_joint_actions(exercise_id, joint_action_id)
exercise_variants(exercise_id, variant_exercise_id, variation_axis)
exercise_media(id PK, exercise_id, media_type, remote_url,
               thumbnail_url, is_primary BOOL, is_public BOOL)
exercise_safety(exercise_id PK, spotter_policy)

i18n(entity_type, entity_id, field, locale, value)
  PK (entity_type, entity_id, field, locale)
```

Indici obbligatori su tutte le colonne usate dai filtri della libreria:
`difficulty_level`, `mechanics_type`, `force_type`, `unilateral`, `bodyweight`,
più gli indici di join sulle tabelle ponte.

> **Nota.** Il bug che oggi fa tornare zero risultati a qualsiasi filtro diverso
> dal testo nasce dal fatto che la cache persiste tre campi mentre il filtro ne
> interroga nove. Con questo schema quella incoerenza non compila.

### i18n dei dati

I testi localizzati del catalogo (`nameI18n`, `descriptionI18n`, `tipsI18n`,
`commonMistakesI18n`) **non** sono colonne per lingua: stanno nella tabella
`i18n`, chiave `(entity_type, entity_id, field, locale)`.

Il bundle spedisce `it` ed `en`. Aggiungere una lingua è un delta, non una
migrazione di schema.

La catena di fallback è unica e centralizzata: `<lang>_<country>` → `<lang>` →
`en` → prima disponibile. Nessuna feature la reimplementa.

### Dati utente — client-authored, insostituibili

```
custom_exercises(
  id PK, created_at, updated_at, deleted_at NULL,
  difficulty_level, mechanics_type, force_type,
  unilateral BOOL, bodyweight BOOL
)
-- i testi vanno in i18n con entity_type='custom_exercise'

workouts(
  id PK, title, goal, notes,
  created_at, updated_at, deleted_at NULL,
  active BOOL, archived BOOL,
  origin TEXT CHECK(origin IN ('user','assigned')) DEFAULT 'user',
  source_program_id NULL       -- valorizzato solo se origin='assigned'
)

workout_blocks(id PK, workout_id FK, position, kind, rest_seconds)
  kind ∈ straight | superset | circuit

workout_entries(id PK, block_id FK, position, notes,
                exercise_id NULL, custom_exercise_id NULL,
                CHECK (exercise_id IS NOT NULL) <> (custom_exercise_id IS NOT NULL))

workout_sets(id PK, entry_id FK, position, kind,
             reps, load, load_unit, rest_seconds, rir, tempo)
  kind ∈ warmup | working | drop | amrap | failure
```

Il riferimento a un esercizio è **esclusivo**: o catalogo o custom, mai entrambi,
mai una stringa libera. Il vincolo è nello schema, non nel codice.

### Sessioni — append-only, è il prodotto

```
sessions(id PK, workout_id, started_at, completed_at NULL,
         status, client_session_id UNIQUE)

session_events(
  id PK, session_id FK, seq INTEGER, occurred_at,
  type TEXT, payload TEXT   -- JSON
)
  UNIQUE(session_id, seq)
```

`session_events` è **append-only**: nessun `UPDATE`, nessun `DELETE`. È
contemporaneamente il formato di sync più semplice possibile (append idempotente
per `(session_id, seq)`) e il dataset che serve al backend per capire *come* si
allenano le persone — non solo il risultato finale.

Tipi di evento minimi:

```
session_started        set_completed         set_skipped
exercise_substituted   load_changed          reps_changed
rest_started           rest_ended            note_added
session_paused         session_resumed       session_completed
```

Lo stato corrente di una sessione è una **proiezione** degli eventi, non una
tabella autoritativa. Se serve per performance, è una tabella materializzata
ricostruibile, e va marcata come tale.

### Sync

```
outbox(
  id PK, entity_type, entity_id, operation, payload TEXT,
  created_at, attempts INT, next_attempt_at NULL,
  status TEXT, last_error NULL
)
  status ∈ pending | sending | sent | failed_permanent
```

Nessuno stato `conflict` o `rejected_by_server`: il client è l'autore. Vedi
`05-sync-and-offline.md`.

### Media

```
media_cache(
  asset_id PK, exercise_id, kind, remote_url,
  local_path NULL, bytes INT, downloaded_at, last_used_at
)
```

I byte stanno sul filesystem, mai nel database. Vedi `16-media.md`.

### Dati assegnati — server-authored, oggi vuoti

```
programs(id PK, coach_id, title, published_at, revision)
program_assignments(id PK, program_id, assigned_at, starts_at, ends_at)
```

Sono dichiarate ora **anche se restano vuote**, perché il confine deve esistere
prima che serva. Le schede assegnate da un coach saranno `workouts` con
`origin='assigned'`: quando arriveranno, l'autorità su quelle righe passerà al
server senza toccare lo schema di quelle dell'utente.

## Regole del data layer

1. **Il repository è l'unico punto di ingresso.** I DAO Drift non escono da
   `data/local/`, i data source HTTP non escono da `data/remote/`.
2. **Un repository per aggregato**, non per schermata.
3. **Ogni metodo pubblico ritorna `Result<T, Failure>`.** Nessun `throw` che
   attraversa il confine, nessuna `ApiResponse` esposta sopra.
4. **Le letture reattive sono stream Drift** (`watch`), non polling né
   invalidazioni manuali. Una scrittura locale aggiorna la UI perché il DB
   notifica, non perché qualcuno ha chiamato `invalidate`.
5. **Ogni scrittura utente è una transazione unica** che comprende il dato e la
   riga di outbox. Mai due write separate.
6. **La formattazione non esiste qui.** Niente `"3x10"`, niente `"90s"`, niente
   `"75kg"`. Numeri e unità; le stringhe le costruisce la presentazione.

## Cosa non sta in Drift

| Dato | Dove | Perché |
|---|---|---|
| Token, refresh token | `flutter_secure_storage` | segreti |
| Lingua, tema, tab iniziale, tour visto | `SharedPreferencesAsync` | preferenze banali, perderle è irrilevante |
| Byte di immagini e video | filesystem + `media_cache` | il DB non è un blob store |
| Stato effimero di UI | Riverpod | non sopravvive alla sessione per definizione |

## Migrazioni

Nessuna migrazione dai box Hive: ADR-005, l'app non ha utenti in produzione.
Hive viene rimosso, il database viene creato da zero.

Da qui in avanti, però, valgono le regole normali di Drift:

- ogni cambio di schema incrementa `schemaVersion`;
- lo snapshot dello schema viene esportato e versionato in
  `drift_schemas/` a ogni release;
- ogni migrazione ha un test che parte dallo snapshot precedente.

Questa disciplina va attivata **dal primo giorno**, non quando servirà.

## Riferimenti

- [Drift — Importing and exporting databases](https://drift.simonbinder.eu/examples/existing_databases/)
- [Drift — Exporting schemas](https://drift.simonbinder.eu/migrations/exports/)
- [Flutter — Offline-first support](https://docs.flutter.dev/app-architecture/design-patterns/offline-first)
