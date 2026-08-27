---
livello: Riferimento
stato: active
---

# 21 — Golden path: aggiungere una feature

Vale più di tutte le regole degli altri documenti messe insieme, perché è
l'unica forma di specifica che si segue davvero.

Esempio reale: **"segna un esercizio come preferito"**. Dato utente, locale,
sincronizzato verso il backend, visibile nella libreria.

## 0. Prima di scrivere codice

Tre domande:

| Domanda | Risposta per questo esempio |
|---|---|
| Che classe di dato è? | dato utente → nasce locale, sale in outbox |
| Serve un domain layer? | no, non c'è nessuna regola |
| Serve un componente nuovo? | no, `ExerciseTile` prende uno stato in più |

## 1. Schema — `core/database/tables/favorites.dart`

```dart
class Favorites extends Table {
  TextColumn get exerciseId => text().nullable()();
  TextColumn get customExerciseId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK ((exercise_id IS NULL) <> (custom_exercise_id IS NULL))',
  ];
}
```

Riferimento esclusivo catalogo-o-custom, soft delete, vincolo nello schema.
Si incrementa `schemaVersion` e si esporta lo snapshot.

## 2. DAO — `features/exercises/data/local/favorites_dao.dart`

```dart
Stream<Set<String>> watchFavoriteIds();
Future<void> setFavorite(String exerciseId, bool value);
```

Il DAO non esce da `data/local/`.

## 3. Repository — `features/exercises/data/repositories/`

```dart
abstract interface class FavoritesRepository {
  Stream<Set<String>> watchFavorites();
  Future<Result<void, Failure>> toggle(String exerciseId);
}
```

`toggle` scrive il dato **e** la riga di outbox in **una transazione**:

```dart
await _db.transaction(() async {
  await _dao.setFavorite(exerciseId, value);
  await _outbox.enqueue(
    entityType: 'favorite',
    entityId: exerciseId,
    operation: value ? 'create' : 'delete',
    payload: {...},
  );
});
```

Da qui in poi la UI è già aggiornata e nessuno aspetta la rete.

## 4. Provider — `features/exercises/application/`

```dart
@Riverpod(keepAlive: true)
Stream<Set<String>> favoriteExerciseIds(Ref ref) =>
    ref.watch(favoritesRepositoryProvider).watchFavorites();

@riverpod
class FavoritesController extends _$FavoritesController {
  @override
  void build() {}

  @mutation
  Future<void> toggle(String exerciseId) async {
    final result = await ref.read(favoritesRepositoryProvider).toggle(exerciseId);
    if (result case Err(:final failure)) throw failure;
  }
}
```

`keepAlive` sullo stream (osservato da più schermate), autoDispose sul
controller. La mutation dà alla UI lo stato `Pending`/`Error` senza flag scritti
a mano.

## 5. UI

```dart
class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.name,          // già tradotto
    required this.isFavorite,
    required this.onToggleFavorite,
  });
  …
}
```

Il componente non legge provider e non traduce. La pagina collega:

```dart
final favorites = ref.watch(
  favoriteExerciseIdsProvider.select((s) => s.value ?? const <String>{}),
);
```

`select` perché la lista si ricostruirebbe a ogni cambiamento.

## 6. Testi — `lib/l10n/app_en.arb` e `app_it.arb`

```json
"exerciseAddToFavorites": "Add to favorites",
"exerciseRemoveFromFavorites": "Remove from favorites"
```

Entrambe le lingue insieme: il test di parità fallisce altrimenti.

## 7. Accessibilità

Il bottone è un `IconButton` dentro un target da 48 dp, con
`Semantics(button: true, label: …, selected: isFavorite)` e label che cambia con
lo stato. Niente colore come unico veicolo dello stato: cambia anche l'icona.

## 8. Test

| File | Cosa verifica |
|---|---|
| `favorites_repository_test.dart` | DB in-memory: toggle scrive dato **e** outbox in transazione |
| `favorites_controller_test.dart` | fake repository: la mutation propaga il `Failure` |
| `exercise_tile_golden_test.dart` | preferito/non preferito, scaling 2.0 |
| `exercise_list_a11y_test.dart` | target e label |

## 9. Osservabilità

Un evento analytics `exercise_favorited` con `{source: 'library'|'detail'}`,
registrato in `22-analytics-events.md`. Nessun log tecnico: non è un errore.

## Checklist finale

- [ ] schema con vincoli, `schemaVersion` incrementata, snapshot esportato
- [ ] scrittura dato + outbox in una transazione
- [ ] repository ritorna `Result`, nessun `throw` al confine
- [ ] `keepAlive` dichiarato dove serve, `select` nelle foglie
- [ ] componente senza provider e senza traduzioni
- [ ] chiavi ARB in entrambe le lingue
- [ ] nessun colore, misura o stringa letterale
- [ ] target ≥ 48 dp, semantica con stato
- [ ] test: repository, controller, golden, a11y
- [ ] evento analytics registrato

## Cosa non abbiamo fatto

Nessun `FavoriteUseCase`, nessun `FavoriteService`, nessun `BaseRepository`,
nessuna cartella `domain/`. La feature non ha regole di dominio, quindi non ha un
domain layer.

Aggiungere quei livelli per rispettare un diagramma è l'anti-pattern che
`01-principles.md` vieta esplicitamente.
