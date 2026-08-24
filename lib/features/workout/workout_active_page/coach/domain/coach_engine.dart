import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision_resolver.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_evaluator.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_event.dart';

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
