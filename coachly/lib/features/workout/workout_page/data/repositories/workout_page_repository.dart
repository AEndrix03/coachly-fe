import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';

abstract class IWorkoutPageRepository {
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts();

  Future<ApiResponse<List<WorkoutModel>>> getRecentWorkouts();

  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats();
}
