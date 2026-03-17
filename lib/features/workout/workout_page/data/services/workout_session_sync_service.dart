import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/session_sync_job_model.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_hive_service.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_stats_provider/workout_stats_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutSessionSyncServiceProvider = Provider<WorkoutSessionSyncService>((
  ref,
) {
  final service = WorkoutSessionSyncService(
    sessionHiveService: ref.watch(workoutSessionHiveServiceProvider),
    workoutPageService: ref.watch(workoutPageServiceProvider),
    workoutHiveService: ref.watch(workoutHiveServiceProvider),
    isAuthenticatedReader: () {
      final authState = ref.read(authProvider).asData?.value;
      return authState?.isAuthenticated == true &&
          authState?.isTokenValid == true;
    },
    invalidateWorkoutCaches: () {
      ref.invalidate(workoutListProvider);
      ref.invalidate(recentWorkoutsProvider);
      ref.invalidate(workoutStatsProvider);
    },
  );

  ref.listen<AsyncValue<List<ConnectivityResult>>>(connectivityProvider, (
    previous,
    next,
  ) {
    final isOnline = next.asData?.value.any(
      (result) => result != ConnectivityResult.none,
    );
    final wasOnline = previous?.asData?.value.any(
      (result) => result != ConnectivityResult.none,
    );

    if (isOnline == true && wasOnline != true) {
      unawaited(service.syncPendingSessions(trigger: 'connectivity_restored'));
    }
  });

  ref.onDispose(service.dispose);
  unawaited(service.scheduleRetryIfNeeded());
  return service;
});

class WorkoutSessionSyncService {
  static const Duration _retryBaseDelay = Duration(seconds: 5);
  static const Duration _retryMaxDelay = Duration(minutes: 15);

  final WorkoutSessionHiveService _sessionHiveService;
  final WorkoutPageService _workoutPageService;
  final WorkoutHiveService _workoutHiveService;
  final bool Function() _isAuthenticatedReader;
  final void Function() _invalidateWorkoutCaches;
  final Future<bool> Function()? _isOnlineOverride;
  final Random _random = Random();

  bool _isSyncing = false;
  Timer? _retryTimer;

  WorkoutSessionSyncService({
    required WorkoutSessionHiveService sessionHiveService,
    required WorkoutPageService workoutPageService,
    required WorkoutHiveService workoutHiveService,
    required bool Function() isAuthenticatedReader,
    required void Function() invalidateWorkoutCaches,
    Future<bool> Function()? isOnlineOverride,
  }) : _sessionHiveService = sessionHiveService,
       _workoutPageService = workoutPageService,
       _workoutHiveService = workoutHiveService,
       _isAuthenticatedReader = isAuthenticatedReader,
       _invalidateWorkoutCaches = invalidateWorkoutCaches,
       _isOnlineOverride = isOnlineOverride;

  Future<void> syncPendingSessions({String trigger = 'manual'}) async {
    if (_isSyncing) {
      return;
    }

    if (!_isAuthenticated()) {
      debugPrint('Session sync skipped ($trigger): unauthenticated.');
      return;
    }

    if (!await _isOnline()) {
      debugPrint('Session sync skipped ($trigger): offline.');
      await scheduleRetryIfNeeded();
      return;
    }

    _isSyncing = true;
    try {
      final jobs = await _sessionHiveService.getPendingJobsOrdered();
      final now = DateTime.now().toUtc();

      for (final job in jobs) {
        if (job.status == SessionSyncJobStatus.retryWait) {
          final nextRetryAt = job.nextRetryAt;
          if (nextRetryAt != null && nextRetryAt.isAfter(now)) {
            continue;
          }
        }

        final outcome = await _syncSingleJob(job);
        if (outcome == _SyncJobOutcome.transientFailure) {
          // FIFO semantics: stop and retry later.
          break;
        }
      }
    } finally {
      _isSyncing = false;
      await scheduleRetryIfNeeded();
    }
  }

  Future<void> scheduleRetryIfNeeded() async {
    _retryTimer?.cancel();
    _retryTimer = null;

    final earliestRetryJob = await _sessionHiveService.getEarliestRetryJob();
    if (earliestRetryJob == null || earliestRetryJob.nextRetryAt == null) {
      return;
    }

    final now = DateTime.now().toUtc();
    final dueIn = earliestRetryJob.nextRetryAt!.difference(now);
    if (dueIn <= Duration.zero) {
      unawaited(syncPendingSessions(trigger: 'retry_due_now'));
      return;
    }

    _retryTimer = Timer(dueIn, () {
      unawaited(syncPendingSessions(trigger: 'retry_timer'));
    });
  }

