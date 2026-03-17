class StructuredWorkoutSnapshot {
  final String workoutId;
  final String workoutWriteCommandJson;
  final DateTime? sourceUpdatedAt;
  final DateTime updatedAt;

  const StructuredWorkoutSnapshot({
    required this.workoutId,
    required this.workoutWriteCommandJson,
    required this.sourceUpdatedAt,
    required this.updatedAt,
  });

  factory StructuredWorkoutSnapshot.fromJson(Map<String, dynamic> json) {
    return StructuredWorkoutSnapshot(
      workoutId: json['workoutId'] as String? ?? '',
      workoutWriteCommandJson:
          json['workoutWriteCommandJson'] as String? ?? '{}',
      sourceUpdatedAt: _parseDateTime(json['sourceUpdatedAt'] as String?),
      updatedAt: _parseDateTime(json['updatedAt'] as String?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutId': workoutId,
      'workoutWriteCommandJson': workoutWriteCommandJson,
      'sourceUpdatedAt': sourceUpdatedAt?.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  StructuredWorkoutSnapshot copyWith({
    String? workoutId,
    String? workoutWriteCommandJson,
    DateTime? sourceUpdatedAt,
    DateTime? updatedAt,
  }) {
    return StructuredWorkoutSnapshot(
      workoutId: workoutId ?? this.workoutId,
      workoutWriteCommandJson:
          workoutWriteCommandJson ?? this.workoutWriteCommandJson,
      sourceUpdatedAt: sourceUpdatedAt ?? this.sourceUpdatedAt,
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
