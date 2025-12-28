import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';

abstract class IWorkoutPageRepository {
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts();

  Future<ApiResponse<List<WorkoutModel>>> getRecentWorkouts();

  Future<ApiResponse<WorkoutModel?>> getWorkout(String workoutId);

  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats();

  Future<ApiResponse<void>> enableWorkout(String workoutId);

  Future<ApiResponse<void>> disableWorkout(String workoutId);

  Future<ApiResponse<void>> deleteWorkout(String workoutId);

  Future<ApiResponse<void>> updateWorkout(WorkoutModel updatedWorkout);

  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    Map<String, dynamic> data,
  );
}
