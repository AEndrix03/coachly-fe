import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutPageServiceProvider = Provider<WorkoutPageService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkoutPageService(apiClient);
});

class WorkoutPageService {
  final ApiClient _apiClient;

  WorkoutPageService(this._apiClient);

  Future<ApiResponse<List<WorkoutModel>>> fetchWorkouts() async {
    return await _apiClient.get<List<WorkoutModel>>(
      '/workouts/user',
      fromJson: (json) {
        if (json is List) {
          return json
              .map(
                (item) => WorkoutModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<List<WorkoutModel>>> fetchRecentWorkouts() async {
    final allWorkoutsResponse = await fetchWorkouts();
    if (allWorkoutsResponse.success) {
      final allWorkouts = allWorkoutsResponse.data ?? [];
      allWorkouts.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      return ApiResponse.success(data: allWorkouts.take(3).toList());
    }
    return allWorkoutsResponse;
  }

  Future<ApiResponse<WorkoutStatsModel>> fetchWorkoutStats() async {
    return ApiResponse.success(
      data: const WorkoutStatsModel(
        activeWorkouts: 4,
        completedWorkouts: 24,
        progressPercentage: 12.0,
        currentStreak: 7,
        weeklyWorkouts: 3,
      ),
    );
  }

  // Sincronizza workout dirty con il BE
  Future<ApiResponse<void>> syncDirtyWorkouts(
    List<WorkoutModel> dirtyWorkouts,
  ) async {
    return await _apiClient.post<void>(
      '/workouts/sync',
      body: {'workouts': dirtyWorkouts.map((w) => w.toJson()).toList()},
      fromJson: (_) => null,
    );
  }

  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    Map<String, dynamic> data,
  ) async {
    return await _apiClient.post<void>(
      '/workouts',
      body: data,
      fromJson: (_) => null,
    );
  }
}
