import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_check/data/workout_check_service.dart';
import 'package:coachly/features/workout/workout_check/domain/workout_check_models.dart';

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
