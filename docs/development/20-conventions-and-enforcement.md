---
livello: Costituzione
stato: active
---

# 20 — Convenzioni ed enforcement

## Perché questo documento esiste

`AGENTS.md` contiene già una regola dichiarata **mandatory** che vieta i colori
letterali. Il codice ne contiene 216.

Non è mancata disciplina: è mancato un meccanismo. Una regola che nessuno
verifica non è una regola, è un'opinione scritta bene.

Da qui la regola sulle regole:

> Ogni voce di questi documenti è **bloccante** (un lint la verifica e la CI
> fallisce), **verificata** (un test la copre), oppure **dichiarata come
> raccomandazione**. Non esistono altre categorie.

## Lint bloccanti

### Dal pacchetto standard

`analysis_options.yaml` parte da `flutter_lints` e aggiunge:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "qual/**"            # copia di lavoro, 211 dei 308 issue attuali
  errors:
    invalid_annotation_target: ignore
    missing_required_param: error
    missing_return: error

linter:
  rules:
    - always_use_package_imports      # niente import relativi
    - avoid_print
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - unawaited_futures
    - use_build_context_synchronously
    - sort_pub_dependencies
    - avoid_slow_async_io
```

`always_use_package_imports` non è cosmesi: `app_router.dart` oggi mescola
`package:coachly/...` e `../features/...`, il che rende invisibili le violazioni
delle dependency rules a qualsiasi analisi statica.

### Custom lint

Implementati in `tool/coachly_lints/`, agganciati via
`analyzer: plugins: [custom_lint]`. Ogni regola implementa una riga di
`01-principles.md`.

**Stato attuale — 21 violazioni residue** (erano 170 alla prima esecuzione):

| Regola | Residue | Iniziali | Doc |
|---|---|---|---|
| `no_cross_feature_presentation` | 10 | 10 | 01 D4 |
| `no_literal_colors` | 4 | 142 | 09 |
| `no_features_in_core` | 4 | 15 | 01 D5 |
| `no_data_layer_in_presentation` | 3 | 3 | 01 D1 |
| `no_side_effects_in_build` | 0 | 0 | 03 |
| `no_raw_datetime_now` | 0 (attende `core/time`) | — | 19 |
| `no_material_in_application` | 0 (attende `application/`) | — | 01 D2 |
| `no_data_source_outside_repository` | 0 (attende `data/remote`) | — | 01 D6 |

Delle 21 residue, **8 sono in file con modifiche non committate** e non sono
toccabili senza conflitto.

Le 10 `no_cross_feature_presentation` sono **una sola causa**: la feature
workout importa `exercise_info_page/presentation/exercise_theme.dart`. Si
risolvono tutte insieme spostando quel file in `design_system/`, appena i file
in lavorazione sono committati.

Le 4 `no_features_in_core` restanti sono in `local_database_service`,
`workout_adapter` e `auth_interceptor_client`: i primi due spariscono con Hive
nella fase 3, il terzo richiede di invertire la dipendenza verso l'auth
(interfaccia in `core`, implementazione nella feature).

Le tre a zero non trovano nulla perché le cartelle target non esistono ancora:
sono attive in anticipo, così la prima feature scritta secondo la nuova
struttura è già coperta.

Regole ancora da implementare, in ordine di valore:

| Regola | Cosa vieta | Doc | Prerequisito |
|---|---|---|---|
| `no_hardcoded_strings` | stringhe letterali in `Text()` e proprietà user-facing | 13 | ARB (fase 5.2) |
| `no_literal_text_style` | `TextStyle(...)` costruito fuori dai token | 09 | — |
| `no_magic_spacing` | `SizedBox`/`EdgeInsets`/`BorderRadius` con letterali non-token | 09 | — |
| `no_non_material_icons` | import di `ionicons`, `lucide_icons_flutter` | 12 | — |
| `no_manual_uuid` | generazione id fuori da `core/ids/` | 05 | `core/ids` |

`no_magic_spacing` è la più delicata: deve distinguere un numero magico da un
token, quindi va scritta solo dopo che i token di spazio sono realmente in uso,
altrimenti segnala tutto e viene disattivata.

### Regola di adozione

I lint restano `warning` su tutto il repository e sono **bloccanti solo sui file
toccati dal PR**. Attivarli come errore ovunque il primo giorno bloccherebbe
qualsiasi lavoro e finirebbe con un `// ignore_for_file` generalizzato — cioè
esattamente il fallimento di `AGENTS.md`, ripetuto.

