import 'dart:math';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/features/exercise/data/local/custom_exercise_dao.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/data/services/exercise_info_page_service.dart';
import 'package:coachly/features/sync/data/local/outbox_dao.dart';
import 'package:coachly/features/sessions/data/local/session_dao.dart';
import 'package:coachly/features/workout/data/local/workout_dao.dart';
import 'package:coachly/features/sessions/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/data/services/workout_page_service.dart';
import 'package:coachly/features/sessions/data/services/workout_session_sync_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/network/fake_dio.dart';

void main() {
  late AppDatabase db;
  late FixedClock clock;
  late WorkoutDao workoutDao;
  late SessionDao sessionDao;
  late OutboxDao outboxDao;
  late _FakeWorkoutPageService fakeWorkoutPageService;
  late _FakeExerciseService fakeExerciseService;
  late CustomExerciseDao customExerciseDao;

  final frozenNow = DateTime.utc(2026, 3, 18, 11);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    clock = FixedClock(frozenNow);
    workoutDao = WorkoutDao(db);
    sessionDao = SessionDao(db);
    outboxDao = OutboxDao(db, clock: clock, random: Random(11));
    fakeWorkoutPageService = _FakeWorkoutPageService();
    fakeExerciseService = _FakeExerciseService();
    customExerciseDao = CustomExerciseDao(db, clock, const SilentAppLogger());
  });

  tearDown(() => db.close());

  WorkoutSessionSyncService buildService({required bool online}) {
    return WorkoutSessionSyncService(
      sessionDao: sessionDao,
      workoutDao: workoutDao,
      outboxDao: outboxDao,
      workoutPageService: fakeWorkoutPageService,
      exerciseService: fakeExerciseService,
      customExerciseDao: customExerciseDao,
      isAuthenticatedReader: () => true,
      isOnlineOverride: () async => online,
      clock: clock,
    );
  }

  Future<void> seed({
    required String sessionId,
    required String outboxId,
  }) async {
    await sessionDao.upsert(
      _buildLocalSession(localSessionId: sessionId, now: clock.nowUtc()),
    );
    await outboxDao.enqueue(
      id: outboxId,
      entityType: 'session',
      entityId: sessionId,
      operation: 'create',
      payload:
          '{"entries":[{"exerciseId":"exercise-1","position":0,"sets":[]}]}',
      secondaryPayload: '{"name":"Workout","blocks":[]}',
    );
  }

  test('offline: nessuna chiamata, la riga resta pending', () async {
    final service = buildService(online: false);
    await seed(sessionId: 'offline-session', outboxId: 'o1');

    await service.syncPendingSessions(trigger: 'test_offline');

    expect(fakeWorkoutPageService.uploadCalls, 0);
    expect(fakeWorkoutPageService.patchCalls, 0);
    final row = await outboxDao.getById('o1');
    expect(OutboxStatus.fromValue(row!.status), OutboxStatus.pending);

    service.dispose();
  });

  test('online: POST sessione, poi PUT workout, poi sent', () async {
    final service = buildService(online: true);
    await workoutDao.upsert(_buildWorkout(id: 'workout-1', dirty: true));
    await seed(sessionId: 'online-session', outboxId: 'o1');

    await service.syncPendingSessions(trigger: 'test_online');

    expect(fakeWorkoutPageService.callSequence, ['post', 'put', 'fetch']);
    final row = await outboxDao.getById('o1');
    expect(OutboxStatus.fromValue(row!.status), OutboxStatus.sent);
    final session = await sessionDao.getSession('online-session');
    expect(session!.syncState, LocalWorkoutSessionSyncState.synced);
    expect((await workoutDao.getWorkout('workout-1'))!.dirty, isFalse);

    service.dispose();
  });

  test('errore transiente: torna pending con nextAttemptAt', () async {
    fakeWorkoutPageService.uploadResponse = ApiResponse.error(
      message: 'Temporary server issue',
      statusCode: 500,
    );
    final service = buildService(online: true);
    await seed(sessionId: 'retry-session', outboxId: 'o1');

    await service.syncPendingSessions(trigger: 'test_transient');

    final row = await outboxDao.getById('o1');
    expect(OutboxStatus.fromValue(row!.status), OutboxStatus.pending);
    expect(row.attempts, 1);
    expect(row.nextAttemptAt, isNotNull);
    expect(row.nextAttemptAt!.isAfter(frozenNow), isTrue);

    service.dispose();
  });

  test('errore permanente: failed_permanent e il dato resta', () async {
    fakeWorkoutPageService.uploadResponse = ApiResponse.error(
      message: 'Validation failed',
      statusCode: 400,
    );
    final service = buildService(online: true);
    await seed(sessionId: 'permanent-session', outboxId: 'o1');

    await service.syncPendingSessions(trigger: 'test_permanent');

    final row = await outboxDao.getById('o1');
    expect(OutboxStatus.fromValue(row!.status), OutboxStatus.failedPermanent);
    expect(row.nextAttemptAt, isNull);

    // Il fallimento riguarda la telemetria, non l'utente.
    final session = await sessionDao.getSession('permanent-session');
    expect(session, isNotNull);
    expect(session!.syncState, LocalWorkoutSessionSyncState.failedPermanent);
    expect(session.entries, isNotEmpty);

    service.dispose();
  });

  test('FIFO: un fallimento transiente ferma la coda', () async {
    fakeWorkoutPageService.uploadResponse = ApiResponse.error(
      message: 'Temporary server issue',
      statusCode: 503,
    );
    final service = buildService(online: true);
    await seed(sessionId: 'first-session', outboxId: 'o1');
    clock.advance(const Duration(minutes: 1));
    await seed(sessionId: 'second-session', outboxId: 'o2');

    await service.syncPendingSessions(trigger: 'test_fifo');

    expect(fakeWorkoutPageService.uploadCalls, 1);
    final second = await outboxDao.getById('o2');
    expect(second!.attempts, 0);

    service.dispose();
  });

  test('workout create sale e pulisce dirty', () async {
    final service = buildService(online: true);
    const workoutId = '22222222-2222-4222-8222-222222222222';
    await workoutDao.upsert(_buildWorkout(id: workoutId, dirty: true));
    await outboxDao.enqueue(
      id: 'o1',
      entityType: 'workout',
      entityId: workoutId,
      operation: 'create',
      payload: '{"id":"$workoutId","name":"Offline","blocks":[]}',
    );

    await service.syncPendingSessions(trigger: 'test_workout_create');

    expect(fakeWorkoutPageService.createCalls, 1);
    expect((await workoutDao.getWorkout(workoutId))!.dirty, isFalse);
    expect(
      OutboxStatus.fromValue((await outboxDao.getById('o1'))!.status),
      OutboxStatus.sent,
    );
    service.dispose();
  });

  test('workout delete viene purgato solo dopo la conferma remota', () async {
    final service = buildService(online: true);
    await workoutDao.upsert(_buildWorkout(id: 'workout-1', dirty: true));
    await outboxDao.enqueue(
      id: 'o1',
      entityType: 'workout',
      entityId: 'workout-1',
      operation: 'delete',
      payload: '{}',
    );

    await service.syncPendingSessions(trigger: 'test_workout_delete');

    expect(fakeWorkoutPageService.deleteCalls, 1);
    expect(await workoutDao.getWorkout('workout-1'), isNull);
    service.dispose();
  });

  test(
    'custom exercise create e delete convergono dalla stessa coda',
    () async {
      final service = buildService(online: true);
      const exerciseId = '33333333-3333-4333-8333-333333333333';
      await customExerciseDao.upsert(
        const ExerciseDetailModel(
          id: exerciseId,
          isPersonal: true,
          nameI18n: {'it': 'Offline'},
        ),
      );
      await outboxDao.enqueue(
        id: 'o1',
        entityType: 'custom_exercise',
        entityId: exerciseId,
        operation: 'create',
        payload: '{"id":"$exerciseId","nameI18n":{"it":"Offline"}}',
      );
      clock.advance(const Duration(seconds: 1));
      await outboxDao.enqueue(
        id: 'o2',
        entityType: 'custom_exercise',
        entityId: exerciseId,
        operation: 'delete',
        payload: '{}',
      );

      await service.syncPendingSessions(trigger: 'test_exercise_lifecycle');

      expect(fakeExerciseService.createCalls, 1);
      expect(fakeExerciseService.deleteCalls, 1);
      expect(await db.select(db.customExercises).get(), isEmpty);
      service.dispose();
    },
  );
}

