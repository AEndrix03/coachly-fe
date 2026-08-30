import 'package:coachly/features/active_workout/domain/coach/coach_context.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_decision.dart';
import 'package:coachly/features/active_workout/domain/coach/coach_event.dart';

abstract interface class CoachEvaluator {
  List<CoachDecisionCandidate> evaluate(CoachEvent event, CoachContext context);
}
