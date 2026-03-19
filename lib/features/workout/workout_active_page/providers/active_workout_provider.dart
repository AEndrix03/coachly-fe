import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_workout_provider.g.dart';

@riverpod
class ActiveWorkout extends _$ActiveWorkout {
  int _loadToken = 0;

  @override
  ActiveWorkoutState build(String workoutId) {
    final token = ++_loadToken;
    _loadWorkout(workoutId, token);
    return ActiveWorkoutState.loading();
  }

  // ─── Load ──────────────────────────────────────────────────────────────────

  Future<void> _loadWorkout(String workoutId, int token) async {
    final repo = ref.read(workoutPageRepositoryProvider);
    final response = await repo.getWorkout(workoutId);
    if (!ref.mounted || token != _loadToken) {
      return;
    }

    if (response.success && response.data != null) {
      final workout = response.data!;
      final exercises = workout.workoutExercises.asMap().entries.map((e) {
        return _buildActiveExercise(e.value, e.key);
      }).toList();

      state = state.copyWith(
        status: ActiveWorkoutStatus.active,
        workout: workout,
        startedAt: DateTime.now(),
        exercises: exercises,
      );
    } else {
      state = ActiveWorkoutState.error(
        response.message ?? 'Unable to load workout.',
      );
    }
  }

  ActiveExerciseState _buildActiveExercise(
    WorkoutExerciseModel exercise,
    int index,
  ) {
    final setParts = _extractSetParts(exercise.sets);
    final setCount = int.tryParse(setParts.$1) ?? 1;
    final reps = int.tryParse(setParts.$2) ?? 0;
    final weight = _parseWeight(exercise.weight);

    final sets = List.generate(
      setCount,
      (i) => ActiveSetState(
        position: i,
        setType: 'Normale',
        weight: weight,
        reps: reps,
        completed: false,
      ),
    );

    return ActiveExerciseState(
      exercise: exercise,
      displayName: _extractDisplayName(exercise, index),
      sets: sets,
    );
  }

  // ─── Set mutations ────────────────────────────────────────────────────────

  void completeSet(int exerciseIdx, int setIdx, bool completed) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(completed: completed));
  }

  void updateSetWeight(int exerciseIdx, int setIdx, double weight) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(weight: weight));
  }

  void updateSetReps(int exerciseIdx, int setIdx, int reps) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(reps: reps));
  }

  void updateSetType(int exerciseIdx, int setIdx, String setType) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(setType: setType));
  }

  void addSet(int exerciseIdx) {
    final exercises = [...state.exercises];
    final ex = exercises[exerciseIdx];
    final last = ex.sets.isNotEmpty ? ex.sets.last : null;
    final newSet = ActiveSetState(
      position: ex.sets.length,
      setType: last?.setType ?? 'Normale',
      weight: last?.weight ?? 0,
      reps: last?.reps ?? 0,
      completed: false,
    );
    exercises[exerciseIdx] = ex.copyWith(sets: [...ex.sets, newSet]);
    state = state.copyWith(exercises: exercises);
  }

  void deleteSet(int exerciseIdx, int setIdx) {
    final exercises = [...state.exercises];
    final ex = exercises[exerciseIdx];
    final sets = [...ex.sets]..removeAt(setIdx);
    final renumbered = sets
        .asMap()
        .entries
        .map((e) => e.value.copyWith(position: e.key))
        .toList();
    exercises[exerciseIdx] = ex.copyWith(sets: renumbered);
    state = state.copyWith(exercises: exercises);
  }

  void duplicateSet(int exerciseIdx, int setIdx) {
    final exercises = [...state.exercises];
    final ex = exercises[exerciseIdx];
    final sets = [...ex.sets];
    final copy = sets[setIdx].copyWith(position: sets.length, completed: false);
    sets.insert(setIdx + 1, copy);
    final renumbered = sets
        .asMap()
        .entries
        .map((e) => e.value.copyWith(position: e.key))
        .toList();
    exercises[exerciseIdx] = ex.copyWith(sets: renumbered);
    state = state.copyWith(exercises: exercises);
  }

  void _mutateSet(
    int exerciseIdx,
    int setIdx,
    ActiveSetState Function(ActiveSetState) mutator,
  ) {
    final exercises = [...state.exercises];
    final ex = exercises[exerciseIdx];
    final sets = [...ex.sets];
    sets[setIdx] = mutator(sets[setIdx]);
    exercises[exerciseIdx] = ex.copyWith(sets: sets);
    state = state.copyWith(exercises: exercises);
  }

  // ─── Complete workout ─────────────────────────────────────────────────────

  Future<bool> completeWorkout() async {
    final workout = state.workout;
    final startedAt = state.startedAt;
    if (workout == null || startedAt == null) return false;

    state = state.copyWith(status: ActiveWorkoutStatus.saving);

    final command = _buildSessionCommand(startedAt);
    final repo = ref.read(workoutPageRepositoryProvider);
    final response = await repo.saveSession(workout.id, command);
    if (!ref.mounted) {
      return false;
    }

    if (response.success) {
      state = state.copyWith(status: ActiveWorkoutStatus.saved);
      return true;
    } else {
      state = state.copyWith(
        status: ActiveWorkoutStatus.active,
        errorMessage: response.message ?? 'Error while saving.',
      );
      return false;
    }
  }

  WorkoutSessionWriteCommand _buildSessionCommand(DateTime startedAt) {
    final entries = state.exercises.asMap().entries.map((entry) {
      final exerciseIdx = entry.key;
      final ex = entry.value;
      final exerciseId = ex.exercise.exercise.id ?? '';

      final sets = ex.sets.map((s) {
        return WorkoutSessionSetWritePayload(
          position: s.position,
          setType: s.setType,
          reps: s.reps,
          load: s.weight,
          loadUnit: 'kg',
          completed: s.completed,
          notes: null,
        );
      }).toList();

      return WorkoutSessionEntryWritePayload(
        exerciseId: exerciseId,
        position: exerciseIdx,
        completed: ex.sets.every((s) => s.completed),
        notes: null,
        sets: sets,
      );
    }).toList();

    return WorkoutSessionWriteCommand(
      startedAt: startedAt,
      completedAt: DateTime.now(),
      notes: null,
      entries: entries,
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  (String, String) _extractSetParts(String rawSets) {
    final matches = RegExp(
      r'\d+',
    ).allMatches(rawSets).map((m) => m.group(0)!).toList();
    if (matches.length >= 2) return (matches[0], matches[1]);
    if (matches.length == 1) return (matches[0], '');
    return ('', '');
  }

  double _parseWeight(String rawWeight) {
    final match = RegExp(r'[\d.]+').firstMatch(rawWeight);
    if (match == null) return 0;
    return double.tryParse(match.group(0)!) ?? 0;
  }

  String _extractDisplayName(WorkoutExerciseModel exercise, int index) {
    final exerciseId = exercise.exercise.id;
    final names = exercise.exercise.nameI18n;
    if (names != null) {
      final normalizedNames = names.map(
        (key, value) => MapEntry(key.toLowerCase().replaceAll('-', '_'), value),
      );
      for (final lang in ['en', 'en_us', 'en_en', 'it', 'it_it']) {
        final name = normalizedNames[lang];
        if (name != null && name.isNotEmpty && name != exerciseId) {
          return name;
        }
      }
      for (final name in normalizedNames.values) {
        if (name.isNotEmpty && name != exerciseId) return name;
      }
    }
    return 'Exercise ${index + 1}';
  }
}
