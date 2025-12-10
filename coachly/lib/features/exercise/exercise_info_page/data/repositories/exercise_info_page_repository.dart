import 'package:coachly/core/network/api_response.dart';

import '../models/exercise_model/exercise_model.dart';

abstract class IExerciseInfoPageRepository {
  Future<ApiResponse<ExerciseModel>> getExerciseDetail(String exerciseId);

  Future<ApiResponse<List<ExerciseModel>>> getAllExercises();
}
