---
livello: Costituzione
stato: active
---

# 02 — Struttura del progetto

## Albero di riferimento

```
lib/
├── app/
│   ├── bootstrap.dart          init DB, config, error zone
│   ├── app.dart                MaterialApp.router
│   └── router/
│       ├── app_router.dart
│       ├── routes.dart         enum tipizzata delle destinazioni
│       └── guards.dart
│
├── core/
│   ├── config/                 AppConfig, dart-define, cache mode
│   ├── database/               Drift: schema, DAO, connection, seed
│   ├── network/                ApiClient, coalescing, interceptor
│   ├── result/                 Result<T, Failure>, tassonomia Failure
│   ├── sync/                   outbox, uploader, scheduler
│   ├── media/                  MediaCache, prefetch, budget
│   ├── time/                   Clock iniettabile
│   ├── ids/                    generazione id e idempotency key
│   ├── logging/                AppLogger
│   ├── analytics/              tracker + tassonomia eventi
│   ├── flags/                  FeatureFlags
│   └── observability/          crash reporter, tracer, debug screen
│
├── design_system/
│   ├── tokens/                 colore, tipografia, spazio, raggio, motion
│   ├── theme/                  ThemeData + ThemeExtension
│   ├── components/             componenti con semantica di prodotto
│   └── states/                 loading, empty, error, offline
│
├── l10n/
│   ├── app_en.arb
│   └── app_it.arb
│
└── features/
    ├── exercises/
    ├── workouts/
    ├── active_workout/
    ├── programs/
    ├── progress/
    ├── auth/
    └── profile/
```

## Anatomia di una feature

```
features/<feature>/
├── data/
│   ├── dto/                    modelli di trasporto, mai esposti sopra
│   ├── local/                  DAO Drift della feature
│   ├── remote/                 data source HTTP
│   ├── mappers/                DTO ↔ dominio, entity ↔ dominio
│   └── repositories/           l'unico punto di ingresso ai dati
│
├── domain/                     [solo se la feature lo merita]
│   ├── models/                 modelli Freezed di dominio
│   └── <engine>.dart           regole pure, testabili senza Flutter
│
├── application/
│   └── <nome>_controller.dart  Notifier / AsyncNotifier Riverpod
│
└── presentation/
    ├── pages/
    └── widgets/                widget locali alla feature
```

Regole:

- **Una feature non ha più di un repository per aggregato.** Se ne servono due,
  probabilmente sono due feature.
- **`presentation/widgets/` è per widget che non hanno senso fuori dalla
  feature.** Se un widget serve altrove, sale in `design_system/components/`
  (vedi `10-components.md`), non viene importato da un'altra feature.
- **`dto/` non esce mai da `data/`.** I mapper esistono per questo.

## Naming

| Elemento | Convenzione | Esempio |
|---|---|---|
| File | `snake_case.dart` | `workout_repository.dart` |
| Repository | `<Aggregato>Repository` + `Impl` | `WorkoutRepository`, `WorkoutRepositoryImpl` |
| Data source | `<Aggregato><Local\|Remote>DataSource` | `WorkoutRemoteDataSource` |
| DAO Drift | `<Aggregato>Dao` | `WorkoutDao` |
| Controller | `<Schermo o concetto>Controller` | `ActiveWorkoutController` |
| Provider generato | camelCase del controller | `activeWorkoutControllerProvider` |
| Pagina | `<Nome>Page` | `WorkoutDetailPage` |
| Componente DS | `Coachly<Nome>` o nome di prodotto | `CoachlyButton`, `SetInput` |
| Modello di dominio | sostantivo, senza suffisso | `Workout`, non `WorkoutModel` |
| DTO | `<Nome>Dto` | `ExerciseDetailDto` |

Il suffisso `Model` è **abolito**: oggi indica indistintamente DTO, entity e
modello di dominio, ed è una delle ragioni per cui i confini si sono confusi.

## Regola sulla dimensione dei file

Un file oltre le **400 righe** richiede una motivazione nel PR; oltre le **800**
va diviso.

