import 'dart:async';
import 'dart:math';

import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_programming_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_edit_draft_provider.g.dart';

class WorkoutEditDraftState {
  final WorkoutModel? source;
  final List<WorkoutProgrammingBlockModel> blocks;
  final bool isDirty;
  final bool isSaving;
  final bool savedOffline;
  final String? error;

  const WorkoutEditDraftState({
    this.source,
    this.blocks = const [],
    this.isDirty = false,
    this.isSaving = false,
    this.savedOffline = false,
    this.error,
  });

  bool get isInitialized => source != null;

  WorkoutEditDraftState copyWith({
    WorkoutModel? source,
    List<WorkoutProgrammingBlockModel>? blocks,
    bool? isDirty,
    bool? isSaving,
    bool? savedOffline,
    String? error,
    bool clearError = false,
  }) => WorkoutEditDraftState(
    source: source ?? this.source,
    blocks: blocks ?? this.blocks,
    isDirty: isDirty ?? this.isDirty,
    isSaving: isSaving ?? this.isSaving,
    savedOffline: savedOffline ?? this.savedOffline,
    error: clearError ? null : error ?? this.error,
  );
}

@riverpod
class WorkoutEditDraft extends _$WorkoutEditDraft {
  @override
  WorkoutEditDraftState build(String workoutId) =>
      const WorkoutEditDraftState();

  void initialize(WorkoutModel workout) {
    if (state.isInitialized && state.source?.id == workout.id) return;
    state = WorkoutEditDraftState(
      source: workout,
      blocks: _normalizeBlocks(workout),
    );
  }

  void moveBlock(int oldIndex, int newIndex) {
    if (!_validIndex(oldIndex) || oldIndex == newIndex) return;
    final blocks = [...state.blocks];
    final block = blocks.removeAt(oldIndex);
    final target = newIndex.clamp(0, blocks.length);
    blocks.insert(target, block);
    state = state.copyWith(
      blocks: _reposition(blocks),
      isDirty: true,
      clearError: true,
    );
  }

  void removeExercise(String instanceId) {
    final blocks = <WorkoutProgrammingBlockModel>[];
    for (final block in state.blocks) {
      final entries = block.entries
          .where((entry) => entry.id != instanceId)
          .toList();
      if (entries.isEmpty) continue;
      blocks.add(
        block.copyWith(
          entries: _repositionEntries(entries),
          groupType: entries.length == 1 ? 'exercise' : block.groupType,
          rounds: entries.length == 1 ? null : block.rounds,
        ),
      );
    }
    state = state.copyWith(
      blocks: _reposition(blocks),
      isDirty: true,
      clearError: true,
    );
  }

  void restoreBlocks(List<WorkoutProgrammingBlockModel> blocks) {
    state = state.copyWith(
      blocks: _reposition(blocks),
      isDirty: true,
      clearError: true,
    );
  }

