import 'package:coachly/features/exercise/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_detail_page/providers/workout_edit_draft_provider.dart';
import 'package:coachly/features/workout/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/data/models/workout_programming_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late WorkoutEditDraft notifier;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    notifier = container.read(workoutEditDraftProvider('workout').notifier);
    notifier.initialize(_workout());
  });

  test('normalizes legacy exercises into stable independent blocks', () {
    final state = container.read(workoutEditDraftProvider('workout'));

    expect(state.blocks, hasLength(3));
    expect(state.blocks.map((block) => block.position), [0, 1, 2]);
    expect(
      state.blocks.every((block) => block.groupType == 'exercise'),
      isTrue,
    );
    expect(state.isDirty, isFalse);
  });

  test(
    'duplicates, moves and removes by instance id rather than index identity',
    () {
      notifier.duplicateExercise('entry-1');
      var state = container.read(workoutEditDraftProvider('workout'));
      expect(state.blocks, hasLength(4));
      expect(state.blocks[1].entries.single.id, isNot('entry-1'));

      notifier.moveBlock(0, 3);
      state = container.read(workoutEditDraftProvider('workout'));
      expect(state.blocks.last.entries.single.id, 'entry-1');

      notifier.removeExercise('entry-2');
      state = container.read(workoutEditDraftProvider('workout'));
      expect(
        state.blocks.expand((block) => block.entries).map((entry) => entry.id),
        isNot(contains('entry-2')),
      );
      expect(state.isDirty, isTrue);
    },
  );

  test('creates and ungroups valid supersets', () {
    notifier.createGroup(
      type: 'superset',
      instanceIds: const ['entry-1', 'entry-2'],
      rounds: 3,
    );
    var state = container.read(workoutEditDraftProvider('workout'));
    final group = state.blocks.firstWhere(
      (block) => block.groupType == 'superset',
    );
    expect(group.entries, hasLength(2));
    expect(group.rounds, 3);

    notifier.ungroup(group.id);
    state = container.read(workoutEditDraftProvider('workout'));
    expect(state.blocks.every((block) => block.entries.length == 1), isTrue);
  });

  test('updates a prescription once in the draft', () {
    notifier.updatePrescription(
      instanceId: 'entry-1',
      sets: 4,
      repsMin: 6,
      repsMax: 10,
      restSeconds: 180,
      intensityType: 'rir',
      intensityMin: 1,
      intensityMax: 2,
    );
    final entry = container
        .read(workoutEditDraftProvider('workout'))
        .blocks
        .first
        .entries
        .single;

    expect(entry.sets, hasLength(4));
    expect(entry.sets.first.repsMin, 6);
    expect(entry.sets.first.repsMax, 10);
    expect(entry.sets.first.intensityType, 'rir');
    expect(entry.sets.first.intensityMax, 2);
  });

  test('persists advanced prescription fields and can discard the draft', () {
    notifier.updatePrescription(
      instanceId: 'entry-1',
      sets: 3,
      repsMin: 6,
      repsMax: 8,
      restSeconds: 180,
      intensityType: 'rpe',
      intensityMin: 8,
      intensityMax: 8,
      setType: 'backoff',
      unilateral: true,
      tempo: '3-1-1-0',
      pauseSeconds: 1,
      notes: 'Control the eccentric',
      relativeLoadPercent: -7.5,
    );

    var state = container.read(workoutEditDraftProvider('workout'));
    final set = state.blocks.first.entries.single.sets.first;
    expect(set.setType, 'backoff');
    expect(set.relativeLoadPercent, -7.5);
    expect(set.unilateral, isTrue);
    expect(set.tempo, '3-1-1-0');
    expect(set.pauseSeconds, 1);
    expect(set.notes, 'Control the eccentric');
    expect(state.isDirty, isTrue);

    notifier.discard();
    state = container.read(workoutEditDraftProvider('workout'));
    expect(state.blocks, hasLength(3));
    expect(state.blocks.first.entries.single.sets.first.setType, 'normal');
    expect(state.isDirty, isFalse);
  });

  test(
    'quick adds an exercise with explicit prescription and stable identity',
    () {
      notifier.addExercise(
        exercise: const ExerciseDetailModel(
          id: '00000000-0000-4000-8000-000000000009',
          nameI18n: {'en': 'Cable Fly', 'it': 'Croci ai cavi'},
        ),
        sets: List.generate(
          3,
          (index) => WorkoutProgrammingSetModel(
            position: index,
            repsMin: 10,
            repsMax: 15,
            intensityType: 'rir',
            intensityMin: 1,
            restSeconds: 90,
          ),
        ),
      );
      final state = container.read(workoutEditDraftProvider('workout'));
      final added = state.blocks.last.entries.single;

      expect(added.exerciseId, '00000000-0000-4000-8000-000000000009');
      expect(added.sets, hasLength(3));
      expect(added.sets.first.repsMax, 15);
      expect(
        state.source!.workoutExercises.last.exercise.nameI18n!['en'],
        'Cable Fly',
      );
      expect(state.isDirty, isTrue);
    },
  );
}

WorkoutModel _workout() => WorkoutModel(
  id: 'workout',
  titleI18n: const {'en': 'Upper', 'it': 'Upper'},
  descriptionI18n: null,
  goal: 'Hypertrophy',
  lastUsed: DateTime(2026),
  type: 'Hypertrophy',
  workoutExercises: List.generate(3, (index) {
    final number = index + 1;
    return WorkoutExerciseModel(
      id: 'entry-$number',
      exercise: ExerciseDetailModel(
        id: '00000000-0000-4000-8000-00000000000$number',
        nameI18n: {'en': 'Exercise $number', 'it': 'Esercizio $number'},
      ),
      sets: '3x10',
      rest: '120s',
      weight: '-',
      progress: 0,
    );
  }),
);
