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
        await _hiveService.addWorkouts(remoteResponse.data!);
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
  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats() async {
    return await _apiService.fetchWorkoutStats();
  }

  @override
  Future<ApiResponse<String>> enableWorkout(String workoutId) async {
    // Here you would typically make an API call.
    // For now, we can imagine it succeeds and we might update local state.
    return await _apiService.enableWorkoutApi(workoutId);
  }

  @override
  Future<ApiResponse<String>> disableWorkout(String workoutId) async {
    return await _apiService.disableWorkoutApi(workoutId);
  }

  @override
  Future<ApiResponse<String>> deleteWorkout(String workoutId) async {
    return await _apiService.deleteWorkoutApi(workoutId);
  }

  @override
  Future<ApiResponse<String>> updateWorkout(WorkoutModel updatedWorkout) async {
    // TODO: Implement logic to mark workout as dirty and sync later.
    return await _apiService.updateWorkoutApi(updatedWorkout);
  }
}
