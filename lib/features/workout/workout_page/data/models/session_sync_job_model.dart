enum SessionSyncJobStatus {
  queued('queued'),
  uploading('uploading'),
  uploaded('uploaded'),
  patching('patching'),
  synced('synced'),
  retryWait('retry_wait'),
  failedPermanent('failed_permanent');

  const SessionSyncJobStatus(this.value);

  final String value;

  bool get isTerminal =>
      this == SessionSyncJobStatus.synced ||
      this == SessionSyncJobStatus.failedPermanent;

  static SessionSyncJobStatus fromValue(String? value) {
    return SessionSyncJobStatus.values.firstWhere(
      (item) => item.value == value,
      orElse: () => SessionSyncJobStatus.queued,
    );
  }
}

class SessionSyncJob {
  final String jobId;
  final String localSessionId;
  final String workoutId;
  final String sessionPayloadJson;
  final String mergedWorkoutCommandJson;
  final SessionSyncJobStatus status;
  final int retryCount;
  final DateTime? nextRetryAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionSyncJob({
    required this.jobId,
    required this.localSessionId,
    required this.workoutId,
    required this.sessionPayloadJson,
    required this.mergedWorkoutCommandJson,
    required this.status,
    required this.retryCount,
    required this.nextRetryAt,
    required this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionSyncJob.fromJson(Map<String, dynamic> json) {
    return SessionSyncJob(
      jobId: json['jobId'] as String? ?? '',
      localSessionId: json['localSessionId'] as String? ?? '',
      workoutId: json['workoutId'] as String? ?? '',
      sessionPayloadJson: json['sessionPayloadJson'] as String? ?? '{}',
      mergedWorkoutCommandJson:
          json['mergedWorkoutCommandJson'] as String? ?? '{}',
      status: SessionSyncJobStatus.fromValue(json['status'] as String?),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      nextRetryAt: _parseDateTime(json['nextRetryAt'] as String?),
      lastError: json['lastError'] as String?,
      createdAt: _parseDateTime(json['createdAt'] as String?) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt'] as String?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'localSessionId': localSessionId,
      'workoutId': workoutId,
      'sessionPayloadJson': sessionPayloadJson,
      'mergedWorkoutCommandJson': mergedWorkoutCommandJson,
      'status': status.value,
      'retryCount': retryCount,
      'nextRetryAt': nextRetryAt?.toUtc().toIso8601String(),
      'lastError': lastError,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  SessionSyncJob copyWith({
    String? jobId,
    String? localSessionId,
    String? workoutId,
    String? sessionPayloadJson,
    String? mergedWorkoutCommandJson,
    SessionSyncJobStatus? status,
    int? retryCount,
    DateTime? nextRetryAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearNextRetryAt = false,
    bool clearLastError = false,
  }) {
    return SessionSyncJob(
      jobId: jobId ?? this.jobId,
      localSessionId: localSessionId ?? this.localSessionId,
      workoutId: workoutId ?? this.workoutId,
      sessionPayloadJson: sessionPayloadJson ?? this.sessionPayloadJson,
      mergedWorkoutCommandJson:
          mergedWorkoutCommandJson ?? this.mergedWorkoutCommandJson,
      status: status ?? this.status,
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
