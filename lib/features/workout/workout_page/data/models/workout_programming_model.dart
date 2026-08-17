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

  WorkoutProgrammingBlockModel copyWith({
    String? id,
    int? position,
    Object? label = _unset,
    Object? sectionId = _unset,
    Object? sectionPosition = _unset,
    Object? sectionTitle = _unset,
    Object? sectionKind = _unset,
    Object? groupType = _unset,
    Object? rounds = _unset,
    Object? restBetweenExercisesSeconds = _unset,
    Object? restSeconds = _unset,
    Object? notes = _unset,
    List<WorkoutProgrammingEntryModel>? entries,
  }) => WorkoutProgrammingBlockModel(
    id: id ?? this.id,
    position: position ?? this.position,
    label: identical(label, _unset) ? this.label : label as String?,
    sectionId: identical(sectionId, _unset)
        ? this.sectionId
        : sectionId as String?,
    sectionPosition: identical(sectionPosition, _unset)
        ? this.sectionPosition
        : sectionPosition as int?,
    sectionTitle: identical(sectionTitle, _unset)
        ? this.sectionTitle
        : sectionTitle as String?,
    sectionKind: identical(sectionKind, _unset)
        ? this.sectionKind
        : sectionKind as String?,
    groupType: identical(groupType, _unset)
        ? this.groupType
        : groupType as String?,
    rounds: identical(rounds, _unset) ? this.rounds : rounds as int?,
    restBetweenExercisesSeconds: identical(restBetweenExercisesSeconds, _unset)
        ? this.restBetweenExercisesSeconds
        : restBetweenExercisesSeconds as int?,
    restSeconds: identical(restSeconds, _unset)
        ? this.restSeconds
        : restSeconds as int?,
    notes: identical(notes, _unset) ? this.notes : notes as String?,
    entries: entries ?? this.entries,
  );
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

  WorkoutProgrammingEntryModel copyWith({
    String? id,
    String? exerciseId,
    int? position,
    List<WorkoutProgrammingSetModel>? sets,
  }) => WorkoutProgrammingEntryModel(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    position: position ?? this.position,
    sets: sets ?? this.sets,
  );
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

  WorkoutProgrammingSetModel copyWith({
    Object? id = _unset,
    int? position,
    String? setType,
    Object? reps = _unset,
    Object? repsMin = _unset,
    Object? repsMax = _unset,
    String? intensityType,
    Object? intensityMin = _unset,
    Object? intensityMax = _unset,
    Object? relativeLoadPercent = _unset,
    Object? load = _unset,
    Object? loadUnit = _unset,
    Object? restSeconds = _unset,
    Object? tempo = _unset,
    Object? pauseSeconds = _unset,
    bool? unilateral,
    Object? notes = _unset,
  }) => WorkoutProgrammingSetModel(
    id: identical(id, _unset) ? this.id : id as String?,
    position: position ?? this.position,
    setType: setType ?? this.setType,
    reps: identical(reps, _unset) ? this.reps : reps as int?,
    repsMin: identical(repsMin, _unset) ? this.repsMin : repsMin as int?,
    repsMax: identical(repsMax, _unset) ? this.repsMax : repsMax as int?,
    intensityType: intensityType ?? this.intensityType,
    intensityMin: identical(intensityMin, _unset)
        ? this.intensityMin
        : intensityMin as double?,
    intensityMax: identical(intensityMax, _unset)
        ? this.intensityMax
        : intensityMax as double?,
    relativeLoadPercent: identical(relativeLoadPercent, _unset)
        ? this.relativeLoadPercent
        : relativeLoadPercent as double?,
    load: identical(load, _unset) ? this.load : load as double?,
    loadUnit: identical(loadUnit, _unset) ? this.loadUnit : loadUnit as String?,
    restSeconds: identical(restSeconds, _unset)
        ? this.restSeconds
        : restSeconds as int?,
    tempo: identical(tempo, _unset) ? this.tempo : tempo as String?,
    pauseSeconds: identical(pauseSeconds, _unset)
        ? this.pauseSeconds
        : pauseSeconds as int?,
    unilateral: unilateral ?? this.unilateral,
    notes: identical(notes, _unset) ? this.notes : notes as String?,
  );
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

const Object _unset = Object();
