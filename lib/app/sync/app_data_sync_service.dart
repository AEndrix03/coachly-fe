import 'dart:async';

import 'package:coachly/core/config/app_config.dart';
import 'package:coachly/app/sync/local_database_service.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_detail_view_provider.dart';
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
/// Vive in `app/` e non in `core/`: conosce quattro feature diverse e contiene
/// orchestrazione di dominio Coachly, quindi non soddisfa le condizioni per
/// stare in `core/` (`docs/development/02-project-structure.md`). Il livello
/// `app/` è l'unico autorizzato a conoscere le feature.
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
  bool _hasAppliedColdStart = false;
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
    await _applyColdStartOnce();
    if (_isSyncing) return;
    if (_hasSyncedCurrentSession && !force && !_isCacheStale) return;

    if (!await _canSync()) {
      return;
    }

    unawaited(
      _sessionSyncService.syncPendingSessions(trigger: 'authenticated_access'),
    );

    _isSyncing = true;
    try {
      final workoutResult = await _workoutRepository.refreshFromRemote();
      final exerciseResult = await _exerciseRepository
          .refreshFromRemoteResult();
      final success = workoutResult.success && exerciseResult.isOk;

      if (success) {
        _hasSyncedCurrentSession = true;
        await _localDb.updateLastSyncTime();
        _ref.invalidate(workoutListProvider);
        _ref.invalidate(recentWorkoutsProvider);
        _ref.invalidate(exerciseInfoProvider);
        _ref.invalidate(exerciseDetailCatalogProvider);
        _ref.invalidate(exerciseListProvider);
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Refreshes the exercise catalogue whenever the app returns to foreground.
  ///
  /// The existing Hive cache remains available until the network response has
  /// been saved. A running full sync already refreshes exercises, so concurrent
  /// resume events do not issue duplicate requests.
  Future<void> refreshExercisesOnAppResume() async {
    if (_isSyncing || !await _canSync()) return;

    _isSyncing = true;
    try {
      final result = await _exerciseRepository.refreshFromRemoteResult();
      if (result.isOk) {
        _ref.invalidate(exerciseInfoProvider);
        _ref.invalidate(exerciseDetailCatalogProvider);
        _ref.invalidate(exerciseListProvider);
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Applica [CacheMode.cold] svuotando il database locale una sola volta per
  /// processo.
  ///
  /// Vive qui e non nel bootstrap perche' e' il primo punto del ciclo di vita
  /// che possiede il database locale. In release [AppConfig.cacheMode] non vale
  /// mai `cold`, quindi il metodo e' inerte.
  ///
  /// [CacheMode.noSeed] non ha ancora effetto: il catalogo pre-installato non
  /// esiste (`docs/development/17-config-and-flags.md`).
  Future<void> _applyColdStartOnce() async {
    if (_hasAppliedColdStart) return;
    _hasAppliedColdStart = true;
    if (AppConfig.cacheMode != CacheMode.cold) return;
    await _localDb.clearAll();
  }

  Future<bool> _canSync() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );
    if (!isOnline) {
      debugPrint('Sync skipped: device offline');
      return false;
    }

    final accessToken = await _authService.getAccessToken();
    if (accessToken == null || !JwtValidator.isTokenValid(accessToken)) {
      debugPrint('Sync skipped: JWT missing or invalid');
      return false;
    }

    return true;
  }

  void resetSession() {
    _hasSyncedCurrentSession = false;
  }
}