  void dispose() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  bool _isAuthenticated() {
    return _isAuthenticatedReader();
  }

  Future<bool> _isOnline() async {
    final override = _isOnlineOverride;
    if (override != null) {
      return override();
    }
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.any((r) => r != ConnectivityResult.none);
  }

  Future<_SyncJobOutcome> _syncSingleJob(SessionSyncJob initialJob) async {
    final session = await _sessionHiveService.getSession(
      initialJob.localSessionId,
    );
    if (session == null) {
      await _markJobFailedPermanent(
        job: initialJob,
        errorMessage: 'Local session not found for sync.',
      );
      return _SyncJobOutcome.permanentFailure;
    }

    var job = initialJob;
    var currentSession = session;

    final needsSessionUpload = _needsSessionUpload(
      job: job,
      session: currentSession,
    );
    if (needsSessionUpload) {
      final uploadingStateAt = DateTime.now().toUtc();
      job = job.copyWith(
        status: SessionSyncJobStatus.uploading,
        updatedAt: uploadingStateAt,
      );
      currentSession = currentSession.copyWith(
        syncState: LocalWorkoutSessionSyncState.uploading,
        updatedAt: uploadingStateAt,
      );
      await _persist(job: job, session: currentSession);

      final sessionPayload = _decodeJsonMap(job.sessionPayloadJson);
      sessionPayload['clientSessionId'] = job.localSessionId;
      final uploadResponse = await _workoutPageService
          .saveWorkoutSessionPayload(job.workoutId, sessionPayload);
      if (!uploadResponse.success) {
        return _handleFailure(
          job: job,
          session: currentSession,
          response: uploadResponse,
          failurePhase: _SyncFailurePhase.uploadSession,
        );
      }

      final uploadedAt = DateTime.now().toUtc();
      job = job.copyWith(
        status: SessionSyncJobStatus.uploaded,
        updatedAt: uploadedAt,
        clearLastError: true,
        clearNextRetryAt: true,
      );
      currentSession = currentSession.copyWith(
        syncState: LocalWorkoutSessionSyncState.uploaded,
        updatedAt: uploadedAt,
        clearLastError: true,
        clearNextRetryAt: true,
      );
      await _persist(job: job, session: currentSession);
    }

    final patchingAt = DateTime.now().toUtc();
    job = job.copyWith(
      status: SessionSyncJobStatus.patching,
      updatedAt: patchingAt,
    );
    currentSession = currentSession.copyWith(
      syncState: LocalWorkoutSessionSyncState.patching,
      updatedAt: patchingAt,
    );
    await _persist(job: job, session: currentSession);

    final workoutPayload = _decodeJsonMap(job.mergedWorkoutCommandJson);
    final patchResponse = await _workoutPageService.patchWorkoutPayload(
      job.workoutId,
      workoutPayload,
    );
    if (!patchResponse.success) {
      return _handleFailure(
        job: job,
        session: currentSession,
        response: patchResponse,
        failurePhase: _SyncFailurePhase.patchWorkout,
      );
    }

    final syncedAt = DateTime.now().toUtc();
    job = job.copyWith(
      status: SessionSyncJobStatus.synced,
      updatedAt: syncedAt,
      clearLastError: true,
      clearNextRetryAt: true,
    );
    currentSession = currentSession.copyWith(
      syncState: LocalWorkoutSessionSyncState.synced,
      updatedAt: syncedAt,
      clearLastError: true,
      clearNextRetryAt: true,
    );
    await _persist(job: job, session: currentSession);

    await _workoutHiveService.markWorkoutSynced(job.workoutId);
    await _refreshWorkoutCacheFromRemote();
    return _SyncJobOutcome.success;
  }

  bool _needsSessionUpload({
    required SessionSyncJob job,
    required LocalWorkoutSession session,
  }) {
    final sessionState = session.syncState;
    if (sessionState == LocalWorkoutSessionSyncState.uploaded ||
        sessionState == LocalWorkoutSessionSyncState.patching ||
        sessionState == LocalWorkoutSessionSyncState.synced) {
      return false;
    }

    if (job.status == SessionSyncJobStatus.uploaded ||
        job.status == SessionSyncJobStatus.patching ||
        job.status == SessionSyncJobStatus.synced) {
      return false;
    }

    return true;
  }

