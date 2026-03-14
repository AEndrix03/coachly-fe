class WorkoutWriteCommand {
  final String? id;
  final String name;
  final Map<String, WorkoutTranslationWritePayload> translations;
  final String status;
  final List<WorkoutBlockWritePayload> blocks;

  const WorkoutWriteCommand({
    required this.id,
    required this.name,
    required this.translations,
    required this.status,
    required this.blocks,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'translations': translations.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'status': status,
    'blocks': blocks.map((block) => block.toJson()).toList(),
  };
}

class WorkoutTranslationWritePayload {
  final String name;
  final String? description;

  const WorkoutTranslationWritePayload({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => {'name': name, 'description': description};
}

class WorkoutBlockWritePayload {
  final String id;
  final int position;
  final String? label;
  final int? restSeconds;
  final String? notes;
  final List<WorkoutEntryWritePayload> entries;

  const WorkoutBlockWritePayload({
    required this.id,
    required this.position,
    required this.label,
    required this.restSeconds,
    required this.notes,
    required this.entries,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'position': position,
    'label': label,
    'restSeconds': restSeconds,
    'notes': notes,
    'entries': entries.map((entry) => entry.toJson()).toList(),
  };
}

class WorkoutEntryWritePayload {
  final String id;
  final String exerciseId;
  final int position;
  final List<WorkoutSetWritePayload> sets;

  const WorkoutEntryWritePayload({
    required this.id,
    required this.exerciseId,
    required this.position,
    required this.sets,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'exerciseId': exerciseId,
    'position': position,
    'sets': sets.map((set) => set.toJson()).toList(),
  };
}

class WorkoutSetWritePayload {
  final String id;
  final int position;
  final String setType;
  final int? reps;
  final num? load;
  final String? loadUnit;
  final int? restSeconds;
  final String? notes;

  const WorkoutSetWritePayload({
    required this.id,
    required this.position,
    required this.setType,
    required this.reps,
    required this.load,
    required this.loadUnit,
    required this.restSeconds,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'position': position,
    'setType': setType,
    'reps': reps,
    'load': load,
    'loadUnit': loadUnit,
    'restSeconds': restSeconds,
    'notes': notes,
  };
}
