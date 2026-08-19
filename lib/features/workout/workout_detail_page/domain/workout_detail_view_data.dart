import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_programming_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/widgets.dart';

enum WorkoutSectionKind { standard, preparation, main, accessory, custom }

enum WorkoutGroupType { superset, circuit }

enum PrescriptionBlockType {
  standard,
  warmup,
  topSet,
  backoff,
  amrap,
  dropSet,
  failure,
  unilateral,
}

enum IntensityTargetType { none, rir, rpe, percentage1RM }

enum WorkoutConcept {
  rir,
  rpe,
  percentage1RM,
  superset,
  circuit,
  topSet,
  backoff,
  amrap,
}

class IntensityTarget {
  final IntensityTargetType type;
  final double? min;
  final double? max;

  const IntensityTarget.none()
    : type = IntensityTargetType.none,
      min = null,
      max = null;

  const IntensityTarget({required this.type, this.min, this.max});

  String? format() {
    if (type == IntensityTargetType.none || min == null) return null;
    final prefix = switch (type) {
      IntensityTargetType.rir => 'RIR',
      IntensityTargetType.rpe => 'RPE',
      IntensityTargetType.percentage1RM => '',
      IntensityTargetType.none => '',
    };
    final value = max != null && max != min
        ? '${_number(min!)}–${_number(max!)}'
        : _number(min!);
    return type == IntensityTargetType.percentage1RM
        ? '$value% 1RM'
        : '$prefix $value';
  }
}

class PrescriptionBlockViewData {
  final PrescriptionBlockType type;
  final int sets;
  final int? repsMin;
  final int? repsMax;
  final IntensityTarget intensity;
  final int? restSeconds;
  final double? targetLoad;
  final String? loadUnit;
  final double? relativeLoadPercent;
  final String? tempo;
  final int? pauseSeconds;

  const PrescriptionBlockViewData({
    required this.type,
    required this.sets,
    this.repsMin,
    this.repsMax,
    this.intensity = const IntensityTarget.none(),
    this.restSeconds,
    this.targetLoad,
    this.loadUnit,
    this.relativeLoadPercent,
    this.tempo,
    this.pauseSeconds,
  });

  bool get isWorking => type != PrescriptionBlockType.warmup;

  String get targetLabel {
    if (type == PrescriptionBlockType.warmup && repsMin == null) {
      return '$sets sets';
    }
    final reps = repsMin == null
        ? (type == PrescriptionBlockType.amrap ? 'AMRAP' : '—')
        : repsMax != null && repsMax != repsMin
        ? '$repsMin–$repsMax'
        : '$repsMin';
    return '$sets × $reps';
  }
}

class ExercisePrescriptionViewData {
  final List<PrescriptionBlockViewData> blocks;
  final String? note;

  const ExercisePrescriptionViewData({this.blocks = const [], this.note});

  int get workingSets => blocks
      .where((block) => block.isWorking)
      .fold(0, (total, block) => total + block.sets);

  String get compactTarget => blocks.isEmpty
      ? '—'
      : blocks.map((block) => block.targetLabel).join(' · ');

  String? get compactIntensity => blocks
      .map((block) => block.intensity.format())
      .whereType<String>()
      .firstOrNull;

  int? get primaryRestSeconds =>
      blocks.map((block) => block.restSeconds).whereType<int>().firstOrNull;
}

sealed class WorkoutBlockViewData {
  String get id;
  int get exerciseCount;
  int get workingSets;
}

class WorkoutExerciseBlockViewData extends WorkoutBlockViewData {
  final WorkoutExerciseViewData exercise;

  WorkoutExerciseBlockViewData(this.exercise);

  @override
  String get id => exercise.instanceId;
  @override
  int get exerciseCount => 1;
  @override
  int get workingSets => exercise.prescription.workingSets;
}

class WorkoutGroupBlockViewData extends WorkoutBlockViewData {
  @override
  final String id;
  final WorkoutGroupType type;
  final String? label;
  final int rounds;
  final int? restBetweenExercisesSeconds;
  final int? restAfterRoundSeconds;
  final List<WorkoutExerciseViewData> exercises;

  WorkoutGroupBlockViewData({
    required this.id,
    required this.type,
    this.label,
    required this.rounds,
    this.restBetweenExercisesSeconds,
    this.restAfterRoundSeconds,
    required this.exercises,
  });

  @override
  int get exerciseCount => exercises.length;
  @override
  int get workingSets => exercises.fold(
    0,
    (total, exercise) => total + exercise.prescription.workingSets,
  );
}

