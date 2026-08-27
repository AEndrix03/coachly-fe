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

## Pulizia da fare prima di adottare questa struttura

| Azione | Motivo |
|---|---|
| Rimuovere `lucide_icons_flutter`, `flutter_staggered_animations`, `lottie`, `glass_kit`, `flutter_hooks` | zero utilizzi nel codice |
| Rimuovere `ionicons`, `cupertino_icons` | ADR-003, solo Material |
| Rimuovere `equatable` | usato in 1 file, sostituito da Freezed |
| Rimuovere `hive`, `hive_flutter` | ADR-004 |
| Escludere `qual/` dall'analyzer | 211 dei 308 issue attuali vengono da lì |
| Riparare la suite di test | oggi non compila |
| Spostare `core/text_filter/` nella feature che lo usa | viola la regola su `core/` |
