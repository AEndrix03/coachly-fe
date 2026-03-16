import 'package:coachly/shared/json_converters/map_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_variant_model.freezed.dart';
part 'exercise_variant_model.g.dart';

@freezed
abstract class ExerciseVariantModel with _$ExerciseVariantModel {
  const factory ExerciseVariantModel({
    @Default(null) String? id,
    @MapConverter() @Default(null) Map<String, String>? nameI18n,
    @MapConverter() @Default(null) Map<String, String>? descriptionI18n,
    @MapConverter() @Default(null) Map<String, String>? tipsI18n,
    @Default(null) String? difficultyLevel,
    @Default(null) String? mechanicsType,
    @Default(null) String? forceType,
    @Default(null) bool? isUnilateral,
    @Default(null) bool? isBodyweight,
    @Default(null) int? difficultyDelta,
  }) = _ExerciseVariantModel;

  factory ExerciseVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseVariantModelFromJson(json);
}
