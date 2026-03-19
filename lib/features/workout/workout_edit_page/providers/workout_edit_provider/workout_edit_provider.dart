import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart'; // Required for fromI18n
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart'; // Required for Locale
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_edit_provider.g.dart';

class WorkoutEditState {
  final String workoutId;
  final String title;
  final String description;
  final String duration;
  final String type;
  final List<EditableExerciseModel> exercises;
  final bool isDirty;
  final bool isLoading;
  final String? error;

  const WorkoutEditState({
    required this.workoutId,
    this.title = '',
    this.description = '',
    this.duration = '60',
    this.type = 'Hypertrophy',
    this.exercises = const [],
    this.isDirty = false,
    this.isLoading = false,
    this.error,
  });

  WorkoutEditState copyWith({
    String? workoutId,
    String? title,
    String? description,
    String? duration,
    String? type,
    List<EditableExerciseModel>? exercises,
    bool? isDirty,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutEditState(
      workoutId: workoutId ?? this.workoutId,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      exercises: exercises ?? this.exercises,
      isDirty: isDirty ?? this.isDirty,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasError => error != null;

  bool get isEmpty => exercises.isEmpty && !isLoading;

  bool get isValid => title.trim().isNotEmpty && exercises.isNotEmpty;
}

@riverpod
class WorkoutEditPageNotifier extends _$WorkoutEditPageNotifier {
  bool _disposed = false;

  @override
  WorkoutEditState build(String workoutId) {
    ref.onDispose(() => _disposed = true);
    return WorkoutEditState(workoutId: workoutId, isLoading: true);
  }

  Future<void> loadWorkout(String workoutId, Locale locale) async {
    if (workoutId == 'new') {
      state = state.copyWith(
        isLoading: false,
        title: 'New Workout',
        description: '',
        duration: '60',
        type: AppStrings.translate('workout.hypertrophy', locale: locale),
        exercises: [],
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final response = await repository.getWorkout(workoutId);

      if (_disposed) return;

      if (response.success && response.data != null) {
        final workout = response.data!;

        final editableExercises = workout.workoutExercises
            .asMap()
            .entries
            .map(
              (entry) => _mapWorkoutExerciseToEditable(
                entry.value,
                entry.key + 1,
                locale,
              ),
            )
            .toList();

        state = state.copyWith(
          title: workout.titleI18n?.fromI18n(locale) ?? '',
          description: workout.descriptionI18n?.fromI18n(locale) ?? '',
          duration: workout.durationMinutes.toString(),
          type: workout.type,
          exercises: editableExercises,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Error loading workout data',
        );
      }
    } catch (e) {
      if (_disposed) return;
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  EditableExerciseModel _mapWorkoutExerciseToEditable(
    WorkoutExerciseModel workoutExercise,
    int number,
    Locale locale,
  ) {
    final exercise = workoutExercise.exercise;
    final na = AppStrings.translate('common.na', locale: locale);
    return EditableExerciseModel(
      id: 'ex_${DateTime.now().millisecondsSinceEpoch}_${exercise.id}',
      exerciseId: exercise.id ?? '',
      number: number,
      name: exercise.nameI18n?.fromI18n(locale) ?? exercise.id ?? na,
      muscles: (exercise.muscles ?? const [])
          .map((m) => m.muscle?.nameI18n.fromI18n(locale) ?? na)
          .toList(),
      difficulty: exercise.difficultyLevel ?? na,
      sets: workoutExercise.sets,
      rest: workoutExercise.rest,
      weight: workoutExercise.weight,
      progress: workoutExercise.progress.toString(),
      notes: '',
      // Default
      accentColorHex: '#2196F3',
      // Default
      variants: exercise.variants ?? const [],
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title, isDirty: true);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description, isDirty: true);
  }

  void updateDuration(String duration) {
    state = state.copyWith(duration: duration, isDirty: true);
  }

  void updateType(String type) {
    state = state.copyWith(type: type, isDirty: true);
  }

  void addExercise(EditableExerciseModel exercise) {
    final updated = [...state.exercises, exercise];
    state = state.copyWith(exercises: updated, isDirty: true);
  }

  void removeExercise(String exerciseId) {
    final updated = state.exercises.where((e) => e.id != exerciseId).toList();

    // Rinumera gli esercizi
    final renumbered = updated.asMap().entries.map((entry) {
      return entry.value.copyWith(number: entry.key + 1);
    }).toList();

    state = state.copyWith(exercises: renumbered, isDirty: true);
  }

  void updateExercise(String exerciseId, EditableExerciseModel updated) {
    final exercises = state.exercises.map((e) {
      return e.id == exerciseId ? updated : e;
    }).toList();
    state = state.copyWith(exercises: exercises, isDirty: true);
  }

  void reorderExercises(int oldIndex, int newIndex) {
    final exercises = List<EditableExerciseModel>.from(state.exercises);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, item);

    final renumbered = exercises.asMap().entries.map((entry) {
      return entry.value.copyWith(number: entry.key + 1);
    }).toList();

    state = state.copyWith(exercises: renumbered, isDirty: true);
  }

  Future<bool> save() async {
    if (!state.isValid) {
      state = state.copyWith(
        error: 'Fill all required fields and add at least one exercise',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final locale = ref.read(languageProvider);
      final command = WorkoutWriteCommandMapper.fromEditState(state, locale);

      final response = await repository.patchWorkout(state.workoutId, command);

      if (response.success) {
        state = state.copyWith(isLoading: false, isDirty: false);
        // After saving, invalidate the list to show the updated item.
        ref.invalidate(workoutListProvider);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Error while saving',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error while saving: $e');
      return false;
    }
  }

  void resetDirty() {
    state = state.copyWith(isDirty: false);
  }

  void setInitialWorkout(WorkoutModel workout, Locale locale) {
    final editableExercises = workout.workoutExercises
        .asMap()
        .entries
        .map(
          (entry) =>
              _mapWorkoutExerciseToEditable(entry.value, entry.key + 1, locale),
        )
        .toList();

    state = state.copyWith(
      title: workout.titleI18n?.fromI18n(locale) ?? '',
      description: workout.descriptionI18n?.fromI18n(locale) ?? '',
      duration: workout.durationMinutes.toString(),
      type: workout.type,
      exercises: editableExercises,
      isLoading: false,
      isDirty: false, // Start not dirty if loaded from initial data
    );
  }
}
