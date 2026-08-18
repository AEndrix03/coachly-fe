// ignore_for_file: invalid_annotation_target

import 'package:coachly/shared/json_converters/map_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
abstract class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    @Default(null) String? id,
    @Default(null) String? createdBy,
    @JsonKey(name: 'personal') @Default(false) bool isPersonal,
    @MapConverter() @Default(null) Map<String, String>? nameI18n,
    @MapConverter() @Default(null) Map<String, String>? descriptionI18n,
    @MapConverter() @Default(null) Map<String, String>? tipsI18n,
    @Default(null) String? difficultyLevel,
    @Default(null) String? mechanicsType,
    @Default(null) String? forceType,
    @JsonKey(name: 'unilateral') @Default(null) bool? isUnilateral,
    @JsonKey(name: 'bodyweight') @Default(null) bool? isBodyweight,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}
