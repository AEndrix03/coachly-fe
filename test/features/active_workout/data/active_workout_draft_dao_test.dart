import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/active_workout/data/local/active_workout_draft_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late FixedClock clock;
  late ActiveWorkoutDraftDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FixedClock(DateTime.utc(2026, 3, 4, 18, 30));
    dao = ActiveWorkoutDraftDao(db, clock, const SilentAppLogger());
  });

  tearDown(() => db.close());

  test('round-trip di una bozza', () async {
    final payload = <String, dynamic>{
      'sessionId': 'w1:1',
      'phase': 'exercising',
      'sessionChanges': ['load_changed'],
      'sets': [
        {'setId': 's1', 'weight': 80.0, 'reps': 8, 'completed': true},
      ],
    };

    await dao.save('w1', payload);
    expect(await dao.read('w1'), payload);
  });

  test('la bozza si sovrascrive, non si accumula', () async {
    await dao.save('w1', {'phase': 'exercising'});
    clock.advance(const Duration(minutes: 3));
    await dao.save('w1', {'phase': 'resting'});

    final rows = await db.select(db.activeWorkoutDrafts).get();
    expect(rows, hasLength(1));
    expect(rows.single.updatedAt.toUtc(), DateTime.utc(2026, 3, 4, 18, 33));

    final draft = await dao.read('w1');
    expect(draft!['phase'], 'resting');
  });

  test('delete rimuove la bozza, read torna null', () async {
    await dao.save('w1', {'phase': 'exercising'});
    await dao.delete('w1');
    expect(await dao.read('w1'), isNull);
  });

  test('una bozza illeggibile non fa esplodere la lettura', () async {
    await db
        .into(db.activeWorkoutDrafts)
        .insert(
          ActiveWorkoutDraftRow(
            workoutId: 'w2',
            payload: 'not json',
            updatedAt: clock.nowUtc(),
          ),
        );

    // Si riparte dalla scheda, che e il dato autoritativo.
    expect(await dao.read('w2'), isNull);
  });

  test('watch notifica i lettori a ogni scrittura', () async {
    final emissions = <String?>[];
    final subscription = dao
        .watch('w1')
        .map((draft) => draft?['phase'] as String?)
        .listen(emissions.add);
    await pumpEventQueue();

    await dao.save('w1', {'phase': 'exercising'});
    await pumpEventQueue();
    await subscription.cancel();

    expect(emissions, containsAllInOrder([null, 'exercising']));
  });
}
