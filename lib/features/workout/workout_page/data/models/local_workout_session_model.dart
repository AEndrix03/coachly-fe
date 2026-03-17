import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';

enum LocalWorkoutSessionSyncState {
  queued('queued'),
  uploading('uploading'),
  uploaded('uploaded'),
  patching('patching'),
  synced('synced'),
  retryWait('retry_wait'),
  failedPermanent('failed_permanent');

  const LocalWorkoutSessionSyncState(this.value);

  final String value;

  static LocalWorkoutSessionSyncState fromValue(String? value) {
    return LocalWorkoutSessionSyncState.values.firstWhere(
      (item) => item.value == value,
      orElse: () => LocalWorkoutSessionSyncState.queued,
    );
  }
}

class LocalWorkoutSessionSet {
  final int position;
  final String? setType;
  final int? reps;
  final num? load;
  final String? loadUnit;
  final bool? completed;
  final String? notes;

  const LocalWorkoutSessionSet({
    required this.position,
    required this.setType,
    required this.reps,
    required this.load,
    required this.loadUnit,
    required this.completed,
    required this.notes,
  });

  factory LocalWorkoutSessionSet.fromWritePayload(
    WorkoutSessionSetWritePayload payload,
  ) {
    return LocalWorkoutSessionSet(
      position: payload.position,
      setType: payload.setType,
      reps: payload.reps,
      load: payload.load,
      loadUnit: payload.loadUnit,
      completed: payload.completed,
      notes: payload.notes,
    );
  }

  factory LocalWorkoutSessionSet.fromJson(Map<String, dynamic> json) {
    return LocalWorkoutSessionSet(
      position: (json['position'] as num?)?.toInt() ?? 0,
      setType: json['setType'] as String?,
      reps: (json['reps'] as num?)?.toInt(),
      load: json['load'] as num?,
      loadUnit: json['loadUnit'] as String?,
      completed: json['completed'] as bool?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'setType': setType,
      'reps': reps,
      'load': load,
      'loadUnit': loadUnit,
      'completed': completed,
      'notes': notes,
    };
  }
}

class LocalWorkoutSessionEntry {
  final String exerciseId;
  final int position;
  final bool? completed;
  final String? notes;
  final List<LocalWorkoutSessionSet> sets;

  const LocalWorkoutSessionEntry({
    required this.exerciseId,
    required this.position,
    required this.completed,
    required this.notes,
    required this.sets,
  });

  factory LocalWorkoutSessionEntry.fromWritePayload(
    WorkoutSessionEntryWritePayload payload,
  ) {
    return LocalWorkoutSessionEntry(
      exerciseId: payload.exerciseId,
      position: payload.position,
      completed: payload.completed,
      notes: payload.notes,
      sets: payload.sets.map(LocalWorkoutSessionSet.fromWritePayload).toList(),
    );
  }

  factory LocalWorkoutSessionEntry.fromJson(Map<String, dynamic> json) {
    final rawSets = json['sets'] as List<dynamic>? ?? const <dynamic>[];

    return LocalWorkoutSessionEntry(
      exerciseId: json['exerciseId'] as String? ?? '',
      position: (json['position'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool?,
      notes: json['notes'] as String?,
      sets: rawSets
          .whereType<Map>()
          .map(
            (rawSet) => LocalWorkoutSessionSet.fromJson(
              rawSet.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'position': position,
      'completed': completed,
      'notes': notes,
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }
}

class LocalWorkoutSession {
  final String localSessionId;
  final String workoutId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? notes;
  final List<LocalWorkoutSessionEntry> entries;
  final LocalWorkoutSessionSyncState syncState;
  final int retryCount;
  final DateTime? nextRetryAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LocalWorkoutSession({
    required this.localSessionId,
    required this.workoutId,
    required this.startedAt,
    required this.completedAt,
    required this.notes,
    required this.entries,
    required this.syncState,
    required this.retryCount,
    required this.nextRetryAt,
    required this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocalWorkoutSession.fromWriteCommand({
    required String localSessionId,
    required String workoutId,
    required WorkoutSessionWriteCommand command,
    required DateTime now,
  }) {
    return LocalWorkoutSession(
      localSessionId: localSessionId,
      workoutId: workoutId,
      startedAt: command.startedAt,
      completedAt: command.completedAt,
      notes: command.notes,
      entries: command.entries
          .map(LocalWorkoutSessionEntry.fromWritePayload)
          .toList(),
      syncState: LocalWorkoutSessionSyncState.queued,
      retryCount: 0,
      nextRetryAt: null,
      lastError: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory LocalWorkoutSession.fromJson(Map<String, dynamic> json) {
    final rawEntries = json['entries'] as List<dynamic>? ?? const <dynamic>[];

    return LocalWorkoutSession(
      localSessionId: json['localSessionId'] as String? ?? '',
      workoutId: json['workoutId'] as String? ?? '',
      startedAt: _parseDateTime(json['startedAt'] as String?),
      completedAt: _parseDateTime(json['completedAt'] as String?),
      notes: json['notes'] as String?,
      entries: rawEntries
          .whereType<Map>()
          .map(
            (rawEntry) => LocalWorkoutSessionEntry.fromJson(
              rawEntry.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(),
      syncState: LocalWorkoutSessionSyncState.fromValue(
        json['syncState'] as String?,
      ),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      nextRetryAt: _parseDateTime(json['nextRetryAt'] as String?),
      lastError: json['lastError'] as String?,
      createdAt: _parseDateTime(json['createdAt'] as String?) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt'] as String?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localSessionId': localSessionId,
      'workoutId': workoutId,
      'startedAt': startedAt?.toUtc().toIso8601String(),
      'completedAt': completedAt?.toUtc().toIso8601String(),
      'notes': notes,
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'syncState': syncState.value,
      'retryCount': retryCount,
      'nextRetryAt': nextRetryAt?.toUtc().toIso8601String(),
      'lastError': lastError,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  LocalWorkoutSession copyWith({
    String? localSessionId,
    String? workoutId,
    DateTime? startedAt,
    DateTime? completedAt,
    String? notes,
    List<LocalWorkoutSessionEntry>? entries,
    LocalWorkoutSessionSyncState? syncState,
    int? retryCount,
    DateTime? nextRetryAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearNextRetryAt = false,
    bool clearLastError = false,
  }) {
    return LocalWorkoutSession(
      localSessionId: localSessionId ?? this.localSessionId,
      workoutId: workoutId ?? this.workoutId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      entries: entries ?? this.entries,
      syncState: syncState ?? this.syncState,
      retryCount: retryCount ?? this.retryCount,
      nextRetryAt: clearNextRetryAt ? null : (nextRetryAt ?? this.nextRetryAt),
      lastError: clearLastError ? null : (lastError ?? this.lastError),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

DateTime? _parseDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  return DateTime.tryParse(raw);
}
