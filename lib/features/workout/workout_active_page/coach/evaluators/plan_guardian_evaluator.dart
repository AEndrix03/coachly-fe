import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_evaluator.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_event.dart';

class PlanGuardianEvaluator implements CoachEvaluator {
  const PlanGuardianEvaluator();

  @override
  List<CoachDecisionCandidate> evaluate(
    CoachEvent event,
    CoachContext context,
  ) {
    final expected = context.expectedSessionDuration;
    if (expected == null || context.remainingSetCount == 0) return const [];
    final overrun = context.elapsedSessionTime - expected;
    if (overrun < const Duration(minutes: 10)) return const [];

    return [
      CoachDecisionCandidate(
        id: 'guardian:pacing:${context.sessionId}',
        type: CoachDecisionType.reviewSession,
        scope: CoachDecisionScope.session,
        severity: CoachDecisionSeverity.suggestion,
        confidence: CoachConfidence.medium,
        titleKey: 'coach.guardian.pacing_title',
        reasonKey: 'coach.guardian.pacing_reason',
        action: CoachAction(
          type: 'review_remaining_workout',
          payload: {'remainingSets': context.remainingSetCount},
        ),
        evidence: [
          CoachEvidence(
            labelKey: 'coach.evidence.elapsed',
            value: '${context.elapsedSessionTime.inMinutes}',
          ),
        ],
        isActionable: true,
      ),
    ];
  }
}
