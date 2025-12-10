import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';

import '../models/exercise_model/exercise_model.dart';

class ExerciseInfoPageService {
  final ApiClient _apiClient;

  ExerciseInfoPageService(this._apiClient);

  /// Fetch exercise details by id
  Future<ApiResponse<ExerciseModel>> fetchExerciseDetails(
    String exerciseId,
  ) async {
    return await _apiClient.get<ExerciseModel>(
      '/exercises/$exerciseId',
      fromJson: (json) => ExerciseModel.fromJson(json),
    );
  }

  /// Fetch all exercises (if needed)
  Future<ApiResponse<List<ExerciseModel>>> fetchAllExercises() async {
    return await _apiClient.get<List<ExerciseModel>>(
      '/exercises',
      fromJson: (data) {
        if (data is List) {
          return data.map((json) => ExerciseModel.fromJson(json)).toList();
        }
        return [];
      },
    );
  }
}
