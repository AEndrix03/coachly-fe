import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';

class ExerciseInfoPageService {
  final ApiClient _apiClient;

  ExerciseInfoPageService(this._apiClient);

  /// Fetch exercise details by id
  Future<ApiResponse<ExerciseDetailModel>> fetchExerciseDetails(
    String exerciseId,
  ) async {
    // Assuming the endpoint for the full detail model is now /details
    return await _apiClient.get<ExerciseDetailModel>(
      '/exercises/$exerciseId/details',
      fromJson: (json) => ExerciseDetailModel.fromJson(json),
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
