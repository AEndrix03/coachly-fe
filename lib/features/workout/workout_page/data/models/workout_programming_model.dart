class WorkoutProgrammingBlockModel {
  final String id;
  final int position;
  final String? label;
  final String? sectionId;
  final int? sectionPosition;
  final String? sectionTitle;
  final String? sectionKind;
  final String? groupType;
  final int? rounds;
  final int? restBetweenExercisesSeconds;
  final int? restSeconds;
  final String? notes;
  final List<WorkoutProgrammingEntryModel> entries;

  const WorkoutProgrammingBlockModel({
    required this.id,
    required this.position,
    this.label,
    this.sectionId,
    this.sectionPosition,
    this.sectionTitle,
    this.sectionKind,
    this.groupType,
    this.rounds,
    this.restBetweenExercisesSeconds,
    this.restSeconds,
    this.notes,
    this.entries = const [],
  });

  factory WorkoutProgrammingBlockModel.fromJson(Map<String, dynamic> json) {
    final entries =
        _maps(
            json['entries'],
          ).map(WorkoutProgrammingEntryModel.fromJson).toList()
          ..sort((a, b) => a.position.compareTo(b.position));
    return WorkoutProgrammingBlockModel(
      id: _string(json['id']) ?? 'block_${_integer(json['position']) ?? 0}',
      position: _integer(json['position']) ?? 0,
      label: _string(json['label']),
      sectionId: _string(json['sectionId']),
      sectionPosition: _integer(json['sectionPosition']),
      sectionTitle: _string(json['sectionTitle']),
      sectionKind: _string(json['sectionKind'])?.toLowerCase(),
      groupType: _string(json['groupType'])?.toLowerCase(),
      rounds: _integer(json['rounds']),
      restBetweenExercisesSeconds: _integer(
        json['restBetweenExercisesSeconds'],
      ),
      restSeconds: _integer(json['restSeconds']),
      notes: _string(json['notes']),
      entries: entries,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'position': position,
    if (label != null) 'label': label,
    if (sectionId != null) 'sectionId': sectionId,
    if (sectionPosition != null) 'sectionPosition': sectionPosition,
    if (sectionTitle != null) 'sectionTitle': sectionTitle,
    if (sectionKind != null) 'sectionKind': sectionKind,
    if (groupType != null) 'groupType': groupType,
    if (rounds != null) 'rounds': rounds,
    if (restBetweenExercisesSeconds != null)
      'restBetweenExercisesSeconds': restBetweenExercisesSeconds,
    if (restSeconds != null) 'restSeconds': restSeconds,
    if (notes != null) 'notes': notes,
    'entries': entries.map((entry) => entry.toJson()).toList(),
  };
}

class WorkoutProgrammingEntryModel {
  final String id;
  final String exerciseId;
  final int position;
  final List<WorkoutProgrammingSetModel> sets;

  const WorkoutProgrammingEntryModel({
    required this.id,
    required this.exerciseId,
    required this.position,
    this.sets = const [],
  });

  factory WorkoutProgrammingEntryModel.fromJson(Map<String, dynamic> json) {
    final sets =
        _maps(json['sets']).map(WorkoutProgrammingSetModel.fromJson).toList()
          ..sort((a, b) => a.position.compareTo(b.position));
    return WorkoutProgrammingEntryModel(
      id: _string(json['id']) ?? 'entry_${_integer(json['position']) ?? 0}',
      exerciseId: _string(json['exerciseId']) ?? '',
      position: _integer(json['position']) ?? 0,
      sets: sets,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exerciseId': exerciseId,
    'position': position,
    'sets': sets.map((set) => set.toJson()).toList(),
  };
}

class WorkoutProgrammingSetModel {
  final String? id;
  final int position;
  final String setType;
  final int? reps;
  final int? repsMin;
  final int? repsMax;
  final String intensityType;
  final double? intensityMin;
  final double? intensityMax;
  final double? relativeLoadPercent;
  final double? load;
  final String? loadUnit;
  final int? restSeconds;
  final String? tempo;
  final int? pauseSeconds;
  final bool unilateral;
  final String? notes;

  const WorkoutProgrammingSetModel({
    this.id,
    required this.position,
    this.setType = 'normal',
    this.reps,
    this.repsMin,
    this.repsMax,
    this.intensityType = 'none',
    this.intensityMin,
    this.intensityMax,
    this.relativeLoadPercent,
    this.load,
    this.loadUnit,
    this.restSeconds,
    this.tempo,
    this.pauseSeconds,
    this.unilateral = false,
    this.notes,
  });

  factory WorkoutProgrammingSetModel.fromJson(Map<String, dynamic> json) {
    return WorkoutProgrammingSetModel(
      id: _string(json['id']),
      position: _integer(json['position']) ?? 0,
      setType: _string(json['setType'])?.toLowerCase() ?? 'normal',
      reps: _integer(json['reps']),
      repsMin: _integer(json['repsMin']),
      repsMax: _integer(json['repsMax']),
      intensityType: _string(json['intensityType'])?.toLowerCase() ?? 'none',
      intensityMin: _number(json['intensityMin']),
      intensityMax: _number(json['intensityMax']),
      relativeLoadPercent: _number(json['relativeLoadPercent']),
      load: _number(json['load']),
      loadUnit: _string(json['loadUnit'])?.toLowerCase(),
      restSeconds: _integer(json['restSeconds']),
      tempo: _string(json['tempo']),
      pauseSeconds: _integer(json['pauseSeconds']),
      unilateral: json['unilateral'] == true,
      notes: _string(json['notes']),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'position': position,
    'setType': setType,
    if (reps != null) 'reps': reps,
    if (repsMin != null) 'repsMin': repsMin,
    if (repsMax != null) 'repsMax': repsMax,
    'intensityType': intensityType,
    if (intensityMin != null) 'intensityMin': intensityMin,
    if (intensityMax != null) 'intensityMax': intensityMax,
    if (relativeLoadPercent != null) 'relativeLoadPercent': relativeLoadPercent,
    if (load != null) 'load': load,
    if (loadUnit != null) 'loadUnit': loadUnit,
    if (restSeconds != null) 'restSeconds': restSeconds,
    if (tempo != null) 'tempo': tempo,
    if (pauseSeconds != null) 'pauseSeconds': pauseSeconds,
    if (unilateral) 'unilateral': true,
    if (notes != null) 'notes': notes,
  };
}

List<WorkoutProgrammingBlockModel> workoutProgrammingBlocksFromJson(
  Object? value,
) {
  final blocks =
      _maps(value).map(WorkoutProgrammingBlockModel.fromJson).toList()
        ..sort((a, b) => a.position.compareTo(b.position));
  return blocks;
}

Object workoutProgrammingBlocksToJson(
  List<WorkoutProgrammingBlockModel> blocks,
) => blocks.map((block) => block.toJson()).toList();

Iterable<Map<String, dynamic>> _maps(Object? value) sync* {
  if (value is! List) return;
  for (final item in value) {
    if (item is Map) {
      yield item.map((key, value) => MapEntry(key.toString(), value));
    }
  }
}

String? _string(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int? _integer(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');

double? _number(Object? value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString().replaceAll(',', '.') ?? '');
