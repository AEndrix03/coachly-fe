import 'package:coachly/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Il vantaggio più grande della migrazione da Hive: i repository diventano
/// testabili senza filesystem e senza mock
/// (`docs/development/19-testing.md`).
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('lo schema si crea e parte dalla versione 1', () async {
    expect(db.schemaVersion, 1);
    final meta = await db.select(db.catalogMeta).getSingle();
    expect(meta.version, 0);
  });

  test('il filtro sul catalogo è una WHERE, non una scansione', () async {
    await db.batch((batch) {
      batch.insertAll(db.catalogExercises, [
        CatalogExercisesCompanion.insert(
          id: 'squat',
          difficultyLevel: const Value('advanced'),
          mechanicsType: const Value('multi_joint'),
          bodyweight: const Value(false),
          updatedAt: DateTime(2026),
        ),
        CatalogExercisesCompanion.insert(
          id: 'pushup',
          difficultyLevel: const Value('beginner'),
          mechanicsType: const Value('multi_joint'),
          bodyweight: const Value(true),
          updatedAt: DateTime(2026),
        ),
      ]);
    });

    // È il bug F3 che questo schema chiude: la cache Hive persisteva tre campi
    // mentre il filtro ne interrogava nove, quindi qualsiasi filtro diverso
    // dal testo restituiva zero risultati.
    final beginners = await (db.select(
      db.catalogExercises,
    )..where((t) => t.difficultyLevel.equals('beginner'))).get();

    expect(beginners.map((e) => e.id), ['pushup']);

    final bodyweight = await (db.select(
      db.catalogExercises,
    )..where((t) => t.bodyweight.equals(true))).get();

    expect(bodyweight.map((e) => e.id), ['pushup']);
  });

  test('origin accetta solo user o assigned', () async {
    await db
        .into(db.workouts)
        .insert(
          WorkoutsCompanion.insert(
            id: 'w1',
            origin: const Value('user'),
            lastUsed: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        );

    // Il confine fra dati scritti dall'utente e dati che in futuro scriverà un
    // coach è nello schema, non in una convenzione
    // (`docs/development/04-data-layer.md`).
    await expectLater(
      db
          .into(db.workouts)
          .insert(
            WorkoutsCompanion.insert(
              id: 'w2',
              origin: const Value('coach'),
              lastUsed: DateTime(2026),
              updatedAt: DateTime(2026),
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test(
    'una scrittura e la sua riga di outbox stanno in una transazione',
    () async {
      await db.transaction(() async {
        await db
            .into(db.sessions)
            .insert(
              SessionsCompanion.insert(
                id: 's1',
                workoutId: 'w1',
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            );
        await db
            .into(db.outbox)
            .insert(
              OutboxCompanion.insert(
                id: 'o1',
                entityType: 'session',
                entityId: 's1',
                operation: 'create',
                payload: '{}',
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            );
      });

      expect(await db.select(db.sessions).get(), hasLength(1));
      expect(await db.select(db.outbox).get(), hasLength(1));
    },
  );

  test('una transazione fallita non lascia scritture parziali', () async {
    await expectLater(
      db.transaction(() async {
        await db
            .into(db.sessions)
            .insert(
              SessionsCompanion.insert(
                id: 's2',
                workoutId: 'w1',
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            );
        throw StateError('sync queue write failed');
      }),
      throwsA(isA<StateError>()),
    );

    // Se il dato entrasse senza la sua riga di outbox, l'allenamento
    // resterebbe sul dispositivo e non salirebbe mai.
    expect(await db.select(db.sessions).get(), isEmpty);
  });

  test('le letture sono stream: una scrittura notifica i lettori', () async {
    final emissions = <int>[];
    final subscription = db
        .select(db.workouts)
        .watch()
        .map((rows) => rows.length)
        .listen(emissions.add);

    // Si attende la prima emissione (la tabella vuota) prima di scrivere:
    // altrimenti l'insert può precedere la sottoscrizione e il test misura
    // la sequenza sbagliata.
    await pumpEventQueue();

    await db
        .into(db.workouts)
        .insert(
          WorkoutsCompanion.insert(
            id: 'w3',
            origin: const Value('user'),
            lastUsed: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        );
    await pumpEventQueue();
    await subscription.cancel();

    // È ciò che sostituisce le 35 `ref.invalidate` sparse dopo ogni mutazione
    // (`docs/development/03-state-riverpod.md`).
    expect(emissions, containsAllInOrder([0, 1]));
  });

  test('wipe svuota i dati e ricrea il meta del catalogo', () async {
    await db
        .into(db.workouts)
        .insert(
          WorkoutsCompanion.insert(
            id: 'w4',
            origin: const Value('user'),
            lastUsed: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        );

    await db.wipe();

    expect(await db.select(db.workouts).get(), isEmpty);
    expect(await db.select(db.catalogMeta).get(), hasLength(1));
  });
}