Il meccanismo è `tool/check_changed.sh`:

```bash
tool/check_changed.sh              # confronto con origin/master
tool/check_changed.sh develop      # confronto con un'altra base
```

Esce con codice 1 se un file che hai modificato viola una regola, e ignora tutto
il resto. È lo script che la CI esegue sui PR.

Il debito si assorbe file per file, mentre il lint impedisce che ne nasca di
nuovo.

## Test che valgono come regole

Alcune cose non si esprimono in un lint. Diventano test in CI:

| Test | Verifica | Doc |
|---|---|---|
| `l10n_parity_test` | ogni chiave ARB esiste in tutte le lingue | 13 |
| `l10n_unused_test` | nessuna chiave ARB orfana | 13 |
| `tap_target_test` | `androidTapTargetGuideline` sulle schermate principali | 14 |
| `contrast_test` | `textContrastGuideline` | 14 |
| `text_scaling_test` | nessun overflow a `textScaler` 2.0 | 14 |
| `migration_test` | ogni schema Drift migra dallo snapshot precedente | 04 |
| `golden_test` | i componenti del design system non cambiano per caso | 10 |
| `dependency_test` | nessuna dipendenza dichiarata e non usata | 02 |

Il `text_scaling_test` è particolarmente rilevante: `textScaler` oggi ha **zero
occorrenze** nel codice, quindi la app a text scaling alto non è mai stata
verificata da nessuno.

## Pipeline CI

```
flutter analyze                → zero errori
tool/check_changed.sh          → zero violazioni sui file del PR
flutter test                   → tutto verde
dart format --set-exit-if-changed
```

`dart run custom_lint` da solo riporta tutte le violazioni esistenti: serve per
misurare il debito, non come gate.

La suite compila e gira (fase 0.1). Restano 12 test rossi per deriva fra UI e
asserzioni: vedi `26-migration-plan.md`. La CI va attivata accettando quel
residuo come baseline nota, non aspettando che sia zero.

## Convenzioni di codice

**Import** — sempre `package:`, ordinati: Dart, Flutter, pacchetti esterni,
`package:coachly`. Nessun import relativo.

**Async** — `unawaited()` esplicito quando si ignora una Future di proposito.
Mai una Future ignorata in silenzio.

**Context** — mai attraverso un `await` senza `mounted`. Il lint
`use_build_context_synchronously` lo verifica.

**Costruttori** — `const` ovunque possibile. È la singola ottimizzazione con il
miglior rapporto costo/beneficio in Flutter.

**Dispose** — ogni `AnimationController`, `TextEditingController`,
`ScrollController`, `StreamSubscription` ha il suo `dispose`. Nel codice
attuale ci sono 19 `AnimationController` e 46 `StatefulWidget`.

**Commenti** — si commenta il *perché*, mai il *cosa*. Un commento che descrive
il codice sottostante è rumore.

## Definition of done

Una PR è completa quando:

- [ ] `flutter analyze` pulito e `tool/check_changed.sh` verde
- [ ] test verdi, e nuovi test per la logica non banale introdotta
- [ ] nessuna stringa letterale user-facing, nessun colore o misura letterale
- [ ] le dependency rules di `01-principles.md` sono rispettate
- [ ] i target interattivi introdotti sono ≥ 48×48 dp
- [ ] gli stati loading / empty / error sono gestiti, non dimenticati
- [ ] se la PR cambia una decisione architetturale, c'è un ADR

## ADR

Le decisioni vivono in `docs/development/adr/`, numerate, in questo formato:

```markdown
# ADR-00N — Titolo

Stato: proposto | accettato | sostituito da ADR-00M
Data: YYYY-MM-DD

## Contesto
## Decisione
## Conseguenze
## Alternative scartate
```

Una decisione presa e non registrata è una decisione che verrà rimessa in
discussione fra sei mesi senza memoria del perché. Gli ADR-001…006 sono scritti
in `adr/`.
