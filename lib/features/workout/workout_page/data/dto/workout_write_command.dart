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

  factory WorkoutWriteCommand.fromJson(Map<String, dynamic> json) {
    final rawTranslations =
        json['translations'] as Map<String, dynamic>? ?? const {};
    final translations = rawTranslations.map((key, value) {
      final translationMap = value is Map
          ? value.map((k, v) => MapEntry(k.toString(), v))
          : const <String, dynamic>{};
      return MapEntry(
        key,
        WorkoutTranslationWritePayload.fromJson(translationMap),
      );
    });

    final rawBlocks = json['blocks'] as List<dynamic>? ?? const [];
    final blocks = rawBlocks
        .whereType<Map>()
        .map(
          (rawBlock) => WorkoutBlockWritePayload.fromJson(
            rawBlock.map((key, value) => MapEntry(key.toString(), value)),
          ),
        )
        .toList();

    return WorkoutWriteCommand(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      translations: translations,
      status: json['status'] as String? ?? 'active',
      blocks: blocks,
    );
  }

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

  factory WorkoutTranslationWritePayload.fromJson(Map<String, dynamic> json) {
    return WorkoutTranslationWritePayload(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

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

  factory WorkoutBlockWritePayload.fromJson(Map<String, dynamic> json) {
    final rawEntries = json['entries'] as List<dynamic>? ?? const [];
    return WorkoutBlockWritePayload(
      id: json['id'] as String?,
      position: (json['position'] as num?)?.toInt() ?? 0,
      label: json['label'] as String?,
      restSeconds: (json['restSeconds'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      entries: rawEntries
          .whereType<Map>()
          .map(
            (rawEntry) => WorkoutEntryWritePayload.fromJson(
              rawEntry.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(),
    );
  }

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

  factory WorkoutEntryWritePayload.fromJson(Map<String, dynamic> json) {
    final rawSets = json['sets'] as List<dynamic>? ?? const [];
    return WorkoutEntryWritePayload(
      id: json['id'] as String?,
      exerciseId: json['exerciseId'] as String? ?? '',
      position: (json['position'] as num?)?.toInt() ?? 0,
      sets: rawSets
          .whereType<Map>()
          .map(
            (rawSet) => WorkoutSetWritePayload.fromJson(
              rawSet.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(),
    );
  }

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

  factory WorkoutSetWritePayload.fromJson(Map<String, dynamic> json) {
    return WorkoutSetWritePayload(
      id: json['id'] as String?,
      position: (json['position'] as num?)?.toInt() ?? 0,
      setType: json['setType'] as String? ?? 'normal',
      reps: (json['reps'] as num?)?.toInt(),
      load: json['load'] as num?,
      loadUnit: json['loadUnit'] as String?,
      restSeconds: (json['restSeconds'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'position': position, 'setType': setType};
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
