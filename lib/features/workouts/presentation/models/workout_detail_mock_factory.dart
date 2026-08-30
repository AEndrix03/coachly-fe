import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/widgets.dart';

/// Presentation-only fixture used to review sections and execution groups
/// before those concepts are guaranteed by the persisted workout contract.
/// It consumes and returns the same read model as production rendering.
abstract final class WorkoutDetailMockFactory {
  /// Stable catalogue for component previews. It deliberately stays outside
  /// entities, persistence and sync, and includes every supported group kind.
  static List<WorkoutGroupBlockViewData> executionGroupShowcase(
    List<WorkoutExerciseViewData> exercises,
  ) {
    if (exercises.length < 2) return const [];
    List<WorkoutExerciseViewData> take(int count) => List.generate(
      count,
      (index) => exercises[index % exercises.length],
      growable: false,
    );

    return [
      WorkoutGroupBlockViewData(
        id: 'fixture_superset',
        type: WorkoutGroupType.superset,
        rounds: 3,
        restAfterRoundSeconds: 90,
        exercises: take(2),
      ),
      WorkoutGroupBlockViewData(
        id: 'fixture_triset',
        type: WorkoutGroupType.triset,
        rounds: 3,
        restAfterRoundSeconds: 90,
        exercises: take(3),
      ),
      WorkoutGroupBlockViewData(
        id: 'fixture_circuit',
        type: WorkoutGroupType.circuit,
        rounds: 3,
        restBetweenExercisesSeconds: 15,
        restAfterRoundSeconds: 120,
        exercises: take(4),
      ),
      WorkoutGroupBlockViewData(
        id: 'fixture_giant_set',
        type: WorkoutGroupType.giantSet,
        rounds: 3,
        restAfterRoundSeconds: 120,
        exercises: take(4),
      ),
    ];
  }

  static WorkoutDetailViewData withPresentationStructure(
    WorkoutDetailViewData source,
    Locale locale,
  ) {
    final exercises = _exercises(source).toList(growable: false);
    if (exercises.length < 3) return source;

    final sections = <WorkoutSectionViewData>[
      WorkoutSectionViewData(
        id: '${source.id}_fixture_preparation',
        title: AppStrings.translate(
          'workout.detail.section_preparation',
          locale: locale,
        ),
        kind: WorkoutSectionKind.preparation,
        position: 0,
        blocks: [WorkoutExerciseBlockViewData(exercises.first)],
      ),
      WorkoutSectionViewData(
        id: '${source.id}_fixture_main',
        title: AppStrings.translate(
          'workout.detail.section_main',
          locale: locale,
        ),
        kind: WorkoutSectionKind.main,
        position: 1,
        blocks: [
          WorkoutGroupBlockViewData(
            id: '${source.id}_fixture_superset',
            type: WorkoutGroupType.superset,
            rounds: 3,
            restBetweenExercisesSeconds: 0,
            restAfterRoundSeconds: 90,
            exercises: exercises.skip(1).take(2).toList(growable: false),
          ),
        ],
      ),
    ];

    final remaining = exercises.skip(3).toList(growable: false);
    if (remaining.isNotEmpty) {
      sections.add(
        WorkoutSectionViewData(
          id: '${source.id}_fixture_accessories',
          title: AppStrings.translate(
            'workout.detail.section_accessory',
            locale: locale,
          ),
          kind: WorkoutSectionKind.accessory,
          position: 2,
          blocks: remaining.length >= 3
              ? [
                  WorkoutGroupBlockViewData(
                    id: '${source.id}_fixture_circuit',
                    type: WorkoutGroupType.circuit,
                    rounds: 3,
                    restBetweenExercisesSeconds: 15,
                    restAfterRoundSeconds: 120,
                    exercises: remaining.take(3).toList(growable: false),
                  ),
                  ...remaining.skip(3).map(WorkoutExerciseBlockViewData.new),
                ]
              : remaining.map(WorkoutExerciseBlockViewData.new).toList(),
        ),
      );
    }

    final projected = WorkoutDetailViewData(
      id: source.id,
      title: source.title,
      goal: source.goal,
      focus: source.focus,
      sections: sections,
      muscleSummary: source.muscleSummary,
      equipmentSummary: source.equipmentSummary,
      syncPending: source.syncPending,
    );
    return WorkoutDetailViewData(
      id: projected.id,
      title: projected.title,
      goal: projected.goal,
      focus: projected.focus,
      sections: projected.sections,
      estimatedDuration: WorkoutDurationEstimator.estimate(projected),
      muscleSummary: projected.muscleSummary,
      equipmentSummary: projected.equipmentSummary,
      syncPending: projected.syncPending,
    );
  }

  static Iterable<WorkoutExerciseViewData> _exercises(
    WorkoutDetailViewData source,
  ) sync* {
    for (final block in source.sections.expand((section) => section.blocks)) {
      switch (block) {
        case WorkoutExerciseBlockViewData():
          yield block.exercise;
        case WorkoutGroupBlockViewData():
          yield* block.exercises;
      }
    }
  }
}
