import 'package:coachly/features/active_workout/domain/coach/coach_context.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_decision.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_evaluator.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_event.dart';
import 'package:coachly/features/active_workout/domain/coach/performance_comparator.dart';

class ComparabilityEvaluator implements CoachEvaluator {
  final PerformanceComparator comparator;

  const ComparabilityEvaluator(this.comparator);

  @override
  List<CoachDecisionCandidate> evaluate(
    CoachEvent event,
    CoachContext context,
  ) {
    final exercise = context.currentExercise;
    final set = context.currentSet;
    final result = comparator.compare(
      previous: context.previousComparableSet,
      currentExerciseId: exercise?.exercise.exercise.id,
      currentTrackingType: exercise?.inputConfiguration.trackingType,
      currentEquipmentId: context.equipmentId,
      currentSetType: set?.setType,
    );
    if (result == PerformanceComparability.comparable) return const [];

    return [
      CoachDecisionCandidate(
        id: 'comparability:${context.sessionId}:${set?.id ?? 'unknown'}',
        type: CoachDecisionType.notComparable,
        scope: CoachDecisionScope.set,
        severity: CoachDecisionSeverity.observation,
        confidence: CoachConfidence.insufficient,
        titleKey: 'coach.comparability.new_baseline',
        reasonKey: 'coach.comparability.${result.name}',
      ),
    ];
  }
}