  void duplicateExercise(String instanceId) {
    final blocks = [...state.blocks];
    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final block = blocks[blockIndex];
      final entryIndex = block.entries.indexWhere(
        (entry) => entry.id == instanceId,
      );
      if (entryIndex < 0) continue;
      final original = block.entries[entryIndex];
      final copy = original.copyWith(
        id: _uuid(),
        sets: original.sets
            .map((set) => set.copyWith(id: null, position: set.position))
            .toList(),
      );
      if (block.groupType == 'superset' || block.groupType == 'circuit') {
        final entries = [...block.entries]..insert(entryIndex + 1, copy);
        blocks[blockIndex] = block.copyWith(
          entries: _repositionEntries(entries),
        );
      } else {
        blocks.insert(
          blockIndex + 1,
          block.copyWith(
            id: _uuid(),
            position: blockIndex + 1,
            groupType: 'exercise',
            entries: [copy.copyWith(position: 0)],
          ),
        );
      }
      state = state.copyWith(
        blocks: _reposition(blocks),
        isDirty: true,
        clearError: true,
      );
      return;
    }
  }

  void addExercise({
    required ExerciseDetailModel exercise,
    required List<WorkoutProgrammingSetModel> sets,
    String? sectionId,
  }) {
    final exerciseId = exercise.id;
    if (exerciseId == null || exerciseId.isEmpty || sets.isEmpty) return;
    final instanceId = _uuid();
    final sectionAnchor = state.blocks.firstWhere(
      (block) => block.sectionId == sectionId,
      orElse: () => state.blocks.isEmpty
          ? WorkoutProgrammingBlockModel(id: _uuid(), position: 0)
          : state.blocks.last,
    );
    final block = WorkoutProgrammingBlockModel(
      id: _uuid(),
      position: state.blocks.length,
      sectionId: sectionId,
      sectionPosition: sectionId == null ? null : sectionAnchor.sectionPosition,
      sectionTitle: sectionId == null ? null : sectionAnchor.sectionTitle,
      sectionKind: sectionId == null ? null : sectionAnchor.sectionKind,
      groupType: 'exercise',
      entries: [
        WorkoutProgrammingEntryModel(
          id: instanceId,
          exerciseId: exerciseId,
          position: 0,
          sets: sets.indexed
              .map((item) => item.$2.copyWith(id: null, position: item.$1))
              .toList(),
        ),
      ],
    );
    final source = state.source;
    final details = source == null
        ? const <WorkoutExerciseModel>[]
        : [
            ...source.workoutExercises,
            WorkoutExerciseModel(
              id: instanceId,
              exercise: exercise,
              sets:
                  '${sets.length}x${sets.first.repsMin ?? sets.first.reps ?? ''}',
              rest: '${sets.first.restSeconds ?? 0}s',
              weight: '-',
              progress: 0,
            ),
          ];
    state = state.copyWith(
      source: source?.copyWith(workoutExercises: details),
      blocks: [...state.blocks, block],
      isDirty: true,
      clearError: true,
    );
  }

  void moveExerciseToSection(String instanceId, String? sectionId) {
    state = state.copyWith(
      blocks: state.blocks.map((block) {
        if (!block.entries.any((entry) => entry.id == instanceId)) return block;
        final sibling = state.blocks.firstWhere(
          (candidate) => candidate.sectionId == sectionId,
          orElse: () => block,
        );
        return block.copyWith(
          sectionId: sectionId,
          sectionPosition: sibling.sectionPosition,
          sectionTitle: sibling.sectionTitle,
          sectionKind: sibling.sectionKind,
        );
      }).toList(),
      isDirty: true,
      clearError: true,
    );
  }

  void addSection({required String title, required String kind}) {
    final normalized = title.trim();
    if (normalized.isEmpty || state.blocks.isEmpty) return;
    // Sections are attached to blocks by contract. The final unsectioned block
    // becomes the first block in the new section, avoiding empty server rows.
    final targetIndex = state.blocks.lastIndexWhere(
      (block) => block.sectionId == null,
    );
    if (targetIndex < 0) return;
    final blocks = [...state.blocks];
    final sectionId = _uuid();
    blocks[targetIndex] = blocks[targetIndex].copyWith(
      sectionId: sectionId,
      sectionPosition: _sectionCount(blocks),
      sectionTitle: normalized,
      sectionKind: kind,
    );
    state = state.copyWith(blocks: blocks, isDirty: true, clearError: true);
  }

  void createGroup({
    required String type,
    required List<String> instanceIds,
    required int rounds,
    int restBetweenExercisesSeconds = 0,
    int restAfterRoundSeconds = 120,
  }) {
    final selected = instanceIds.toSet();
    if (selected.length < 2 || (type != 'superset' && type != 'circuit')) {
      return;
    }
    final entries = <WorkoutProgrammingEntryModel>[];
    WorkoutProgrammingBlockModel? anchor;
    var insertAt = state.blocks.length;
    for (var index = 0; index < state.blocks.length; index++) {
      final block = state.blocks[index];
      final matches = block.entries.where(
        (entry) => selected.contains(entry.id),
      );
      if (matches.isNotEmpty) {
        anchor ??= block;
        insertAt = min(insertAt, index);
        entries.addAll(matches);
      }
    }
    if (entries.length != selected.length || anchor == null) return;
    final remaining = state.blocks
        .map((block) {
          final entries = block.entries
              .where((entry) => !selected.contains(entry.id))
              .toList();
          if (entries.isEmpty) return null;
          return block.copyWith(
            entries: _repositionEntries(entries),
            groupType: entries.length == 1 ? 'exercise' : block.groupType,
          );
        })
        .whereType<WorkoutProgrammingBlockModel>()
        .toList();
    final group = anchor.copyWith(
      id: _uuid(),
      groupType: type,
      rounds: rounds.clamp(1, 99),
      restBetweenExercisesSeconds: restBetweenExercisesSeconds.clamp(0, 3600),
      restSeconds: restAfterRoundSeconds.clamp(0, 3600),
      entries: _repositionEntries(entries),
    );
    remaining.insert(insertAt.clamp(0, remaining.length), group);
    state = state.copyWith(
      blocks: _reposition(remaining),
      isDirty: true,
      clearError: true,
    );
  }

  void ungroup(String blockId) {
    final blocks = <WorkoutProgrammingBlockModel>[];
    for (final block in state.blocks) {
      if (block.id != blockId || block.entries.length < 2) {
        blocks.add(block);
        continue;
      }
      for (final entry in block.entries) {
        blocks.add(
          block.copyWith(
            id: _uuid(),
            groupType: 'exercise',
            rounds: null,
            restBetweenExercisesSeconds: null,
            entries: [entry.copyWith(position: 0)],
          ),
        );
      }
    }
    state = state.copyWith(
      blocks: _reposition(blocks),
      isDirty: true,
      clearError: true,
    );
  }

  void updatePrescription({
    required String instanceId,
    required int sets,
    required int? repsMin,
    required int? repsMax,
    required int restSeconds,
    required String intensityType,
    double? intensityMin,
    double? intensityMax,
  }) {
    if (sets < 1 || (repsMin != null && repsMax != null && repsMin > repsMax)) {
      return;
    }
    final blocks = state.blocks.map((block) {
      return block.copyWith(
        entries: block.entries.map((entry) {
          if (entry.id != instanceId) return entry;
          final previous = entry.sets.firstOrNull;
          return entry.copyWith(
            sets: List.generate(
              sets,
              (index) => WorkoutProgrammingSetModel(
                position: index,
                setType: previous?.setType ?? 'normal',
                repsMin: repsMin,
                repsMax: repsMax,
                intensityType: intensityType,
                intensityMin: intensityType == 'none' ? null : intensityMin,
                intensityMax: intensityType == 'none' ? null : intensityMax,
                load: previous?.load,
                loadUnit: previous?.loadUnit,
                restSeconds: restSeconds,
                tempo: previous?.tempo,
                pauseSeconds: previous?.pauseSeconds,
                unilateral: previous?.unilateral ?? false,
                notes: previous?.notes,
              ),
            ),
          );
        }).toList(),
      );
    }).toList();
    state = state.copyWith(blocks: blocks, isDirty: true, clearError: true);
  }

  Future<WorkoutModel?> save() async {
    final source = state.source;
    if (source == null || state.isSaving) return null;
    if (state.blocks.any((block) => block.entries.isEmpty)) {
      state = state.copyWith(error: 'A workout block cannot be empty.');
      return null;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    final updated = source.copyWith(
      programmingBlocks: _reposition(state.blocks),
      workoutExercises: _orderedLegacyExercises(
        source.workoutExercises,
        state.blocks,
      ),
      exercises: state.blocks.fold(
        0,
        (sum, block) => sum + block.entries.length,
      ),
      dirty: true,
    );
    final repository = ref.read(workoutPageRepositoryProvider);
    final local = await repository.updateWorkout(updated);
    if (!local.success) {
      state = state.copyWith(
        isSaving: false,
        error: local.message ?? 'Unable to save locally.',
      );
      return null;
    }
    state = state.copyWith(
      source: updated,
      isDirty: false,
      isSaving: false,
      savedOffline: true,
      clearError: true,
    );
    ref.invalidate(workoutListProvider);
    unawaited(_sync(updated));
    return updated;
  }

  Future<void> _sync(WorkoutModel updated) async {
    final repository = ref.read(workoutPageRepositoryProvider);
    final command = WorkoutWriteCommandMapper.fromWorkoutModel(updated);
    final response = await repository.patchWorkout(updated.id, command);
    if (response.success) {
      ref.invalidate(workoutListProvider);
      if (state.source?.id == updated.id) {
        state = state.copyWith(savedOffline: false);
      }
    }
  }

  bool _validIndex(int index) => index >= 0 && index < state.blocks.length;
}

