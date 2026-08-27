import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_active_page/domain/set_input_configuration.dart';

enum ActiveWorkoutStatus { loading, active, saving, saved, error }

enum WorkoutSessionStatus { preparing, active, paused, completed }

enum WorkoutPhase { preparing, exercising, resting, completed }

/// The purpose of a set is independent from the technique applied to it.
enum SetRole { working, warmup, topSet, backoff }

enum SetTechnique { none, dropSet, restPause, myoReps, amrap, failure, cluster }

enum ExerciseGroupType {
  superset,
  triset,
  giantSet,
  circuit,
  preparation,
  mobility,
}

class DropSetState {
  final String id;
  final double weight;
  final int reps;

  const DropSetState({
    required this.id,
    required this.weight,
    required this.reps,
  });

  DropSetState copyWith({String? id, double? weight, int? reps}) =>
      DropSetState(
        id: id ?? this.id,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
      );
}

class ActiveExerciseGroup {
  final String id;
  final ExerciseGroupType type;
  final List<String> exerciseIds;
  final int? restBetweenExercisesSeconds;
  final int? restAfterRoundSeconds;
  final int? rounds;

  const ActiveExerciseGroup({
    required this.id,
    required this.type,
    required this.exerciseIds,
    this.restBetweenExercisesSeconds,
    this.restAfterRoundSeconds,
    this.rounds,
  });
}

class WorkoutExecutionTarget {
  final String blockId;
  final String exerciseId;
  final String setId;

  const WorkoutExecutionTarget({
    required this.blockId,
    required this.exerciseId,
    required this.setId,
  });
}

// ─── Set ──────────────────────────────────────────────────────────────────────

class ActiveSetState {
  final String id;
  final int position;
  final String setType;
  final double weight;
  final int reps;
  final bool completed;
  final bool skipped;
  final int? rir;
  final int? durationSeconds;
  final double? distance;
  final int? leftReps;
  final int? rightReps;
  final SetRole role;
  final SetTechnique technique;
  final List<DropSetState> drops;

  const ActiveSetState({
    required this.id,
    required this.position,
    required this.setType,
    required this.weight,
    required this.reps,
    required this.completed,
    this.skipped = false,
    this.rir,
    this.durationSeconds,
    this.distance,
    this.leftReps,
    this.rightReps,
    this.role = SetRole.working,
    this.technique = SetTechnique.none,
    this.drops = const [],
  });

  ActiveSetState copyWith({
    String? id,
    int? position,
    String? setType,
    double? weight,
    int? reps,
    bool? completed,
    bool? skipped,
    int? rir,
    int? durationSeconds,
    double? distance,
    int? leftReps,
    int? rightReps,
    SetRole? role,
    SetTechnique? technique,
    List<DropSetState>? drops,
  }) {
    return ActiveSetState(
      id: id ?? this.id,
      position: position ?? this.position,
      setType: setType ?? this.setType,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      completed: completed ?? this.completed,
      skipped: skipped ?? this.skipped,
      rir: rir ?? this.rir,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distance: distance ?? this.distance,
      leftReps: leftReps ?? this.leftReps,
      rightReps: rightReps ?? this.rightReps,
      role: role ?? this.role,
      technique: technique ?? this.technique,
      drops: drops ?? this.drops,
    );
  }
}

// ─── Exercise ─────────────────────────────────────────────────────────────────

class ActiveExerciseState {
  final String executionBlockId;
  final WorkoutExerciseModel exercise;
  final String displayName;
  final List<ActiveSetState> sets;

  const ActiveExerciseState({
    required this.executionBlockId,
    required this.exercise,
    required this.displayName,
    required this.sets,
  });

  int get completedSets => sets.where((s) => s.completed).length;
  int get totalSets => sets.length;
  SetInputConfiguration get inputConfiguration =>
      SetInputConfiguration.forExercise(exercise.exercise);

  int get restSeconds {
    final match = RegExp(r'\d+').firstMatch(exercise.rest);
    return match != null ? int.parse(match.group(0)!) : 90;
  }