class WorkoutExerciseViewData {
  final String instanceId;
  final String exerciseId;
  final String name;
  final String? metadata;
  final ExercisePrescriptionViewData prescription;
  final bool isMissing;
  final bool isNameLoading;

  const WorkoutExerciseViewData({
    required this.instanceId,
    required this.exerciseId,
    required this.name,
    this.metadata,
    required this.prescription,
    this.isMissing = false,
    this.isNameLoading = false,
  });
}

class WorkoutSectionViewData {
  final String id;
  final String? title;
  final WorkoutSectionKind kind;
  final int position;
  final List<WorkoutBlockViewData> blocks;

  const WorkoutSectionViewData({
    required this.id,
    this.title,
    required this.kind,
    required this.position,
    required this.blocks,
  });

  int get exerciseCount =>
      blocks.fold(0, (total, block) => total + block.exerciseCount);
}

class WorkoutDetailViewData {
  final String id;
  final String title;
  final String? goal;
  final String? focus;
  final List<WorkoutSectionViewData> sections;
  final Duration? estimatedDuration;
  final bool syncPending;

  const WorkoutDetailViewData({
    required this.id,
    required this.title,
    this.goal,
    this.focus,
    required this.sections,
    this.estimatedDuration,
    this.syncPending = false,
  });

  int get exerciseCount =>
      sections.fold(0, (total, section) => total + section.exerciseCount);

  int get workingSets => sections
      .expand((section) => section.blocks)
      .fold(0, (total, block) => total + block.workingSets);
}

class WorkoutDetailAdapter {
  const WorkoutDetailAdapter._();

  static WorkoutDetailViewData fromWorkout(
    WorkoutModel workout,
    Locale locale, [
    Map<String, String>? resolvedExerciseNames,
    Set<String> resolvingExerciseIds = const {},
  ]) {
    final exerciseNames = resolvedExerciseNames ?? const <String, String>{};
    final lookup = _ExerciseLookup(workout.workoutExercises);
    final sections = workout.programmingBlocks.isEmpty
        ? _legacySections(workout, locale, exerciseNames, resolvingExerciseIds)
        : _structuredSections(
            workout.programmingBlocks,
            lookup,
            locale,
            exerciseNames,
            resolvingExerciseIds,
          );
    final withoutDuration = WorkoutDetailViewData(
      id: workout.id,
      title: workout.titleI18n?.fromI18n(locale) ?? workout.id,
      goal: _nonBlank(workout.descriptionI18n?.fromI18n(locale)),
      focus: _nonBlank(workout.type),
      sections: sections,
      syncPending: workout.dirty,
    );
    return WorkoutDetailViewData(
      id: withoutDuration.id,
      title: withoutDuration.title,
      goal: withoutDuration.goal,
      focus: withoutDuration.focus,
      sections: sections,
      estimatedDuration: WorkoutDurationEstimator.estimate(withoutDuration),
      syncPending: withoutDuration.syncPending,
    );
  }

  /// IDs whose locally available label is absent or just the opaque UUID.
  /// Their display names are resolved by the detail page from the exercise
  /// catalogue before rendering the workout.
  static Set<String> unresolvedExerciseIds(
    WorkoutModel workout,
    Locale locale,
  ) {
    final ids = <String>{};
    for (final exercise in workout.workoutExercises) {
      final id = exercise.exercise.id?.trim();
      if (id == null || id.isEmpty) continue;
      if (_isUnresolvedExerciseName(
        _exerciseName(exercise.exercise, locale),
        id,
      )) {
        ids.add(id);
      }
    }
    for (final block in workout.programmingBlocks) {
      for (final entry in block.entries) {
        if (entry.exerciseId.isNotEmpty &&
            !workout.workoutExercises.any(
              (exercise) => exercise.exercise.id == entry.exerciseId,
            )) {
          ids.add(entry.exerciseId);
        }
      }
    }
    return ids;
  }

  static List<WorkoutSectionViewData> _legacySections(
    WorkoutModel workout,
    Locale locale,
    Map<String, String> resolvedExerciseNames,
    Set<String> resolvingExerciseIds,
  ) {
    final blocks = workout.workoutExercises.map((exercise) {
      return WorkoutExerciseBlockViewData(
        _legacyExercise(
          exercise,
          locale,
          resolvedExerciseNames,
          resolvingExerciseIds,
        ),
      );
    }).toList();
    return [
      WorkoutSectionViewData(
        id: '${workout.id}_implicit',
        kind: WorkoutSectionKind.standard,
        position: 0,
        blocks: blocks,
      ),
    ];
  }

