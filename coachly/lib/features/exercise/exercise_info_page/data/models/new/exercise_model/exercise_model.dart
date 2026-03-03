import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
abstract class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    @Default(null) String? id,
    @MapConverter() @Default(null) Map<String, String>? nameI18n,
    @MapConverter() @Default(null) Map<String, String>? descriptionI18n,
    @MapConverter() @Default(null) Map<String, String>? tipsI18n,
    @Default(null) String? difficultyLevel,
    @Default(null) String? mechanicsType,
    @Default(null) String? forceType,
    @Default(null) bool? isUnilateral,
    @Default(null) bool? isBodyweight,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}
