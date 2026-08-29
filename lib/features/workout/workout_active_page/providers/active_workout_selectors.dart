import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Narrow dependencies for active-workout widgets.  These are intentionally
/// plain providers so they can evolve independently from the generated
/// controller provider.
final activeExerciseIdProvider = Provider.family<String?, String>((
  ref,
  workoutId,
) {
  return ref.watch(
    activeWorkoutProvider(
      workoutId,
    ).select((state) => state.currentTarget?.exerciseId),
  );
});

final activeSetIdProvider = Provider.family<String?, String>((ref, workoutId) {
  return ref.watch(
    activeWorkoutProvider(
      workoutId,
    ).select((state) => state.currentTarget?.setId),
  );
});

final activeExerciseProvider = Provider.family<ActiveExerciseState?, String>((
  ref,
  workoutId,
) {
  final id = ref.watch(activeExerciseIdProvider(workoutId));
  return ref.watch(
    activeWorkoutProvider(workoutId).select((state) {
      if (id == null) return null;
      return state.exercises
          .where((exercise) => exercise.exercise.id == id)
          .firstOrNull;
    }),
  );
});

final activeSetProvider = Provider.family<ActiveSetState?, String>((
  ref,
  workoutId,
) {
  final id = ref.watch(activeSetIdProvider(workoutId));
  return ref.watch(
    activeWorkoutProvider(workoutId).select((state) {
      if (id == null) return null;
      for (final exercise in state.exercises) {
        final set = exercise.sets
            .where((candidate) => candidate.id == id)
            .firstOrNull;
        if (set != null) return set;
      }
      return null;
    }),
  );
});
