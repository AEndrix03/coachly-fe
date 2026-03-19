import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'context_assembler_service.g.dart';

@riverpod
WorkoutContext currentWorkoutContext(Ref ref) {
  final workoutId = ref.watch(aiCoachWorkoutIdProvider);
  final activeState = ref.watch(activeWorkoutProvider(workoutId));
  final locale = ref.watch(languageProvider);
  final allWorkouts =
      ref.watch(workoutListProvider).value ?? const <WorkoutModel>[];

  if (activeState.exercises.isEmpty) {
    return WorkoutContext(
      exerciseName: AppStrings.translate(
        'ai.context_loading_exercise',
        locale: locale,
      ),
      currentSet: 1,
      totalSets: 1,
      weightKg: 0,
      targetReps: 0,
      fatigueIndex: 0,
      recentWeights: const [],
      sessionStart: activeState.startedAt ?? DateTime.now(),
    );
  }

  final activeExercise = _resolveCurrentExercise(activeState.exercises);
  final setIndex = activeExercise.sets.indexWhere((set) => !set.completed);
  final resolvedSetIndex = setIndex == -1
      ? (activeExercise.sets.isEmpty ? 0 : activeExercise.sets.length - 1)
      : setIndex;
  final resolvedSet = activeExercise.sets[resolvedSetIndex];

  final exerciseName =
      activeExercise.exercise.exercise.nameI18n
              ?.fromI18n(locale)
              .trim()
              .isNotEmpty ==
          true
      ? activeExercise.exercise.exercise.nameI18n!.fromI18n(locale)
      : activeExercise.displayName;

  final fatigueIndex = _estimateFatigue(activeState, resolvedSet.weight);
  final recentWeights = _extractRecentWeights(
    workouts: allWorkouts,
    exerciseId: activeExercise.exercise.exercise.id,
  );

  return WorkoutContext(
    exerciseName: exerciseName,
    currentSet: resolvedSetIndex + 1,
    totalSets: activeExercise.sets.length,
    weightKg: resolvedSet.weight,
    targetReps: resolvedSet.reps,
    completedReps: resolvedSet.completed ? resolvedSet.reps : null,
    fatigueIndex: fatigueIndex,
    recentWeights: recentWeights,
    sessionStart: activeState.startedAt ?? DateTime.now(),
  );
}

@riverpod
String aiCoachWorkoutId(Ref ref) => '';

ActiveExerciseState _resolveCurrentExercise(
  List<ActiveExerciseState> exercises,
) {
  for (final exercise in exercises) {
    if (exercise.sets.any((set) => !set.completed)) {
      return exercise;
    }
  }
  return exercises.first;
}

double _estimateFatigue(ActiveWorkoutState state, double currentWeight) {
  final completed = <ActiveSetState>[];
  for (final exercise in state.exercises) {
    for (final set in exercise.sets) {
      if (set.completed) {
        completed.add(set);
      }
    }
  }

  if (completed.isEmpty) {
    return 0.1;
  }

  final sample = completed.reversed.take(3).toList();
  final avgLoad =
      sample.fold<double>(0, (sum, set) => sum + set.weight) / sample.length;
  final loadFactor = currentWeight <= 0
      ? 0.2
      : (avgLoad / currentWeight).clamp(0, 1.4) / 1.4;

  // Approximation when RPE is unavailable: completion/load trend translated in 0..1.
  return (sample.length * 0.11 + loadFactor * 0.67).clamp(0, 1).toDouble();
}

List<double> _extractRecentWeights({
  required List<WorkoutModel> workouts,
  required String? exerciseId,
}) {
  if (exerciseId == null || exerciseId.isEmpty) {
    return const [];
  }

  final sortedWorkouts = [...workouts]
    ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  final collected = <double>[];

  for (final workout in sortedWorkouts) {
    for (final exercise in workout.workoutExercises) {
      if (exercise.exercise.id != exerciseId) {
        continue;
      }
      final weight = _parseWeight(exercise.weight);
      if (weight > 0) {
        collected.add(weight);
      }
      if (collected.length >= 4) {
        return collected;
      }
    }
  }

  return collected;
}

double _parseWeight(String raw) {
  final match = RegExp(r'[\d.,]+').firstMatch(raw);
  if (match == null) {
    return 0;
  }
  final normalized = match.group(0)!.replaceAll(',', '.');
  return double.tryParse(normalized) ?? 0;
}
