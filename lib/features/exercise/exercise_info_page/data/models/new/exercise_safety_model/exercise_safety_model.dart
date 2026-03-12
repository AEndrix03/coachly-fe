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
      _$ExerciseSafetyModelFromJson(json);
}