  Future<_SyncJobOutcome> _handleFailure({
    required SessionSyncJob job,
    required LocalWorkoutSession session,
    required ApiResponse<void> response,
    required _SyncFailurePhase failurePhase,
  }) async {
    final now = DateTime.now().toUtc();
    final errorMessage = _buildErrorMessage(response);
    final statusCode = response.statusCode;

    if (_isTransientStatus(statusCode)) {
      final nextRetryCount = job.retryCount + 1;
      final nextRetryAt = _computeNextRetryAt(
        now: now,
        retryCount: nextRetryCount,
      );

      final retryJob = job.copyWith(
        status: SessionSyncJobStatus.retryWait,
        retryCount: nextRetryCount,
        nextRetryAt: nextRetryAt,
        lastError: errorMessage,
        updatedAt: now,
      );
      await _sessionHiveService.updateSyncJob(retryJob);

      final retrySessionState = failurePhase == _SyncFailurePhase.patchWorkout
          ? LocalWorkoutSessionSyncState.uploaded
          : LocalWorkoutSessionSyncState.retryWait;
      final retrySession = session.copyWith(
        syncState: retrySessionState,
        retryCount: nextRetryCount,
        nextRetryAt: nextRetryAt,
        lastError: errorMessage,
        updatedAt: now,
      );
      await _sessionHiveService.updateSession(retrySession);

      return _SyncJobOutcome.transientFailure;
    }

    await _markJobFailedPermanent(job: job, errorMessage: errorMessage);
    final failedSession = session.copyWith(
      syncState: LocalWorkoutSessionSyncState.failedPermanent,
      lastError: errorMessage,
      updatedAt: now,
    );
    await _sessionHiveService.updateSession(failedSession);
    return _SyncJobOutcome.permanentFailure;
  }

  Future<void> _markJobFailedPermanent({
    required SessionSyncJob job,
    required String errorMessage,
  }) async {
    final now = DateTime.now().toUtc();
    final failedJob = job.copyWith(
      status: SessionSyncJobStatus.failedPermanent,
      lastError: errorMessage,
      updatedAt: now,
      clearNextRetryAt: true,
    );
    await _sessionHiveService.updateSyncJob(failedJob);
  }

  Future<void> _persist({
    required SessionSyncJob job,
    required LocalWorkoutSession session,
  }) async {
    await _sessionHiveService.updateSyncJob(job);
    await _sessionHiveService.updateSession(session);
  }

  Future<void> _refreshWorkoutCacheFromRemote() async {
    final refreshResponse = await _workoutPageService.fetchWorkouts();
    if (!refreshResponse.success || refreshResponse.data == null) {
      debugPrint(
        'Session sync warning: remote refresh failed after successful sync. '
        'status=${refreshResponse.statusCode} message=${refreshResponse.message}',
      );
      return;
    }

    await _workoutHiveService.patchWorkouts(refreshResponse.data!);
    _invalidateWorkoutCaches();
  }

  String _buildErrorMessage(ApiResponse<void> response) {
    final status = response.statusCode;
    final message = response.message ?? 'Unknown session sync error.';
    return status == null ? message : '[$status] $message';
  }

  bool _isTransientStatus(int? statusCode) {
    if (statusCode == null) {
      return true;
    }

    if (statusCode == 0 ||
        statusCode == 408 ||
        statusCode == 429 ||
        statusCode >= 500) {
      return true;
    }

    return false;
  }

  DateTime _computeNextRetryAt({
    required DateTime now,
    required int retryCount,
  }) {
    final boundedRetryCount = retryCount < 0 ? 0 : retryCount;
    final baseSeconds =
        _retryBaseDelay.inSeconds * pow(2, boundedRetryCount - 1);
    final clampedSeconds = min(baseSeconds.toInt(), _retryMaxDelay.inSeconds);
    final jitterRatio = _random.nextDouble() * 0.2;
    final jitterMillis = (clampedSeconds * 1000 * jitterRatio).round();
    final totalDelay =
        Duration(seconds: clampedSeconds) +
        Duration(milliseconds: jitterMillis);
    return now.add(totalDelay);
  }

  Map<String, dynamic> _decodeJsonMap(String rawJson) {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map) {
      return <String, dynamic>{};
    }
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }
}

enum _SyncJobOutcome { success, transientFailure, permanentFailure }

enum _SyncFailurePhase { uploadSession, patchWorkout }
