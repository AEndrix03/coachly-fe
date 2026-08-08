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
      _$ExerciseSafetyModelFromJson(json);
}
