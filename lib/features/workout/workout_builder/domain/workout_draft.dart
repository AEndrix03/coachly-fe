import 'package:coachly/features/workout/data/models/workout_programming_model.dart';

sealed class RepTarget {
  const RepTarget();

  const factory RepTarget.fixed(int value) = FixedRepTarget;
  const factory RepTarget.range({required int min, required int max}) =
      RangeRepTarget;

  int get min;
  int get max;
  bool get isValid => min > 0 && max >= min;
  String get compactLabel => min == max ? '$min' : '$min–$max';
}

final class FixedRepTarget extends RepTarget {
  final int value;
  const FixedRepTarget(this.value);
  @override
  int get min => value;
  @override
  int get max => value;
}

final class RangeRepTarget extends RepTarget {
  @override
  final int min;
  @override
  final int max;
  const RangeRepTarget({required this.min, required this.max});
}

enum WorkoutGroupType { superset, triset, giantSet, circuit }

enum WorkoutSectionKind {
  preparation,
  main,
  accessories,
  custom,
  cooldown,
  finisher,
}

class WorkoutExerciseDraft {
  final String localId;
  final String exerciseId;
  final String name;
  final int sets;
  final RepTarget repTarget;
  final int recoverySeconds;
  final double? targetLoad;
  final String loadUnit;
  final String? notes;

  const WorkoutExerciseDraft({
    required this.localId,
    required this.exerciseId,
    required this.name,
    this.sets = 3,
    this.repTarget = const RepTarget.fixed(10),
    this.recoverySeconds = 90,
    this.targetLoad,
    this.loadUnit = 'kg',
    this.notes,
  });

  WorkoutExerciseDraft copyWith({
    String? localId,
    String? exerciseId,
    String? name,
    int? sets,
    RepTarget? repTarget,
    int? recoverySeconds,
    Object? targetLoad = _unset,
    String? loadUnit,
    Object? notes = _unset,
  }) => WorkoutExerciseDraft(
    localId: localId ?? this.localId,
    exerciseId: exerciseId ?? this.exerciseId,
    name: name ?? this.name,
    sets: sets ?? this.sets,
    repTarget: repTarget ?? this.repTarget,
    recoverySeconds: recoverySeconds ?? this.recoverySeconds,
    targetLoad: identical(targetLoad, _unset)
        ? this.targetLoad
        : targetLoad as double?,
    loadUnit: loadUnit ?? this.loadUnit,
    notes: identical(notes, _unset) ? this.notes : notes as String?,
  );
}

sealed class WorkoutStructureItemDraft {
  String get id;
  int get exerciseCount;
  int get workingSets;
  List<WorkoutExerciseDraft> get exercises;
  const WorkoutStructureItemDraft();
}

final class WorkoutExerciseItemDraft extends WorkoutStructureItemDraft {
  final WorkoutExerciseDraft exercise;
  const WorkoutExerciseItemDraft(this.exercise);
  @override
  String get id => exercise.localId;
  @override
  int get exerciseCount => 1;
  @override
  int get workingSets => exercise.sets;
  @override
  List<WorkoutExerciseDraft> get exercises => [exercise];
}

final class WorkoutExerciseGroupDraft extends WorkoutStructureItemDraft {
  @override
  final String id;
  final WorkoutGroupType type;
  final int rounds;
  @override
  final List<WorkoutExerciseDraft> exercises;
  final int intraExerciseRestSeconds;
  final int roundRestSeconds;
  final String? notes;

  const WorkoutExerciseGroupDraft({
    required this.id,
    required this.type,
    required this.exercises,
    this.rounds = 3,
    this.intraExerciseRestSeconds = 0,
    this.roundRestSeconds = 90,
    this.notes,
  });

  @override
  int get exerciseCount => exercises.length;
  @override
  int get workingSets => exercises.fold(0, (sum, item) => sum + item.sets);

  WorkoutExerciseGroupDraft copyWith({
    WorkoutGroupType? type,
    int? rounds,
    List<WorkoutExerciseDraft>? exercises,
    int? intraExerciseRestSeconds,
    int? roundRestSeconds,
    Object? notes = _unset,
  }) => WorkoutExerciseGroupDraft(
    id: id,
    type: type ?? this.type,
    rounds: rounds ?? this.rounds,
    exercises: exercises ?? this.exercises,
    intraExerciseRestSeconds:
        intraExerciseRestSeconds ?? this.intraExerciseRestSeconds,
    roundRestSeconds: roundRestSeconds ?? this.roundRestSeconds,
    notes: identical(notes, _unset) ? this.notes : notes as String?,
  );
}

class WorkoutSectionDraft {
  final String id;
  final String? name;
  final int position;
  final List<WorkoutStructureItemDraft> items;
  final String? notes;

  WorkoutSectionKind get kind => workoutSectionKindFromName(name);

  const WorkoutSectionDraft({
    required this.id,
    this.name,
    required this.position,
    this.items = const [],
    this.notes,
  });

  WorkoutSectionDraft copyWith({
    Object? name = _unset,
    int? position,
    List<WorkoutStructureItemDraft>? items,
    Object? notes = _unset,
  }) => WorkoutSectionDraft(
    id: id,
    name: identical(name, _unset) ? this.name : name as String?,
    position: position ?? this.position,
    items: items ?? this.items,
    notes: identical(notes, _unset) ? this.notes : notes as String?,
  );
}

