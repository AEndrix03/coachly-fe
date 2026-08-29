import 'dart:io';

import 'package:coachly/app/sync/adapters/workout_adapter.dart';
import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/time/clock.dart';
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

/// Il backoff del sync diventa verificabile solo con un Clock iniettato:
/// nextRetryAt e' un istante calcolato a partire da "adesso".
void main() {
  group('backoff del sync con FixedClock', () {
    late Directory tempDir;
    late Box<Map> sessionsBox;
    late Box<Map> jobsBox;
    late Box<WorkoutModel> workoutsBox;
    late WorkoutSessionHiveService sessionHiveService;
    late WorkoutHiveService workoutHiveService;
    late _FailingWorkoutPageService workoutPageService;
    late FixedClock clock;

    final frozenNow = DateTime.utc(2026, 3, 28, 23, 55);

    setUp(() async {
      await Hive.close();
      tempDir = await Directory.systemTemp.createTemp('coachly_backoff_test_');
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(WorkoutAdapter());
      }
      sessionsBox = await Hive.openBox<Map>('backoff_sessions_box');
      jobsBox = await Hive.openBox<Map>('backoff_jobs_box');
      workoutsBox = await Hive.openBox<WorkoutModel>('backoff_workouts_box');
      sessionHiveService = WorkoutSessionHiveService.fromBoxes(
        sessionsBox: sessionsBox,
        syncJobsBox: jobsBox,
      );
      workoutHiveService = WorkoutHiveService.fromBox(workoutsBox);
      workoutPageService = _FailingWorkoutPageService();
      clock = FixedClock(frozenNow);
    });

    tearDown(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    WorkoutSessionSyncService buildService() {
      return WorkoutSessionSyncService(
        sessionHiveService: sessionHiveService,
        workoutPageService: workoutPageService,
        workoutHiveService: workoutHiveService,
        isAuthenticatedReader: () => true,
        invalidateWorkoutCaches: () {},
        clock: clock,
        isOnlineOverride: () async => true,
      );
    }

    test('il primo errore transiente programma il retry dal clock', () async {
      final service = buildService();
      await _seedQueuedJob(
        sessionHiveService: sessionHiveService,
        localSessionId: 'backoff-session',
        now: frozenNow,
      );

      await service.syncPendingSessions(trigger: 'test_backoff');

      final job = await sessionHiveService.getSyncJobBySessionId(
        'backoff-session',
      );
      expect(job, isNotNull);
      expect(job!.status, SessionSyncJobStatus.retryWait);
      expect(job.retryCount, 1);
      expect(job.updatedAt, frozenNow);

      // base 5s piu' jitter fino al 20%.
      final delay = job.nextRetryAt!.difference(frozenNow);
      expect(delay, greaterThanOrEqualTo(const Duration(seconds: 5)));
      expect(delay, lessThanOrEqualTo(const Duration(seconds: 6)));

      service.dispose();
    });

    test('il retry attende che il clock raggiunga nextRetryAt', () async {
      final service = buildService();
      await _seedQueuedJob(
        sessionHiveService: sessionHiveService,
        localSessionId: 'backoff-session',
        now: frozenNow,
      );

      await service.syncPendingSessions(trigger: 'first_attempt');
      final callsAfterFirst = workoutPageService.uploadCalls;

      // Il tempo non e' avanzato: il job in retry_wait viene saltato.
      await service.syncPendingSessions(trigger: 'too_early');
      expect(workoutPageService.uploadCalls, callsAfterFirst);

      // Oltre la mezzanotte e oltre il ritardo: il job viene ritentato.
      clock.advance(const Duration(minutes: 10));
      await service.syncPendingSessions(trigger: 'after_delay');
      expect(workoutPageService.uploadCalls, callsAfterFirst + 1);

      final job = await sessionHiveService.getSyncJobBySessionId(
        'backoff-session',
      );
      expect(job!.retryCount, 2);
      expect(job.updatedAt, frozenNow.add(const Duration(minutes: 10)));
      expect(job.updatedAt.day, 29);

      service.dispose();
    });

    test('il backoff cresce e resta limitato a 15 minuti', () async {
      final service = buildService();
      await _seedQueuedJob(
        sessionHiveService: sessionHiveService,
        localSessionId: 'backoff-session',
        now: frozenNow,
      );

      final delays = <Duration>[];
      for (var attempt = 0; attempt < 10; attempt++) {
        await service.syncPendingSessions(trigger: 'attempt');
        final job = await sessionHiveService.getSyncJobBySessionId(
          'backoff-session',
        );
        delays.add(job!.nextRetryAt!.difference(clock.nowUtc()));
        clock.advance(const Duration(hours: 1));
      }

      expect(delays.first, lessThan(const Duration(seconds: 7)));
      expect(delays[3], greaterThan(delays.first));
      expect(delays.last, lessThanOrEqualTo(const Duration(minutes: 18)));

      service.dispose();
    });
  });
}

Future<void> _seedQueuedJob({
  required WorkoutSessionHiveService sessionHiveService,
  required String localSessionId,
  required DateTime now,
}) async {
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
    sessionPayloadJson: '{"entries":[]}',
    mergedWorkoutCommandJson: '{"name":"Workout","blocks":[]}',
    status: SessionSyncJobStatus.queued,
    retryCount: 0,
    nextRetryAt: null,
    lastError: null,
    createdAt: now,
    updatedAt: now,
  );
  await sessionHiveService.enqueueSyncJob(job);
}

class _FailingWorkoutPageService extends WorkoutPageService {
  _FailingWorkoutPageService()
    : super(ApiClient(client: _NoopHttpClient(), baseUrl: 'https://localhost'));

  int uploadCalls = 0;

  @override
  Future<ApiResponse<void>> saveWorkoutSessionPayload(
    String workoutId,
    Map<String, dynamic> payload,
  ) async {
    uploadCalls += 1;
    return ApiResponse.error(
      message: 'Temporary server issue',
      statusCode: 503,
    );
  }
}

class _NoopHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError('No real HTTP calls are expected in sync tests.');
  }
}
