import 'dart:async';

import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/exercise/providers/exercise_list_provider.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_sync_service.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDataSyncServiceProvider = Provider<AppDataSyncService>((ref) {
  return AppDataSyncService(
    ref,
    ref.watch(workoutPageRepositoryProvider),
    ref.watch(workoutSessionSyncServiceProvider),
    ref.watch(exerciseInfoPageRepositoryProvider),
    ref.watch(authServiceProvider),
    LocalDatabaseService(),
  );
});

/// Orchestrates full-app data sync on authenticated access.
///
/// Sync runs at most once per session unless [force] is passed, or the cache
/// TTL has expired ([_cacheTtl]). The session is marked as synced only when
/// both repositories succeed, so a partial failure is automatically retried
/// on the next access.
class AppDataSyncService {
  static const Duration _cacheTtl = Duration(hours: 72);

  final Ref _ref;
  final IWorkoutPageRepository _workoutRepository;
  final WorkoutSessionSyncService _sessionSyncService;
  final IExerciseInfoPageRepository _exerciseRepository;
  final AuthService _authService;
  final LocalDatabaseService _localDb;

  bool _hasSyncedCurrentSession = false;
  bool _isSyncing = false;

  AppDataSyncService(
    this._ref,
    this._workoutRepository,
    this._sessionSyncService,
    this._exerciseRepository,
    this._authService,
    this._localDb,
  );

  /// Returns true if the last successful sync is older than [_cacheTtl].
  bool get _isCacheStale {
    final lastSync = _localDb.lastSyncTime;
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync) > _cacheTtl;
  }

  Future<void> syncOnAuthenticatedAccess({bool force = false}) async {
    if (_isSyncing) return;
    if (_hasSyncedCurrentSession && !force && !_isCacheStale) return;

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any(
      (r) => r != ConnectivityResult.none,
    );
    if (!isOnline) {
      debugPrint('Sync skipped: device offline');
      return;
    }

    final accessToken = await _authService.getAccessToken();
    if (accessToken == null || !JwtValidator.isTokenValid(accessToken)) {
      debugPrint('Sync skipped: JWT missing or invalid');
      return;
    }

    unawaited(
      _sessionSyncService.syncPendingSessions(trigger: 'authenticated_access'),
    );

    _isSyncing = true;
    try {
      final workoutResult = await _workoutRepository.refreshFromRemote();
      final exerciseResult = await _exerciseRepository.refreshFromRemote();
      final success = workoutResult.success && exerciseResult.success;

      if (success) {
        _hasSyncedCurrentSession = true;
        await _localDb.updateLastSyncTime();
        _ref.invalidate(workoutListProvider);
        _ref.invalidate(recentWorkoutsProvider);
        _ref.invalidate(exerciseInfoProvider);
        _ref.invalidate(exerciseListProvider);
      }
    } finally {
      _isSyncing = false;
    }
  }

  void resetSession() {
    _hasSyncedCurrentSession = false;
  }
}
