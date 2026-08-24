import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_evaluator.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_event.dart';

class DataQualityEvaluator implements CoachEvaluator {
  static const double _minimumAbsoluteDifferenceKg = 40;
  static const double _maximumRecentLoadRatio = 3;

  const DataQualityEvaluator();

  @override
  List<CoachDecisionCandidate> evaluate(
    CoachEvent event,
    CoachContext context,
  ) {
    if (event is! LoadChanged && event is! SetCompleted) return const [];
    final currentLoad = context.currentSet?.weight;
    final previousLoad = context.previousComparableSet?.load;
    if (currentLoad == null || previousLoad == null || previousLoad <= 0) {
      return const [];
    }
    final difference = (currentLoad - previousLoad).abs();
    final ratio = currentLoad / previousLoad;
    if (difference < _minimumAbsoluteDifferenceKg ||
        ratio < _maximumRecentLoadRatio) {
      return const [];
    }

    return [
      CoachDecisionCandidate(
        id: 'data-quality:${context.currentSet?.id}',
        type: CoachDecisionType.invalidData,
        scope: CoachDecisionScope.set,
        severity: CoachDecisionSeverity.warning,
        confidence: CoachConfidence.high,
        titleKey: 'coach.data_quality.unusual_load_title',
        reasonKey: 'coach.data_quality.unusual_load_reason',
        action: CoachAction(
          type: 'confirm_unusual_load',
          payload: {'load': currentLoad},
        ),
        evidence: [
          CoachEvidence(
            labelKey: 'coach.evidence.recent_load',
            value: '$previousLoad kg',
          ),
        ],
        isDismissible: false,
        isActionable: true,
      ),
    ];
  }
}
