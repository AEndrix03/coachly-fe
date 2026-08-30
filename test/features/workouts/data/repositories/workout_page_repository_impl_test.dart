import 'dart:math';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/ids/id_generator.dart';
import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/sessions/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/sync/data/local/outbox_dao.dart';
import 'package:coachly/features/sessions/data/local/session_dao.dart';
import 'package:coachly/features/workouts/data/local/workout_dao.dart';
import 'package:coachly/features/sessions/domain/models/local_workout_session_model.dart';
import 'package:coachly/features/workouts/domain/models/workout_exercise_model.dart';
import 'package:coachly/features/workouts/domain/models/workout_model.dart';
import 'package:coachly/features/workouts/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workouts/data/services/workout_page_service.dart';
import 'package:coachly/features/sessions/data/services/workout_session_sync_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/network/fake_dio.dart';

const _exerciseId = '11111111-1111-4111-8111-111111111111';

/// Il repository non ha piu' bisogno di filesystem ne' di mock: il database
/// sta in memoria (`docs/development/19-testing.md`).
void main() {
  late AppDatabase db;
  late WorkoutDao workoutDao;
  late SessionDao sessionDao;
  late OutboxDao outboxDao;
  late FixedClock clock;
  late _FakeWorkoutPageService fakeWorkoutPageService;
  late WorkoutSessionSyncService syncService;
  late WorkoutPageRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    clock = FixedClock(DateTime.utc(2026, 3, 18, 11));
    workoutDao = WorkoutDao(db);
    sessionDao = SessionDao(db);
    outboxDao = OutboxDao(db, clock: clock, random: Random(7));
    fakeWorkoutPageService = _FakeWorkoutPageService();
    syncService = WorkoutSessionSyncService(
      sessionDao: sessionDao,
      workoutDao: workoutDao,
      outboxDao: outboxDao,
      workoutPageService: fakeWorkoutPageService,
      isAuthenticatedReader: () => true,
      isOnlineOverride: () async => false,
      clock: clock,
    );
    repository = WorkoutPageRepositoryImpl(
      apiService: fakeWorkoutPageService,
      workoutDao: workoutDao,
      sessionDao: sessionDao,
      outboxDao: outboxDao,
      database: db,
      sessionSyncService: syncService,
      clock: clock,
      idGenerator: SequentialIdGenerator(),
    );

    await workoutDao.upsert(_buildWorkout());
  });

  tearDown(() async {
    syncService.dispose();
    await db.close();
  });

  group('saveSession', () {
    test('scrive sessione e riga di outbox nella stessa transazione', () async {
      final response = await repository.saveSession(
        'workout-1',
        _buildSession(),
      );

      // Un Result di successo non porta messaggi: il `message` di un Failure e'
      // diagnostico e non e' contenuto da asserire
      // (`docs/development/07-errors-and-feedback.md`). Cio' che conta e' che
      // sessione e riga di outbox siano entrambe presenti.
      expect(response.isOk, isTrue);

      final sessions = await sessionDao.getSessionsForWorkout('workout-1');
      expect(sessions, hasLength(1));
      expect(sessions.first.syncState, LocalWorkoutSessionSyncState.queued);

      final pending = await outboxDao.pendingOrdered();
      expect(pending, hasLength(1));
      expect(pending.first.entityType, 'session');
      expect(pending.first.entityId, sessions.first.localSessionId);
      expect(
        OutboxStatus.fromValue(pending.first.status),
        OutboxStatus.pending,
      );
    });

    test('se la riga di outbox non entra, la sessione non resta', () async {
      // `SequentialIdGenerator` rende prevedibile la chiave: occupandola si
      // fa fallire l'INSERT in outbox. Se la sessione sopravvivesse,
      // l'allenamento resterebbe sul dispositivo e non salirebbe mai.
      await outboxDao.enqueue(
        id: 'idem-1',
        entityType: 'session',
        entityId: 'other-session',
        operation: 'create',
        payload: '{}',
      );

      final response = await repository.saveSession(
        'workout-1',
        _buildSession(),
      );

      expect(response.isOk, isFalse);
      expect(await sessionDao.getAllSessions(), isEmpty);
      expect(await outboxDao.pendingOrdered(), hasLength(1));
    });

    test('aggiorna la scheda locale prima di qualsiasi rete', () async {
      await repository.saveSession('workout-1', _buildSession());

      final updatedWorkout = await workoutDao.getWorkout('workout-1');
      expect(updatedWorkout, isNotNull);
      expect(updatedWorkout!.dirty, isTrue);
      expect(updatedWorkout.workoutExercises.first.sets, '2x10');
      expect(updatedWorkout.workoutExercises.first.weight, '85kg');
      expect(fakeWorkoutPageService.uploadCalls, 0);
      expect(fakeWorkoutPageService.patchCalls, 0);
    });

    test('un failed_permanent non cancella il dato locale', () async {
      await repository.saveSession('workout-1', _buildSession());
      final row = (await outboxDao.pendingOrdered()).single;

      await outboxDao.markFailedPermanent(row.id, error: '[400] rejected');

      expect(await sessionDao.getAllSessions(), hasLength(1));
      expect(await workoutDao.getWorkout('workout-1'), isNotNull);
      expect(await outboxDao.pendingOrdered(), isEmpty);
      final failed = await outboxDao.getById(row.id);
      expect(
        OutboxStatus.fromValue(failed!.status),
        OutboxStatus.failedPermanent,
      );
    });
  });

  group('letture reattive', () {
    test('watchWorkouts emette dopo una scrittura', () async {
      final counts = <int>[];
      final subscription = repository.watchWorkouts().listen(
        (workouts) => counts.add(workouts.length),
      );
      await pumpEventQueue();

      await workoutDao.upsert(_buildWorkout().copyWith(id: 'workout-2'));
      await pumpEventQueue();
      await subscription.cancel();

      // E' cio' che sostituisce le `ref.invalidate` dopo ogni mutazione.
      expect(counts, containsAllInOrder([1, 2]));
    });

    test('watchSessions emette dopo il salvataggio di una sessione', () async {
      final counts = <int>[];
      final subscription = repository.watchSessions().listen(
        (sessions) => counts.add(sessions.length),
      );
      await pumpEventQueue();

      await repository.saveSession('workout-1', _buildSession());
      await pumpEventQueue();
      await subscription.cancel();

      expect(counts, containsAllInOrder([0, 1]));
    });
  });

  group('getWorkoutStats', () {
    test('esclude le sessioni failed_permanent dai conteggi', () async {
      final monday = _startOfWeek(clock.now());

      await sessionDao.upsert(
        _buildLocalSession(
          localSessionId: 'ok-1',
          completedAt: monday.add(const Duration(hours: 8)),
          syncState: LocalWorkoutSessionSyncState.synced,
        ),
      );
      await sessionDao.upsert(
        _buildLocalSession(
          localSessionId: 'ok-2',
          completedAt: monday.add(const Duration(days: 1, hours: 9)),
          syncState: LocalWorkoutSessionSyncState.queued,
        ),
      );
      await sessionDao.upsert(
        _buildLocalSession(
          localSessionId: 'bad-1',
          completedAt: monday.add(const Duration(days: 2, hours: 10)),
          syncState: LocalWorkoutSessionSyncState.failedPermanent,
        ),
      );

      final stats = await repository.getWorkoutStats();

      expect(stats.isOk, isTrue);
      expect(stats.valueOrNull!.weeklyWorkouts, 2);
      expect(stats.valueOrNull!.completedWorkouts, 2);
    });

    test('lo streak conta i giorni locali consecutivi', () async {
      final today = clock.now();
      final d0 = DateTime(today.year, today.month, today.day, 10);
      final d1 = d0.subtract(const Duration(days: 1));
      final d2 = d0.subtract(const Duration(days: 3));

      for (final entry in {'streak-1': d0, 'streak-2': d1, 'gap': d2}.entries) {
        await sessionDao.upsert(
          _buildLocalSession(
            localSessionId: entry.key,
            completedAt: entry.value,
            syncState: LocalWorkoutSessionSyncState.synced,
          ),
        );
      }

      final stats = await repository.getWorkoutStats();

      expect(stats.isOk, isTrue);
      expect(stats.valueOrNull!.currentStreak, 2);
    });
  });

  group('scritture locali', () {
    test('disableWorkout marca la scheda dirty', () async {
      await repository.disableWorkout('workout-1');

      final workout = await workoutDao.getWorkout('workout-1');
      expect(workout!.active, isFalse);
      expect(workout.dirty, isTrue);
      final pending = await outboxDao.pendingOrdered();
      expect(pending.single.entityType, 'workout');
      expect(pending.single.operation, 'update');
    });

    test('una nuova scheda viene persistita con operazione create', () async {
      final created = _buildWorkout().copyWith(
        id: '22222222-2222-4222-8222-222222222222',
      );

      final result = await repository.updateWorkout(created);

      expect(result.isOk, isTrue);
      expect(await workoutDao.getWorkout(created.id), isNotNull);
      final pending = await outboxDao.pendingOrdered();
      expect(pending.single.operation, 'create');
      expect(pending.single.payload, contains(created.id));
    });

    test('delete applica una tombstone e accoda senza rete', () async {
      final result = await repository.deleteWorkout('workout-1');

      expect(result.isOk, isTrue);
      expect(await workoutDao.getWorkouts(), isEmpty);
      expect(await workoutDao.getWorkout('workout-1'), isNotNull);
      final pending = await outboxDao.pendingOrdered();
      expect(pending.single.operation, 'delete');
      expect(fakeWorkoutPageService.deleteCalls, 0);
    });

    test('patchWorkouts non calpesta una scheda dirty', () async {
      await repository.disableWorkout('workout-1');

      await workoutDao.patchWorkouts([
        _buildWorkout().copyWith(active: true),
      ], updatedAt: clock.nowUtc());

      // Il client e' l'autore: il remoto non corregge cio' che non e' salito.
      final workout = await workoutDao.getWorkout('workout-1');
      expect(workout!.active, isFalse);
    });
  });
}

