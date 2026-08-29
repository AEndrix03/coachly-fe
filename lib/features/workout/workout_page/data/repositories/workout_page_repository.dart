import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';

abstract class IWorkoutPageRepository {
  /// Tutte le sessioni locali.
  Future<List<LocalWorkoutSession>> getAllSessions();

  /// Quanti allenamenti registrati non sono ancora saliti.
  ///
  /// Serve alla guardia del logout: cancellare il database con la coda non
  /// vuota e' una perdita irreversibile
  /// (`docs/development/24-security-and-privacy.md`).
  Future<int> pendingSyncCount();

  /// Letture reattive: il database notifica i lettori, nessuno chiama
  /// `invalidate` (`docs/development/04-data-layer.md`).
  Stream<List<WorkoutModel>> watchWorkouts();

  Stream<List<LocalWorkoutSession>> watchSessions();

  Future<Result<List<WorkoutModel>, Failure>> getWorkouts();

  Future<Result<List<WorkoutModel>, Failure>> refreshFromRemote();

  Future<Result<List<WorkoutModel>, Failure>> getRecentWorkouts();

  Future<Result<WorkoutModel?, Failure>> getWorkout(String workoutId);

  Future<Result<WorkoutStatsModel, Failure>> getWorkoutStats();

  Future<Result<void, Failure>> enableWorkout(String workoutId);

  Future<Result<void, Failure>> disableWorkout(String workoutId);

  Future<Result<void, Failure>> deleteWorkout(String workoutId);

  Future<Result<void, Failure>> updateWorkout(WorkoutModel updatedWorkout);

  Future<Result<void, Failure>> patchWorkout(
    String workoutId,
    WorkoutWriteCommand command,
  );

  Future<Result<void, Failure>> saveSession(
    String workoutId,
    WorkoutSessionWriteCommand sessionCommand,
  );
}
