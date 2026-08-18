import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_programming_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkoutDetailAdapter', () {
    test(
      'maps sections, groups, rep ranges and intensity independently from DTOs',
      () {
        final viewData = WorkoutDetailAdapter.fromWorkout(
          _structuredWorkout(),
          const Locale('it'),
        );

        expect(viewData.sections, hasLength(1));
        expect(viewData.exerciseCount, 2);
        expect(viewData.workingSets, 6);
        expect(viewData.estimatedDuration, isNotNull);

        final group =
            viewData.sections.single.blocks.single as WorkoutGroupBlockViewData;
        expect(group.type, WorkoutGroupType.superset);
        expect(group.rounds, 3);
        expect(group.exercises.first.prescription.compactTarget, '3 × 6–10');
        expect(group.exercises.first.prescription.compactIntensity, 'RIR 1–2');
      },
    );

    test('does not treat a legacy multi-entry block as a superset', () {
      final workout = _structuredWorkout().copyWith(
        programmingBlocks: [
          _structuredWorkout().programmingBlocks.single.copyWithForTest(
            groupType: null,
          ),
        ],
      );

      final viewData = WorkoutDetailAdapter.fromWorkout(
        workout,
        const Locale('en'),
      );

      expect(viewData.sections.single.blocks, hasLength(2));
      expect(
        viewData.sections.single.blocks,
        everyElement(isA<WorkoutExerciseBlockViewData>()),
      );
    });

    test('uses resolved exercise names instead of opaque exercise IDs', () {
      final workout = _structuredWorkout().copyWith(workoutExercises: const []);
      final viewData = WorkoutDetailAdapter.fromWorkout(
        workout,
        const Locale('it'),
        const {
          '11111111-1111-4111-8111-111111111111': 'Panca inclinata con manubri',
          '22222222-2222-4222-8222-222222222222': 'Lat machine presa larga',
        },
      );

      final exercises =
          (viewData.sections.single.blocks.single as WorkoutGroupBlockViewData)
              .exercises;
      expect(exercises.map((exercise) => exercise.name), [
        'Panca inclinata con manubri',
        'Lat machine presa larga',
      ]);
    });

    test('excludes warm-up sets and detects concepts actually in use', () {
      final workout = _structuredWorkout();
      final firstBlock = workout.programmingBlocks.single;
      final firstEntry = firstBlock.entries.first;
      final withWarmup = WorkoutProgrammingEntryModel(
        id: firstEntry.id,
        exerciseId: firstEntry.exerciseId,
        position: firstEntry.position,
        sets: [
          const WorkoutProgrammingSetModel(
            position: 0,
            setType: 'warmup',
            reps: 10,
          ),
          ...firstEntry.sets,
        ],
      );
      final updated = workout.copyWith(
        programmingBlocks: [
          WorkoutProgrammingBlockModel(
            id: firstBlock.id,
            position: firstBlock.position,
            sectionId: firstBlock.sectionId,
            sectionTitle: firstBlock.sectionTitle,
            sectionKind: firstBlock.sectionKind,
            groupType: firstBlock.groupType,
            rounds: firstBlock.rounds,
            restSeconds: firstBlock.restSeconds,
            entries: [withWarmup, firstBlock.entries.last],
          ),
        ],
      );

      final viewData = WorkoutDetailAdapter.fromWorkout(
        updated,
        const Locale('it'),
      );
      final concepts = WorkoutConceptDetector.detect(viewData);

      expect(viewData.workingSets, 6);
      expect(
        concepts,
        containsAll([WorkoutConcept.rir, WorkoutConcept.superset]),
      );
      expect(concepts, isNot(contains(WorkoutConcept.rpe)));
    });
  });
}

WorkoutModel _structuredWorkout() {
  const firstId = '11111111-1111-4111-8111-111111111111';
  const secondId = '22222222-2222-4222-8222-222222222222';
  final entries = [
    WorkoutProgrammingEntryModel(
      id: 'entry-a',
      exerciseId: firstId,
      position: 0,
      sets: List.generate(
        3,
        (position) => WorkoutProgrammingSetModel(
          position: position,
          repsMin: 6,
          repsMax: 10,
          intensityType: 'rir',
          intensityMin: 1,
          intensityMax: 2,
          restSeconds: 180,
        ),
      ),
    ),
    WorkoutProgrammingEntryModel(
      id: 'entry-b',
      exerciseId: secondId,
      position: 1,
      sets: List.generate(
        3,
        (position) => WorkoutProgrammingSetModel(
          position: position,
          repsMin: 8,
          repsMax: 12,
          intensityType: 'rir',
          intensityMin: 2,
          restSeconds: 120,
        ),
      ),
    ),
  ];
  return WorkoutModel(
    id: 'workout-id',
    titleI18n: const {'it': 'Schiena & Petto', 'en': 'Back & Chest'},
    descriptionI18n: const {'it': 'Sessione upper', 'en': 'Upper session'},
    goal: 'Hypertrophy',
    lastUsed: DateTime(2026),
    type: 'Hypertrophy',
    workoutExercises: const [
      WorkoutExerciseModel(
        id: 'entry-a',
        exercise: ExerciseDetailModel(
          id: firstId,
          nameI18n: {'it': 'Panca inclinata', 'en': 'Incline press'},
        ),
        sets: '3x8',
        rest: '180s',
        weight: '-',
        progress: 0,
      ),
      WorkoutExerciseModel(
        id: 'entry-b',
        exercise: ExerciseDetailModel(
          id: secondId,
          nameI18n: {'it': 'Lat machine', 'en': 'Lat pulldown'},
        ),
        sets: '3x10',
        rest: '120s',
        weight: '-',
        progress: 0,
      ),
    ],
    programmingBlocks: [
      WorkoutProgrammingBlockModel(
        id: 'group-a',
        position: 0,
        sectionId: 'main',
        sectionTitle: 'Main Work',
        sectionKind: 'main',
        groupType: 'superset',
        rounds: 3,
        restSeconds: 120,
        entries: entries,
      ),
    ],
  );
}

extension on WorkoutProgrammingBlockModel {
  WorkoutProgrammingBlockModel copyWithForTest({String? groupType}) {
    return WorkoutProgrammingBlockModel(
      id: id,
      position: position,
      label: label,
      sectionId: sectionId,
      sectionPosition: sectionPosition,
      sectionTitle: sectionTitle,
      sectionKind: sectionKind,
      groupType: groupType,
      rounds: rounds,
      restBetweenExercisesSeconds: restBetweenExercisesSeconds,
      restSeconds: restSeconds,
      notes: notes,
      entries: entries,
    );
  }
}
