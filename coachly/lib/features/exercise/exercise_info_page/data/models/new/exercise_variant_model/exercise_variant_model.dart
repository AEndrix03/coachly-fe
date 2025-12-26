import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_variant_model.freezed.dart';
part 'exercise_variant_model.g.dart';

@freezed
abstract class ExerciseVariantModel with _$ExerciseVariantModel {
  const factory ExerciseVariantModel({
    required String id,
    required Map<String, String> nameI18n,
    required Map<String, String> descriptionI18n,
    required Map<String, String> tipsI18n,
    required String difficultyLevel,
    required String mechanicsType,
    required String forceType,
    required bool isUnilateral,
    required bool isBodyweight,
    required String variationType,
    required int difficultyDelta,
  }) = _ExerciseVariantModel;

  factory ExerciseVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseVariantModelFromJson(json);
}
