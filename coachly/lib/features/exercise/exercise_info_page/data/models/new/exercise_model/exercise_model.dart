import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
abstract class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    required String id,
    required Map<String, String> nameI18n,
    required Map<String, String> descriptionI18n,
    required Map<String, String> tipsI18n,
    required String difficultyLevel,
    required String mechanicsType,
    required String forceType,
    required bool isUnilateral,
    required bool isBodyweight,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}