LocalWorkoutSession _buildLocalSession({
  required String localSessionId,
  required DateTime now,
}) {
  return LocalWorkoutSession(
    localSessionId: localSessionId,
    workoutId: 'workout-1',
    startedAt: now.subtract(const Duration(minutes: 30)),
    completedAt: now,
    notes: null,
    entries: const [
      LocalWorkoutSessionEntry(
        exerciseId: 'exercise-1',
        position: 0,
        completed: true,
        notes: null,
        sets: [
          LocalWorkoutSessionSet(
            position: 0,
            setType: 'normal',
            reps: 10,
            load: 80,
            loadUnit: 'kg',
            completed: true,
            notes: null,
          ),
        ],
      ),
    ],
    syncState: LocalWorkoutSessionSyncState.queued,
    retryCount: 0,
    nextRetryAt: null,
    lastError: null,
    createdAt: now,
    updatedAt: now,
  );
}

WorkoutModel _buildWorkout({required String id, required bool dirty}) {
  return WorkoutModel(
    id: id,
    titleI18n: const {'it': 'Workout'},
    descriptionI18n: const {'it': 'Desc'},
    goal: 'active',
    lastUsed: DateTime.utc(2026, 3, 18, 10),
    type: 'Strength',
    dirty: dirty,
  );
}

