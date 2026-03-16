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

  Map<String, dynamic> toJson({bool includeId = true}) {
    final payload = <String, dynamic>{
      'name': name,
      'translations': translations.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'status': status,
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };

    if (includeId && id != null && id!.isNotEmpty) {
      payload['id'] = id;
    }

    return payload;
  }
}

class WorkoutTranslationWritePayload {
  final String title;
  final String? description;

  const WorkoutTranslationWritePayload({
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'title': title};
    if (description != null) {
      payload['description'] = description;
    }
    return payload;
  }
}

class WorkoutBlockWritePayload {
  final String? id;
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

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'position': position,
      'entries': entries.map((entry) => entry.toJson()).toList(),
    };
    if (id != null) {
      payload['id'] = id;
    }
    if (label != null) {
      payload['label'] = label;
    }
    if (restSeconds != null) {
      payload['restSeconds'] = restSeconds;
    }
    if (notes != null) {
      payload['notes'] = notes;
    }
    return payload;
  }
}

class WorkoutEntryWritePayload {
  final String? id;
  final String exerciseId;
  final int position;
  final List<WorkoutSetWritePayload> sets;

  const WorkoutEntryWritePayload({
    required this.id,
    required this.exerciseId,
    required this.position,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'exerciseId': exerciseId,
      'position': position,
      'sets': sets.map((set) => set.toJson()).toList(),
    };
    if (id != null) {
      payload['id'] = id;
    }
    return payload;
  }
}

class WorkoutSetWritePayload {
  final String? id;
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

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'position': position,
      'setType': setType,
    };
    if (id != null) {
      payload['id'] = id;
    }
    if (reps != null) {
      payload['reps'] = reps;
    }
    if (load != null) {
      payload['load'] = load;
    }
    if (loadUnit != null) {
      payload['loadUnit'] = loadUnit;
    }
    if (restSeconds != null) {
      payload['restSeconds'] = restSeconds;
    }
    if (notes != null) {
      payload['notes'] = notes;
    }
    return payload;
  }
}
