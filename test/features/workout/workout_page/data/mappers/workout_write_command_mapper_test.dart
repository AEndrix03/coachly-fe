import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/features/workout/workout_edit_page/providers/workout_edit_provider/workout_edit_provider.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_write_command_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkoutWriteCommandMapper.fromEditState', () {
    test('maps description into translations payload for save', () {
      const description = 'Descrizione di test workout';
      final state = WorkoutEditState(
        workoutId: 'f0f6f7ee-4b89-446d-abf3-5e4d844f2f50',
        title: 'Scheda Push',
        description: description,
        duration: '60',
        type: 'Hypertrophy',
        exercises: const [
          EditableExerciseModel(
            id: 'temp_ex_1',
            exerciseId: '33ab4fac-bf4f-4f4d-b1d2-f2cb6b5674ff',
            number: 1,
            name: 'Panca piana',
            muscles: ['Petto'],
            difficulty: 'Intermediate',
            sets: '3x10',
            rest: '90s',
            weight: '80kg',
            progress: '0',
            notes: '',
            accentColorHex: '#2196F3',
            variants: [],
          ),
        ],
      );

      final command = WorkoutWriteCommandMapper.fromEditState(
        state,
        const Locale('it'),
      );
      final payload = command.toJson(includeId: false);

      expect(command.description, description);
      expect(command.translations['it']?.description, description);
      expect(command.translations['en']?.description, description);
      expect(payload['translations']['it']['description'], description);
      expect(payload['translations']['en']['description'], description);
    });
  });
}