  static List<WorkoutSectionViewData> _structuredSections(
    List<WorkoutProgrammingBlockModel> models,
    _ExerciseLookup lookup,
    Locale locale,
    Map<String, String> resolvedExerciseNames,
    Set<String> resolvingExerciseIds,
  ) {
    final sections = <String, _MutableSection>{};
    for (final model in models) {
      final sectionKey = model.sectionId ?? '__implicit__';
      final section = sections.putIfAbsent(
        sectionKey,
        () => _MutableSection(
          id: sectionKey,
          title: model.sectionId == null ? null : model.sectionTitle,
          kind: _sectionKind(model.sectionKind),
          position: model.sectionPosition ?? 0,
        ),
      );
      final exercises = model.entries
          .map(
            (entry) => _structuredExercise(
              entry,
              model,
              lookup,
              locale,
              resolvedExerciseNames,
              resolvingExerciseIds,
            ),
          )
          .toList();
      final groupType = _groupType(model.groupType);
      if (groupType != null && exercises.length >= 2) {
        section.blocks.add(
          WorkoutGroupBlockViewData(
            id: model.id,
            type: groupType,
            label: model.label,
            rounds: model.rounds ?? _inferRounds(exercises),
            restBetweenExercisesSeconds: model.restBetweenExercisesSeconds,
            restAfterRoundSeconds: model.restSeconds,
            exercises: exercises,
          ),
        );
      } else {
        // A null type is a legacy flat block, not an implicit superset.
        section.blocks.addAll(exercises.map(WorkoutExerciseBlockViewData.new));
      }
    }
    final result = sections.values.map((section) => section.freeze()).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    return result;
  }

  static WorkoutExerciseViewData _legacyExercise(
    WorkoutExerciseModel model,
    Locale locale,
    Map<String, String> resolvedExerciseNames,
    Set<String> resolvingExerciseIds,
  ) {
    final values = RegExp(
      r'\d+',
    ).allMatches(model.sets).map((m) => int.parse(m[0]!)).toList();
    final rest = _seconds(model.rest);
    final load = double.tryParse(
      RegExp(
            r'\d+(?:[.,]\d+)?',
          ).firstMatch(model.weight)?.group(0)?.replaceAll(',', '.') ??
          '',
    );
    return WorkoutExerciseViewData(
      instanceId: model.id,
      exerciseId: model.exercise.id ?? model.id,
      name: _displayExerciseName(
        _exerciseName(model.exercise, locale),
        model.exercise.id,
        resolvedExerciseNames,
      ),
      metadata: _exerciseMetadata(model.exercise, locale),
      isMissing: model.exercise.id == null,
      isNameLoading:
          model.exercise.id != null &&
          resolvingExerciseIds.contains(model.exercise.id),
      prescription: ExercisePrescriptionViewData(
        blocks: [
          PrescriptionBlockViewData(
            type: PrescriptionBlockType.standard,
            sets: values.firstOrNull ?? 1,
            repsMin: values.length > 1 ? values[1] : null,
            repsMax: values.length > 2 ? values[2] : null,
            restSeconds: rest,
            targetLoad: load,
            loadUnit: load == null ? null : 'kg',
          ),
        ],
      ),
    );
  }

  static WorkoutExerciseViewData _structuredExercise(
    WorkoutProgrammingEntryModel entry,
    WorkoutProgrammingBlockModel block,
    _ExerciseLookup lookup,
    Locale locale,
    Map<String, String> resolvedExerciseNames,
    Set<String> resolvingExerciseIds,
  ) {
    final exercise =
        lookup.byEntryId[entry.id] ?? lookup.byExerciseId[entry.exerciseId];
    return WorkoutExerciseViewData(
      instanceId: entry.id,
      exerciseId: entry.exerciseId,
      name: _displayExerciseName(
        exercise == null
            ? (entry.exerciseId.isEmpty ? 'Exercise' : entry.exerciseId)
            : _exerciseName(exercise, locale),
        entry.exerciseId,
        resolvedExerciseNames,
      ),
      metadata: exercise == null ? null : _exerciseMetadata(exercise, locale),
      isMissing: entry.exerciseId.isEmpty,
      isNameLoading: resolvingExerciseIds.contains(entry.exerciseId),
      prescription: _prescription(entry.sets, block),
    );
  }