  String get repsRange {
    if (sets.isEmpty) return '—';
    return sets.first.reps.toString();
  }

  ActiveExerciseState copyWith({
    String? executionBlockId,
    WorkoutExerciseModel? exercise,
    String? displayName,
    List<ActiveSetState>? sets,
  }) {
    return ActiveExerciseState(
      executionBlockId: executionBlockId ?? this.executionBlockId,
      exercise: exercise ?? this.exercise,
      displayName: displayName ?? this.displayName,
      sets: sets ?? this.sets,
    );
  }
}

// ─── Workout ──────────────────────────────────────────────────────────────────

class ActiveWorkoutState {
  final String sessionId;
  final ActiveWorkoutStatus status;
  final WorkoutModel? workout;
  final DateTime? startedAt;
  final WorkoutSessionStatus sessionStatus;
  final WorkoutPhase phase;
  final WorkoutExecutionTarget? currentTarget;
  final DateTime? lastSetCompletedAt;
  final String? pendingCoachDecisionId;
  final List<String> sessionChanges;
  final List<ActiveExerciseState> exercises;
  final List<ActiveExerciseGroup> groups;
  final String? errorMessage;

  const ActiveWorkoutState({
    this.sessionId = '',
    required this.status,
    this.workout,
    this.startedAt,
    this.sessionStatus = WorkoutSessionStatus.preparing,
    this.phase = WorkoutPhase.preparing,
    this.currentTarget,
    this.lastSetCompletedAt,
    this.pendingCoachDecisionId,
    this.sessionChanges = const [],
    this.exercises = const [],
    this.groups = const [],
    this.errorMessage,
  });

  factory ActiveWorkoutState.loading() =>
      const ActiveWorkoutState(status: ActiveWorkoutStatus.loading);

  factory ActiveWorkoutState.error(String message) => ActiveWorkoutState(
    status: ActiveWorkoutStatus.error,
    errorMessage: message,
  );

  int get totalExercises => exercises.length;

  int get completedSetCount =>
      exercises.fold(0, (total, exercise) => total + exercise.completedSets);

  int get totalSetCount =>
      exercises.fold(0, (total, exercise) => total + exercise.totalSets);

  ActiveExerciseState? get currentExercise {
    final exerciseId = currentTarget?.exerciseId;
    if (exerciseId == null) return null;
    for (final exercise in exercises) {
      if (exercise.exercise.id == exerciseId) return exercise;
    }
    return null;
  }

  ActiveSetState? get currentSet {
    final setId = currentTarget?.setId;
    if (setId == null) return null;
    for (final exercise in exercises) {
      for (final set in exercise.sets) {
        if (set.id == setId) return set;
      }
    }
    return null;
  }

  ActiveWorkoutState copyWith({
    String? sessionId,
    ActiveWorkoutStatus? status,
    WorkoutModel? workout,
    DateTime? startedAt,
    WorkoutSessionStatus? sessionStatus,
    WorkoutPhase? phase,
    WorkoutExecutionTarget? currentTarget,
    DateTime? lastSetCompletedAt,
    String? pendingCoachDecisionId,
    List<String>? sessionChanges,
    bool clearCurrentTarget = false,
    bool clearPendingCoachDecision = false,
    List<ActiveExerciseState>? exercises,
    List<ActiveExerciseGroup>? groups,
    String? errorMessage,
  }) {
    return ActiveWorkoutState(
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      workout: workout ?? this.workout,
      startedAt: startedAt ?? this.startedAt,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      phase: phase ?? this.phase,
      currentTarget: clearCurrentTarget
          ? null
          : currentTarget ?? this.currentTarget,
      lastSetCompletedAt: lastSetCompletedAt ?? this.lastSetCompletedAt,
      pendingCoachDecisionId: clearPendingCoachDecision
          ? null
          : pendingCoachDecisionId ?? this.pendingCoachDecisionId,
      sessionChanges: sessionChanges ?? this.sessionChanges,
      exercises: exercises ?? this.exercises,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
