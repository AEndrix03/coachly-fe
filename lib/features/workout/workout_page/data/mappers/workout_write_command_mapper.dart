import 'package:coachly/core/error/failures.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/features/workout/workout_edit_page/providers/workout_edit_provider/workout_edit_provider.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:flutter/material.dart';

class WorkoutWriteCommandMapper {
  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[1-5][0-9a-fA-F]{3}\-[89abAB][0-9a-fA-F]{3}\-[0-9a-fA-F]{12}$',
  );

  static WorkoutWriteCommand fromEditState(
    WorkoutEditState state,
    Locale locale,
  ) {
    final workoutId = state.workoutId == 'new' ? null : state.workoutId;
    final name = state.title.trim();
    final description = _nullIfBlank(state.description);

    _validateName(name);
    final translations = _buildDefaultTranslations(
      title: name,
      description: description,
      preferredLocale: locale.languageCode,
    );

    return WorkoutWriteCommand(
      id: workoutId,
      name: name,
      translations: translations,
      status: 'active',
      blocks: [
        WorkoutBlockWritePayload(
          id: null,
          position: 0,
          label: _nullIfBlank(state.type),
          restSeconds: null,
          notes: null,
          entries: state.exercises.asMap().entries.map((entry) {
            return _entryFromEditableExercise(
              exercise: entry.value,
              position: entry.key,
            );
          }).toList(),
        ),
      ],
    );
  }

  static WorkoutWriteCommand fromWorkoutModel(WorkoutModel workout) {
    final translationKeys = {
      ...?workout.titleI18n?.keys,
      ...?workout.descriptionI18n?.keys,
    };

    final translations = <String, WorkoutTranslationWritePayload>{};
    for (final key in translationKeys) {
      final translatedName = workout.titleI18n?[key]?.trim();
      if (translatedName == null || translatedName.isEmpty) {
        continue;
      }

      translations[key] = WorkoutTranslationWritePayload(
        title: translatedName,
        description: _nullIfBlank(workout.descriptionI18n?[key]),
      );
    }

    final fallbackName =
        translations['it']?.title ??
        translations['en']?.title ??
        translations.values.firstOrNull?.title ??
        workout.id;

    return WorkoutWriteCommand(
      id: workout.id,
      name: fallbackName,
      translations: translations,
      status: workout.delete
          ? 'archived'
          : workout.active
          ? 'active'
          : 'draft',
      blocks: [
        WorkoutBlockWritePayload(
          id: _optionalUuid(workout.id),
          position: 0,
          label: _nullIfBlank(workout.type),
          restSeconds: null,
          notes: null,
          entries: workout.workoutExercises.asMap().entries.map((entry) {
            return _entryFromWorkoutExercise(
              exercise: entry.value,
              position: entry.key,
            );
          }).toList(),
        ),
      ],
    );
  }

  static WorkoutEntryWritePayload _entryFromEditableExercise({
    required EditableExerciseModel exercise,
    required int position,
  }) {
    _validateExerciseId(exercise.exerciseId);

    final setCount = _parseSetCount(exercise.sets);
    final reps = _parseReps(exercise.sets);
    final load = _parseLoad(exercise.weight);
    final restSeconds = _parseSeconds(exercise.rest);
    final notes = _nullIfBlank(exercise.notes);

    return WorkoutEntryWritePayload(
      id: _optionalUuid(exercise.id),
      exerciseId: exercise.exerciseId,
      position: position,
      sets: List.generate(setCount, (index) {
        return WorkoutSetWritePayload(
          id: null,
          position: index,
          setType: 'normal',
          reps: reps,
          load: load,
          loadUnit: load != null ? 'kg' : null,
          restSeconds: restSeconds,
          notes: notes,
        );
      }),
    );
  }

  static WorkoutEntryWritePayload _entryFromWorkoutExercise({
    required WorkoutExerciseModel exercise,
    required int position,
  }) {
    final exerciseId = exercise.exercise.id;
    if (exerciseId == null) {
      throw const ValidationFailure({
        'exerciseId':
            'Each synced workout entry must reference an exercise id.',
      });
    }

    _validateExerciseId(exerciseId);

    final setCount = _parseSetCount(exercise.sets);
    final reps = _parseReps(exercise.sets);
    final load = _parseLoad(exercise.weight);
    final restSeconds = _parseSeconds(exercise.rest);

    return WorkoutEntryWritePayload(
      id: _optionalUuid(exercise.id),
      exerciseId: exerciseId,
      position: position,
      sets: List.generate(setCount, (index) {
        return WorkoutSetWritePayload(
          id: null,
          position: index,
          setType: 'normal',
          reps: reps,
          load: load,
          loadUnit: load != null ? 'kg' : null,
          restSeconds: restSeconds,
          notes: null,
        );
      }),
    );
  }

  static void _validateName(String name) {
    if (name.isEmpty) {
      throw const ValidationFailure({'name': 'Workout name cannot be empty.'});
    }
  }

  static void _validateExerciseId(String exerciseId) {
    if (!_uuidPattern.hasMatch(exerciseId)) {
      throw ValidationFailure({
        'exerciseId': 'Exercise id "$exerciseId" is not a valid catalog UUID.',
      });
    }
  }

  static int _parseSetCount(String rawSets) {
    final values = RegExp(r'\d+')
        .allMatches(rawSets)
        .map((match) => int.tryParse(match.group(0)!))
        .whereType<int>()
        .toList();
    final setCount = values.isEmpty ? null : values.first;

    if (setCount == null || setCount <= 0) {
      throw ValidationFailure({
        'sets': 'Sets value "$rawSets" cannot be converted to structured sets.',
      });
    }

    return setCount;
  }

  static int? _parseReps(String rawSets) {
    final values = RegExp(r'\d+')
        .allMatches(rawSets)
        .map((match) => int.tryParse(match.group(0)!))
        .whereType<int>()
        .toList();
    if (values.length < 2) {
      return null;
    }
    return values[1];
  }

  static int? _parseSeconds(String rawValue) {
    final match = RegExp(r'(\d+)').firstMatch(rawValue);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  static num? _parseLoad(String rawWeight) {
    final match = RegExp(r'(\d+(?:[.,]\d+)?)').firstMatch(rawWeight);
    if (match == null) {
      return null;
    }

    final normalized = match.group(1)!.replaceAll(',', '.');
    final doubleValue = double.tryParse(normalized);
    if (doubleValue == null) {
      return null;
    }

    return doubleValue % 1 == 0 ? doubleValue.toInt() : doubleValue;
  }

  static String? _nullIfBlank(String? value) {
    if (value == null) {
      return null;
    }

    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? _optionalUuid(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }
    return _uuidPattern.hasMatch(rawValue) ? rawValue : null;
  }

  static Map<String, WorkoutTranslationWritePayload> _buildDefaultTranslations({
    required String title,
    required String? description,
    required String preferredLocale,
  }) {
    final translations = <String, WorkoutTranslationWritePayload>{
      'it': WorkoutTranslationWritePayload(
        title: title,
        description: description,
      ),
      'en': WorkoutTranslationWritePayload(
        title: title,
        description: description,
      ),
    };

    if (preferredLocale != 'it' && preferredLocale != 'en') {
      translations[preferredLocale] = WorkoutTranslationWritePayload(
        title: title,
        description: description,
      );
    }

    return translations;
  }
}
