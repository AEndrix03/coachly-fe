import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';

enum ActiveWorkoutStatus { loading, active, saving, saved, error }

// ─── Set ──────────────────────────────────────────────────────────────────────

class ActiveSetState {
  final int position;
  final String setType;
  final double weight;
  final int reps;
  final bool completed;

  const ActiveSetState({
    required this.position,
    required this.setType,
    required this.weight,
    required this.reps,
    required this.completed,
  });

  ActiveSetState copyWith({
    int? position,
    String? setType,
    double? weight,
    int? reps,
    bool? completed,
  }) {
    return ActiveSetState(
      position: position ?? this.position,
      setType: setType ?? this.setType,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      completed: completed ?? this.completed,
    );
  }
}

// ─── Exercise ─────────────────────────────────────────────────────────────────

class ActiveExerciseState {
  final WorkoutExerciseModel exercise;
  final String displayName;
  final List<ActiveSetState> sets;

  const ActiveExerciseState({
    required this.exercise,
    required this.displayName,
    required this.sets,
  });

  int get completedSets => sets.where((s) => s.completed).length;
  int get totalSets => sets.length;

  int get restSeconds {
    final match = RegExp(r'\d+').firstMatch(exercise.rest);
    return match != null ? int.parse(match.group(0)!) : 90;
  }

  String get repsRange {
    if (sets.isEmpty) return '—';
    return sets.first.reps.toString();
  }

  ActiveExerciseState copyWith({
    WorkoutExerciseModel? exercise,
    String? displayName,
    List<ActiveSetState>? sets,
  }) {
    return ActiveExerciseState(
      exercise: exercise ?? this.exercise,
      displayName: displayName ?? this.displayName,
      sets: sets ?? this.sets,
    );
  }
}

// ─── Workout ──────────────────────────────────────────────────────────────────

class ActiveWorkoutState {
  final ActiveWorkoutStatus status;
  final WorkoutModel? workout;
  final DateTime? startedAt;
  final List<ActiveExerciseState> exercises;
  final String? errorMessage;

  const ActiveWorkoutState({
    required this.status,
    this.workout,
    this.startedAt,
    this.exercises = const [],
    this.errorMessage,
  });

  factory ActiveWorkoutState.loading() =>
      const ActiveWorkoutState(status: ActiveWorkoutStatus.loading);

  factory ActiveWorkoutState.error(String message) => ActiveWorkoutState(
    status: ActiveWorkoutStatus.error,
    errorMessage: message,
  );

  int get totalExercises => exercises.length;

  ActiveWorkoutState copyWith({
    ActiveWorkoutStatus? status,
    WorkoutModel? workout,
    DateTime? startedAt,
    List<ActiveExerciseState>? exercises,
    String? errorMessage,
  }) {
    return ActiveWorkoutState(
      status: status ?? this.status,
      workout: workout ?? this.workout,
      startedAt: startedAt ?? this.startedAt,
      exercises: exercises ?? this.exercises,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
