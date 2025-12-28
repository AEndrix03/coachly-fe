import 'package:coachly/core/network/api_response.dart';
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

  WorkoutPageRepositoryImpl(this._apiService, this._hiveService);

  @override
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts() async {
    try {
      // Fetch remote workouts first.
      final remoteResponse = await _apiService.fetchWorkouts();
      if (remoteResponse.success && remoteResponse.data != null) {
        // If successful, add any new workouts to the local hive box.
        await _hiveService.patchWorkouts(remoteResponse.data!);
      }

      // Always return the data from hive as the source of truth.
      final localWorkouts = await _hiveService.getWorkouts();
      return ApiResponse.success(data: localWorkouts);
    } catch (e) {
      // If API fails, still try to return local data.
      final localWorkouts = await _hiveService.getWorkouts();
      if (localWorkouts.isNotEmpty) {
        return ApiResponse.success(
          data: localWorkouts,
          message: "API failed, showing local data.",
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
      final workout = await _hiveService.getWorkout(workoutId);
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
    return ApiResponse.success(
      data: _hiveService.enableWorkout(workoutId),
      message: "Enabled workout ${workoutId}",
    );
  }

  @override
  Future<ApiResponse<void>> disableWorkout(String workoutId) async {
    return ApiResponse.success(
      data: _hiveService.disableWorkout(workoutId),
      message: "Disabeled workout ${workoutId}",
    );
  }

  @override
  Future<ApiResponse<void>> deleteWorkout(String workoutId) async {
    return ApiResponse.success(
      data: _hiveService.deleteWorkout(workoutId),
      message: "Deleted workout ${workoutId}",
    );
  }

  @override
  Future<ApiResponse<void>> updateWorkout(WorkoutModel updatedWorkout) async {
    // TODO: Implement logic to mark workout as dirty and sync later.
    return ApiResponse.success(
      data: _hiveService.patchWorkout(updatedWorkout),
      message: "Updated workout ${updatedWorkout.id}",
    );
  }

  @override
  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    Map<String, dynamic> data,
  ) async {
    // TODO: After patching, the local HIVE data will be stale.
    // We need a way to get the updated model and save it to Hive.
    return await _apiService.patchWorkout(workoutId, data);
  }
}
