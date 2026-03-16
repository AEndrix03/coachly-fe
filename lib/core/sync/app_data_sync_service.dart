import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDataSyncServiceProvider = Provider<AppDataSyncService>((ref) {
  final workoutRepository = ref.watch(workoutPageRepositoryProvider);
  return AppDataSyncService(ref, workoutRepository);
});

class AppDataSyncService {
  final Ref _ref;
  final IWorkoutPageRepository _workoutRepository;

  bool _hasSyncedCurrentSession = false;
  bool _isSyncing = false;

  AppDataSyncService(this._ref, this._workoutRepository);

  Future<void> syncOnAuthenticatedAccess({bool force = false}) async {
    if (_isSyncing) {
      return;
    }

    if (_hasSyncedCurrentSession && !force) {
      return;
    }

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!isOnline) {
      debugPrint('Sync skipped: device offline');
      return;
    }

    _isSyncing = true;

    try {
      final workoutResult = await _workoutRepository.refreshFromRemote();
      final success = workoutResult.success;

      if (success) {
        _hasSyncedCurrentSession = true;
        _ref.invalidate(workoutListProvider);
        _ref.invalidate(recentWorkoutsProvider);
      }
    } finally {
      _isSyncing = false;
    }
  }

  void resetSession() {
    _hasSyncedCurrentSession = false;
  }
}
