import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';

class WorkoutExecutionResolver {
  const WorkoutExecutionResolver();

  WorkoutExecutionTarget? resolveNext({
    required List<ActiveExerciseState> exercises,
    WorkoutExecutionTarget? after,
  }) {
    final orderedTargets = <WorkoutExecutionTarget>[];
    final blockIds = <String>[];
    for (final exercise in exercises) {
      if (!blockIds.contains(exercise.executionBlockId)) {
        blockIds.add(exercise.executionBlockId);
      }
    }

    for (final blockId in blockIds) {
      final blockExercises = exercises
          .where((exercise) => exercise.executionBlockId == blockId)
          .toList();
      final maxSets = blockExercises.fold<int>(
        0,
        (maximum, exercise) =>
            exercise.sets.length > maximum ? exercise.sets.length : maximum,
      );
      for (var setPosition = 0; setPosition < maxSets; setPosition += 1) {
        for (final exercise in blockExercises) {
          if (setPosition >= exercise.sets.length) continue;
          final set = exercise.sets[setPosition];
          if (set.completed || set.skipped) continue;
          orderedTargets.add(
            WorkoutExecutionTarget(
              blockId: exercise.executionBlockId,
              exerciseId: exercise.exercise.id,
              setId: set.id,
            ),
          );
        }
      }
    }

    if (orderedTargets.isEmpty) return null;
    if (after == null) return orderedTargets.first;

    final afterIndex = orderedTargets.indexWhere(
      (target) => target.setId == after.setId,
    );
    if (afterIndex == -1 || afterIndex + 1 >= orderedTargets.length) {
      return orderedTargets.first;
    }
    return orderedTargets[afterIndex + 1];
  }
}
