import 'dart:io';

import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/sync/adapters/workout_adapter.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/session_sync_job_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

void main() {
  group('WorkoutSessionSyncService', () {
    late Directory tempDir;
    late Box<Map> sessionsBox;
    late Box<Map> jobsBox;
    late Box<WorkoutModel> workoutsBox;
    late WorkoutSessionHiveService sessionHiveService;
    late WorkoutHiveService workoutHiveService;
    late _FakeWorkoutPageService fakeWorkoutPageService;

    setUp(() async {
      await Hive.close();
      tempDir = await Directory.systemTemp.createTemp(
        'coachly_workout_session_sync_test_',
      );
      Hive.init(tempDir.path);

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(WorkoutAdapter());
      }

      sessionsBox = await Hive.openBox<Map>('sync_sessions_test_box');
      jobsBox = await Hive.openBox<Map>('sync_jobs_test_box');
      workoutsBox = await Hive.openBox<WorkoutModel>('sync_workouts_test_box');

      sessionHiveService = WorkoutSessionHiveService.fromBoxes(
        sessionsBox: sessionsBox,
        syncJobsBox: jobsBox,
      );
      workoutHiveService = WorkoutHiveService.fromBox(workoutsBox);
      fakeWorkoutPageService = _FakeWorkoutPageService();
    });

    tearDown(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('offline: no BE calls, queued job remains queued', () async {
      final service = WorkoutSessionSyncService(
        sessionHiveService: sessionHiveService,
        workoutPageService: fakeWorkoutPageService,
        workoutHiveService: workoutHiveService,
        isAuthenticatedReader: () => true,
        isOnlineOverride: () async => false,
        invalidateWorkoutCaches: () {},
      );

      await _seedQueuedJob(
        sessionHiveService: sessionHiveService,
        localSessionId: 'offline-session',
      );

      await service.syncPendingSessions(trigger: 'test_offline');

      final job = await sessionHiveService.getSyncJobBySessionId(
        'offline-session',
      );
      expect(fakeWorkoutPageService.uploadCalls, 0);
      expect(fakeWorkoutPageService.patchCalls, 0);
      expect(job, isNotNull);
      expect(job!.status, SessionSyncJobStatus.queued);

      service.dispose();
    });

    test('online: executes POST session then PUT workout in order', () async {
      final service = WorkoutSessionSyncService(
        sessionHiveService: sessionHiveService,
        workoutPageService: fakeWorkoutPageService,
        workoutHiveService: workoutHiveService,
        isAuthenticatedReader: () => true,
        isOnlineOverride: () async => true,
        invalidateWorkoutCaches: () {},
      );

      await workoutsBox.put(
        'workout-1',
        _buildWorkout(id: 'workout-1', dirty: true),
      );
      await _seedQueuedJob(
        sessionHiveService: sessionHiveService,
        localSessionId: 'online-session',
      );

      await service.syncPendingSessions(trigger: 'test_online');

      final job = await sessionHiveService.getSyncJobBySessionId(
        'online-session',
      );
      expect(fakeWorkoutPageService.callSequence, ['post', 'put', 'fetch']);
      expect(job, isNotNull);
      expect(job!.status, SessionSyncJobStatus.synced);

      service.dispose();
    });

    test('transient error: sets retry_wait with nextRetryAt', () async {
      fakeWorkoutPageService.uploadResponse = ApiResponse.error(
        message: 'Temporary server issue',
        statusCode: 500,
      );

      final service = WorkoutSessionSyncService(
        sessionHiveService: sessionHiveService,
        workoutPageService: fakeWorkoutPageService,
        workoutHiveService: workoutHiveService,
        isAuthenticatedReader: () => true,
        isOnlineOverride: () async => true,
        invalidateWorkoutCaches: () {},
      );

      await _seedQueuedJob(
        sessionHiveService: sessionHiveService,
        localSessionId: 'retry-session',
      );

      await service.syncPendingSessions(trigger: 'test_transient');

      final job = await sessionHiveService.getSyncJobBySessionId(
        'retry-session',
      );
      expect(job, isNotNull);
      expect(job!.status, SessionSyncJobStatus.retryWait);
      expect(job.retryCount, 1);
      expect(job.nextRetryAt, isNotNull);

      service.dispose();
    });

    test(
      'permanent error: marks failed_permanent and stops retrying',
      () async {
        fakeWorkoutPageService.uploadResponse = ApiResponse.error(
          message: 'Validation failed',
          statusCode: 400,
        );

        final service = WorkoutSessionSyncService(
          sessionHiveService: sessionHiveService,
          workoutPageService: fakeWorkoutPageService,
          workoutHiveService: workoutHiveService,
          isAuthenticatedReader: () => true,
          isOnlineOverride: () async => true,
          invalidateWorkoutCaches: () {},
        );

        await _seedQueuedJob(
          sessionHiveService: sessionHiveService,
          localSessionId: 'permanent-session',
        );

        await service.syncPendingSessions(trigger: 'test_permanent');

        final job = await sessionHiveService.getSyncJobBySessionId(
          'permanent-session',
        );
        expect(job, isNotNull);
        expect(job!.status, SessionSyncJobStatus.failedPermanent);
        expect(job.nextRetryAt, isNull);

        service.dispose();
      },
    );
  });
}

Future<void> _seedQueuedJob({
  required WorkoutSessionHiveService sessionHiveService,
  required String localSessionId,
}) async {
  final now = DateTime.now().toUtc();

  final session = LocalWorkoutSession(
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
  await sessionHiveService.saveSession(session);

  final job = SessionSyncJob(
    jobId: 'job-$localSessionId',
    localSessionId: localSessionId,
    workoutId: 'workout-1',
    sessionPayloadJson:
        '{"entries":[{"exerciseId":"exercise-1","position":0,"sets":[{"position":0,"reps":10,"load":80,"loadUnit":"kg"}]}]}',
    mergedWorkoutCommandJson:
        '{"name":"Workout","translations":{"it":{"title":"Workout"}},"status":"active","blocks":[]}',
    status: SessionSyncJobStatus.queued,
    retryCount: 0,
    nextRetryAt: null,
    lastError: null,
    createdAt: now,
    updatedAt: now,
  );
  await sessionHiveService.enqueueSyncJob(job);
}

WorkoutModel _buildWorkout({required String id, required bool dirty}) {
  return WorkoutModel(
    id: id,
    titleI18n: const {'it': 'Workout'},
    descriptionI18n: const {'it': 'Desc'},
    goal: 'active',
    lastUsed: DateTime.now().toUtc(),
    type: 'Strength',
    dirty: dirty,
  );
}

class _FakeWorkoutPageService extends WorkoutPageService {
  _FakeWorkoutPageService()
    : super(ApiClient(client: _NoopHttpClient(), baseUrl: 'https://localhost'));

  int uploadCalls = 0;
  int patchCalls = 0;
  final List<String> callSequence = [];

  ApiResponse<void> uploadResponse = ApiResponse.success();
  ApiResponse<void> patchResponse = ApiResponse.success();

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

class _NoopHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError('No real HTTP calls are expected in sync tests.');
  }
}
