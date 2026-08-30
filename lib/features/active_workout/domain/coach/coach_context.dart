import 'package:coachly/features/active_workout/domain/set_input_configuration.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';

class ComparableSetPerformance {
  final String exerciseId;
  final ExerciseTrackingType trackingType;
  final String? equipmentId;
  final String setType;
  final double? load;
  final int? reps;
  final int? rir;

  const ComparableSetPerformance({
    required this.exerciseId,
    required this.trackingType,
    required this.setType,
    this.equipmentId,
    this.load,
    this.reps,
    this.rir,
  });
}

class CoachContext {
  final String sessionId;
  final ActiveExerciseState? currentExercise;
  final ActiveSetState? currentSet;
  final ComparableSetPerformance? previousComparableSet;
  final String? equipmentId;
  final Duration elapsedSessionTime;
  final int remainingSetCount;
  final Duration? expectedSessionDuration;

  const CoachContext({
    required this.sessionId,
    this.currentExercise,
    this.currentSet,
    this.previousComparableSet,
    this.equipmentId,
    this.elapsedSessionTime = Duration.zero,
    this.remainingSetCount = 0,
    this.expectedSessionDuration,
  });
}
