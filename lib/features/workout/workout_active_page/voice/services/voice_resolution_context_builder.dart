import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceResolutionContextBuilderProvider =
    Provider<VoiceResolutionContextBuilder>((ref) {
      return const VoiceResolutionContextBuilder();
    });

class VoiceResolutionContextBuilder {
  const VoiceResolutionContextBuilder();

  VoiceResolutionContext build({
    required String workoutId,
    required ActiveWorkoutState workoutState,
    required String? userId,
  }) {
    final exercises = workoutState.exercises.asMap().entries.map((entry) {
      final index = entry.key;
      final exercise = entry.value;
      final exerciseId = exercise.exercise.exercise.id ?? '';

      final aliases = <String>{
        exercise.displayName,
        ...exercise.exercise.exercise.nameI18n?.values ?? const <String>[],
        ...exercise.exercise.exercise.variants
                ?.expand((variant) => variant.nameI18n?.values ?? const <String>[]) ??
            const <String>[],
      };

      final normalizedAliases = aliases
          .map((alias) => alias.trim())
          .where((alias) => alias.isNotEmpty)
          .toList(growable: false);

      return VoiceContextExercise(
        exerciseId: exerciseId,
        displayName: exercise.displayName,
        order: index,
        hasCompletedSets: exercise.completedSets > 0,
        aliases: normalizedAliases,
      );
    }).where((exercise) => exercise.exerciseId.trim().isNotEmpty).toList();

    final currentExerciseOrder = workoutState.exercises.indexWhere(
      (exercise) => exercise.sets.any((set) => !set.completed),
    );

    return VoiceResolutionContext(
      workoutId: workoutId,
      userId: userId,
      currentExerciseOrder: currentExerciseOrder == -1 ? null : currentExerciseOrder,
      workoutExercises: exercises,
    );
  }
}
