import 'dart:async';
import 'dart:math';

import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/workout/workout_active_page/domain/workout_execution_resolver.dart';
import 'package:coachly/features/workout/workout_active_page/data/active_workout_draft_service.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_event.dart';
import 'package:coachly/features/workout/workout_active_page/coach/providers/workout_coach_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_stats_provider/workout_stats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'active_workout_provider.g.dart';

@riverpod
class ActiveWorkout extends _$ActiveWorkout {
  static const _executionResolver = WorkoutExecutionResolver();
  static const _uuid = Uuid();
  int _loadToken = 0;

  @override
  ActiveWorkoutState build(String workoutId) {
    final token = ++_loadToken;
    ref.listen<RestTimerState>(restTimerProvider, (previous, next) {
      if (previous?.isActive == true && !next.isActive) {
        unawaited(
          ref.read(activeWorkoutDraftServiceProvider).clearRest(workoutId),
        );
      }
    });
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

    if (response.isOk && response.valueOrNull != null) {
      final workout = response.valueOrNull!;
      var exercises = _buildExecutionExercises(workout);
      var groups = _buildExecutionGroups(workout, exercises);
      exercises = await _resolveMissingExerciseNames(exercises);
      if (!ref.mounted || token != _loadToken) {
        return;
      }
      final draft = await ref
          .read(activeWorkoutDraftServiceProvider)
          .read(workoutId);
      if (!ref.mounted || token != _loadToken) {
        return;
      }
      exercises = _restoreExercises(exercises, draft);
      groups = _restoreGroups(groups, draft);
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
        groups: groups,
        sessionChanges:
            (draft?['sessionChanges'] as List?)?.whereType<String>().toList() ??
            const [],
        sessionStatus: WorkoutSessionStatus.active,
        phase: WorkoutPhase.exercising,
        currentTarget: restoredTarget ?? _firstExecutionTarget(exercises),
      );
      _restoreRestTimer(draft);
      ref
          .read(workoutCoachProvider(state.sessionId).notifier)
          .restore(
            ref
                .read(activeWorkoutDraftServiceProvider)
                .readCoachDecision(draft),
          );
    } else {
      state = ActiveWorkoutState.error(
        response.failureOrNull?.message ?? 'Unable to load workout.',
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

  Future<List<ActiveExerciseState>> _resolveMissingExerciseNames(
    List<ActiveExerciseState> exercises,
  ) async {
    final repository = ref.read(exerciseInfoPageRepositoryProvider);
    return Future.wait(
      exercises.map((exercise) async {
        if (!_hasMissingExerciseName(exercise.exercise)) {
          return exercise;
        }

        final exerciseId = exercise.exercise.exercise.id?.trim();
        if (exerciseId == null || exerciseId.isEmpty) {
          return exercise;
        }

        final resolvedExercise = (await repository.getExerciseDetailResult(
          exerciseId,
        )).valueOrNull;
        if (resolvedExercise == null) {
          return exercise;
        }
        final resolvedName = _displayNameFromI18n(
          resolvedExercise.nameI18n,
          exerciseId: exerciseId,
        );
        if (resolvedName == null) return exercise;

        return exercise.copyWith(
          exercise: exercise.exercise.copyWith(exercise: resolvedExercise),
          displayName: resolvedName,
        );
      }),
    );
  }

  bool _hasMissingExerciseName(WorkoutExerciseModel exercise) {
    final exerciseId = exercise.exercise.id?.trim();
    return _displayNameFromI18n(
          exercise.exercise.nameI18n,
          exerciseId: exerciseId,
        ) ==
        null;
  }

  String? _displayNameFromI18n(
    Map<String, String>? names, {
    required String? exerciseId,
  }) {
    if (names == null || names.isEmpty) return null;
    final normalized = names.map(
      (key, value) => MapEntry(key.toLowerCase().replaceAll('-', '_'), value),
    );
    for (final locale in ['it', 'it_it', 'en', 'en_us', 'en_en']) {
      final name = normalized[locale]?.trim();
      if (name != null && name.isNotEmpty && name != exerciseId) {
        return name;
      }
    }
    for (final name in normalized.values) {
      final trimmed = name.trim();
      if (trimmed.isNotEmpty && trimmed != exerciseId) return trimmed;
    }
    return null;
  }

  List<ActiveExerciseState> _buildExecutionExercises(WorkoutModel workout) {
    if (workout.programmingBlocks.isEmpty) {
      return workout.workoutExercises.asMap().entries.map((entry) {
        return _buildActiveExercise(entry.value, entry.key);
      }).toList();
    }

    final result = <ActiveExerciseState>[];
    for (final block in workout.programmingBlocks) {
      for (final entry in block.entries) {
        final legacyIndex = workout.workoutExercises.indexWhere(
          (exercise) =>
              exercise.id == entry.id ||
              exercise.exercise.id == entry.exerciseId,
        );
        if (legacyIndex == -1) continue;
        final legacy = workout.workoutExercises[legacyIndex];
        final fallback = _buildActiveExercise(legacy, legacyIndex);
        final programmedSets = entry.sets.map((programmed) {
          final reps =
              programmed.reps ?? programmed.repsMin ?? programmed.repsMax ?? 0;
          final rir = programmed.intensityType == 'rir'
              ? programmed.intensityMax?.round() ??
                    programmed.intensityMin?.round()
              : null;
          return ActiveSetState(
            id: programmed.id ?? '${entry.id}:set:${programmed.position}',
            position: programmed.position,
            setType: programmed.setType,
            weight: programmed.load ?? fallback.sets.firstOrNull?.weight ?? 0,
            reps: reps,
            rir: rir,
            leftReps: programmed.unilateral ? reps : null,
            rightReps: programmed.unilateral ? reps : null,
            completed: false,
          );
        }).toList();
        result.add(
          fallback.copyWith(
            executionBlockId: block.id,
            sets: programmedSets.isEmpty ? fallback.sets : programmedSets,
          ),
        );
      }
    }
    return result.isEmpty
        ? workout.workoutExercises.asMap().entries.map((entry) {
            return _buildActiveExercise(entry.value, entry.key);
          }).toList()
        : result;
  }

  List<ActiveExerciseGroup> _buildExecutionGroups(
    WorkoutModel workout,
    List<ActiveExerciseState> exercises,
  ) {
    ExerciseGroupType? groupType(String? raw) => switch (raw) {
      'superset' => ExerciseGroupType.superset,
      'triset' => ExerciseGroupType.triset,
      'giantset' || 'giant_set' || 'giant set' => ExerciseGroupType.giantSet,
      'circuit' => ExerciseGroupType.circuit,
      'preparation' => ExerciseGroupType.preparation,
      'mobility' => ExerciseGroupType.mobility,
      _ => null,
    };
    final result = <ActiveExerciseGroup>[];
    for (final block in workout.programmingBlocks) {
      final type = groupType(block.groupType);
      if (type == null || block.entries.length < 2) continue;
      final ids = exercises
          .where((item) => item.executionBlockId == block.id)
          .map((item) => item.exercise.id)
          .toList();
      if (ids.length < 2) continue;
      result.add(
        ActiveExerciseGroup(
          id: block.id,
          type: type,
          exerciseIds: ids,
          restBetweenExercisesSeconds: block.restBetweenExercisesSeconds,
          restAfterRoundSeconds: block.restSeconds,
          rounds: block.rounds,
        ),
      );
    }
    return result;
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

  void completeSetAndStartRest(String setId) {
    final exercise = state.exercises
        .where((item) => item.sets.any((set) => set.id == setId))
        .firstOrNull;
    if (exercise == null) return;
    final didComplete = completeSetById(setId);
    if (!didComplete) return;
    if (state.currentTarget != null) {
      final restSeconds = exercise.restSeconds;
      ref.read(restTimerProvider.notifier).startTimer(restSeconds);
      unawaited(
        ref
            .read(activeWorkoutDraftServiceProvider)
            .saveRest(
              workoutId: workoutId,
              endsAt: DateTime.now().add(Duration(seconds: restSeconds)),
              initialSeconds: restSeconds,
            ),
      );
    }
  }

  void undoSetAndRest(String setId) {
    ref.read(restTimerProvider.notifier).stopTimer();
    undoSetCompletion(setId);
  }

  bool completeSetById(String setId) {
    final target = _targetForSet(setId);
    if (target == null) return false;
    final targetSet = state.exercises
        .expand((exercise) => exercise.sets)
        .where((set) => set.id == setId)
        .firstOrNull;
    if (targetSet == null || targetSet.completed) return false;
    final coachContext = _coachContextFor(setId);
    _mutateSetById(
      setId,
      (set) => set.copyWith(completed: true, skipped: false),
    );
    final next = _executionResolver.resolveNext(
      exercises: state.exercises,
      after: target,
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
      final coach = ref.read(workoutCoachProvider(state.sessionId).notifier);
      coach.observe(
        SetCompleted(
          sessionId: state.sessionId,
          occurredAt: DateTime.now(),
          exerciseId: exerciseId,
          setId: setId,
        ),
        coachContext,
      );
      unawaited(
        ref
            .read(activeWorkoutDraftServiceProvider)
            .saveCoachDecision(
              workoutId,
              ref.read(workoutCoachProvider(state.sessionId)).decision,
            ),
      );
    }
    return true;
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
    unawaited(
      ref
          .read(activeWorkoutDraftServiceProvider)
          .saveCoachDecision(
            workoutId,
            ref.read(workoutCoachProvider(state.sessionId)).decision,
          ),
    );
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

  void updateSetNote(String setId, String note, Set<SetNoteTag> tags) {
    _mutateSetById(
      setId,
      (set) => set.copyWith(note: note, noteTags: Set.unmodifiable(tags)),
    );
  }

  void updateSetSideReps(String setId, {int? left, int? right}) {
    _mutateSetById(
      setId,
      (set) => set.copyWith(leftReps: left, rightReps: right),
    );
  }

  void updateSetType(int exerciseIdx, int setIdx, String setType) {
    _mutateSet(exerciseIdx, setIdx, (s) => s.copyWith(setType: setType));
  }

  void changeSetTechnique(String setId, SetTechnique technique) {
    _mutateSetById(
      setId,
      (set) => set.copyWith(
        technique: technique,
        drops: technique == SetTechnique.dropSet && set.drops.isEmpty
            ? [
                DropSetState(
                  id: '$setId:drop:0',
                  weight: set.weight * .60,
                  reps: (set.reps - 2).clamp(0, 999),
                ),
              ]
            : set.drops,
      ),
    );
  }

  void addDrop(String setId, {double? weight, int? reps}) {
    _mutateSetById(setId, (set) {
      final last = set.drops.isNotEmpty ? set.drops.last : null;
      final sourceWeight = last?.weight ?? set.weight;
      final sourceReps = last?.reps ?? set.reps;
      final nextWeight = weight ?? sourceWeight * .60;
      return set.copyWith(
        technique: SetTechnique.dropSet,
        drops: [
          ...set.drops,
          DropSetState(
            id: '$setId:drop:${set.drops.length}',
            weight: nextWeight,
            reps: reps ?? (sourceReps - 2).clamp(0, 999),
          ),
        ],
      );
    });
  }

  void removeDrop(String setId, String dropId) {
    _mutateSetById(setId, (set) {
      final remaining = set.drops.where((drop) => drop.id != dropId).toList();
      return set.copyWith(
        drops: remaining,
        technique: remaining.isEmpty ? SetTechnique.none : set.technique,
      );
    });
  }

  void updateDropWeight(String setId, String dropId, double weight) {
    _mutateSetById(
      setId,
      (set) => set.copyWith(
        drops: [
          for (final drop in set.drops)
            drop.id == dropId
                ? drop.copyWith(weight: weight.clamp(0, 9999))
                : drop,
        ],
      ),
    );
  }

  void updateDropReps(String setId, String dropId, int reps) {
    _mutateSetById(
      setId,
      (set) => set.copyWith(
        drops: [
          for (final drop in set.drops)
            drop.id == dropId ? drop.copyWith(reps: reps.clamp(0, 999)) : drop,
        ],
      ),
    );
  }

  void createExerciseGroup(List<String> exerciseIds, ExerciseGroupType type) {
    if (exerciseIds.length < 2) return;
    final id = 'group:${DateTime.now().microsecondsSinceEpoch}';
    final group = ActiveExerciseGroup(
      id: id,
      type: type,
      exerciseIds: List.unmodifiable(exerciseIds),
      restAfterRoundSeconds: 60,
    );
    final exercises = state.exercises.map((exercise) {
      return exerciseIds.contains(exercise.exercise.id)
          ? exercise.copyWith(executionBlockId: id)
          : exercise;
    }).toList();
    state = state.copyWith(
      groups: [...state.groups, group],
      exercises: exercises,
    );
    _persistDraft();
  }

  void ungroupExercises(String groupId) {
    final group = state.groups.where((item) => item.id == groupId).firstOrNull;
    final exercises = group == null
        ? state.exercises
        : state.exercises.map((exercise) {
            return group.exerciseIds.contains(exercise.exercise.id)
                ? exercise.copyWith(
                    executionBlockId: 'block:${exercise.exercise.id}',
                  )
                : exercise;
          }).toList();
    state = state.copyWith(
      groups: state.groups.where((group) => group.id != groupId).toList(),
      exercises: exercises,
    );
    _persistDraft();
  }

  void updateExerciseGroup({
    required String groupId,
    ExerciseGroupType? type,
    int? restBetweenExercisesSeconds,
    int? restAfterRoundSeconds,
    int? rounds,
  }) {
    state = state.copyWith(
      groups: state.groups.map((group) {
        if (group.id != groupId) return group;
        return ActiveExerciseGroup(
          id: group.id,
          type: type ?? group.type,
          exerciseIds: group.exerciseIds,
          restBetweenExercisesSeconds:
              restBetweenExercisesSeconds ?? group.restBetweenExercisesSeconds,
          restAfterRoundSeconds:
              restAfterRoundSeconds ?? group.restAfterRoundSeconds,
          rounds: rounds ?? group.rounds,
        );
      }).toList(),
    );
    _persistDraft();
  }

  void updateSetRole(String setId, SetRole role) {
    _mutateSetById(setId, (set) => set.copyWith(role: role));
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
    state = state.copyWith(
      exercises: exercises,
      currentTarget: WorkoutExecutionTarget(
        blockId: ex.executionBlockId,
        exerciseId: ex.exercise.id,
        setId: newSet.id,
      ),
      phase: WorkoutPhase.exercising,
    );
    _persistDraft();
  }

  /// Inserts a locally cached exercise without waiting for a server-generated id.
  String? addExercise(
    ExerciseDetailModel exercise, {
    String? afterExerciseId,
    String? groupId,
  }) {
    final exerciseId = exercise.id;
    if (exerciseId == null || exerciseId.isEmpty) return null;
    final entryId = _uuid.v4();
    final activeExercise = ActiveExerciseState(
      executionBlockId: groupId ?? 'block:$entryId',
      exercise: WorkoutExerciseModel(
        id: entryId,
        exercise: exercise,
        sets: '3x10',
        rest: '90s',
        weight: '0 kg',
        progress: 0,
      ),
      displayName:
          _displayNameFromI18n(exercise.nameI18n, exerciseId: exerciseId) ??
          'Exercise',
      sets: List.generate(
        3,
        (index) => ActiveSetState(
          id: _uuid.v4(),
          position: index,
          setType: 'normal',
          weight: 0,
          reps: 10,
          completed: false,
        ),
      ),
    );
    final exercises = [...state.exercises];
    final anchor = afterExerciseId == null
        ? -1
        : exercises.indexWhere((item) => item.exercise.id == afterExerciseId);
    exercises.insert(
      anchor < 0 ? exercises.length : anchor + 1,
      activeExercise,
    );
    final groups = state.groups.map((group) {
      if (group.id != groupId) return group;
      return ActiveExerciseGroup(
        id: group.id,
        type: group.type,
        exerciseIds: [...group.exerciseIds, entryId],
        restBetweenExercisesSeconds: group.restBetweenExercisesSeconds,
        restAfterRoundSeconds: group.restAfterRoundSeconds,
        rounds: group.rounds,
      );
    }).toList();
    state = state.copyWith(exercises: exercises, groups: groups);
    _persistDraft();
    return entryId;
  }

  void removeExercise(String entryId) {
    final exercises = state.exercises
        .where((exercise) => exercise.exercise.id != entryId)
        .toList();
    final groups = state.groups
        .map(
          (group) => ActiveExerciseGroup(
            id: group.id,
            type: group.type,
            exerciseIds: group.exerciseIds
                .where((id) => id != entryId)
                .toList(),
            restBetweenExercisesSeconds: group.restBetweenExercisesSeconds,
            restAfterRoundSeconds: group.restAfterRoundSeconds,
            rounds: group.rounds,
          ),
        )
        .where((group) => group.exerciseIds.length > 1)
        .toList();
    state = state.copyWith(exercises: exercises, groups: groups);
    _advanceFrom(state.currentTarget);
  }

  void reorderExercise(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= state.exercises.length) return;
    final exercises = [...state.exercises];
    final item = exercises.removeAt(oldIndex);
    exercises.insert(newIndex.clamp(0, exercises.length), item);
    state = state.copyWith(exercises: exercises);
    _persistDraft();
  }

  void substituteExercise(String entryId, ExerciseDetailModel replacement) {
    final index = state.exercises.indexWhere(
      (exercise) => exercise.exercise.id == entryId,
    );
    if (index < 0) return;
    final replacementId = replacement.id;
    if (replacementId == null || replacementId.isEmpty) return;
    final current = state.exercises[index];
    final replacementEntryId = _uuid.v4();
    final exercises = [...state.exercises];
    exercises[index] = current.copyWith(
      exercise: current.exercise.copyWith(
        id: replacementEntryId,
        exercise: replacement,
      ),
      displayName:
          _displayNameFromI18n(
            replacement.nameI18n,
            exerciseId: replacementId,
          ) ??
          current.displayName,
    );
    final groups = state.groups
        .map(
          (group) => ActiveExerciseGroup(
            id: group.id,
            type: group.type,
            exerciseIds: group.exerciseIds
                .map((id) => id == entryId ? replacementEntryId : id)
                .toList(),
            restBetweenExercisesSeconds: group.restBetweenExercisesSeconds,
            restAfterRoundSeconds: group.restAfterRoundSeconds,
            rounds: group.rounds,
          ),
        )
        .toList();
    state = state.copyWith(exercises: exercises, groups: groups);
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

    if (response.isOk) {
      await ref.read(activeWorkoutDraftServiceProvider).delete(workoutId);
      ref.invalidate(workoutListProvider);
      ref.invalidate(recentWorkoutsProvider);
      ref.invalidate(workoutStatsProvider);
      state = state.copyWith(status: ActiveWorkoutStatus.saved);
      return true;
    } else {
      state = state.copyWith(
        status: ActiveWorkoutStatus.active,
        errorMessage: response.failureOrNull?.message ?? 'Error while saving.',
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
          notes: _setNotePayload(s),
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

  String? _setNotePayload(ActiveSetState set) {
    final text = set.note?.trim() ?? '';
    final tags = (set.noteTags ?? const <SetNoteTag>{})
        .map((tag) => '#${tag.name}')
        .join(' ');
    if (text.isEmpty && tags.isEmpty) return null;
    if (text.isEmpty) return tags;
    if (tags.isEmpty) return text;
    return '$tags\n$text';
  }

  String _extractDisplayName(WorkoutExerciseModel exercise, int index) {
    return _displayNameFromI18n(
          exercise.exercise.nameI18n,
          exerciseId: exercise.exercise.id,
        ) ??
        'Exercise ${index + 1}';
  }

  void _persistDraft() {
    if (state.sessionId.isEmpty) return;
    unawaited(
      ref.read(activeWorkoutDraftServiceProvider).save(workoutId, state),
    );
  }

  void _restoreRestTimer(Map<String, dynamic>? draft) {
    final restEndsAt = DateTime.tryParse(draft?['restEndsAt'] as String? ?? '');
    if (restEndsAt == null) return;
    final remaining = restEndsAt.difference(DateTime.now()).inSeconds;
    if (remaining > 0) {
      ref.read(restTimerProvider.notifier).startTimer(remaining);
    } else {
      unawaited(
        ref.read(activeWorkoutDraftServiceProvider).clearRest(workoutId),
      );
    }
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
    final technique =
        SetTechnique.values
            .where((item) => item.name == saved['technique'])
            .firstOrNull ??
        set.technique;
    final role =
        SetRole.values
            .where((item) => item.name == saved['role'])
            .firstOrNull ??
        set.role;
    final drops = (saved['drops'] as List?)?.whereType<Map>().map((raw) {
      final drop = raw.map((key, value) => MapEntry(key.toString(), value));
      return DropSetState(
        id: drop['id'] as String? ?? '${set.id}:drop:0',
        weight: (drop['weight'] as num?)?.toDouble() ?? set.weight,
        reps: (drop['reps'] as num?)?.toInt() ?? set.reps,
      );
    }).toList();
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
      role: role,
      technique: technique,
      drops: drops,
      note: saved['note'] as String?,
      noteTags:
          (saved['noteTags'] as List?)
              ?.whereType<String>()
              .map(
                (name) => SetNoteTag.values
                    .where((tag) => tag.name == name)
                    .firstOrNull,
              )
              .whereType<SetNoteTag>()
              .toSet() ??
          set.noteTags,
      completed: saved['completed'] as bool?,
      skipped: saved['skipped'] as bool?,
    );
  }

  List<ActiveExerciseGroup> _restoreGroups(
    List<ActiveExerciseGroup> defaults,
    Map<String, dynamic>? draft,
  ) {
    final rawGroups = draft?['groups'];
    if (rawGroups is! List) return defaults;
    final restored = <ActiveExerciseGroup>[];
    for (final raw in rawGroups.whereType<Map>()) {
      final group = raw.map((key, value) => MapEntry(key.toString(), value));
      final type = ExerciseGroupType.values
          .where((item) => item.name == group['type'])
          .firstOrNull;
      final id = group['id'] as String?;
      final ids = (group['exerciseIds'] as List?)?.whereType<String>().toList();
      if (type == null || id == null || ids == null || ids.length < 2) continue;
      restored.add(
        ActiveExerciseGroup(
          id: id,
          type: type,
          exerciseIds: ids,
          restBetweenExercisesSeconds:
              (group['restBetweenExercisesSeconds'] as num?)?.toInt(),
          restAfterRoundSeconds: (group['restAfterRoundSeconds'] as num?)
              ?.toInt(),
          rounds: (group['rounds'] as num?)?.toInt(),
        ),
      );
    }
    return restored;
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
