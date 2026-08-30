import 'dart:async';

import 'package:coachly/core/ids/id_generator.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/data/mappers/workout_write_command_mapper.dart';
import 'package:coachly/features/workout/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/data/models/workout_programming_model.dart';
import 'package:coachly/features/workout/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_builder_providers.g.dart';

class WorkoutBuilderState {
  final WorkoutDraft draft;
  final WorkoutDraft? baseline;
  final bool isSaving;
  final String? error;

  const WorkoutBuilderState({
    required this.draft,
    this.baseline,
    this.isSaving = false,
    this.error,
  });
  bool get isDirty => baseline == null
      ? draft.title.isNotEmpty ||
            draft.trainingGoal != null ||
            draft.focus != null ||
            draft.exerciseCount > 0
      : !_sameDraft(draft, baseline!);
  WorkoutDraftValidation get validation => WorkoutDraftRules.validate(draft);

  WorkoutBuilderState copyWith({
    WorkoutDraft? draft,
    WorkoutDraft? baseline,
    bool? isSaving,
    Object? error = _unset,
  }) => WorkoutBuilderState(
    draft: draft ?? this.draft,
    baseline: baseline ?? this.baseline,
    isSaving: isSaving ?? this.isSaving,
    error: identical(error, _unset) ? this.error : error as String?,
  );
}

