import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';

class CoachDecisionResolver {
  const CoachDecisionResolver();

  CoachDecision? resolve(Iterable<CoachDecisionCandidate> candidates) {
    final deduplicated = <String, CoachDecisionCandidate>{};
    for (final candidate in candidates) {
      if (candidate.confidence == CoachConfidence.insufficient &&
          candidate.type != CoachDecisionType.notComparable) {
        continue;
      }
      final key = '${candidate.type.name}:${candidate.scope.name}';
      final current = deduplicated[key];
      if (current == null || _priority(candidate) > _priority(current)) {
        deduplicated[key] = candidate;
      }
    }
    final ordered = deduplicated.values.toList()
      ..sort((left, right) => _priority(right).compareTo(_priority(left)));
    if (ordered.isEmpty) return null;

    return CoachDecision(
      primary: ordered.first,
      observations: ordered
          .skip(1)
          .where(
            (candidate) =>
                candidate.severity == CoachDecisionSeverity.observation,
          )
          .toList(),
    );
  }

  int _priority(CoachDecisionCandidate candidate) {
    final typePriority = switch (candidate.type) {
      CoachDecisionType.invalidData => 700,
      CoachDecisionType.adjustCurrentSet => 600,
      CoachDecisionType.reviewSession => 400,
      CoachDecisionType.increaseLoad ||
      CoachDecisionType.progressReps ||
      CoachDecisionType.maintain => 300,
      CoachDecisionType.baseline || CoachDecisionType.notComparable => 200,
      CoachDecisionType.observe => 100,
    };
    final severityPriority = switch (candidate.severity) {
      CoachDecisionSeverity.warning => 40,
      CoachDecisionSeverity.recommendation => 30,
      CoachDecisionSeverity.suggestion => 20,
      CoachDecisionSeverity.observation => 10,
    };
    return typePriority + severityPriority;
  }
}
