import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision_resolver.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_engine.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_event.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/performance_comparator.dart';
import 'package:coachly/features/workout/workout_active_page/coach/evaluators/comparability_evaluator.dart';
import 'package:coachly/features/workout/workout_active_page/coach/evaluators/data_quality_evaluator.dart';
import 'package:coachly/features/workout/workout_active_page/coach/evaluators/progression_evaluator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutCoachState {
  final CoachDecision? decision;
  final List<CoachEvent> recentEvents;

  const WorkoutCoachState({this.decision, this.recentEvents = const []});

  WorkoutCoachState copyWith({
    CoachDecision? decision,
    List<CoachEvent>? recentEvents,
    bool clearDecision = false,
  }) {
    return WorkoutCoachState(
      decision: clearDecision ? null : decision ?? this.decision,
      recentEvents: recentEvents ?? this.recentEvents,
    );
  }
}

class WorkoutCoachController extends Notifier<WorkoutCoachState> {
  final String sessionId;
  late final CoachEngine _engine;

  WorkoutCoachController(this.sessionId);

  @override
  WorkoutCoachState build() {
    _engine = const CoachEngine(
      evaluators: [
        DataQualityEvaluator(),
        ComparabilityEvaluator(PerformanceComparator()),
        ProgressionEvaluator(),
      ],
      resolver: CoachDecisionResolver(),
    );
    return const WorkoutCoachState();
  }

  void observe(CoachEvent event, CoachContext context) {
    final decision = _engine.handle(event, context);
    state = state.copyWith(
      decision: decision,
      clearDecision: decision == null,
      recentEvents: [...state.recentEvents, event].takeLast(20),
    );
  }

  void dismiss() => state = state.copyWith(clearDecision: true);

  void restore(CoachDecision? decision) {
    state = state.copyWith(decision: decision, clearDecision: decision == null);
  }

  void invalidateDecisionDerivedFrom(String setId) {
    final primaryId = state.decision?.primary.id;
    if (primaryId?.contains(setId) == true) dismiss();
  }
}

extension _TakeLast<T> on List<T> {
  List<T> takeLast(int count) =>
      length <= count ? this : sublist(length - count);
}

final workoutCoachProvider =
    NotifierProvider.family<WorkoutCoachController, WorkoutCoachState, String>(
      WorkoutCoachController.new,
    );
