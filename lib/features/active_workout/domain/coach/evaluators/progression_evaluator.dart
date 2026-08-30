import 'package:coachly/features/active_workout/domain/coach/coach_context.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_decision.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_evaluator.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_event.dart';

class ProgressionEvaluator implements CoachEvaluator {
  const ProgressionEvaluator();

  @override
  List<CoachDecisionCandidate> evaluate(
    CoachEvent event,
    CoachContext context,
  ) {
    if (event is! SetCompleted) return const [];
    final current = context.currentSet;
    final previous = context.previousComparableSet;
    if (current == null || previous == null) return const [];
    if (current.rir == null || previous.rir == null) return const [];

    if (current.reps >= (previous.reps ?? current.reps) &&
        current.rir! >= previous.rir!) {
      return [
        CoachDecisionCandidate(
          id: 'progress:${event.setId}',
          type: CoachDecisionType.progressReps,
          scope: CoachDecisionScope.set,
          severity: CoachDecisionSeverity.recommendation,
          confidence: CoachConfidence.medium,
          titleKey: 'coach.progress_reps.title',
          reasonKey: 'coach.progress_reps.reason',
          action: CoachAction(
            type: 'adjust_reps',
            payload: {'reps': current.reps + 1},
          ),
          evidence: [
            CoachEvidence(
              labelKey: 'coach.evidence.previous',
              value:
                  '${previous.load ?? 0} × ${previous.reps} @${previous.rir}',
            ),
          ],
          isActionable: true,
        ),
      ];
    }

    return [
      CoachDecisionCandidate(
        id: 'observe:${event.setId}',
        type: CoachDecisionType.observe,
        scope: CoachDecisionScope.exercise,
        severity: CoachDecisionSeverity.observation,
        confidence: CoachConfidence.low,
        titleKey: 'coach.observe.title',
        reasonKey: 'coach.observe.reason',
      ),
    ];
  }
}
