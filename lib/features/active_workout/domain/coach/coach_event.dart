sealed class CoachEvent {
  final String sessionId;
  final DateTime occurredAt;

  const CoachEvent({required this.sessionId, required this.occurredAt});
}

class WorkoutStarted extends CoachEvent {
  const WorkoutStarted({required super.sessionId, required super.occurredAt});
}

class SetPrepared extends CoachEvent {
  final String exerciseId;
  final String setId;

  const SetPrepared({
    required super.sessionId,
    required super.occurredAt,
    required this.exerciseId,
    required this.setId,
  });
}

class SetCompleted extends SetPrepared {
  const SetCompleted({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required super.setId,
  });
}

class SetEdited extends SetPrepared {
  const SetEdited({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required super.setId,
  });
}

class SetCompletionUndone extends SetPrepared {
  const SetCompletionUndone({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required super.setId,
  });
}

sealed class SetValueChanged extends SetPrepared {
  const SetValueChanged({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required super.setId,
  });
}

class LoadChanged extends SetValueChanged {
  final double load;

  const LoadChanged({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required super.setId,
    required this.load,
  });
}

class RepsChanged extends SetValueChanged {
  final int reps;

  const RepsChanged({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required super.setId,
    required this.reps,
  });
}

class RirRecorded extends SetValueChanged {
  final int rir;

  const RirRecorded({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required super.setId,
    required this.rir,
  });
}

class ExerciseStarted extends CoachEvent {
  final String exerciseId;

  const ExerciseStarted({
    required super.sessionId,
    required super.occurredAt,
    required this.exerciseId,
  });
}

class ExerciseSkipped extends ExerciseStarted {
  const ExerciseSkipped({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
  });
}

class ExerciseSubstituted extends ExerciseStarted {
  final String replacementExerciseId;

  const ExerciseSubstituted({
    required super.sessionId,
    required super.occurredAt,
    required super.exerciseId,
    required this.replacementExerciseId,
  });
}

class RestStarted extends CoachEvent {
  final int targetSeconds;

  const RestStarted({
    required super.sessionId,
    required super.occurredAt,
    required this.targetSeconds,
  });
}

class RestCompleted extends CoachEvent {
  const RestCompleted({required super.sessionId, required super.occurredAt});
}

class WorkoutCompleted extends CoachEvent {
  const WorkoutCompleted({required super.sessionId, required super.occurredAt});
}