  static ExercisePrescriptionViewData _prescription(
    List<WorkoutProgrammingSetModel> sets,
    WorkoutProgrammingBlockModel parent,
  ) {
    if (sets.isEmpty) return const ExercisePrescriptionViewData();
    final groups = <String, List<WorkoutProgrammingSetModel>>{};
    for (final set in sets) {
      final key = [
        set.setType,
        set.repsMin ?? set.reps,
        set.repsMax ?? set.reps,
        set.intensityType,
        set.intensityMin,
        set.intensityMax,
        set.restSeconds ?? parent.restSeconds,
      ].join('|');
      groups.putIfAbsent(key, () => []).add(set);
    }
    final blocks = groups.values.map((group) {
      final set = group.first;
      return PrescriptionBlockViewData(
        type: _blockType(set),
        sets: group.length,
        repsMin: set.repsMin ?? set.reps,
        repsMax: set.repsMax ?? set.reps,
        intensity: _intensity(set),
        restSeconds: set.restSeconds ?? parent.restSeconds,
        targetLoad: set.load,
        loadUnit: set.loadUnit,
        relativeLoadPercent: set.relativeLoadPercent,
        tempo: set.tempo,
        pauseSeconds: set.pauseSeconds,
      );
    }).toList();
    return ExercisePrescriptionViewData(
      blocks: blocks,
      note: _nonBlank(
        sets.map((set) => set.notes).whereType<String>().firstOrNull ??
            parent.notes,
      ),
    );
  }
}

class WorkoutDurationEstimator {
  static const int standardSetExecutionSeconds = 38;
  static const int exerciseTransitionSeconds = 50;

  const WorkoutDurationEstimator._();

  static Duration? estimate(WorkoutDetailViewData workout) {
    if (workout.exerciseCount == 0) return null;
    var seconds = 0;
    for (final section in workout.sections) {
      for (final block in section.blocks) {
        if (block is WorkoutExerciseBlockViewData) {
          seconds += _exerciseSeconds(block.exercise);
        } else if (block is WorkoutGroupBlockViewData) {
          for (final exercise in block.exercises) {
            seconds += _exerciseSeconds(exercise, includeTransition: false);
          }
          seconds += block.rounds * (block.restAfterRoundSeconds ?? 0);
          seconds +=
              block.rounds *
              (block.exercises.length - 1) *
              (block.restBetweenExercisesSeconds ?? 0);
          seconds += exerciseTransitionSeconds;
        }
      }
    }
    return Duration(seconds: seconds);
  }

  static int _exerciseSeconds(
    WorkoutExerciseViewData exercise, {
    bool includeTransition = true,
  }) {
    var total = includeTransition ? exerciseTransitionSeconds : 0;
    for (final block in exercise.prescription.blocks) {
      total += block.sets * standardSetExecutionSeconds;
      total += (block.sets - 1).clamp(0, block.sets) * (block.restSeconds ?? 0);
    }
    return total;
  }
}

class WorkoutConceptDetector {
  const WorkoutConceptDetector._();

  static Set<WorkoutConcept> detect(WorkoutDetailViewData workout) {
    final result = <WorkoutConcept>{};
    for (final block in workout.sections.expand((section) => section.blocks)) {
      final exercises = switch (block) {
        WorkoutExerciseBlockViewData() => [block.exercise],
        WorkoutGroupBlockViewData() => block.exercises,
      };
      if (block is WorkoutGroupBlockViewData) {
        result.add(
          block.type == WorkoutGroupType.superset
              ? WorkoutConcept.superset
              : WorkoutConcept.circuit,
        );
      }
      for (final prescription in exercises.expand(
        (exercise) => exercise.prescription.blocks,
      )) {
        switch (prescription.intensity.type) {
          case IntensityTargetType.rir:
            result.add(WorkoutConcept.rir);
          case IntensityTargetType.rpe:
            result.add(WorkoutConcept.rpe);
          case IntensityTargetType.percentage1RM:
            result.add(WorkoutConcept.percentage1RM);
          case IntensityTargetType.none:
            break;
        }
        switch (prescription.type) {
          case PrescriptionBlockType.topSet:
            result.add(WorkoutConcept.topSet);
          case PrescriptionBlockType.backoff:
            result.add(WorkoutConcept.backoff);
          case PrescriptionBlockType.amrap:
            result.add(WorkoutConcept.amrap);
          default:
            break;
        }
      }
    }
    return result;
  }
}

class _MutableSection {
  final String id;
  final String? title;
  final WorkoutSectionKind kind;
  final int position;
  final List<WorkoutBlockViewData> blocks = [];

