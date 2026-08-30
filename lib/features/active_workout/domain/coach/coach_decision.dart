enum CoachDecisionType {
  baseline,
  maintain,
  progressReps,
  increaseLoad,
  observe,
  adjustCurrentSet,
  reviewSession,
  invalidData,
  notComparable,
}

enum CoachDecisionScope { set, exercise, session, program }

enum CoachDecisionSeverity { observation, suggestion, recommendation, warning }

enum CoachConfidence { insufficient, low, medium, high }

class CoachEvidence {
  final String labelKey;
  final String value;

  const CoachEvidence({required this.labelKey, required this.value});
}

class CoachAction {
  final String type;
  final Map<String, Object?> payload;

  const CoachAction({required this.type, this.payload = const {}});
}

class CoachDecisionCandidate {
  final String id;
  final CoachDecisionType type;
  final CoachDecisionScope scope;
  final CoachDecisionSeverity severity;
  final CoachConfidence confidence;
  final CoachAction? action;
  final String titleKey;
  final String reasonKey;
  final List<CoachEvidence> evidence;
  final bool isDismissible;
  final bool isActionable;

  const CoachDecisionCandidate({
    required this.id,
    required this.type,
    required this.scope,
    required this.severity,
    required this.confidence,
    required this.titleKey,
    required this.reasonKey,
    this.action,
    this.evidence = const [],
    this.isDismissible = true,
    this.isActionable = false,
  });
}

class CoachDecision {
  final CoachDecisionCandidate primary;
  final List<CoachDecisionCandidate> observations;

  const CoachDecision({required this.primary, this.observations = const []});
}