DateTime _startOfWeek(DateTime instant) {
  final day = DateTime(instant.year, instant.month, instant.day);
  return day.subtract(Duration(days: day.weekday - 1));
}

LocalWorkoutSession _buildLocalSession({
  required String localSessionId,
  required DateTime completedAt,
  required LocalWorkoutSessionSyncState syncState,
}) {
  return LocalWorkoutSession(
    localSessionId: localSessionId,
    workoutId: 'workout-1',
    startedAt: completedAt.subtract(const Duration(minutes: 45)),
    completedAt: completedAt,
    notes: null,
    entries: const [],
    syncState: syncState,
    retryCount: 0,
    nextRetryAt: null,
    lastError: null,
    createdAt: completedAt,
    updatedAt: completedAt,
  );
}

WorkoutModel _buildWorkout() {
  return WorkoutModel(
    id: 'workout-1',
    titleI18n: const {'it': 'Push Day'},
    descriptionI18n: const {'it': 'Desc'},
    goal: 'strength',
    lastUsed: DateTime.parse('2026-03-18T10:00:00.000Z'),
    type: 'Strength',
    workoutExercises: const [
      WorkoutExerciseModel(
        id: 'entry-1',
        exercise: ExerciseDetailModel(id: _exerciseId),
        sets: '2x8',
        rest: '90s',
        weight: '80kg',
        progress: 0,
      ),
    ],
    exercises: 1,
    sessionsCount: 4,
  );
}

