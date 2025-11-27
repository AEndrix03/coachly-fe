import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model.dart';

class WorkoutPageService {
  final ApiClient _apiClient;

  WorkoutPageService(this._apiClient);

  /// Fetch all workouts (active + inactive)
  Future<ApiResponse<List<Workout>>> fetchWorkouts() async {
    return await _apiClient.get<List<Workout>>(
      '/workouts',
      fromJson: (data) {
        if (data is List) {
          return data.map((json) => Workout.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

  /// Fetch workout statistics
  Future<ApiResponse<WorkoutStats>> fetchWorkoutStats() async {
    return await _apiClient.get<WorkoutStats>(
      '/workouts/stats',
      fromJson: (json) => WorkoutStats.fromJson(json),
    );
  }

  /// Fetch recent workouts (last 5 used)
  Future<ApiResponse<List<Workout>>> fetchRecentWorkouts() async {
    return await _apiClient.get<List<Workout>>(
      '/workouts/recent',
      fromJson: (data) {
        if (data is List) {
          return data.map((json) => Workout.fromJson(json)).toList();
        }
        return [];
      },
    );
  }
}