List<WorkoutProgrammingBlockModel> _normalizeBlocks(WorkoutModel workout) {
  if (workout.programmingBlocks.isNotEmpty) {
    return _reposition(workout.programmingBlocks);
  }
  return workout.workoutExercises.indexed.map((item) {
    final exercise = item.$2;
    final values = RegExp(
      r'\d+',
    ).allMatches(exercise.sets).map((m) => int.parse(m[0]!)).toList();
    final setCount = values.firstOrNull ?? 1;
    final reps = values.length > 1 ? values[1] : null;
    final rest = int.tryParse(
      RegExp(r'\d+').firstMatch(exercise.rest)?.group(0) ?? '',
    );
    return WorkoutProgrammingBlockModel(
      id: _uuid(),
      position: item.$1,
      groupType: 'exercise',
      entries: [
        WorkoutProgrammingEntryModel(
          id: exercise.id,
          exerciseId: exercise.exercise.id ?? '',
          position: 0,
          sets: List.generate(
            setCount,
            (index) => WorkoutProgrammingSetModel(
              position: index,
              reps: reps,
              restSeconds: rest,
            ),
          ),
        ),
      ],
    );
  }).toList();
}

List<WorkoutProgrammingBlockModel> _reposition(
  List<WorkoutProgrammingBlockModel> blocks,
) => blocks.indexed.map((item) => item.$2.copyWith(position: item.$1)).toList();

