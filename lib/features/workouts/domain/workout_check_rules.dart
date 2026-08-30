import 'package:coachly/features/workouts/domain/workout_draft.dart';
import 'package:coachly/features/workouts/domain/workout_check_models.dart';

class MuscleCoverageRule implements WorkoutCheckRule {
  @override
  String get id => 'muscle-coverage';

  @override
  bool supports(WorkoutCheckContext context) => context.exerciseDetails.values
      .any((detail) => detail.muscles?.isNotEmpty == true);

  @override
  List<WorkoutCheckFinding> evaluate(WorkoutCheckContext context) {
    final exposure = <String, int>{};
    for (final exercise in context.draft.exercises) {
      final detail = context.exerciseDetails[exercise.exerciseId];
      for (final relation in detail?.muscles ?? const []) {
        final muscle = relation.muscle;
        if (muscle == null) continue;
        exposure.update(
          muscle.code,
          (sets) => sets + exercise.sets,
          ifAbsent: () => exercise.sets,
        );
      }
    }
    if (exposure.isEmpty) return const [];
    final peak = exposure.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return [
      WorkoutCheckFinding(
        id: id,
        category: WorkoutCheckCategory.muscleCoverage,
        severity: WorkoutCheckSeverity.information,
        titleKey: 'workout.check.coverage_title',
        explanationKey: 'workout.check.coverage_body',
        params: {'muscles': '${exposure.length}'},
        evidence: [
          WorkoutCheckEvidence(
            'workout.check.evidence_peak_muscle',
            params: {'muscle': peak.key, 'count': '${peak.value}'},
          ),
          const WorkoutCheckEvidence('workout.check.evidence_catalogue'),
        ],
      ),
    ];
  }
}

class MovementPatternRule implements WorkoutCheckRule {
  @override
  String get id => 'movement-profile';

  @override
  bool supports(WorkoutCheckContext context) => context.exerciseDetails.values
      .any((detail) => detail.mechanicsType?.isNotEmpty == true);

  @override
  List<WorkoutCheckFinding> evaluate(WorkoutCheckContext context) {
    final patterns = context.exerciseDetails.values
        .map((detail) => detail.mechanicsType)
        .whereType<String>()
        .toSet();
    return [
      WorkoutCheckFinding(
        id: id,
        category: WorkoutCheckCategory.movementProfile,
        severity: WorkoutCheckSeverity.information,
        titleKey: 'workout.check.movement_title',
        explanationKey: 'workout.check.movement_body',
        params: {'count': '${patterns.length}'},
        evidence: patterns
            .map(
              (pattern) => WorkoutCheckEvidence(
                'workout.check.evidence_pattern',
                params: {'pattern': pattern},
              ),
            )
            .toList(),
      ),
    ];
  }
}

class WorkoutStructureRule implements WorkoutCheckRule {
  @override
  String get id => 'structure';

  @override
  bool supports(WorkoutCheckContext context) => context.draft.exerciseCount > 0;

  @override
  List<WorkoutCheckFinding> evaluate(WorkoutCheckContext context) {
    final draft = context.draft;
    final populated = draft.sections.where(
      (section) => section.items.isNotEmpty,
    );
    final groups = draft.items.whereType<WorkoutExerciseGroupDraft>().length;
    return [
      WorkoutCheckFinding(
        id: id,
        category: WorkoutCheckCategory.sessionStructure,
        severity: WorkoutCheckSeverity.positive,
        titleKey: 'workout.check.structure_title',
        explanationKey: 'workout.check.structure_body',
        params: {'sections': '${populated.length}', 'blocks': '$groups'},
        evidence: [
          WorkoutCheckEvidence(
            'workout.check.evidence_sections',
            params: {'count': '${populated.length}'},
          ),
          WorkoutCheckEvidence(
            'workout.check.evidence_blocks',
            params: {'count': '$groups'},
          ),
          WorkoutCheckEvidence(
            'workout.check.evidence_exercises',
            params: {'count': '${draft.exerciseCount}'},
          ),
        ],
      ),
    ];
  }
}

