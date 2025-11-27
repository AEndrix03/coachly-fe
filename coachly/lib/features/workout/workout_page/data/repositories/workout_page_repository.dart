import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model.dart';

abstract class IWorkoutPageRepository {
  Future<ApiResponse<List<Workout>>> getWorkouts();

  Future<ApiResponse<List<Workout>>> getRecentWorkouts();

  Future<ApiResponse<WorkoutStats>> getWorkoutStats();
}
