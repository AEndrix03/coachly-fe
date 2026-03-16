import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDataSyncServiceProvider = Provider<AppDataSyncService>((ref) {
  final workoutRepository = ref.watch(workoutPageRepositoryProvider);
  final exerciseRepository = ref.watch(exerciseInfoPageRepositoryProvider);
  return AppDataSyncService(ref, workoutRepository, exerciseRepository);
});

/// Orchestrates full-app data sync on authenticated access.
///
/// Sync runs at most once per session unless [force] is passed.
/// Session is only marked as synced when all repositories succeed, so
/// a partial failure is automatically retried on the next access.
class AppDataSyncService {
  final Ref _ref;
  final IWorkoutPageRepository _workoutRepository;
  final IExerciseInfoPageRepository _exerciseRepository;

  bool _hasSyncedCurrentSession = false;
  bool _isSyncing = false;

  AppDataSyncService(
    this._ref,
    this._workoutRepository,
    this._exerciseRepository,
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
