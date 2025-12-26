// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseVariantModel _$ExerciseVariantModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseVariantModel(
  id: json['id'] as String,
  nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
  descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
  tipsI18n: Map<String, String>.from(json['tipsI18n'] as Map),
  difficultyLevel: json['difficultyLevel'] as String,
  mechanicsType: json['mechanicsType'] as String,
  forceType: json['forceType'] as String,
  isUnilateral: json['isUnilateral'] as bool,
  isBodyweight: json['isBodyweight'] as bool,
  variationType: json['variationType'] as String,
  difficultyDelta: (json['difficultyDelta'] as num).toInt(),
);

Map<String, dynamic> _$ExerciseVariantModelToJson(
  _ExerciseVariantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameI18n': instance.nameI18n,
  'descriptionI18n': instance.descriptionI18n,
  'tipsI18n': instance.tipsI18n,
  'difficultyLevel': instance.difficultyLevel,
  'mechanicsType': instance.mechanicsType,
  'forceType': instance.forceType,
  'isUnilateral': instance.isUnilateral,
  'isBodyweight': instance.isBodyweight,
  'variationType': instance.variationType,
  'difficultyDelta': instance.difficultyDelta,
};
