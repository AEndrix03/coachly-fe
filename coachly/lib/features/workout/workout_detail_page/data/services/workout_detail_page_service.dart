import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_detail_page/data/models/exercise_info_model/exercise_info_model.dart';
import 'package:coachly/features/workout/workout_detail_page/data/models/workout_detail_model/workout_detail_model.dart';

class WorkoutDetailPageService {
  final ApiClient _apiClient;

  WorkoutDetailPageService(this._apiClient);

  /// Fetch workoutDetail by workoutId
  Future<ApiResponse<WorkoutDetailModel>> fetchWorkoutDetails(
    String workoutId,
  ) async {
    return await _apiClient.get<WorkoutDetailModel>(
      '/workouts/${workoutId}',
      fromJson: (data) => WorkoutDetailModel.fromJson(data),
    );
  }

  /// Fetch all exercises for a given workoutId
  Future<ApiResponse<List<ExerciseInfoModel>>> fetchAllWorkoutExercises(
    String workoutId,
  ) async {
    return await _apiClient.get<List<ExerciseInfoModel>>(
      '/workouts/exercises/${workoutId}',
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => ExerciseInfoModel.fromJson(item)).toList();
        }
        return [];
      },
    );
  }
}
