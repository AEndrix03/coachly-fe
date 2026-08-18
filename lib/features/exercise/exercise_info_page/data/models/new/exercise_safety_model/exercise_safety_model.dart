import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_safety_model.freezed.dart';
part 'exercise_safety_model.g.dart';

@freezed
abstract class ExerciseSafetyModel with _$ExerciseSafetyModel {
  const factory ExerciseSafetyModel({
    required String id,
    required String overallRiskLevel,
    required bool spotterRequired,
    required Map<String, String> safetyNotesI18n,
  }) = _ExerciseSafetyModel;

  factory ExerciseSafetyModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSafetyModelFromJson(_normalizeV2Fields(json));

  /// V2 exposes `spotterPolicy` and `notesI18n`, while the UI still consumes
  /// the previous safety field names. Keep the compatibility mapping local to
  /// deserialization until the presentation model is migrated to V2.
  static Map<String, dynamic> _normalizeV2Fields(Map<String, dynamic> json) {
    return {
      ...json,
      'id': json['id'] ?? '',
      'overallRiskLevel':
          json['overallRiskLevel'] ?? json['spotterPolicy'] ?? '',
      'spotterRequired': json['spotterRequired'] ?? false,
      'safetyNotesI18n': json['safetyNotesI18n'] ?? json['notesI18n'] ?? {},
    };
  }
}
