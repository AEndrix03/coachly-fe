import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';

abstract class IWorkoutDetailPageRepository {
  Future<ApiResponse<WorkoutModel>> getWorkout(String workoutId);
}