  _MutableSection({
    required this.id,
    this.title,
    required this.kind,
    required this.position,
  });

  WorkoutSectionViewData freeze() => WorkoutSectionViewData(
    id: id,
    title: title,
    kind: kind,
    position: position,
    blocks: List.unmodifiable(blocks),
  );
}

class _ExerciseLookup {
  final Map<String, ExerciseDetailModel> byEntryId;
  final Map<String, ExerciseDetailModel> byExerciseId;

  _ExerciseLookup(List<WorkoutExerciseModel> exercises)
    : byEntryId = {for (final item in exercises) item.id: item.exercise},
      byExerciseId = {
        for (final item in exercises)
          if (item.exercise.id != null) item.exercise.id!: item.exercise,
      };
}

WorkoutSectionKind _sectionKind(String? value) => switch (value) {
  'preparation' => WorkoutSectionKind.preparation,
  'main' => WorkoutSectionKind.main,
  'accessory' => WorkoutSectionKind.accessory,
  'custom' => WorkoutSectionKind.custom,
  _ => WorkoutSectionKind.standard,
};

WorkoutGroupType? _groupType(String? value) => switch (value) {
  'superset' => WorkoutGroupType.superset,
  'circuit' => WorkoutGroupType.circuit,
  _ => null,
};

PrescriptionBlockType _blockType(WorkoutProgrammingSetModel set) {
  if (set.unilateral) return PrescriptionBlockType.unilateral;
  return switch (set.setType) {
    'warmup' || 'approach' => PrescriptionBlockType.warmup,
    'top_set' => PrescriptionBlockType.topSet,
    'backoff' => PrescriptionBlockType.backoff,
    'amrap' => PrescriptionBlockType.amrap,
    'dropset' => PrescriptionBlockType.dropSet,
    'failure' => PrescriptionBlockType.failure,
    _ => PrescriptionBlockType.standard,
  };
}

IntensityTarget _intensity(WorkoutProgrammingSetModel set) {
  final type = switch (set.intensityType) {
    'rir' => IntensityTargetType.rir,
    'rpe' => IntensityTargetType.rpe,
    'percentage_1rm' => IntensityTargetType.percentage1RM,
    _ => IntensityTargetType.none,
  };
  return type == IntensityTargetType.none
      ? const IntensityTarget.none()
      : IntensityTarget(
          type: type,
          min: set.intensityMin,
          max: set.intensityMax,
        );
}

int _inferRounds(List<WorkoutExerciseViewData> exercises) => exercises
    .map(
      (exercise) => exercise.prescription.blocks.fold(
        0,
        (sum, block) => sum + block.sets,
      ),
    )
    .fold<int>(0, (max, value) => value > max ? value : max)
    .clamp(1, 99);

String _exerciseName(ExerciseDetailModel exercise, Locale locale) =>
    exercise.nameI18n?.fromI18n(locale) ?? 'Exercise';

String _displayExerciseName(
  String localName,
  String? exerciseId,
  Map<String, String> resolvedExerciseNames,
) {
  final resolvedName = exerciseId == null
      ? null
      : resolvedExerciseNames[exerciseId];
  if (resolvedName != null &&
      resolvedName.trim().isNotEmpty &&
      _isUnresolvedExerciseName(localName, exerciseId)) {
    return resolvedName;
  }
  if (_isUnresolvedExerciseName(localName, exerciseId)) return 'Exercise';
  return localName;
}

bool _isUnresolvedExerciseName(String name, String? exerciseId) {
  final normalizedName = name.trim();
  return normalizedName.isEmpty ||
      normalizedName == 'Exercise' ||
      (exerciseId != null && normalizedName == exerciseId);
}

String? _exerciseMetadata(ExerciseDetailModel exercise, Locale locale) {
  final equipment = exercise.equipments?.firstOrNull?.equipment.nameI18n
      .fromI18n(locale);
  final muscles = exercise.muscles
      ?.take(2)
      .map((muscle) => muscle.muscle?.nameI18n.fromI18n(locale))
      .whereType<String>()
      .join(' · ');
  return _nonBlank([muscles, equipment].whereType<String>().join(' · '));
}

int? _seconds(String raw) {
  final values = RegExp(
    r'\d+',
  ).allMatches(raw).map((m) => int.parse(m[0]!)).toList();
  if (values.isEmpty) return null;
  if (raw.contains(':') && values.length > 1) return values[0] * 60 + values[1];
  return values.first;
}

String? _nonBlank(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

String _number(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);
