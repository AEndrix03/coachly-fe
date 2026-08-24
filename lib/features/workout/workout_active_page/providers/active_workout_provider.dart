import 'dart:async';
import 'dart:math';

import 'package:coachly/features/workout/workout_active_page/domain/workout_execution_resolver.dart';
import 'package:coachly/features/workout/workout_active_page/data/active_workout_draft_service.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_event.dart';
import 'package:coachly/features/workout/workout_active_page/coach/providers/workout_coach_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_stats_provider/workout_stats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_workout_provider.g.dart';

@riverpod
class ActiveWorkout extends _$ActiveWorkout {
  static const _executionResolver = WorkoutExecutionResolver();
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
      var exercises = workout.workoutExercises.asMap().entries.map((e) {
        return _buildActiveExercise(e.value, e.key);
      }).toList();
      final draft = ref.read(activeWorkoutDraftServiceProvider).read(workoutId);
      exercises = _restoreExercises(exercises, draft);
      final restoredTarget = _restoreTarget(exercises, draft);

      state = state.copyWith(
        status: ActiveWorkoutStatus.active,
        sessionId:
            draft?['sessionId'] as String? ??
            '$workoutId:${DateTime.now().microsecondsSinceEpoch}',
        workout: workout,
        startedAt:
            DateTime.tryParse(draft?['startedAt'] as String? ?? '') ??
            DateTime.now(),
        exercises: exercises,
        sessionStatus: WorkoutSessionStatus.active,
        phase: WorkoutPhase.exercising,
        currentTarget: restoredTarget ?? _firstExecutionTarget(exercises),
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
        id: '${exercise.id}:set:$i',
        position: i,
        setType: 'Normale',
        weight: weight,
        reps: reps,
        completed: false,
      ),
    );

    return ActiveExerciseState(
      executionBlockId: 'block:${exercise.id}',
      exercise: exercise,
      displayName: _extractDisplayName(exercise, index),
      sets: sets,
    );
  }

  // ─── Set mutations ────────────────────────────────────────────────────────

  void completeSet(int exerciseIdx, int setIdx, bool completed) {
    final setId = state.exercises[exerciseIdx].sets[setIdx].id;
    if (completed) {
      completeSetById(setId);
    } else {
      undoSetCompletion(setId);
    }
  }

  void completeCurrentSet() {
    final setId = state.currentTarget?.setId;
    if (setId != null) completeSetById(setId);
  }

  void completeSetById(String setId) {
    final coachContext = _coachContextFor(setId);
    final previousTarget = state.currentTarget;
    _mutateSetById(
      setId,
      (set) => set.copyWith(completed: true, skipped: false),
    );
    final next = _executionResolver.resolveNext(
      exercises: state.exercises,
      after: previousTarget,
    );
    state = state.copyWith(
      currentTarget: next,
      clearCurrentTarget: next == null,
      phase: next == null ? WorkoutPhase.completed : WorkoutPhase.resting,
      sessionStatus: next == null
          ? WorkoutSessionStatus.completed
          : WorkoutSessionStatus.active,
      lastSetCompletedAt: DateTime.now(),
    );
    _persistDraft();
    final exerciseId = coachContext.currentExercise?.exercise.exercise.id;
    if (exerciseId != null) {
      ref
          .read(workoutCoachProvider(state.sessionId).notifier)
          .observe(
            SetCompleted(
              sessionId: state.sessionId,
              occurredAt: DateTime.now(),
              exerciseId: exerciseId,
              setId: setId,
            ),
            coachContext,
          );
    }
  }

  void undoSetCompletion(String setId) {
    _mutateSetById(setId, (set) => set.copyWith(completed: false));
    final target = _targetForSet(setId);
    state = state.copyWith(
      currentTarget: target,
      phase: WorkoutPhase.exercising,
      sessionStatus: WorkoutSessionStatus.active,
      clearPendingCoachDecision: true,
    );
    _persistDraft();
    ref
        .read(workoutCoachProvider(state.sessionId).notifier)
        .invalidateDecisionDerivedFrom(setId);
  }

  void skipSet(String setId) {
    _mutateSetById(setId, (set) => set.copyWith(skipped: true));
    _advanceFrom(state.currentTarget);
  }

  void skipExercise(String exerciseId) {
    final exercises = state.exercises.map((exercise) {
      if (exercise.exercise.id != exerciseId) return exercise;
      return exercise.copyWith(
        sets: exercise.sets
            .map((set) => set.completed ? set : set.copyWith(skipped: true))
            .toList(),
      );
    }).toList();
    state = state.copyWith(exercises: exercises);
    _advanceFrom(state.currentTarget);
  }

  void goToSet(String setId) {
    final target = _targetForSet(setId);
    if (target == null) return;
    state = state.copyWith(
      currentTarget: target,
      phase: WorkoutPhase.exercising,
    );
  }

  void goToExercise(String exerciseId) {
    final exercise = state.exercises
        .where((item) => item.exercise.id == exerciseId)
        .firstOrNull;
    if (exercise == null) return;
    final set = exercise.sets.where((item) => !item.completed).firstOrNull;
    if (set != null) goToSet(set.id);
  }

  void updateSetWeight(int exerciseIdx, int setIdx, double weight) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(weight: weight));
  }

  void updateSetReps(int exerciseIdx, int setIdx, int reps) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(reps: reps));
  }

  void updateSetRir(String setId, int rir) {
    _mutateSetById(setId, (set) => set.copyWith(rir: rir));
  }

  void updateSetType(int exerciseIdx, int setIdx, String setType) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(setType: setType));
  }

  VoiceApplyOutcome? applyVoiceEntry({
    required String exerciseId,
    required int? sets,
    required int? reps,
    required double? weightKg,
  }) {
    if (sets == null && reps == null && weightKg == null) {
      return null;
    }

    final exerciseIndex = state.exercises.indexWhere(
      (exercise) => exercise.exercise.exercise.id == exerciseId,
    );
    if (exerciseIndex == -1) {
      return null;
    }

    final exercises = [...state.exercises];
    final exercise = exercises[exerciseIndex];
    final existingSets = exercise.sets;
    final firstSet = existingSets.isNotEmpty ? existingSets.first : null;

    final resolvedSetCount = (sets != null && sets > 0)
        ? sets
        : max(1, existingSets.length);
    final resolvedReps = (reps != null && reps > 0)
        ? reps
        : (firstSet?.reps ?? 0);
    final resolvedWeight = (weightKg != null && weightKg >= 0)
        ? weightKg
        : (firstSet?.weight ?? 0);

    final updatedSets = List.generate(resolvedSetCount, (index) {
      final previous = index < existingSets.length ? existingSets[index] : null;
      return ActiveSetState(
        id: previous?.id ?? '${exercise.exercise.id}:set:$index',
        position: index,
        setType: previous?.setType ?? firstSet?.setType ?? 'Normale',
        weight: resolvedWeight,
        reps: resolvedReps,
        completed: previous?.completed ?? false,
      );
    });

    exercises[exerciseIndex] = exercise.copyWith(sets: updatedSets);
    state = state.copyWith(exercises: exercises);
    _persistDraft();

    return VoiceApplyOutcome(
      exerciseId: exerciseId,
      exerciseName: exercise.displayName,
      sets: resolvedSetCount,
      reps: resolvedReps,
      weightKg: resolvedWeight,
    );
  }

  void addSet(int exerciseIdx) {
    final exercises = [...state.exercises];
    final ex = exercises[exerciseIdx];
    final last = ex.sets.isNotEmpty ? ex.sets.last : null;
    final newSet = ActiveSetState(
      id: '${ex.exercise.id}:set:${DateTime.now().microsecondsSinceEpoch}',
      position: ex.sets.length,
      setType: last?.setType ?? 'Normale',
      weight: last?.weight ?? 0,
      reps: last?.reps ?? 0,
      completed: false,
    );
    exercises[exerciseIdx] = ex.copyWith(sets: [...ex.sets, newSet]);
    state = state.copyWith(exercises: exercises);
    _persistDraft();
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
    _persistDraft();
  }

  void duplicateSet(int exerciseIdx, int setIdx) {
    final exercises = [...state.exercises];
    final ex = exercises[exerciseIdx];
    final sets = [...ex.sets];
    final copy = sets[setIdx].copyWith(
      id: '${ex.exercise.id}:set:${DateTime.now().microsecondsSinceEpoch}',
      position: sets.length,
      completed: false,
    );
    sets.insert(setIdx + 1, copy);
    final renumbered = sets
        .asMap()
        .entries
        .map((e) => e.value.copyWith(position: e.key))
        .toList();
    exercises[exerciseIdx] = ex.copyWith(sets: renumbered);
    state = state.copyWith(exercises: exercises);
    _persistDraft();
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
    _persistDraft();
  }

  void _mutateSetById(
    String setId,
    ActiveSetState Function(ActiveSetState) mutator,
  ) {
    final exercises = state.exercises.map((exercise) {
      final setIndex = exercise.sets.indexWhere((set) => set.id == setId);
      if (setIndex == -1) return exercise;
      final sets = [...exercise.sets];
      sets[setIndex] = mutator(sets[setIndex]);
      return exercise.copyWith(sets: sets);
    }).toList();
    state = state.copyWith(exercises: exercises);
    _persistDraft();
  }

  WorkoutExecutionTarget? _targetForSet(String setId) {
    for (final exercise in state.exercises) {
      if (exercise.sets.any((set) => set.id == setId)) {
        return WorkoutExecutionTarget(
          blockId: exercise.executionBlockId,
          exerciseId: exercise.exercise.id,
          setId: setId,
        );
      }
    }
    return null;
  }

  void _advanceFrom(WorkoutExecutionTarget? previousTarget) {
    final next = _executionResolver.resolveNext(
      exercises: state.exercises,
      after: previousTarget,
    );
    state = state.copyWith(
      currentTarget: next,
      clearCurrentTarget: next == null,
      phase: next == null ? WorkoutPhase.completed : WorkoutPhase.exercising,
      sessionStatus: next == null
          ? WorkoutSessionStatus.completed
          : WorkoutSessionStatus.active,
    );
    _persistDraft();
  }

  CoachContext _coachContextFor(String setId) {
    ActiveExerciseState? currentExercise;
    ActiveSetState? currentSet;
    for (final exercise in state.exercises) {
      final match = exercise.sets.where((set) => set.id == setId).firstOrNull;
      if (match == null) continue;
      currentExercise = exercise;
      currentSet = match;
      break;
    }
    final startedAt = state.startedAt;
    return CoachContext(
      sessionId: state.sessionId,
      currentExercise: currentExercise,
      currentSet: currentSet,
      elapsedSessionTime: startedAt == null
          ? Duration.zero
          : DateTime.now().difference(startedAt),
      remainingSetCount: state.totalSetCount - state.completedSetCount,
      expectedSessionDuration: state.workout == null
          ? null
          : Duration(minutes: state.workout!.durationMinutes),
    );
  }

  // ─── Complete workout ─────────────────────────────────────────────────────

  WorkoutExecutionTarget? _firstExecutionTarget(
    List<ActiveExerciseState> exercises,
  ) {
    return _executionResolver.resolveNext(exercises: exercises);
  }

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
      await ref.read(activeWorkoutDraftServiceProvider).delete(workoutId);
      ref.invalidate(workoutListProvider);
      ref.invalidate(recentWorkoutsProvider);
      ref.invalidate(workoutStatsProvider);
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
          setType: _toBackendSetType(s.setType),
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

  String _toBackendSetType(String rawType) {
    switch (rawType.trim().toLowerCase()) {
      case 'normale':
      case 'normal':
        return 'normal';
      case 'riscaldamento':
      case 'warmup':
      case 'warm-up':
        return 'warmup';
      case 'avvicinamento':
      case 'approach':
        return 'approach';
      case 'dropset':
      case 'drop set':
        return 'dropset';
      case 'cluster':
      case 'cluster set':
        return 'cluster';
      case 'cedimento':
      case 'failure':
        return 'failure';
      case 'rest pause':
      case 'rest_pause':
        return 'rest_pause';
      case 'amrap':
        return 'amrap';
      default:
        return 'normal';
    }
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

  void _persistDraft() {
    if (state.sessionId.isEmpty) return;
    unawaited(
      ref.read(activeWorkoutDraftServiceProvider).save(workoutId, state),
    );
  }

  List<ActiveExerciseState> _restoreExercises(
    List<ActiveExerciseState> exercises,
    Map<String, dynamic>? draft,
  ) {
    final rawSets = draft?['sets'];
    if (rawSets is! List) return exercises;
    final savedExerciseIds =
        (draft?['exerciseEntryIds'] as List?)?.whereType<String>().toSet() ??
        const <String>{};
    final savedById = <String, Map<String, dynamic>>{};
    for (final raw in rawSets.whereType<Map>()) {
      final normalized = raw.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      final id = normalized['setId'] as String?;
      if (id != null) savedById[id] = normalized;
    }
    return exercises.map((exercise) {
      final savedForExercise =
          savedById.values
              .where(
                (saved) => saved['exerciseEntryId'] == exercise.exercise.id,
              )
              .toList()
            ..sort(
              (left, right) => ((left['position'] as num?)?.toInt() ?? 0)
                  .compareTo((right['position'] as num?)?.toInt() ?? 0),
            );
      if (savedForExercise.isEmpty) {
        return savedExerciseIds.contains(exercise.exercise.id)
            ? exercise.copyWith(sets: const [])
            : exercise;
      }
      final existingById = {for (final set in exercise.sets) set.id: set};
      final restoredSets = <ActiveSetState>[];
      for (final saved in savedForExercise) {
        final savedId = saved['setId'] as String?;
        if (savedId == null) continue;
        final existing = existingById[savedId];
        restoredSets.add(
          _restoreSet(
            existing ??
                ActiveSetState(
                  id: savedId,
                  position:
                      (saved['position'] as num?)?.toInt() ??
                      restoredSets.length,
                  setType: saved['setType'] as String? ?? 'Normale',
                  weight: (saved['weight'] as num?)?.toDouble() ?? 0,
                  reps: (saved['reps'] as num?)?.toInt() ?? 0,
                  completed: false,
                ),
            saved,
          ),
        );
      }
      return exercise.copyWith(sets: restoredSets);
    }).toList();
  }

  ActiveSetState _restoreSet(ActiveSetState set, Map<String, dynamic> saved) {
    return set.copyWith(
      position: (saved['position'] as num?)?.toInt(),
      setType: saved['setType'] as String?,
      weight: (saved['weight'] as num?)?.toDouble(),
      reps: (saved['reps'] as num?)?.toInt(),
      rir: (saved['rir'] as num?)?.toInt(),
      durationSeconds: (saved['durationSeconds'] as num?)?.toInt(),
      distance: (saved['distance'] as num?)?.toDouble(),
      leftReps: (saved['leftReps'] as num?)?.toInt(),
      rightReps: (saved['rightReps'] as num?)?.toInt(),
      completed: saved['completed'] as bool?,
      skipped: saved['skipped'] as bool?,
    );
  }

  WorkoutExecutionTarget? _restoreTarget(
    List<ActiveExerciseState> exercises,
    Map<String, dynamic>? draft,
  ) {
    final setId = draft?['currentSetId'] as String?;
    if (setId == null) return null;
    for (final exercise in exercises) {
      if (exercise.sets.any((set) => set.id == setId && !set.completed)) {
        return WorkoutExecutionTarget(
          blockId:
              draft?['currentBlockId'] as String? ?? exercise.executionBlockId,
          exerciseId:
              draft?['currentExerciseId'] as String? ?? exercise.exercise.id,
          setId: setId,
        );
      }
    }
    return null;
  }
}