WorkoutSessionWriteCommand _buildSession() {
  return WorkoutSessionWriteCommand(
    startedAt: DateTime.parse('2026-03-18T10:00:00.000Z'),
    completedAt: DateTime.parse('2026-03-18T10:45:00.000Z'),
    notes: null,
    entries: const [
      WorkoutSessionEntryWritePayload(
        exerciseId: _exerciseId,
        position: 0,
        completed: true,
        notes: null,
        sets: [
          WorkoutSessionSetWritePayload(
            position: 0,
            setType: 'normal',
            reps: 10,
            load: 85,
            loadUnit: 'kg',
            completed: true,
            notes: null,
          ),
        ],
      ),
    ],
  );
}

class _FakeWorkoutPageService extends WorkoutPageService {
  _FakeWorkoutPageService()
    : super(
        ApiClient(dio: fakeDio(FakeDioAdapter()), baseUrl: 'https://localhost'),
      );

  int uploadCalls = 0;
  int patchCalls = 0;
  int deleteCalls = 0;

  @override
  Future<ApiResponse<void>> saveWorkoutSessionPayload(
    String workoutId,
    Map<String, dynamic> payload,
  ) async {
    uploadCalls += 1;
    return ApiResponse.success();
  }

  @override
  Future<ApiResponse<void>> patchWorkoutPayload(
    String workoutId,
    Map<String, dynamic> commandPayload,
  ) async {
    patchCalls += 1;
    return ApiResponse.success();
  }

  @override
  Future<ApiResponse<void>> deleteWorkout(String workoutId) async {
    deleteCalls += 1;
    return ApiResponse.success();
  }
}
