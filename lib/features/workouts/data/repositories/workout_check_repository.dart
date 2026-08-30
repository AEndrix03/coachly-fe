import 'package:coachly/features/workouts/domain/workout_draft.dart';
import 'package:coachly/features/workouts/data/services/workout_check_service.dart';
import 'package:coachly/features/workouts/domain/workout_check_models.dart';

abstract interface class WorkoutCheckRepository {
  Future<WorkoutCheckReport> evaluate(WorkoutDraft draft);
}

class LocalWorkoutCheckRepository implements WorkoutCheckRepository {
  final WorkoutCheckService service;
  const LocalWorkoutCheckRepository(this.service);

  @override
  Future<WorkoutCheckReport> evaluate(WorkoutDraft draft) =>
      service.evaluate(draft);
}
