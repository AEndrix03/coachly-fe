import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDataSyncServiceProvider = Provider<AppDataSyncService>((ref) {
  return AppDataSyncService(
    ref,
    ref.watch(workoutPageRepositoryProvider),
    ref.watch(exerciseInfoPageRepositoryProvider),
    ref.watch(authServiceProvider),
  );
});

/// Orchestrates full-app data sync on authenticated access.
///
/// Sync runs at most once per session unless [force] is passed.
/// The session is marked as synced only when both repositories succeed,
/// so a partial failure is automatically retried on the next access.
class AppDataSyncService {
  final Ref _ref;
  final IWorkoutPageRepository _workoutRepository;
  final IExerciseInfoPageRepository _exerciseRepository;
  final AuthService _authService;

  bool _hasSyncedCurrentSession = false;
  bool _isSyncing = false;

  AppDataSyncService(
    this._ref,
    this._workoutRepository,
    this._exerciseRepository,
    this._authService,
  );

  Future<void> syncOnAuthenticatedAccess({bool force = false}) async {
    if (_isSyncing) return;
    if (_hasSyncedCurrentSession && !force) return;

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

    _isSyncing = true;
    try {
      final workoutResult = await _workoutRepository.refreshFromRemote();
      final exerciseResult = await _exerciseRepository.refreshFromRemote();
      final success = workoutResult.success && exerciseResult.success;

      if (success) {
        _hasSyncedCurrentSession = true;
        _ref.invalidate(workoutListProvider);
        _ref.invalidate(recentWorkoutsProvider);
        _ref.invalidate(exerciseInfoProvider);
      }
    } finally {
      _isSyncing = false;
    }
  }

  void resetSession() {
    _hasSyncedCurrentSession = false;
  }
}
