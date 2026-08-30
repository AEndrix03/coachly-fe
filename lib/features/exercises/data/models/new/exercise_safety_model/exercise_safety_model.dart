// ignore_for_file: invalid_annotation_target

import 'package:coachly/shared/json_converters/map_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_safety_model.freezed.dart';
part 'exercise_safety_model.g.dart';

@freezed
abstract class ExerciseSafetyModel with _$ExerciseSafetyModel {
  const factory ExerciseSafetyModel({
    @Default(null) String? spotterPolicy,
    @MapConverter() @Default(null) Map<String, String>? notesI18n,
    @Default(null) Map<String, List<String>>? notesListI18n,
  }) = _ExerciseSafetyModel;

  factory ExerciseSafetyModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSafetyModelFromJson(_normalizeV2Fields(json));

  /// Normalize the legacy safety payload to the V2 field names at the API
  /// boundary, so callers only ever consume the V2 model.
  static Map<String, dynamic> _normalizeV2Fields(Map<String, dynamic> json) {
    return {
      ...json,
      'spotterPolicy': json['spotterPolicy'] ?? json['overallRiskLevel'],
      'notesI18n': json['notesI18n'] ?? json['safetyNotesI18n'],
    };
  }
}
