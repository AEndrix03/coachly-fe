import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutPageRepositoryProvider = Provider<IWorkoutPageRepository>((ref) {
  final workoutService = ref.watch(workoutPageServiceProvider);
  final workoutHiveService = ref.watch(workoutHiveServiceProvider);
  return WorkoutPageRepositoryImpl(workoutService, workoutHiveService);
});

class WorkoutPageRepositoryImpl implements IWorkoutPageRepository {
  final WorkoutPageService _apiService;
  final WorkoutHiveService _hiveService;
  Future<ApiResponse<List<WorkoutModel>>>? _ongoingRefresh;

  WorkoutPageRepositoryImpl(this._apiService, this._hiveService);

  @override
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts() async {
    final localWorkouts = await _hiveService.getWorkouts();
    if (localWorkouts.isNotEmpty) {
      return ApiResponse.success(data: localWorkouts);
    }
    // Cache empty — populate from remote.
    return _refreshFromRemoteDeduplicated();
  }

  @override
  Future<ApiResponse<List<WorkoutModel>>> refreshFromRemote() async {
    return _refreshFromRemoteDeduplicated();
  }

  Future<ApiResponse<List<WorkoutModel>>> _refreshFromRemoteDeduplicated() {
    final ongoingRefresh = _ongoingRefresh;
    if (ongoingRefresh != null) {
      return ongoingRefresh;
    }

    final refreshFuture = _performRefreshFromRemote();
    _ongoingRefresh = refreshFuture;
    refreshFuture.whenComplete(() {
      if (identical(_ongoingRefresh, refreshFuture)) {
        _ongoingRefresh = null;
      }
    });
    return refreshFuture;
  }

  Future<ApiResponse<List<WorkoutModel>>> _performRefreshFromRemote() async {
    List<WorkoutModel>? remoteWorkouts;
    try {
      final remoteResponse = await _apiService.fetchWorkouts();
      if (remoteResponse.success && remoteResponse.data != null) {
        remoteWorkouts = remoteResponse.data!;
        await _hiveService.patchWorkouts(remoteWorkouts);
      } else {
        return ApiResponse.error(
          message:
              remoteResponse.message ??
              'Failed to refresh workouts from remote',
          statusCode: remoteResponse.statusCode,
          errors: remoteResponse.errors,
        );
      }

      final localWorkouts = await _hiveService.getWorkouts();
      return ApiResponse.success(data: localWorkouts);
    } catch (e) {
      final localWorkouts = await _hiveService.getWorkouts();
      if (localWorkouts.isNotEmpty) {
        return ApiResponse.success(
          data: localWorkouts,
          message: "API failed, showing local data.",
        );
      }

      if (remoteWorkouts != null && remoteWorkouts.isNotEmpty) {
        return ApiResponse.success(
          data: remoteWorkouts,
          message: 'Local cache failed, showing remote data.',
        );
      }

      return ApiResponse.error(
        message: "Failed to fetch workouts: ${e.toString()}",
      );
    }
  }

  @override
  Future<ApiResponse<List<WorkoutModel>>> getRecentWorkouts() async {
    final response = await getWorkouts();
    if (response.success) {
      final allWorkouts = response.data ?? [];
      allWorkouts.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      return ApiResponse.success(data: allWorkouts.take(3).toList());
    }
    return response;
  }

  @override
  Future<ApiResponse<WorkoutModel?>> getWorkout(String workoutId) async {
    try {
      var workout = await _hiveService.getWorkout(workoutId);
      if (workout == null) {
        await refreshFromRemote();
        workout = await _hiveService.getWorkout(workoutId);
      }

      if (workout != null) {
        return ApiResponse.success(data: workout);
      } else {
        return ApiResponse.error(message: 'Workout not found in local cache');
      }
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats() async {
    return await _apiService.fetchWorkoutStats();
  }

  @override
  Future<ApiResponse<void>> enableWorkout(String workoutId) async {
    await _hiveService.enableWorkout(workoutId);
    return ApiResponse.success(message: 'Enabled workout $workoutId');
  }

  @override
  Future<ApiResponse<void>> disableWorkout(String workoutId) async {
    await _hiveService.disableWorkout(workoutId);
    return ApiResponse.success(message: 'Disabled workout $workoutId');
  }

  @override
  Future<ApiResponse<void>> deleteWorkout(String workoutId) async {
    await _hiveService.deleteWorkout(workoutId);
    return ApiResponse.success(message: 'Deleted workout $workoutId');
  }

  /// Patches workout locally and marks it dirty for later sync.
  @override
  Future<ApiResponse<void>> updateWorkout(WorkoutModel updatedWorkout) async {
    await _hiveService.patchWorkout(updatedWorkout);
    return ApiResponse.success(message: 'Updated workout ${updatedWorkout.id}');
  }

  @override
  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    WorkoutWriteCommand command,
  ) async {
    final response = await _apiService.patchWorkout(workoutId, command);
    if (response.success) {
      await refreshFromRemote();
    }
    return response;
  }
}
