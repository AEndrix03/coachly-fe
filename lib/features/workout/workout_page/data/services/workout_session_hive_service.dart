import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/session_sync_job_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final workoutSessionHiveServiceProvider = Provider<WorkoutSessionHiveService>((
  ref,
) {
  final localDbService = ref.watch(localDatabaseServiceProvider);
  return WorkoutSessionHiveService(localDbService);
});

class WorkoutSessionHiveService {
  final Box<Map> _sessionsBox;
  final Box<Map> _syncJobsBox;

  WorkoutSessionHiveService(LocalDatabaseService localDbService)
    : this.fromBoxes(
        sessionsBox: localDbService.workoutSessions,
        syncJobsBox: localDbService.sessionSyncJobs,
      );

  WorkoutSessionHiveService.fromBoxes({
    required Box<Map> sessionsBox,
    required Box<Map> syncJobsBox,
  }) : _sessionsBox = sessionsBox,
       _syncJobsBox = syncJobsBox;

  Future<void> saveSession(LocalWorkoutSession session) async {
    await _sessionsBox.put(session.localSessionId, session.toJson());
  }

  Future<LocalWorkoutSession?> getSession(String localSessionId) async {
    final raw = _sessionsBox.get(localSessionId);
    if (raw == null) {
      return null;
    }
    return LocalWorkoutSession.fromJson(_normalizeMap(raw));
  }

  Future<void> updateSession(LocalWorkoutSession session) async {
    await saveSession(session);
  }

  Future<List<LocalWorkoutSession>> getSessionsForWorkout(
    String workoutId,
  ) async {
    final sessions = _sessionsBox.values
        .map((raw) => LocalWorkoutSession.fromJson(_normalizeMap(raw)))
        .where((session) => session.workoutId == workoutId)
        .toList();
    sessions.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return sessions;
  }

  Future<void> enqueueSyncJob(SessionSyncJob job) async {
    await _syncJobsBox.put(job.jobId, job.toJson());
  }

  Future<SessionSyncJob?> getSyncJob(String jobId) async {
    final raw = _syncJobsBox.get(jobId);
    if (raw == null) {
      return null;
    }
    return SessionSyncJob.fromJson(_normalizeMap(raw));
  }

  Future<SessionSyncJob?> getSyncJobBySessionId(String localSessionId) async {
    for (final raw in _syncJobsBox.values) {
      final job = SessionSyncJob.fromJson(_normalizeMap(raw));
      if (job.localSessionId == localSessionId) {
        return job;
      }
    }
    return null;
  }

  Future<void> updateSyncJob(SessionSyncJob job) async {
    await enqueueSyncJob(job);
  }

  Future<void> dequeueSyncJob(String jobId) async {
    await _syncJobsBox.delete(jobId);
  }

  Future<List<SessionSyncJob>> getPendingJobsOrdered() async {
    final jobs = _syncJobsBox.values
        .map((raw) => SessionSyncJob.fromJson(_normalizeMap(raw)))
        .where((job) => !job.status.isTerminal)
        .toList();
    jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return jobs;
  }

  Future<List<SessionSyncJob>> getDueRetryJobs(DateTime now) async {
    final jobs = await getPendingJobsOrdered();
    return jobs.where((job) {
      if (job.status != SessionSyncJobStatus.retryWait) {
        return false;
      }
      final nextRetryAt = job.nextRetryAt;
      return nextRetryAt != null && !nextRetryAt.isAfter(now);
    }).toList();
  }

  Future<SessionSyncJob?> getEarliestRetryJob() async {
    final jobs = await getPendingJobsOrdered();
    SessionSyncJob? earliest;
    for (final job in jobs) {
      if (job.status != SessionSyncJobStatus.retryWait ||
          job.nextRetryAt == null) {
        continue;
      }
      if (earliest == null ||
          job.nextRetryAt!.isBefore(earliest.nextRetryAt!)) {
        earliest = job;
      }
    }
    return earliest;
  }
}

Map<String, dynamic> _normalizeMap(Map raw) {
  return raw.map((key, value) => MapEntry(key.toString(), value));
}
