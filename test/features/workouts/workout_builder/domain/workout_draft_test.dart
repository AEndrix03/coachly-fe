import 'package:coachly/features/workouts/domain/workout_draft.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WorkoutExerciseDraft exercise(
    String id, {
    int sets = 3,
    RepTarget reps = const RepTarget.fixed(10),
  }) => WorkoutExerciseDraft(
    localId: id,
    exerciseId: 'catalog_$id',
    name: id,
    sets: sets,
    repTarget: reps,
  );

  test('derives summary without storing duplicate counters', () {
    final draft = WorkoutDraft(
      localDraftId: 'draft',
      title: 'Pull',
      sections: [
        WorkoutSectionDraft(
          id: 'implicit',
          position: 0,
          items: [
            WorkoutExerciseItemDraft(exercise('lat', sets: 4)),
            WorkoutExerciseGroupDraft(
              id: 'group',
              type: WorkoutGroupType.superset,
              exercises: [exercise('fly'), exercise('row', sets: 2)],
            ),
          ],
        ),
      ],
    );
    expect(draft.exerciseCount, 3);
    expect(draft.workingSets, 9);
    expect(draft.estimatedDurationMinutes, greaterThan(0));
  });

  test('supports fixed and ranged repetitions', () {
    expect(const RepTarget.fixed(8).compactLabel, '8');
    expect(const RepTarget.range(min: 8, max: 10).compactLabel, '8–10');
    expect(const RepTarget.range(min: 10, max: 8).isValid, isFalse);
  });

  test('validation protects ids, prescriptions and group invariants', () {
    final draft = WorkoutDraft(
      localDraftId: 'draft',
      title: 'Workout',
      sections: [
        WorkoutSectionDraft(
          id: 'section',
          name: 'Main',
          position: 0,
          items: [
            WorkoutExerciseItemDraft(exercise('same')),
            WorkoutExerciseItemDraft(exercise('same')),
            WorkoutExerciseGroupDraft(
              id: 'broken',
              type: WorkoutGroupType.superset,
              exercises: [exercise('only')],
            ),
          ],
        ),
      ],
    );
    expect(
      WorkoutDraftRules.validate(draft).errors,
      containsAll(['duplicate_id', 'group']),
    );
  });

  test('mapper preserves sections, explicit group type and rep range', () {
    final draft = WorkoutDraft(
      localDraftId: 'draft',
      title: 'Workout',
      sections: [
        WorkoutSectionDraft(
          id: 'main',
          name: 'Main',
          position: 0,
          items: [
            WorkoutExerciseGroupDraft(
              id: 'circuit',
              type: WorkoutGroupType.circuit,
              rounds: 4,
              exercises: [
                exercise('a', reps: const RepTarget.range(min: 8, max: 10)),
                exercise('b'),
              ],
            ),
          ],
        ),
      ],
    );
    final block = WorkoutDraftProgrammingMapper.toProgramming(draft).single;
    expect(block.sectionTitle, 'Main');
    expect(block.groupType, 'circuit');
    expect(block.rounds, 4);
    expect(block.entries.first.sets.first.repsMin, 8);
    expect(block.entries.first.sets.first.repsMax, 10);
  });
}
