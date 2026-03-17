import 'dart:io';

import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/session_sync_job_model.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_hive_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  group('WorkoutSessionHiveService', () {
    late Directory tempDir;
    late Box<Map> sessionsBox;
    late Box<Map> jobsBox;
    late WorkoutSessionHiveService service;

    setUp(() async {
      await Hive.close();
      tempDir = await Directory.systemTemp.createTemp(
        'coachly_workout_session_hive_test_',
      );
      Hive.init(tempDir.path);
      sessionsBox = await Hive.openBox<Map>('sessions_test_box');
      jobsBox = await Hive.openBox<Map>('jobs_test_box');
      service = WorkoutSessionHiveService.fromBoxes(
        sessionsBox: sessionsBox,
        syncJobsBox: jobsBox,
      );
    });

    tearDown(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('enqueue + dequeue sync job', () async {
      final job = _buildJob(
        jobId: 'job-1',
        status: SessionSyncJobStatus.queued,
        nextRetryAt: null,
      );

      await service.enqueueSyncJob(job);
      final pendingJobs = await service.getPendingJobsOrdered();
      expect(pendingJobs, hasLength(1));
      expect(pendingJobs.first.jobId, 'job-1');

      await service.dequeueSyncJob(job.jobId);
      final afterDequeue = await service.getPendingJobsOrdered();
      expect(afterDequeue, isEmpty);
    });

    test('recovers jobs and sessions after app restart', () async {
      final session = _buildSession(
        localSessionId: 'session-restart',
        syncState: LocalWorkoutSessionSyncState.queued,
        retryCount: 0,
        nextRetryAt: null,
      );
      final job = _buildJob(
        jobId: 'job-restart',
        localSessionId: session.localSessionId,
        status: SessionSyncJobStatus.queued,
        nextRetryAt: null,
      );

      await service.saveSession(session);
      await service.enqueueSyncJob(job);

      await Hive.close();
      Hive.init(tempDir.path);
      sessionsBox = await Hive.openBox<Map>('sessions_test_box');
      jobsBox = await Hive.openBox<Map>('jobs_test_box');
      service = WorkoutSessionHiveService.fromBoxes(
        sessionsBox: sessionsBox,
        syncJobsBox: jobsBox,
      );

      final recoveredSession = await service.getSession(session.localSessionId);
      final recoveredJob = await service.getSyncJob(job.jobId);

      expect(recoveredSession, isNotNull);
      expect(recoveredSession!.localSessionId, session.localSessionId);
      expect(recoveredJob, isNotNull);
      expect(recoveredJob!.jobId, job.jobId);
    });

    test('persists retry state and exposes due retry jobs', () async {
      final now = DateTime.now().toUtc();
      final dueAt = now.subtract(const Duration(minutes: 1));
      final futureAt = now.add(const Duration(minutes: 5));

      final dueSession = _buildSession(
        localSessionId: 'session-due',
        syncState: LocalWorkoutSessionSyncState.retryWait,
        retryCount: 3,
        nextRetryAt: dueAt,
      );
      final futureSession = _buildSession(
        localSessionId: 'session-future',
        syncState: LocalWorkoutSessionSyncState.retryWait,
        retryCount: 1,
        nextRetryAt: futureAt,
      );

      final dueJob = _buildJob(
        jobId: 'job-due',
        localSessionId: dueSession.localSessionId,
        status: SessionSyncJobStatus.retryWait,
        nextRetryAt: dueAt,
        retryCount: 3,
      );
      final futureJob = _buildJob(
        jobId: 'job-future',
        localSessionId: futureSession.localSessionId,
        status: SessionSyncJobStatus.retryWait,
        nextRetryAt: futureAt,
        retryCount: 1,
      );

      await service.saveSession(dueSession);
      await service.saveSession(futureSession);
      await service.enqueueSyncJob(dueJob);
      await service.enqueueSyncJob(futureJob);

      final dueJobs = await service.getDueRetryJobs(now);
      expect(dueJobs.map((job) => job.jobId), contains('job-due'));
      expect(dueJobs.map((job) => job.jobId), isNot(contains('job-future')));
    });
  });
}

LocalWorkoutSession _buildSession({
  required String localSessionId,
  required LocalWorkoutSessionSyncState syncState,
  required int retryCount,
  required DateTime? nextRetryAt,
}) {
  final now = DateTime.now().toUtc();
  return LocalWorkoutSession(
    localSessionId: localSessionId,
    workoutId: 'workout-1',
    startedAt: now.subtract(const Duration(minutes: 40)),
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
    syncState: syncState,
    retryCount: retryCount,
    nextRetryAt: nextRetryAt,
    lastError: null,
    createdAt: now,
    updatedAt: now,
  );
}

SessionSyncJob _buildJob({
  required String jobId,
  String localSessionId = 'session-1',
  required SessionSyncJobStatus status,
  required DateTime? nextRetryAt,
  int retryCount = 0,
}) {
  final now = DateTime.now().toUtc();
  return SessionSyncJob(
    jobId: jobId,
    localSessionId: localSessionId,
    workoutId: 'workout-1',
    sessionPayloadJson:
        '{"entries":[{"exerciseId":"exercise-1","position":0,"sets":[{"position":0,"reps":10,"load":80,"loadUnit":"kg"}]}]}',
    mergedWorkoutCommandJson: '{"blocks":[]}',
    status: status,
    retryCount: retryCount,
    nextRetryAt: nextRetryAt,
    lastError: null,
    createdAt: now,
    updatedAt: now,
  );
}
