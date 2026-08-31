import 'dart:async';
import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/auth/application/auth_provider.dart';
import 'package:coachly/features/exercises/data/local/custom_exercise_dao.dart';
import 'package:coachly/features/exercises/data/services/exercise_info_page_service.dart';
import 'package:coachly/features/exercises/application/exercise_info_provider.dart'
    show exerciseInfoPageServiceProvider;
import 'package:coachly/features/sync/data/local/outbox_dao.dart';
import 'package:coachly/features/sessions/data/local/session_dao.dart';
import 'package:coachly/features/workouts/data/local/workout_dao.dart';
import 'package:coachly/features/sessions/domain/models/local_workout_session_model.dart';
import 'package:coachly/features/workouts/data/services/workout_page_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutSessionSyncServiceProvider = Provider<WorkoutSessionSyncService>((
  ref,
) {
  final service = WorkoutSessionSyncService(
    sessionDao: ref.watch(sessionDaoProvider),
    workoutDao: ref.watch(workoutDaoProvider),
    outboxDao: ref.watch(outboxDaoProvider),
    workoutPageService: ref.watch(workoutPageServiceProvider),
    exerciseService: ref.watch(exerciseInfoPageServiceProvider),
    customExerciseDao: ref.watch(customExerciseDaoProvider),
    clock: ref.watch(clockProvider),
    logger: ref.watch(appLoggerProvider),
    isAuthenticatedReader: () {
      final authState = ref.read(authProvider).asData?.value;
      return authState?.isAuthenticated == true &&
          authState?.isTokenValid == true;
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

/// Svuota l'outbox verso il backend.
///
/// La coda e' append-only e client-authored: il server riceve cio' che il
/// client ha prodotto e non lo corregge (`docs/development/05-sync-and-offline.md`).
/// Nessun esito di sync cancella mai il dato locale.
class WorkoutSessionSyncService {
  /// Tipo di entita' che questo servizio sa spedire.
  static const String sessionEntityType = 'session';

  final SessionDao _sessionDao;
  final WorkoutDao _workoutDao;
  final OutboxDao _outboxDao;
  final WorkoutPageService _workoutPageService;
  final ExerciseInfoPageService? _exerciseService;
  final CustomExerciseDao? _customExerciseDao;
  final Clock _clock;
  final AppLogger _logger;
  final bool Function() _isAuthenticatedReader;
  final Future<bool> Function()? _isOnlineOverride;

  Future<void>? _activeSync;
  Timer? _retryTimer;

  WorkoutSessionSyncService({
    required SessionDao sessionDao,
    required WorkoutDao workoutDao,
    required OutboxDao outboxDao,
    required WorkoutPageService workoutPageService,
    ExerciseInfoPageService? exerciseService,
    CustomExerciseDao? customExerciseDao,
    required bool Function() isAuthenticatedReader,
    Clock clock = const SystemClock(),
    AppLogger logger = const ConsoleAppLogger(),
    Future<bool> Function()? isOnlineOverride,
  }) : _sessionDao = sessionDao,
       _workoutDao = workoutDao,
       _outboxDao = outboxDao,
       _workoutPageService = workoutPageService,
       _exerciseService = exerciseService,
       _customExerciseDao = customExerciseDao,
       _clock = clock,
       _logger = logger,
       _isAuthenticatedReader = isAuthenticatedReader,
       _isOnlineOverride = isOnlineOverride;

  Future<void> syncPendingSessions({String trigger = 'manual'}) async {
    final running = _activeSync;
    if (running != null) return running;

    if (!_isAuthenticatedReader()) {
      _logger.debug(
        'Session sync skipped: unauthenticated.',
        context: {'trigger': trigger},
      );
      return;
    }

    if (!await _isOnline()) {
      _logger.debug(
        'Session sync skipped: offline.',
        context: {'trigger': trigger},
      );
      await scheduleRetryIfNeeded();
      return;
    }

    final operation = _drainPending();
    _activeSync = operation;
    try {
      await operation;
    } finally {
      if (identical(_activeSync, operation)) _activeSync = null;
      await scheduleRetryIfNeeded();
    }
  }

  Future<void> _drainPending() async {
    // FIFO: l'ordine di creazione e' l'ordine di invio.
    final rows = await _outboxDao.pendingOrdered();
    final now = _clock.nowUtc();

    for (final row in rows) {
      final nextAttemptAt = row.nextAttemptAt;
      if (nextAttemptAt != null && nextAttemptAt.isAfter(now)) continue;

      final outcome = await switch (row.entityType) {
        sessionEntityType => _syncSessionRow(row),
        'workout' => _syncWorkoutRow(row),
        'custom_exercise' => _syncCustomExerciseRow(row),
        _ => _markUnsupported(row),
      };
      if (outcome == _SyncOutcome.transientFailure) break;
    }
  }

  Future<void> scheduleRetryIfNeeded() async {
    _retryTimer?.cancel();
    _retryTimer = null;

    final earliest = await _outboxDao.earliestNextAttemptAt();
    if (earliest == null) {
      return;
    }

    final dueIn = earliest.difference(_clock.nowUtc());
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

  Future<bool> _isOnline() async {
    final override = _isOnlineOverride;
    if (override != null) {
      return override();
    }
    // `connectivity_plus` e' un segnale per tentare, mai un'autorita' su cosa
    // sia possibile: l'autorita' sono timeout ed esiti HTTP.
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.any((r) => r != ConnectivityResult.none);
  }

  Future<_SyncOutcome> _syncSessionRow(OutboxRow row) async {
    final session = await _sessionDao.getSession(row.entityId);
    if (session == null) {
      await _outboxDao.markFailedPermanent(
        row.id,
        error: 'Local session not found for sync.',
      );
      return _SyncOutcome.permanentFailure;
    }

    await _outboxDao.markSending(row.id);

    var currentSession = session;
    if (_needsSessionUpload(currentSession)) {
      currentSession = await _setSessionState(
        currentSession,
        LocalWorkoutSessionSyncState.uploading,
      );

      final sessionPayload = _decodeJsonMap(row.payload);
      sessionPayload['clientSessionId'] = row.entityId;
      final uploadResponse = await _workoutPageService
          .saveWorkoutSessionPayload(currentSession.workoutId, sessionPayload);
      if (!uploadResponse.success) {
        return _handleFailure(
          row: row,
          session: currentSession,
          response: uploadResponse,
          failurePhase: _SyncFailurePhase.uploadSession,
        );
      }

      currentSession = await _setSessionState(
        currentSession,
        LocalWorkoutSessionSyncState.uploaded,
      );
    }

    currentSession = await _setSessionState(
      currentSession,
      LocalWorkoutSessionSyncState.patching,
    );

    final workoutPayload = _decodeJsonMap(row.secondaryPayload ?? '{}');
    final patchResponse = await _workoutPageService.patchWorkoutPayload(
      currentSession.workoutId,
      workoutPayload,
    );
    if (!patchResponse.success) {
      return _handleFailure(
        row: row,
        session: currentSession,
        response: patchResponse,
        failurePhase: _SyncFailurePhase.patchWorkout,
      );
    }

    await _setSessionState(currentSession, LocalWorkoutSessionSyncState.synced);
    await _outboxDao.markSent(row.id);
    if (!await _outboxDao.hasPendingForEntity(
      entityType: 'workout',
      entityId: currentSession.workoutId,
    )) {
      await _workoutDao.markSynced(
        currentSession.workoutId,
        updatedAt: _clock.nowUtc(),
      );
    }
    await _refreshWorkoutCacheFromRemote();
    return _SyncOutcome.success;
  }

  Future<_SyncOutcome> _syncWorkoutRow(OutboxRow row) async {
    await _outboxDao.markSending(row.id);
    final payload = _decodeJsonMap(row.payload);
    final response = switch (row.operation) {
      'create' => await _workoutPageService.createWorkoutPayload(payload),
      'update' => await _workoutPageService.patchWorkoutPayload(
        row.entityId,
        payload,
      ),
      'delete' => await _workoutPageService.deleteWorkout(row.entityId),
      _ => null,
    };
    if (response == null) return _markUnsupported(row);
    if (!response.success) {
      return _handleOutboxFailure(row: row, response: response);
    }
    if (row.operation == 'delete') {
      await _workoutDao.deleteWorkout(row.entityId);
    } else if (!await _outboxDao.hasPendingForEntity(
      entityType: 'workout',
      entityId: row.entityId,
      excludingId: row.id,
    )) {
      await _workoutDao.markSynced(row.entityId, updatedAt: _clock.nowUtc());
    }
    await _outboxDao.markSent(row.id);
    return _SyncOutcome.success;
  }

  Future<_SyncOutcome> _syncCustomExerciseRow(OutboxRow row) async {
    final exerciseService = _exerciseService;
    final customExerciseDao = _customExerciseDao;
    if (exerciseService == null || customExerciseDao == null) {
      return _markUnsupported(row);
    }
    await _outboxDao.markSending(row.id);
    final payload = _decodeJsonMap(row.payload);
    final response = switch (row.operation) {
      'create' => await exerciseService.createPersonalExercisePayload(payload),
      'update' => await exerciseService.updatePersonalExercisePayload(
        row.entityId,
        payload,
      ),
      'delete' => await exerciseService.deletePersonalExercise(row.entityId),
      _ => null,
    };
    if (response == null) return _markUnsupported(row);
    if (!response.success) {
      return _handleOutboxFailure(row: row, response: response);
    }
    if (row.operation == 'delete') {
      await customExerciseDao.deletePermanently(row.entityId);
    }
    await _outboxDao.markSent(row.id);
    return _SyncOutcome.success;
  }

  Future<_SyncOutcome> _markUnsupported(OutboxRow row) async {
    await _outboxDao.markFailedPermanent(
      row.id,
      error: 'Unsupported outbox operation: ${row.entityType}/${row.operation}',
    );
    return _SyncOutcome.permanentFailure;
  }

  Future<_SyncOutcome> _handleOutboxFailure({
    required OutboxRow row,
    required ApiResponse<void> response,
  }) async {
    final errorMessage = _buildErrorMessage(response);
    if (_isTransientStatus(response.statusCode)) {
      await _outboxDao.markFailed(row.id, error: errorMessage);
      return _SyncOutcome.transientFailure;
    }
    await _outboxDao.markFailedPermanent(row.id, error: errorMessage);
    _logger.warn(
      'Outbox operation failed permanently; local data kept.',
      context: {
        'outboxId': row.id,
        'entityType': row.entityType,
        'entityId': row.entityId,
      },
    );
    return _SyncOutcome.permanentFailure;
  }

  bool _needsSessionUpload(LocalWorkoutSession session) {
    return switch (session.syncState) {
      LocalWorkoutSessionSyncState.uploaded ||
      LocalWorkoutSessionSyncState.patching ||
      LocalWorkoutSessionSyncState.synced => false,
      _ => true,
    };
  }

  Future<LocalWorkoutSession> _setSessionState(
    LocalWorkoutSession session,
    LocalWorkoutSessionSyncState state, {
    String? lastError,
  }) async {
    final updated = session.copyWith(
      syncState: state,
      lastError: lastError,
      clearLastError: lastError == null,
      updatedAt: _clock.nowUtc(),
    );
    await _sessionDao.upsert(updated);
    return updated;
  }

  Future<_SyncOutcome> _handleFailure({
    required OutboxRow row,
    required LocalWorkoutSession session,
    required ApiResponse<void> response,
    required _SyncFailurePhase failurePhase,
  }) async {
    final errorMessage = _buildErrorMessage(response);

    if (_isTransientStatus(response.statusCode)) {
      // Backoff esponenziale con jitter, calcolato dall'outbox sul `Clock`.
      final nextAttemptAt = await _outboxDao.markFailed(
        row.id,
        error: errorMessage,
      );
      final retryState = failurePhase == _SyncFailurePhase.patchWorkout
          ? LocalWorkoutSessionSyncState.uploaded
          : LocalWorkoutSessionSyncState.retryWait;
      await _sessionDao.upsert(
        session.copyWith(
          syncState: retryState,
          retryCount: session.retryCount + 1,
          nextRetryAt: nextAttemptAt,
          lastError: errorMessage,
          updatedAt: _clock.nowUtc(),
        ),
      );
      return _SyncOutcome.transientFailure;
    }

    // `failed_permanent` non cancella mai il dato locale: il fallimento
    // riguarda la telemetria, non l'utente.
    await _outboxDao.markFailedPermanent(row.id, error: errorMessage);
    await _sessionDao.upsert(
      session.copyWith(
        syncState: LocalWorkoutSessionSyncState.failedPermanent,
        lastError: errorMessage,
        updatedAt: _clock.nowUtc(),
      ),
    );
    _logger.warn(
      'Session upload failed permanently; local data kept.',
      context: {'outboxId': row.id, 'sessionId': row.entityId},
    );
    return _SyncOutcome.permanentFailure;
  }

  Future<void> _refreshWorkoutCacheFromRemote() async {
    final refreshResponse = await _workoutPageService.fetchWorkouts();
    if (!refreshResponse.success || refreshResponse.data == null) {
      _logger.warn(
        'Remote refresh failed after a successful session sync.',
        context: {
          'status': refreshResponse.statusCode,
          'message': refreshResponse.message,
        },
      );
      return;
    }

    await _workoutDao.patchWorkouts(
      refreshResponse.data!,
      updatedAt: _clock.nowUtc(),
    );
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

    return statusCode == 0 ||
        statusCode == 408 ||
        statusCode == 429 ||
        statusCode >= 500;
  }

  Map<String, dynamic> _decodeJsonMap(String rawJson) {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map) {
      return <String, dynamic>{};
    }
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }
}

enum _SyncOutcome { success, transientFailure, permanentFailure }

enum _SyncFailurePhase { uploadSession, patchWorkout }
