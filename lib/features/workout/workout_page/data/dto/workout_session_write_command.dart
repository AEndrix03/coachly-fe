class WorkoutSessionWriteCommand {
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? notes;
  final List<WorkoutSessionEntryWritePayload> entries;

  const WorkoutSessionWriteCommand({
    required this.startedAt,
    required this.completedAt,
    required this.notes,
    required this.entries,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'entries': entries.map((entry) => entry.toJson()).toList(),
    };

    if (startedAt != null) {
      payload['startedAt'] = startedAt!.toUtc().toIso8601String();
    }
    if (completedAt != null) {
      payload['completedAt'] = completedAt!.toUtc().toIso8601String();
    }
    if (notes != null) {
      payload['notes'] = notes;
    }

    return payload;
  }
}

class WorkoutSessionEntryWritePayload {
  final String exerciseId;
  final int position;
  final bool? completed;
  final String? notes;
  final List<WorkoutSessionSetWritePayload> sets;

  const WorkoutSessionEntryWritePayload({
    required this.exerciseId,
    required this.position,
    required this.completed,
    required this.notes,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'exerciseId': exerciseId,
      'position': position,
      'sets': sets.map((set) => set.toJson()).toList(),
    };

    if (completed != null) {
      payload['completed'] = completed;
    }
    if (notes != null) {
      payload['notes'] = notes;
    }

    return payload;
  }
}

class WorkoutSessionSetWritePayload {
  final int position;
  final String? setType;
  final int? reps;
  final num? load;
  final String? loadUnit;
  final bool? completed;
  final String? notes;

  const WorkoutSessionSetWritePayload({
    required this.position,
    required this.setType,
    required this.reps,
    required this.load,
    required this.loadUnit,
    required this.completed,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'position': position};

    if (setType != null) {
      payload['setType'] = setType;
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
    if (completed != null) {
      payload['completed'] = completed;
    }
    if (notes != null) {
      payload['notes'] = notes;
    }

    return payload;
  }
}
