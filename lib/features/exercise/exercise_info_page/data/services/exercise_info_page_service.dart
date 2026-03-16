import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';

class ExerciseInfoPageService {
  final ApiClient _apiClient;

  ExerciseInfoPageService(this._apiClient);

  /// Fetch exercise details by id
  Future<ApiResponse<ExerciseDetailModel>> fetchExerciseDetails(
    String exerciseId,
  ) async {
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

  /// Fetch filtered exercises
  Future<ApiResponse<List<ExerciseDetailModel>>> fetchFilteredExercises(
    ExerciseFilterModel filter,
  ) async {
    final Map<String, String> queryParameters = {};

    if (filter.textFilter != null && filter.textFilter!.isNotEmpty) {
      queryParameters['textFilter'] = filter.textFilter!;
    }
    if (filter.langFilter != null && filter.langFilter!.isNotEmpty) {
      queryParameters['langFilter'] = filter.langFilter!;
    }
    if (filter.difficultyLevel != null && filter.difficultyLevel!.isNotEmpty) {
      queryParameters['difficultyLevel'] = filter.difficultyLevel!;
    }
    if (filter.mechanicsType != null && filter.mechanicsType!.isNotEmpty) {
      queryParameters['mechanicsType'] = filter.mechanicsType!;
    }
    if (filter.forceType != null && filter.forceType!.isNotEmpty) {
      queryParameters['forceType'] = filter.forceType!;
    }
    if (filter.isUnilateral != null) {
      queryParameters['isUnilateral'] = filter.isUnilateral!.toString();
    }
    if (filter.isBodyweight != null) {
      queryParameters['isBodyweight'] = filter.isBodyweight!.toString();
    }
    if (filter.categoryIds != null && filter.categoryIds!.isNotEmpty) {
      queryParameters['categoryIds'] = filter.categoryIds!.join(',');
    }
    if (filter.muscleIds != null && filter.muscleIds!.isNotEmpty) {
      queryParameters['muscleIds'] = filter.muscleIds!.join(',');
    }

    return await _apiClient.get<List<ExerciseDetailModel>>(
      '/exercises/filtered',
      queryParameters: queryParameters,
      fromJson: (data) {
        if (data is List) {
          return data
              .map((json) => ExerciseDetailModel.fromJson(json))
              .toList();
        }
        return [];
      },
    );
  }
}
