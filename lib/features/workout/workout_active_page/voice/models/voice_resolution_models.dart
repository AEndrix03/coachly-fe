enum VoiceMatchDecisionType { autoMatch, topSuggestions, manualSelection }

class ParsedVoiceEntry {
  const ParsedVoiceEntry({
    required this.originalText,
    required this.normalizedText,
    required this.exercisePhrase,
    required this.sets,
    required this.reps,
    required this.weightKg,
  });

  final String originalText;
  final String normalizedText;
  final String exercisePhrase;
  final int? sets;
  final int? reps;
  final double? weightKg;
}

class VoiceContextExercise {
  const VoiceContextExercise({
    required this.exerciseId,
    required this.displayName,
    required this.order,
    required this.hasCompletedSets,
    required this.aliases,
  });

  final String exerciseId;
  final String displayName;
  final int order;
  final bool hasCompletedSets;
  final List<String> aliases;
}

class VoiceResolutionContext {
  const VoiceResolutionContext({
    required this.workoutId,
    required this.userId,
    required this.currentExerciseOrder,
    required this.workoutExercises,
  });

  final String workoutId;
  final String? userId;
  final int? currentExerciseOrder;
  final List<VoiceContextExercise> workoutExercises;

  bool containsExercise(String exerciseId) {
    return workoutExercises.any((exercise) => exercise.exerciseId == exerciseId);
  }
}

class VoiceExerciseCatalogEntry {
  const VoiceExerciseCatalogEntry({
    required this.exerciseId,
    required this.canonicalName,
    required this.aliases,
    required this.equipment,
    required this.muscleGroups,
    required this.isActive,
  });

  final String exerciseId;
  final String canonicalName;
  final List<String> aliases;
  final String? equipment;
  final List<String> muscleGroups;
  final bool isActive;
}

class VoiceExerciseCandidate {
  const VoiceExerciseCandidate({
    required this.exerciseId,
    required this.displayName,
    required this.baseScore,
    required this.finalScore,
    required this.isInActiveWorkout,
    required this.scoreBreakdown,
  });

  final String exerciseId;
  final String displayName;
  final double baseScore;
  final double finalScore;
  final bool isInActiveWorkout;
  final Map<String, double> scoreBreakdown;

  VoiceExerciseCandidate copyWith({
    double? baseScore,
    double? finalScore,
    bool? isInActiveWorkout,
    Map<String, double>? scoreBreakdown,
  }) {
    return VoiceExerciseCandidate(
      exerciseId: exerciseId,
      displayName: displayName,
      baseScore: baseScore ?? this.baseScore,
      finalScore: finalScore ?? this.finalScore,
      isInActiveWorkout: isInActiveWorkout ?? this.isInActiveWorkout,
      scoreBreakdown: scoreBreakdown ?? this.scoreBreakdown,
    );
  }
}

class VoiceMatchDecision {
  const VoiceMatchDecision({
    required this.type,
    required this.confidence,
  });

  final VoiceMatchDecisionType type;
  final double confidence;
}

class VoiceResolutionResult {
  const VoiceResolutionResult({
    required this.logId,
    required this.parsedEntry,
    required this.candidates,
    required this.decision,
  });

  final String logId;
  final ParsedVoiceEntry parsedEntry;
  final List<VoiceExerciseCandidate> candidates;
  final VoiceMatchDecision decision;
}

class UserVoiceAliasMatch {
  const UserVoiceAliasMatch({
    required this.exerciseId,
    required this.confirmations,
  });

  final String exerciseId;
  final int confirmations;
}

class VoiceApplyOutcome {
  const VoiceApplyOutcome({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weightKg,
  });

  final String exerciseId;
  final String exerciseName;
  final int sets;
  final int reps;
  final double weightKg;
}