class EstimatedDurationRule implements WorkoutCheckRule {
  @override
  String get id => 'duration';

  @override
  bool supports(WorkoutCheckContext context) => context.draft.exerciseCount > 0;

  @override
  List<WorkoutCheckFinding> evaluate(WorkoutCheckContext context) => [
    WorkoutCheckFinding(
      id: id,
      category: WorkoutCheckCategory.estimatedDuration,
      severity: WorkoutCheckSeverity.information,
      titleKey: 'workout.check.duration_title',
      explanationKey: 'workout.check.duration_body',
      params: {'minutes': '${context.draft.estimatedDurationMinutes}'},
      evidence: [
        WorkoutCheckEvidence(
          'workout.check.evidence_sets',
          params: {'count': '${context.draft.workingSets}'},
        ),
        const WorkoutCheckEvidence('workout.check.evidence_rest'),
        const WorkoutCheckEvidence('workout.check.evidence_execution'),
      ],
    ),
  ];
}

class GoalAlignmentRule implements WorkoutCheckRule {
  @override
  String get id => 'goal';

  @override
  bool supports(WorkoutCheckContext context) => context.draft.exerciseCount > 0;

  @override
  List<WorkoutCheckFinding> evaluate(WorkoutCheckContext context) {
    final goal = context.draft.trainingGoal;
    return [
      WorkoutCheckFinding(
        id: id,
        category: WorkoutCheckCategory.goalAlignment,
        severity: goal == null
            ? WorkoutCheckSeverity.insufficientData
            : WorkoutCheckSeverity.information,
        titleKey: goal == null
            ? 'workout.check.goal_missing_title'
            : 'workout.check.goal_title',
        explanationKey: goal == null
            ? 'workout.check.goal_missing_body'
            : 'workout.check.goal_body',
        params: {'goal': goal ?? ''},
        evidence: goal == null
            ? const []
            : [
                WorkoutCheckEvidence(
                  'workout.check.evidence_goal',
                  params: {'goal': goal},
                ),
              ],
      ),
    ];
  }
}

class ExerciseOverlapRule implements WorkoutCheckRule {
  @override
  String get id => 'overlap';

  @override
  bool supports(WorkoutCheckContext context) =>
      context.exerciseDetails.length >= 2;

  @override
  List<WorkoutCheckFinding> evaluate(WorkoutCheckContext context) {
    final details = context.exerciseDetails.values.toList();
    for (var a = 0; a < details.length; a++) {
      for (var b = a + 1; b < details.length; b++) {
        final first = details[a];
        final second = details[b];
        final firstMuscles =
            first.muscles
                ?.map((relation) => relation.muscle?.id)
                .whereType<String>()
                .toSet() ??
            const <String>{};
        final secondMuscles =
            second.muscles
                ?.map((relation) => relation.muscle?.id)
                .whereType<String>()
                .toSet() ??
            const <String>{};
        final similarMovement =
            first.mechanicsType != null &&
            first.mechanicsType == second.mechanicsType;
        final shared = firstMuscles.intersection(secondMuscles).length;
        if (similarMovement && shared >= 2) {
          return [
            WorkoutCheckFinding(
              id: '$id-${first.id}-${second.id}',
              category: WorkoutCheckCategory.exerciseOverlap,
              severity: WorkoutCheckSeverity.review,
              titleKey: 'workout.check.overlap_title',
              explanationKey: 'workout.check.overlap_body',
              params: {'count': '$shared'},
              evidence: [
                WorkoutCheckEvidence(
                  'workout.check.evidence_movement',
                  params: {'movement': '${first.mechanicsType}'},
                ),
                WorkoutCheckEvidence(
                  'workout.check.evidence_muscles',
                  params: {'count': '$shared'},
                ),
              ],
            ),
          ];
        }
      }
    }
    return const [
      WorkoutCheckFinding(
        id: 'overlap-clear',
        category: WorkoutCheckCategory.exerciseOverlap,
        severity: WorkoutCheckSeverity.positive,
        titleKey: 'workout.check.overlap_clear_title',
        explanationKey: 'workout.check.overlap_clear_body',
      ),
    ];
  }
}
