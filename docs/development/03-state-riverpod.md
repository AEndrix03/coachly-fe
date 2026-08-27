---
livello: Standard
stato: active
---

# 03 — Stato e Riverpod

Riverpod 3 è già la versione in uso (`riverpod: ^3.0.3`). Nessun
`StateProvider`, `StateNotifier` o `ChangeNotifier` residuo: il punto di partenza
è pulito e va tenuto tale.

## Cosa è un provider, cosa non è

Riverpod collega e rende reattivi i layer. Non è un layer.

| Uso legittimo | Uso vietato |
|---|---|
| Dependency injection | contenere regole di dominio |
| Stato di UI e di schermata | fare da database |
| Ciclo di vita dei controller | fare da cache persistente |
| Esporre stream del data layer | fare da event bus |

Se un file in `application/` contiene una regola che sopravviverebbe a un
cambio completo di interfaccia, quella regola va in `domain/`.

## Tipi e quando usarli

| Tipo | Uso | Esempio |
|---|---|---|
| `Provider` | dipendenze senza stato | `workoutRepositoryProvider` |
| `Notifier` | stato sincrono di schermata | `WorkoutBuilderController` |
| `AsyncNotifier` | stato che nasce da un'operazione asincrona | `ActiveWorkoutController` |
| `StreamProvider` | proiezione diretta di uno stream Drift | `workoutListProvider` |
| `FutureProvider` | derivazione una-tantum senza comandi | proiezioni di sola lettura |

`FutureProvider` è ammesso solo per derivazioni **senza azioni**. Appena serve un
metodo che modifica lo stato, diventa `AsyncNotifier`.

## Regola: niente side effect nel build

```dart
// VIETATO — presente oggi in FeedbackHubController e WorkoutStatsNotifier
@override
State build() {
  Future.microtask(load);      // side effect nella costruzione dello stato
  return const State(isLoading: true);
}

// CORRETTO
@override
Future<State> build() async {
  return _load();              // AsyncNotifier gestisce loading ed errore
}
```

`AsyncNotifier` esiste esattamente per questo: espone `AsyncLoading`,
`AsyncData`, `AsyncError` senza che tu li debba modellare a mano in uno stato
custom con `isLoading` e `errorMessage`.

## Letture reattive: lo stream, non l'invalidate

Con Drift, una scrittura locale notifica i lettori. La UI si aggiorna perché il
database lo dice, non perché qualcuno ha chiamato `invalidate`.

```dart
@riverpod
Stream<List<Workout>> workoutList(Ref ref) =>
    ref.watch(workoutRepositoryProvider).watchWorkouts();
```

`ref.invalidate` resta legittimo solo per: forzare un refresh richiesto
dall'utente, e reagire a un cambio di identità (logout). Non per propagare una
scrittura: quello lo fa il DB.

Oggi il codice contiene 12 `ref.invalidate(workoutListProvider)` sparsi in 8 file
dopo ogni mutazione. Con gli stream spariscono tutti.

## keepAlive e autoDispose

La regola generale di `@riverpod` è autoDispose. Le eccezioni vanno dichiarate ed
è bene che siano poche.

| Categoria | Lifecycle | Perché |
|---|---|---|
| Repository, data source, servizi core | `keepAlive: true` | singleton stateless, ricrearli è puro costo |
| Stream di dati globali (lista workout) | `keepAlive: true` | osservati da più schermate |
| Controller di schermata | autoDispose | muoiono con la pagina |
| `family` per id (dettaglio esercizio) | autoDispose | altrimenti la mappa cresce senza limite |

> **Precedente da non ripetere.** Oggi `exerciseInfoPageRepositoryProvider` è
> autoDispose e le sue mappe di deduplica sopravvivono solo perché
> `appDataSyncServiceProvider` lo tiene in vita per caso. Un `keepAlive` esplicito
> non è ottimizzazione: è la differenza fra corretto per design e corretto per
> coincidenza.

## Granularità: `.select()`

Oggi: 97 `ref.watch` contro **5 `.select()`**. Ogni widget si ricostruisce per
qualsiasi cambiamento dello stato che osserva.

```dart
// ricostruisce a ogni serie completata, a ogni tick del timer
final state = ref.watch(activeWorkoutControllerProvider);
Text(state.currentExercise.name);

// ricostruisce solo quando cambia il nome
final name = ref.watch(
  activeWorkoutControllerProvider.select((s) => s.currentExercise.name),
);
```

Regola: in una schermata ad alta frequenza di aggiornamento — il logger su tutte
— **ogni `ref.watch` in un widget foglia usa `select`**.

## Provider fragmentation

Uno stato coerente appartiene a un controller solo.

```
// NO
currentSetWeightProvider, currentSetRepsProvider,
currentSetRirProvider, currentExerciseIndexProvider…

// SÌ
ActiveWorkoutController
  ├─ stato: ActiveWorkoutState (Freezed)
  └─ comandi: completeSet, changeLoad, changeReps,
              substituteExercise, startRest, …
```

La granularità nella lettura si ottiene con `select`, non spezzando lo stato in
provider separati che poi devono restare coerenti fra loro.

## Mutations (Riverpod 3)

Le azioni utente espongono nativamente il proprio ciclo di vita:

```dart
@riverpod
class WorkoutController extends _$WorkoutController {
  @mutation
  Future<void> deleteWorkout(String id) async { … }
}
```

La UI osserva `Idle / Pending / Success / Error` senza modellare a mano flag di
caricamento, ed è il meccanismo su cui si appoggia la distinzione fra errore di
lettura ed errore di azione descritta in `07-errors-and-feedback.md`.

> La **persistenza offline** di Riverpod 3 è dichiarata sperimentale e **non si
> usa**: il database è Drift, esplicito e sotto il nostro controllo.

## Widget

| Serve | Usa |
|---|---|
| leggere provider | `ConsumerWidget` |
| leggere provider + controller locali (scroll, animazioni, focus) | `ConsumerStatefulWidget` |
| niente provider, niente stato | `StatelessWidget` |

Oggi ci sono 46 `StatefulWidget` contro 15 `ConsumerWidget`. Uno `StatefulWidget`
si giustifica solo con risorse che vogliono `dispose`.

`ref.read` solo dentro i callback. `ref.watch` solo dentro `build`. Mai il
contrario.

## Test

I controller si testano con `ProviderContainer` e override dei repository con
fake — mai con mock del data layer reale. Vedi `19-testing.md`.

```dart
final container = ProviderContainer(overrides: [
  workoutRepositoryProvider.overrideWithValue(FakeWorkoutRepository()),
]);
addTearDown(container.dispose);
```

## Riferimenti

- [Riverpod 3 — What's new](https://riverpod.dev/docs/whats_new)
- [Riverpod — Offline persistence (experimental)](https://riverpod.dev/docs/concepts2/offline)
- [Riverpod — About code generation](https://riverpod.dev/docs/concepts/about_code_generation)