WorkoutSectionKind workoutSectionKindFromName(String? name) {
  final normalized = name?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return WorkoutSectionKind.main;
  if ({
    'preparation',
    'preparazione',
    'warm-up',
    'warmup',
  }.contains(normalized)) {
    return WorkoutSectionKind.preparation;
  }
  if ({'main', 'principale', 'principali'}.contains(normalized)) {
    return WorkoutSectionKind.main;
  }
  if ({'accessories', 'accessori', 'accessory'}.contains(normalized)) {
    return WorkoutSectionKind.accessories;
  }
  if ({'cooldown', 'defaticamento', 'cool down'}.contains(normalized)) {
    return WorkoutSectionKind.cooldown;
  }
  if ({'finisher'}.contains(normalized)) return WorkoutSectionKind.finisher;
  return WorkoutSectionKind.custom;
}

class WorkoutDraft {
  final String localDraftId;
  final String? sourceWorkoutId;
  final String title;
  final String? trainingGoal;
  final String? focus;
  final List<WorkoutSectionDraft> sections;

  const WorkoutDraft({
    required this.localDraftId,
    this.sourceWorkoutId,
    this.title = '',
    this.trainingGoal,
    this.focus,
    this.sections = const [],
  });

  bool get isCreate => sourceWorkoutId == null;
  Iterable<WorkoutStructureItemDraft> get items =>
      sections.expand((s) => s.items);
  Iterable<WorkoutExerciseDraft> get exercises =>
      items.expand((i) => i.exercises);
  int get exerciseCount =>
      items.fold(0, (sum, item) => sum + item.exerciseCount);
  int get workingSets => items.fold(0, (sum, item) => sum + item.workingSets);
  int get estimatedDurationMinutes {
    final workSeconds = workingSets * 45;
    final restSeconds = exercises.fold(
      0,
      (sum, item) => sum + item.sets * item.recoverySeconds,
    );
    return ((workSeconds + restSeconds) / 60).ceil();
  }

  WorkoutDraft copyWith({
    String? title,
    Object? trainingGoal = _unset,
    Object? focus = _unset,
    List<WorkoutSectionDraft>? sections,
  }) => WorkoutDraft(
    localDraftId: localDraftId,
    sourceWorkoutId: sourceWorkoutId,
    title: title ?? this.title,
    trainingGoal: identical(trainingGoal, _unset)
        ? this.trainingGoal
        : trainingGoal as String?,
    focus: identical(focus, _unset) ? this.focus : focus as String?,
    sections: sections ?? this.sections,
  );
}

class WorkoutDraftValidation {
  final List<String> errors;
  const WorkoutDraftValidation(this.errors);
  bool get isValid => errors.isEmpty;
}

abstract final class WorkoutDraftRules {
  static WorkoutDraftValidation validate(WorkoutDraft draft) {
    final errors = <String>[];
    if (draft.title.trim().isEmpty) errors.add('title');
    if (draft.exerciseCount == 0) errors.add('exercises');
    final ids = <String>{};
    for (final section in draft.sections) {
      for (final item in section.items) {
        if (!ids.add(item.id)) errors.add('duplicate_id');
        if (item is WorkoutExerciseGroupDraft && item.exercises.length < 2) {
          errors.add('group');
        }
        for (final exercise in item.exercises) {
          if (exercise.exerciseId.isEmpty ||
              exercise.sets < 1 ||
              !exercise.repTarget.isValid ||
              exercise.recoverySeconds < 0) {
            errors.add('prescription');
          }
        }
      }
    }
    return WorkoutDraftValidation(errors.toSet().toList());
  }
}

abstract final class WorkoutDraftProgrammingMapper {
  static List<WorkoutProgrammingBlockModel> toProgramming(WorkoutDraft draft) {
    var blockPosition = 0;
    return draft.sections.expand((section) {
      return section.items.map((item) {
        final group = item is WorkoutExerciseGroupDraft ? item : null;
        return WorkoutProgrammingBlockModel(
          id: item.id,
          position: blockPosition++,
          sectionId: section.name == null ? null : section.id,
          sectionPosition: section.name == null ? null : section.position,
          sectionTitle: section.name,
          sectionKind: section.name == null ? null : 'custom',
          groupType: group == null ? 'exercise' : group.type.name,
          rounds: group?.rounds,
          notes: _notesFor(section, item),
          restBetweenExercisesSeconds: group?.intraExerciseRestSeconds,
          restSeconds: group?.roundRestSeconds,
          entries: item.exercises.indexed
              .map((pair) => _entry(pair.$2, pair.$1))
              .toList(),
        );
      });
    }).toList();
  }

  static WorkoutProgrammingEntryModel _entry(
    WorkoutExerciseDraft exercise,
    int position,
  ) => WorkoutProgrammingEntryModel(
    id: exercise.localId,
    exerciseId: exercise.exerciseId,
    position: position,
    sets: List.generate(
      exercise.sets,
      (index) => WorkoutProgrammingSetModel(
        position: index,
        reps: exercise.repTarget.min == exercise.repTarget.max
            ? exercise.repTarget.min
            : null,
        repsMin: exercise.repTarget.min,
        repsMax: exercise.repTarget.max,
        restSeconds: exercise.recoverySeconds,
        load: exercise.targetLoad,
        loadUnit: exercise.targetLoad == null ? null : exercise.loadUnit,
      ),
    ),
  );

  static String? _notesFor(
    WorkoutSectionDraft section,
    WorkoutStructureItemDraft item,
  ) {
    final itemNotes = switch (item) {
      WorkoutExerciseItemDraft(:final exercise) => exercise.notes,
      WorkoutExerciseGroupDraft(:final notes) => notes,
    };
    final values = [section.notes, itemNotes]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    return values.isEmpty ? null : values.join('\n\n');
  }
}

const _unset = Object();
