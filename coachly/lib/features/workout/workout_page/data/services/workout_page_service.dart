import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';

class WorkoutPageService {
  final ApiClient _apiClient;

  WorkoutPageService(this._apiClient);

  /// Fetch all workouts (active + inactive)
  Future<ApiResponse<List<WorkoutModel>>> fetchWorkouts() async {
    return await _apiClient.get<List<WorkoutModel>>(
      '/workouts',
      fromJson: (data) {
        if (data is List) {
          return data.map((json) => WorkoutModel.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

  /// Fetch workout statistics
  Future<ApiResponse<WorkoutStatsModel>> fetchWorkoutStats() async {
    return await _apiClient.get<WorkoutStatsModel>(
      '/workouts/stats',
      fromJson: (json) => WorkoutStatsModel.fromJson(json),
    );
  }

  /// Fetch recent workouts (last 5 used)
  Future<ApiResponse<List<WorkoutModel>>> fetchRecentWorkouts() async {
    return await _apiClient.get<List<WorkoutModel>>(
      '/workouts/recent',
      fromJson: (data) {
        if (data is List) {
          return data.map((json) => WorkoutModel.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

  /// Enable a workout
  Future<ApiResponse<String>> enableWorkoutApi(String workoutId) async {
    return await _apiClient.put<String>(
      '/workouts/$workoutId/enable',
      fromJson: (data) => workoutId, // Assuming API returns nothing or success, we return the ID
    );
  }

  /// Disable a workout
  Future<ApiResponse<String>> disableWorkoutApi(String workoutId) async {
    return await _apiClient.put<String>(
      '/workouts/$workoutId/disable',
      fromJson: (data) => workoutId, // Assuming API returns nothing or success, we return the ID
    );
  }

  /// Delete a workout
  Future<ApiResponse<String>> deleteWorkoutApi(String workoutId) async {
    return await _apiClient.delete<String>(
      '/workouts/$workoutId',
      fromJson: (data) => workoutId, // Assuming API returns nothing or success, we return the ID
    );
  }

  /// Update a workout
  Future<ApiResponse<String>> updateWorkoutApi(WorkoutModel updatedWorkout) async {
    return await _apiClient.put<String>(
      '/workouts/${updatedWorkout.id}',
      body: updatedWorkout.toJson(),
      fromJson: (data) => updatedWorkout.id, // Assuming API returns nothing or success, we return the ID
    );
  }
}
