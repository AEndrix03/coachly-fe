class WorkoutWriteCommand {
  final String? id;
  final String name;
  final String? description;
  final Map<String, WorkoutTranslationWritePayload> translations;
  final String status;
  final List<WorkoutBlockWritePayload> blocks;

  const WorkoutWriteCommand({
    required this.id,
    required this.name,
    required this.description,
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
      description: json['description'] as String?,
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

    if (description != null && description!.isNotEmpty) {
      payload['description'] = description;
    }

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
  final String? sectionId;
  final int? sectionPosition;
  final String? sectionTitle;
  final String? sectionKind;
  final String? groupType;
  final int? rounds;
  final int? restBetweenExercisesSeconds;
  final int? restSeconds;
  final String? notes;
  final List<WorkoutEntryWritePayload> entries;

  const WorkoutBlockWritePayload({
    required this.id,
    required this.position,
    required this.label,
    this.sectionId,
    this.sectionPosition,
    this.sectionTitle,
    this.sectionKind,
    this.groupType,
    this.rounds,
    this.restBetweenExercisesSeconds,
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
      sectionId: json['sectionId'] as String?,
      sectionPosition: (json['sectionPosition'] as num?)?.toInt(),
      sectionTitle: json['sectionTitle'] as String?,
      sectionKind: json['sectionKind'] as String?,
      groupType: json['groupType'] as String?,
      rounds: (json['rounds'] as num?)?.toInt(),
      restBetweenExercisesSeconds: (json['restBetweenExercisesSeconds'] as num?)
          ?.toInt(),
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
    if (sectionId != null) payload['sectionId'] = sectionId;
    if (sectionPosition != null) payload['sectionPosition'] = sectionPosition;
    if (sectionTitle != null) payload['sectionTitle'] = sectionTitle;
    if (sectionKind != null) payload['sectionKind'] = sectionKind;
    if (groupType != null) payload['groupType'] = groupType;
    if (rounds != null) payload['rounds'] = rounds;
    if (restBetweenExercisesSeconds != null) {
      payload['restBetweenExercisesSeconds'] = restBetweenExercisesSeconds;
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
  final int? repsMin;
  final int? repsMax;
  final String intensityType;
  final num? intensityMin;
  final num? intensityMax;
  final num? relativeLoadPercent;
  final num? load;
  final String? loadUnit;
  final int? restSeconds;
  final String? tempo;
  final int? pauseSeconds;
  final bool unilateral;
  final String? notes;

  const WorkoutSetWritePayload({
    required this.id,
    required this.position,
    required this.setType,
    required this.reps,
    this.repsMin,
    this.repsMax,
    this.intensityType = 'none',
    this.intensityMin,
    this.intensityMax,
    this.relativeLoadPercent,
    required this.load,
    required this.loadUnit,
    required this.restSeconds,
    this.tempo,
    this.pauseSeconds,
    this.unilateral = false,
    required this.notes,
  });

  factory WorkoutSetWritePayload.fromJson(Map<String, dynamic> json) {
    return WorkoutSetWritePayload(
      id: json['id'] as String?,
      position: (json['position'] as num?)?.toInt() ?? 0,
      setType: json['setType'] as String? ?? 'normal',
      reps: (json['reps'] as num?)?.toInt(),
      repsMin: (json['repsMin'] as num?)?.toInt(),
      repsMax: (json['repsMax'] as num?)?.toInt(),
      intensityType: json['intensityType'] as String? ?? 'none',
      intensityMin: json['intensityMin'] as num?,
      intensityMax: json['intensityMax'] as num?,
      relativeLoadPercent: json['relativeLoadPercent'] as num?,
      load: json['load'] as num?,
      loadUnit: json['loadUnit'] as String?,
      restSeconds: (json['restSeconds'] as num?)?.toInt(),
      tempo: json['tempo'] as String?,
      pauseSeconds: (json['pauseSeconds'] as num?)?.toInt(),
      unilateral: json['unilateral'] == true,
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
    if (repsMin != null) payload['repsMin'] = repsMin;
    if (repsMax != null) payload['repsMax'] = repsMax;
    if (intensityType != 'none') payload['intensityType'] = intensityType;
    if (intensityMin != null) payload['intensityMin'] = intensityMin;
    if (intensityMax != null) payload['intensityMax'] = intensityMax;
    if (relativeLoadPercent != null) {
      payload['relativeLoadPercent'] = relativeLoadPercent;
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
    if (tempo != null) payload['tempo'] = tempo;
    if (pauseSeconds != null) payload['pauseSeconds'] = pauseSeconds;
    if (unilateral) payload['unilateral'] = true;
    if (notes != null) {
      payload['notes'] = notes;
    }
    return payload;
  }
}
