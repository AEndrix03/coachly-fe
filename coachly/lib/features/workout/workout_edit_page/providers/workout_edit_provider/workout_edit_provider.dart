import 'package:coachly/features/workout/workout_detail_page/providers/workout_detail_provider/workout_detail_provider.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../workout_detail_page/data/models/exercise_info_model/exercise_info_model.dart';

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
    this.type = 'Ipertrofia',
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
    // Carica i dati del workout in modo asincrono dopo la costruzione iniziale
    Future.microtask(() => _loadWorkout(workoutId));

    // Ritorna uno stato iniziale di caricamento
    return WorkoutEditState(workoutId: workoutId, isLoading: true);
  }

  Future<void> _loadWorkout(String workoutId) async {
    if (workoutId == 'new') {
      state = state.copyWith(
        isLoading: false,
        title: 'Nuova Scheda',
        description: '',
        duration: '60',
        type: 'Ipertrofia',
        exercises: [],
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(workoutDetailPageRepositoryProvider);
      final workoutResponse = await repository.getWorkoutDetail(workoutId);
      final exercisesResponse = await repository.getWorkoutExercises(workoutId);

      if (_disposed) return;

      if (workoutResponse.success &&
          workoutResponse.data != null &&
          exercisesResponse.success &&
          exercisesResponse.data != null) {
        final workout = workoutResponse.data!;
        final exercises = exercisesResponse.data!;

        final editableExercises = exercises
            .map((e) => _mapExerciseInfoToEditable(e))
            .toList();

        state = state.copyWith(
          title: workout.title,
          description: workout.description,
          duration: workout.durationMinutes.toString(),
          type: workout.type,
          exercises: editableExercises,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error:
              workoutResponse.message ??
              exercisesResponse.message ??
              'Errore caricamento dati workout',
        );
      }
    } catch (e) {
      if (_disposed) return;
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  EditableExerciseModel _mapExerciseInfoToEditable(ExerciseInfoModel exercise) {
    // La logica di mappatura va qui
    // Assumiamo che manchino alcuni campi che devono essere gestiti
    return EditableExerciseModel(
      id: 'ex_${DateTime.now().millisecondsSinceEpoch}_${exercise.name}',
      exerciseId: exercise.name,
      // Usiamo il nome come fallback
      number: exercise.number,
      name: exercise.name,
      muscle: exercise.muscle,
      difficulty: exercise.difficulty,
      sets: exercise.sets,
      rest: exercise.rest,
      weight: exercise.weight,
      progress: exercise.progress,
      notes: '',
      // Default
      accentColorHex: exercise.accentColorHex,
      hasVariants: false, // Default
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
        error:
            'Compila tutti i campi obbligatori e aggiungi almeno un esercizio',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, isDirty: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Errore durante il salvataggio: $e',
      );
      return false;
    }
  }

  void resetDirty() {
    state = state.copyWith(isDirty: false);
  }
}
