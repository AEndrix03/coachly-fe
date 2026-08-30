import 'package:coachly/features/active_workout/domain/coach/coach_context.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_decision.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_decision_resolver.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_evaluator.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_event.dart';

class CoachEngine {
  final List<CoachEvaluator> evaluators;
  final CoachDecisionResolver resolver;

  const CoachEngine({required this.evaluators, required this.resolver});

  CoachDecision? handle(CoachEvent event, CoachContext context) {
    final candidates = evaluators.expand(
      (evaluator) => evaluator.evaluate(event, context),
    );
    return resolver.resolve(candidates);
  }
}
