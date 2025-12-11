import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
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
  @override
  WorkoutEditState build(String workoutId) {
    _loadWorkout();
    return WorkoutEditState(workoutId: workoutId);
  }

  Future<void> _loadWorkout() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 500));

    state = state.copyWith(
      title: 'PETTO & TRICIPITI',
      description: 'Programma focalizzato sull\'aumento della massa muscolare',
      duration: '50',
      type: 'Ipertrofia',
      exercises: [
        const EditableExerciseModel(
          id: '1',
          exerciseId: 'ex_1',
          number: 1,
          name: 'Panca Piana con Bilanciere',
          muscle: 'Petto',
          difficulty: 'Intermedio',
          sets: '4 × 8-10',
          rest: '120s',
          weight: '85 kg',
          progress: '+5%',
          notes: '',
          accentColorHex: '#2196F3',
          hasVariants: true,
        ),
        const EditableExerciseModel(
          id: '2',
          exerciseId: 'ex_2',
          number: 2,
          name: 'Panca Inclinata Manubri',
          muscle: 'Petto Alto',
          difficulty: 'Intermedio',
          sets: '4 × 10-12',
          rest: '90s',
          weight: '32 kg',
          progress: '',
          notes: '',
          accentColorHex: '#2196F3',
          hasVariants: true,
        ),
      ],
      isLoading: false,
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