Non è estetica: è il segnale più affidabile che un widget ha assorbito logica che
appartiene a un controller. Lo stato attuale — `workout_builder_widgets.dart` a
2495 righe, `exercise_info_page.dart` a 1530, `exercise_picker_sheet.dart` a 1443
— è la lista dei posti dove questa architettura non esiste ancora.

## Cartelle vietate

- `utils/`, `helpers/`, `common/`, `misc/` — nomi che non dicono niente e che
  diventano discariche. Un modulo o ha un nome che descrive cosa fa, o non
  merita una cartella.
- `models/` a livello di feature che contenga insieme DTO, entity e modelli di
  dominio.
- Qualsiasi cartella `presentation/` importata da un'altra feature.

## Pulizia prima di adottare questa struttura — fatta

| Azione | Motivo | Stato |
|---|---|---|
| Rimuovere `lucide_icons_flutter`, `flutter_staggered_animations`, `lottie`, `glass_kit`, `flutter_hooks` | zero utilizzi nel codice | ✅ |
| Rimuovere `ionicons`, `cupertino_icons` | ADR-003, solo Material | ✅ |
| Rimuovere `equatable` | usato in 1 file, sostituito da Freezed | ✅ |
| Rimuovere `hive`, `hive_flutter` | ADR-004 | ✅ |
| Escludere `qual/` dall'analyzer | 211 dei 308 issue attuali vengono da lì | ✅ |
| Riparare la suite di test | oggi non compila | ✅ 209 verdi |
| Spostare `core/text_filter/` nella feature che lo usa | viola la regola su `core/` | ✅ in `workout_edit_page/text_filter/` |
| Rimuovere `core/utils/` | cartella vietata | ✅ il debouncer è in `workout_edit_page/search/` |
| Rimuovere `gap`, `collection`, `async`, `flutter_ringtone_player`, `riverpod` diretto | zero import | ✅ con `dependency_test` che impedisce il ritorno |
| `lib/routes/` dentro `lib/app/router/` | due router in due posti | ✅ |
| `lib/pages/` | conteneva solo due `.md` di refactor | ✅ rimossa |

`flutter analyze` è passato da 163 issue a **zero**, e la CI lo tiene lì.

## Il data layer è per aggregato — fatto

I data layer vivevano dentro cartelle di **schermata**: sei `data/` sparsi, e
`workout_page/data/` conteneva insieme schede, sessioni e outbox. Ora sono
**cinque, uno per aggregato**:

```
features/
├── auth/data/
├── exercise/data/      ← era exercise_info_page/data/
├── sessions/data/      ← era dentro workout_page/data/
├── sync/data/          ← l'outbox: e' trasversale, implementa core/sync
└── workout/data/       ← assorbe workout_check, workout_edit_page,
                          workout_active_page e il resto di workout_page
```

Due estrazioni meritano una riga di spiegazione, perché non sono meccaniche.

**L'outbox non appartiene ai workout.** Ci finiscono sessioni, schede ed
esercizi personali (`05-sync-and-offline.md`): stava sotto `workout_page`
solo perché è lì che è stato scritto per primo. `core/sync` ne dichiara
l'interfaccia, `features/sync` la implementa, `app/bootstrap` le collega.

**Le sessioni sono un aggregato, non un dettaglio delle schede.** Sono *il
prodotto* — ciò che l'utente ha davvero fatto — e il doc 04 le vuole come
event log append-only. Tenerle dentro la feature delle schede rendeva quel
passo più difficile di quanto sia.

Prima di questo giro `features/voice/` è stata estratta allo stesso modo, e poi
rimossa del tutto perché non era cablata (vedi `23-voice.md`).

## Quello che resta

**La presentazione è ancora per schermata.** `workout/` contiene otto cartelle
`workout_*_page`, ognuna con le proprie `providers/`, `widgets/` e a volte
`domain/`. Non è più il problema che era — non ci sono più data layer
duplicati né repository che portano il nome di una schermata — ma non è ancora
la struttura del documento.

È lavoro diverso da quello appena fatto: spostare un DAO non cambia niente per
l'utente, mentre riorganizzare la presentazione tocca i file più grandi del
repository (`adaptive_workout_workspace.dart` a 3.854 righe) e va fatto mentre
si lavora a quelle schermate, non in un'unica passata.

