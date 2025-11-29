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
}
