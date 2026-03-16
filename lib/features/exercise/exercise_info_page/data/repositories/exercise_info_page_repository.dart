import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';

abstract class IExerciseInfoPageRepository {
  Future<ApiResponse<ExerciseDetailModel>> getExerciseDetail(String exerciseId);

  Future<ApiResponse<List<ExerciseModel>>> getAllExercises();

  Future<ApiResponse<List<ExerciseDetailModel>>> getFilteredExercises(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  });

  Future<ApiResponse<List<ExerciseDetailModel>>> refreshFromRemote();
}
