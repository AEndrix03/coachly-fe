import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/coach/providers/workout_coach_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Narrow dependencies for active-workout widgets.  These are intentionally
/// plain providers so they can evolve independently from the generated
/// controller provider.
final activeExerciseIdProvider = Provider.family<String?, String>((
  ref,
  workoutId,
) {
  return ref.watch(
    activeWorkoutProvider(
      workoutId,
    ).select((state) => state.currentTarget?.exerciseId),
  );
});

final activeSetIdProvider = Provider.family<String?, String>((ref, workoutId) {
  return ref.watch(
    activeWorkoutProvider(
      workoutId,
    ).select((state) => state.currentTarget?.setId),
  );
});

final activeExerciseProvider = Provider.family<ActiveExerciseState?, String>((
  ref,
  workoutId,
) {
  final id = ref.watch(activeExerciseIdProvider(workoutId));
  return ref.watch(
    activeWorkoutProvider(workoutId).select((state) {
      if (id == null) return null;
      return state.exercises
          .where((exercise) => exercise.exercise.id == id)
          .firstOrNull;
    }),
  );
});

final activeSetProvider = Provider.family<ActiveSetState?, String>((
  ref,
  workoutId,
) {
  final id = ref.watch(activeSetIdProvider(workoutId));
  return ref.watch(
    activeWorkoutProvider(workoutId).select((state) {
      if (id == null) return null;
      for (final exercise in state.exercises) {
        final set = exercise.sets
            .where((candidate) => candidate.id == id)
            .firstOrNull;
        if (set != null) return set;
      }
      return null;
    }),
  );
});

enum PlanGuardSeverity { none, informational, relevant, important }

class PlanGuardFinding {
  final String id;
  final CoachDecisionScope scope;
  final PlanGuardSeverity severity;
  final String titleKey;
  final String messageKey;

  const PlanGuardFinding({
    required this.id,
    required this.scope,
    required this.severity,
    required this.titleKey,
    required this.messageKey,
  });
}

class PlanGuardState {
  final List<PlanGuardFinding> findings;
  const PlanGuardState({this.findings = const []});
  int get unreadCount => findings.length;
  PlanGuardSeverity get highestSeverity => findings.fold(
    PlanGuardSeverity.none,
    (current, finding) =>
        finding.severity.index > current.index ? finding.severity : current,
  );
}

/// Adapts the existing local coach engine to the persistent Plan Guard UI.
final planGuardProvider = Provider.family<PlanGuardState, String>((
  ref,
  sessionId,
) {
  if (sessionId.isEmpty) return const PlanGuardState();
  final decision = ref.watch(
    workoutCoachProvider(sessionId).select((state) => state.decision),
  );
  if (decision == null) return const PlanGuardState();
  final item = decision.primary;
  final severity = switch (item.severity) {
    CoachDecisionSeverity.observation => PlanGuardSeverity.informational,
    CoachDecisionSeverity.suggestion => PlanGuardSeverity.relevant,
    CoachDecisionSeverity.recommendation ||
    CoachDecisionSeverity.warning => PlanGuardSeverity.important,
  };
  return PlanGuardState(
    findings: [
      PlanGuardFinding(
        id: item.id,
        scope: item.scope,
        severity: severity,
        titleKey: item.titleKey,
        messageKey: item.reasonKey,
      ),
    ],
  );
});
