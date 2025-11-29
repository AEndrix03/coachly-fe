import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_detail_page/data/models/exercise_info_model/exercise_info_model.dart';
import 'package:coachly/features/workout/workout_detail_page/data/models/workout_detail_model/workout_detail_model.dart';

abstract class IWorkoutDetailPageRepository {
  Future<ApiResponse<WorkoutDetailModel>> getWorkoutDetail(String workoutId);

  Future<ApiResponse<List<ExerciseInfoModel>>> getWorkoutExercises(
    String workoutId,
  );
}
