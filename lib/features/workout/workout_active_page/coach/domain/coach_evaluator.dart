import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_event.dart';

abstract interface class CoachEvaluator {
  List<CoachDecisionCandidate> evaluate(CoachEvent event, CoachContext context);
}
