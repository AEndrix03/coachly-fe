import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';

abstract class IWorkoutPageRepository {
  /// Letture reattive: il database notifica i lettori, nessuno chiama
  /// `invalidate` (`docs/development/04-data-layer.md`).
  Stream<List<WorkoutModel>> watchWorkouts();

  Stream<List<LocalWorkoutSession>> watchSessions();

  Future<ApiResponse<List<WorkoutModel>>> getWorkouts();

  Future<ApiResponse<List<WorkoutModel>>> refreshFromRemote();

  Future<ApiResponse<List<WorkoutModel>>> getRecentWorkouts();

  Future<ApiResponse<WorkoutModel?>> getWorkout(String workoutId);

  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats();

  Future<ApiResponse<void>> enableWorkout(String workoutId);

  Future<ApiResponse<void>> disableWorkout(String workoutId);

  Future<ApiResponse<void>> deleteWorkout(String workoutId);

  Future<ApiResponse<void>> updateWorkout(WorkoutModel updatedWorkout);

  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    WorkoutWriteCommand command,
  );

  Future<ApiResponse<void>> saveSession(
    String workoutId,
    WorkoutSessionWriteCommand sessionCommand,
  );
}