List<WorkoutProgrammingEntryModel> _repositionEntries(
  List<WorkoutProgrammingEntryModel> entries,
) =>
    entries.indexed.map((item) => item.$2.copyWith(position: item.$1)).toList();

int _sectionCount(List<WorkoutProgrammingBlockModel> blocks) =>
    blocks.map((block) => block.sectionId).whereType<String>().toSet().length;

List<WorkoutExerciseModel> _orderedLegacyExercises(
  List<WorkoutExerciseModel> exercises,
  List<WorkoutProgrammingBlockModel> blocks,
) {
  final byInstance = {for (final exercise in exercises) exercise.id: exercise};
  return blocks
      .expand((block) => block.entries)
      .map((entry) => byInstance[entry.id])
      .whereType<WorkoutExerciseModel>()
      .toList();
}

String _uuid() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

@riverpod
WorkoutProgrammingEntryModel? lastExercisePrescription(
  Ref ref,
  String exerciseId,
) {
  final workouts = ref.watch(workoutListProvider).value;
  if (workouts == null) return null;
  final ordered = [...workouts]
    ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  for (final workout in ordered) {
    for (final block in workout.programmingBlocks) {
      for (final entry in block.entries) {
        if (entry.exerciseId == exerciseId && entry.sets.isNotEmpty) {
          return entry;
        }
      }
    }
  }
  return null;
}
