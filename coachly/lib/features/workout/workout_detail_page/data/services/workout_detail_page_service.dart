import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';

class WorkoutDetailPageService {
  final ApiClient _apiClient;

  WorkoutDetailPageService(this._apiClient);

  /// Fetch workout by workoutId
  Future<ApiResponse<WorkoutModel>> fetchWorkout(
    String workoutId,
  ) async {
    return await _apiClient.get<WorkoutModel>(
      '/workouts/${workoutId}',
      fromJson: (data) => WorkoutModel.fromJson(data),
    );
  }

  /// Patch a workout
  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    Map<String, dynamic> data,
  ) async {
    return await _apiClient.post<void>(
      '/workouts/$workoutId',
      body: data,
      fromJson: (_) => null,
    );
  }
}
