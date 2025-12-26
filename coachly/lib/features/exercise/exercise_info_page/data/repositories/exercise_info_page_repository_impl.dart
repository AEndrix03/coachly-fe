import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_info_page_service.dart';

class ExerciseInfoPageRepositoryImpl implements IExerciseInfoPageRepository {
  final ExerciseInfoPageService _service;

  const ExerciseInfoPageRepositoryImpl(this._service);

  @override
  Future<ApiResponse<ExerciseDetailModel>> getExerciseDetail(
    String exerciseId,
  ) async {
    return await _service.fetchExerciseDetails(exerciseId);
  }

  @override
  Future<ApiResponse<List<ExerciseModel>>> getAllExercises() async {
    return await _service.fetchAllExercises();
  }
}