class _FakeWorkoutPageService extends WorkoutPageService {
  _FakeWorkoutPageService()
    : super(
        ApiClient(dio: fakeDio(FakeDioAdapter()), baseUrl: 'https://localhost'),
      );

  int uploadCalls = 0;
  int patchCalls = 0;
  int createCalls = 0;
  int deleteCalls = 0;
  final List<String> callSequence = [];

  ApiResponse<void> uploadResponse = ApiResponse.success();
  ApiResponse<void> patchResponse = ApiResponse.success();

  @override
  Future<ApiResponse<void>> createWorkoutPayload(
    Map<String, dynamic> commandPayload,
  ) async {
    createCalls += 1;
    return ApiResponse.success();
  }

  @override
  Future<ApiResponse<void>> deleteWorkout(String workoutId) async {
    deleteCalls += 1;
    return ApiResponse.success();
  }

  @override
  Future<ApiResponse<void>> saveWorkoutSessionPayload(
    String workoutId,
    Map<String, dynamic> payload,
  ) async {
    uploadCalls += 1;
    callSequence.add('post');
    return uploadResponse;
  }

  @override
  Future<ApiResponse<void>> patchWorkoutPayload(
    String workoutId,
    Map<String, dynamic> commandPayload,
  ) async {
    patchCalls += 1;
    callSequence.add('put');
    return patchResponse;
  }

  @override
  Future<ApiResponse<List<WorkoutModel>>> fetchWorkouts() async {
    callSequence.add('fetch');
    return ApiResponse.success(
      data: [_buildWorkout(id: 'workout-1', dirty: false)],
    );
  }
}

class _FakeExerciseService extends ExerciseInfoPageService {
  _FakeExerciseService()
    : super(
        ApiClient(dio: fakeDio(FakeDioAdapter()), baseUrl: 'https://localhost'),
      );

  int createCalls = 0;
  int deleteCalls = 0;

  @override
  Future<ApiResponse<void>> createPersonalExercisePayload(
    Map<String, dynamic> body,
  ) async {
    createCalls += 1;
    return ApiResponse.success();
  }

  @override
  Future<ApiResponse<void>> deletePersonalExercise(String exerciseId) async {
    deleteCalls += 1;
    return ApiResponse.success();
  }
}