abstract mixin class WorkoutDraftMutations {
  WorkoutBuilderState get current;
  set current(WorkoutBuilderState value);

  void updateMetadata({
    String? title,
    Object? goal = _unset,
    Object? focus = _unset,
  }) {
    current = current.copyWith(
      draft: current.draft.copyWith(
        title: title,
        trainingGoal: goal,
        focus: focus,
      ),
      error: null,
    );
  }

  void addSection(String? name, {String? notes}) {
    final section = WorkoutSectionDraft(
      id: _id(),
      name: name?.trim().isEmpty == true ? null : name?.trim(),
      position: current.draft.sections.length,
      notes: notes,
    );
    final sections = _insertSectionAtDefaultPosition(
      current.draft.sections,
      section,
    );
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void renameSection(String sectionId, String name) {
    final sections = current.draft.sections
        .map(
          (section) => section.id == sectionId
              ? section.copyWith(name: name.trim())
              : section,
        )
        .toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void updateSection(WorkoutSectionDraft updated) {
    final sections = current.draft.sections
        .map((section) => section.id == updated.id ? updated : section)
        .toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void removeSection(String sectionId) {
    final sections = [...current.draft.sections];
    final index = sections.indexWhere((section) => section.id == sectionId);
    if (index < 0) return;
    final removed = sections.removeAt(index);
    if (sections.isEmpty) {
      sections.add(
        WorkoutSectionDraft(id: _id(), position: 0, items: removed.items),
      );
    } else if (removed.items.isNotEmpty) {
      final destination = (index - 1).clamp(0, sections.length - 1);
      sections[destination] = sections[destination].copyWith(
        items: [...sections[destination].items, ...removed.items],
      );
    }
    current = current.copyWith(
      draft: current.draft.copyWith(
        sections: sections.indexed
            .map((pair) => pair.$2.copyWith(position: pair.$1))
            .toList(),
      ),
      error: null,
    );
  }

  void addExercise(WorkoutExerciseDraft exercise, {String? sectionId}) {
    var sections = [...current.draft.sections];
    if (sections.isEmpty) {
      sections.add(WorkoutSectionDraft(id: _id(), position: 0));
    }
    var index = sectionId == null
        ? sections.indexWhere(
            (section) => section.kind == WorkoutSectionKind.main,
          )
        : sections.indexWhere((s) => s.id == sectionId);
    if (index < 0) index = 0;
    final section = sections[index];
    sections[index] = section.copyWith(
      items: [...section.items, WorkoutExerciseItemDraft(exercise)],
    );
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void updateExercise(WorkoutExerciseDraft exercise) {
    final sections = current.draft.sections
        .map(
          (section) => section.copyWith(
            items: section.items.map((item) {
              if (item is WorkoutExerciseItemDraft &&
                  item.id == exercise.localId) {
                return WorkoutExerciseItemDraft(exercise);
              }
              if (item is WorkoutExerciseGroupDraft &&
                  item.exercises.any((e) => e.localId == exercise.localId)) {
                return item.copyWith(
                  exercises: item.exercises
                      .map((e) => e.localId == exercise.localId ? exercise : e)
                      .toList(),
                );
              }
              return item;
            }).toList(),
          ),
        )
        .toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void updateGroup(WorkoutExerciseGroupDraft group) {
    final sections = current.draft.sections
        .map(
          (section) => section.copyWith(
            items: section.items
                .map((item) => item.id == group.id ? group : item)
                .toList(),
          ),
        )
        .toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void removeItem(String itemId) {
    final sections = current.draft.sections
        .map(
          (section) => section.copyWith(
            items: section.items.where((item) => item.id != itemId).toList(),
          ),
        )
        .toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void removeExercise(String exerciseId) {
    final sections = current.draft.sections.map((section) {
      final items = <WorkoutStructureItemDraft>[];
      for (final item in section.items) {
        if (item is! WorkoutExerciseGroupDraft ||
            !item.exercises.any((exercise) => exercise.localId == exerciseId)) {
          items.add(item);
          continue;
        }
        final remaining = item.exercises
            .where((exercise) => exercise.localId != exerciseId)
            .toList();
        if (remaining.length > 1) {
          items.add(item.copyWith(exercises: remaining));
        } else if (remaining.length == 1) {
          items.add(WorkoutExerciseItemDraft(remaining.single));
        }
      }
      return section.copyWith(items: items);
    }).toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void duplicateItem(String itemId) {
    final sections = current.draft.sections.map((section) {
      final index = section.items.indexWhere((item) => item.id == itemId);
      if (index < 0) return section;
      final source = section.items[index];
      final duplicate = switch (source) {
        WorkoutExerciseItemDraft(:final exercise) => WorkoutExerciseItemDraft(
          exercise.copyWith(localId: _id()),
        ),
        WorkoutExerciseGroupDraft group => WorkoutExerciseGroupDraft(
          id: _id(),
          type: group.type,
          rounds: group.rounds,
          exercises: group.exercises
              .map((exercise) => exercise.copyWith(localId: _id()))
              .toList(),
          intraExerciseRestSeconds: group.intraExerciseRestSeconds,
          roundRestSeconds: group.roundRestSeconds,
          notes: group.notes,
        ),
      };
      final items = [...section.items]..insert(index + 1, duplicate);
      return section.copyWith(items: items);
    }).toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void moveItemToSection(String itemId, String sectionId) {
    WorkoutStructureItemDraft? moving;
    var sections = current.draft.sections.map((section) {
      final match = section.items
          .where((item) => item.id == itemId)
          .firstOrNull;
      if (match == null) return section;
      moving = match;
      return section.copyWith(
        items: section.items.where((item) => item.id != itemId).toList(),
      );
    }).toList();
    if (moving == null) return;
    sections = sections.map((section) {
      if (section.id != sectionId) return section;
      return section.copyWith(items: [...section.items, moving!]);
    }).toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void reorderInSection(String sectionId, int oldIndex, int newIndex) {
    final sections = current.draft.sections.map((section) {
      if (section.id != sectionId ||
          oldIndex < 0 ||
          oldIndex >= section.items.length) {
        return section;
      }
      final items = [...section.items];
      if (newIndex > oldIndex) newIndex -= 1;
      final item = items.removeAt(oldIndex);
      items.insert(newIndex.clamp(0, items.length), item);
      return section.copyWith(items: items);
    }).toList();
    current = current.copyWith(
      draft: current.draft.copyWith(sections: sections),
      error: null,
    );
  }

  void reorderSections(int oldIndex, int newIndex) {
    final sections = [...current.draft.sections];
    if (oldIndex < 0 || oldIndex >= sections.length) return;
    if (newIndex > oldIndex) newIndex -= 1;
    final section = sections.removeAt(oldIndex);
    sections.insert(newIndex.clamp(0, sections.length), section);
    current = current.copyWith(
      draft: current.draft.copyWith(
        sections: sections.indexed
            .map((pair) => pair.$2.copyWith(position: pair.$1))
            .toList(),
      ),
      error: null,
    );
  }

  void createGroup({
    required WorkoutGroupType type,
    required List<String> itemIds,
    int rounds = 3,
    int restBetweenExercisesSeconds = 0,
    int restAfterRoundSeconds = 90,
    String? notes,
  }) {
    final selected = itemIds.toSet();
    if (selected.length < 2) return;
    for (
      var sectionIndex = 0;
      sectionIndex < current.draft.sections.length;
      sectionIndex++
    ) {
      final section = current.draft.sections[sectionIndex];
      final matches = section.items
          .where(
            (item) =>
                selected.contains(item.id) && item is WorkoutExerciseItemDraft,
          )
          .toList();
      if (matches.length != selected.length) continue;
      final firstIndex = section.items.indexWhere(
        (item) => selected.contains(item.id),
      );
      final byId = {
        for (final item in matches.cast<WorkoutExerciseItemDraft>())
          item.id: item.exercise,
      };
      final exercises = itemIds
          .map((id) => byId[id])
          .whereType<WorkoutExerciseDraft>()
          .toList();
      final items = section.items
          .where((item) => !selected.contains(item.id))
          .toList();
      items.insert(
        firstIndex,
        WorkoutExerciseGroupDraft(
          id: _id(),
          type: type,
          rounds: rounds,
          exercises: exercises,
          intraExerciseRestSeconds: restBetweenExercisesSeconds,
          roundRestSeconds: restAfterRoundSeconds,
          notes: notes,
        ),
      );
      final sections = [...current.draft.sections];
      sections[sectionIndex] = section.copyWith(items: items);
      current = current.copyWith(
        draft: current.draft.copyWith(sections: sections),
        error: null,
      );
      return;
    }
  }
}

@riverpod
class CreateWorkoutController extends _$CreateWorkoutController
    with WorkoutDraftMutations {
  @override
  WorkoutBuilderState build() => WorkoutBuilderState(
    draft: WorkoutDraft(
      localDraftId: _id(),
      sections: [WorkoutSectionDraft(id: _id(), position: 0)],
    ),
  );
  @override
  WorkoutBuilderState get current => state;
  @override
  set current(WorkoutBuilderState value) => state = value;

  Future<WorkoutModel?> commit() async {
    if (!state.validation.isValid) {
      state = state.copyWith(error: state.validation.errors.join(','));
      return null;
    }
    state = state.copyWith(isSaving: true, error: null);
    final locale = ref.read(languageProvider).languageCode;
    final now = DateTime.now();
    final workout = WorkoutModel(
      id: 'local_${now.microsecondsSinceEpoch}',
      titleI18n: {locale: state.draft.title.trim()},
      descriptionI18n: state.draft.focus?.trim().isNotEmpty == true
          ? {locale: state.draft.focus!.trim()}
          : null,
      goal: state.draft.trainingGoal ?? 'general',
      type: state.draft.trainingGoal ?? 'general',
      lastUsed: now,
      durationMinutes: state.draft.estimatedDurationMinutes,
      exercises: state.draft.exerciseCount,
      workoutExercises: _localWorkoutExercises(state.draft, locale),
      programmingBlocks: WorkoutDraftProgrammingMapper.toProgramming(
        state.draft,
      ),
      dirty: true,
    );
    final response = await ref
        .read(workoutPageRepositoryProvider)
        .updateWorkout(workout);
    if (!response.isOk) {
      state = state.copyWith(
        isSaving: false,
        error: response.failureOrNull?.message ?? 'local_persistence',
      );
      return null;
    }
    state = state.copyWith(isSaving: false, baseline: state.draft);
    ref.invalidate(workoutListProvider);
    return workout;
  }
}

@riverpod
class EditWorkoutController extends _$EditWorkoutController
    with WorkoutDraftMutations {
  @override
  WorkoutBuilderState build(String workoutId) => WorkoutBuilderState(
    draft: WorkoutDraft(localDraftId: _id(), sourceWorkoutId: workoutId),
  );
  @override
  WorkoutBuilderState get current => state;
  @override
  set current(WorkoutBuilderState value) => state = value;

  void initialize(WorkoutModel workout) {
    if (state.baseline != null) return;
    final locale = ref.read(languageProvider);
    final draft = _fromWorkout(workout, locale);
    state = WorkoutBuilderState(draft: draft, baseline: draft);
  }

  void discard() {
    final baseline = state.baseline;
    if (baseline != null) {
      state = WorkoutBuilderState(draft: baseline, baseline: baseline);
    }
  }

  Future<WorkoutModel?> commit(WorkoutModel source) async {
    if (!state.validation.isValid) {
      state = state.copyWith(error: state.validation.errors.join(','));
      return null;
    }
    state = state.copyWith(isSaving: true, error: null);
    final locale = ref.read(languageProvider).languageCode;
    final updated = source.copyWith(
      titleI18n: {...?source.titleI18n, locale: state.draft.title.trim()},
      descriptionI18n: state.draft.focus?.trim().isNotEmpty == true
          ? {...?source.descriptionI18n, locale: state.draft.focus!.trim()}
          : null,
      goal: state.draft.trainingGoal ?? source.goal,
      type: state.draft.trainingGoal ?? source.type,
      durationMinutes: state.draft.estimatedDurationMinutes,
      exercises: state.draft.exerciseCount,
      workoutExercises: _localWorkoutExercises(
        state.draft,
        locale,
        source.workoutExercises,
      ),
      programmingBlocks: WorkoutDraftProgrammingMapper.toProgramming(
        state.draft,
      ),
      dirty: true,
    );
    final response = await ref
        .read(workoutPageRepositoryProvider)
        .updateWorkout(updated);
    if (!response.isOk) {
      state = state.copyWith(
        isSaving: false,
        error: response.failureOrNull?.message ?? 'local_persistence',
      );
      return null;
    }
    state = state.copyWith(isSaving: false, baseline: state.draft);
    ref.invalidate(workoutListProvider);
    unawaited(
      ref
          .read(workoutPageRepositoryProvider)
          .patchWorkout(
            updated.id,
            WorkoutWriteCommandMapper.fromWorkoutModel(updated),
          ),
    );
    return updated;
  }
}

List<WorkoutExerciseModel> _localWorkoutExercises(
  WorkoutDraft draft,
  String locale, [
  List<WorkoutExerciseModel> existing = const [],
]) {
  final existingByExerciseId = {
    for (final item in existing)
      if (item.exercise.id?.isNotEmpty == true) item.exercise.id!: item,
  };
  return draft.sections
      .expand((section) => section.items)
      .expand((item) => item.exercises)
      .map((exercise) {
        final existingItem = existingByExerciseId[exercise.exerciseId];
        final knownNames = existingItem?.exercise.nameI18n;
        final exerciseDetail =
            existingItem?.exercise.copyWith(
              nameI18n: {...?knownNames, locale: exercise.name},
            ) ??
            ExerciseDetailModel(
              id: exercise.exerciseId,
              nameI18n: {locale: exercise.name},
            );
        final load = exercise.targetLoad;
        return WorkoutExerciseModel(
          id: exercise.localId,
          exercise: exerciseDetail,
          sets: '${exercise.sets}x${exercise.repTarget.compactLabel}',
          rest: '${exercise.recoverySeconds}s',
          weight: load == null
              ? '-'
              : '${_compactLoad(load)}${exercise.loadUnit}',
          progress: existingItem?.progress ?? 0,
        );
      })
      .toList();
}

String _compactLoad(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);

WorkoutDraft _fromWorkout(WorkoutModel workout, dynamic locale) {
  final names = {
    for (final item in workout.workoutExercises)
      item.id:
          item.exercise.nameI18n?.fromI18n(locale) ?? item.exercise.id ?? '',
  };
  final blocks = workout.programmingBlocks.isNotEmpty
      ? workout.programmingBlocks
      : workout.workoutExercises.indexed.map((pair) {
          final values = RegExp(
            r'\d+',
          ).allMatches(pair.$2.sets).map((m) => int.parse(m[0]!)).toList();
          final setCount = values.firstOrNull ?? 1;
          final reps = values.length > 1 ? values[1] : 10;
          final rest =
              int.tryParse(
                RegExp(r'\d+').firstMatch(pair.$2.rest)?.group(0) ?? '',
              ) ??
              90;
          return WorkoutProgrammingBlockModel(
            id: 'block_${pair.$2.id}',
            position: pair.$1,
            groupType: 'exercise',
            entries: [
              WorkoutProgrammingEntryModel(
                id: pair.$2.id,
                exerciseId: pair.$2.exercise.id ?? '',
                position: 0,
                sets: List.generate(
                  setCount,
                  (index) => WorkoutProgrammingSetModel(
                    position: index,
                    reps: reps,
                    repsMin: reps,
                    repsMax: reps,
                    restSeconds: rest,
                  ),
                ),
              ),
            ],
          );
        }).toList();
  final sectionKeys = <String?>[];
  for (final block in blocks) {
    if (!sectionKeys.contains(block.sectionId)) {
      sectionKeys.add(block.sectionId);
    }
  }
  final sections = sectionKeys.indexed.map((pair) {
    final matching = blocks.where((b) => b.sectionId == pair.$2).toList();
    return WorkoutSectionDraft(
      id: pair.$2 ?? 'implicit',
      name: matching.firstOrNull?.sectionTitle,
      position: pair.$1,
      items: matching.map((block) {
        final exercises = block.entries.map((entry) {
          final set = entry.sets.firstOrNull;
          final min = set?.repsMin ?? set?.reps ?? 10;
          final max = set?.repsMax ?? set?.reps ?? min;
          return WorkoutExerciseDraft(
            localId: entry.id,
            exerciseId: entry.exerciseId,
            name: names[entry.id] ?? entry.exerciseId,
            sets: entry.sets.isEmpty ? 1 : entry.sets.length,
            repTarget: min == max
                ? RepTarget.fixed(min)
                : RepTarget.range(min: min, max: max),
            recoverySeconds: set?.restSeconds ?? 90,
            targetLoad: set?.load,
            loadUnit: set?.loadUnit ?? 'kg',
            notes: block.groupType == 'exercise' ? block.notes : null,
          );
        }).toList();
        if (block.groupType != null &&
            block.groupType != 'exercise' &&
            exercises.length > 1) {
          return WorkoutExerciseGroupDraft(
            id: block.id,
            type: _groupType(block.groupType!),
            exercises: exercises,
            rounds: block.rounds ?? 3,
            intraExerciseRestSeconds: block.restBetweenExercisesSeconds ?? 0,
            roundRestSeconds: block.restSeconds ?? 90,
            notes: block.notes,
          );
        }
        return WorkoutExerciseItemDraft(exercises.first);
      }).toList(),
    );
  }).toList();
  return WorkoutDraft(
    localDraftId: _id(),
    sourceWorkoutId: workout.id,
    title: workout.titleI18n?.fromI18n(locale) ?? '',
    trainingGoal: _goal(workout.type),
    focus: workout.descriptionI18n?.fromI18n(locale),
    sections: sections,
  );
}

WorkoutGroupType _groupType(String value) => switch (value) {
  'triset' => WorkoutGroupType.triset,
  'giantSet' || 'giant_set' => WorkoutGroupType.giantSet,
  'circuit' => WorkoutGroupType.circuit,
  _ => WorkoutGroupType.superset,
};

String _goal(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('hyper') || normalized.contains('ipertrof')) {
    return 'hypertrophy';
  }
  if (normalized.contains('strength') || normalized.contains('forza')) {
    return 'strength';
  }
  return 'general';
}

List<WorkoutSectionDraft> _insertSectionAtDefaultPosition(
  List<WorkoutSectionDraft> existing,
  WorkoutSectionDraft section,
) {
  final sections = [...existing];
  final index = switch (section.kind) {
    WorkoutSectionKind.preparation => 0,
    WorkoutSectionKind.main => _afterLastKind(sections, const {
      WorkoutSectionKind.preparation,
    }),
    WorkoutSectionKind.accessories => _beforeFirstKind(sections, const {
      WorkoutSectionKind.custom,
      WorkoutSectionKind.cooldown,
      WorkoutSectionKind.finisher,
    }),
    WorkoutSectionKind.custom => _beforeFirstKind(sections, const {
      WorkoutSectionKind.cooldown,
      WorkoutSectionKind.finisher,
    }),
    WorkoutSectionKind.cooldown => _beforeFirstKind(sections, const {
      WorkoutSectionKind.finisher,
    }),
    WorkoutSectionKind.finisher => sections.length,
  };
  sections.insert(index, section);
  return sections.indexed
      .map((pair) => pair.$2.copyWith(position: pair.$1))
      .toList();
}

int _beforeFirstKind(
  List<WorkoutSectionDraft> sections,
  Set<WorkoutSectionKind> kinds,
) {
  final index = sections.indexWhere((section) => kinds.contains(section.kind));
  return index < 0 ? sections.length : index;
}

int _afterLastKind(
  List<WorkoutSectionDraft> sections,
  Set<WorkoutSectionKind> kinds,
) {
  final index = sections.lastIndexWhere(
    (section) => kinds.contains(section.kind),
  );
  return index < 0 ? 0 : index + 1;
}

bool _sameDraft(WorkoutDraft a, WorkoutDraft b) =>
    a.title == b.title &&
    a.trainingGoal == b.trainingGoal &&
    a.focus == b.focus &&
    a.sections.length == b.sections.length &&
    a.sections.indexed.every(
      (p) =>
          p.$2.name == b.sections[p.$1].name &&
          p.$2.notes == b.sections[p.$1].notes &&
          p.$2.items.length == b.sections[p.$1].items.length &&
          p.$2.items.indexed.every(
            (i) =>
                i.$2.id == b.sections[p.$1].items[i.$1].id &&
                _itemNotes(i.$2) == _itemNotes(b.sections[p.$1].items[i.$1]) &&
                i.$2.exercises.indexed.every((e) {
                  final other = b.sections[p.$1].items[i.$1].exercises[e.$1];
                  return e.$2.sets == other.sets &&
                      e.$2.repTarget.min == other.repTarget.min &&
                      e.$2.repTarget.max == other.repTarget.max &&
                      e.$2.recoverySeconds == other.recoverySeconds &&
                      e.$2.targetLoad == other.targetLoad;
                }),
          ),
    );

String? _itemNotes(WorkoutStructureItemDraft item) => switch (item) {
  WorkoutExerciseItemDraft(:final exercise) => exercise.notes,
  WorkoutExerciseGroupDraft(:final notes) => notes,
};

/// Unica sorgente di id del client (`docs/development/05-sync-and-offline.md`).
const _ids = UuidIdGenerator();

String _id() => _ids.newId();

const _unset = Object();
