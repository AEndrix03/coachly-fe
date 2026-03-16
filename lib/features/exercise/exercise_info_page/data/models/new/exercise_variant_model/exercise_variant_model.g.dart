// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseVariantModel _$ExerciseVariantModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseVariantModel(
  id: json['id'] as String? ?? null,
  nameI18n: json['nameI18n'] == null
      ? null
      : const MapConverter().fromJson(json['nameI18n']),
  descriptionI18n: json['descriptionI18n'] == null
      ? null
      : const MapConverter().fromJson(json['descriptionI18n']),
  tipsI18n: json['tipsI18n'] == null
      ? null
      : const MapConverter().fromJson(json['tipsI18n']),
  difficultyLevel: json['difficultyLevel'] as String? ?? null,
  mechanicsType: json['mechanicsType'] as String? ?? null,
  forceType: json['forceType'] as String? ?? null,
  isUnilateral: json['isUnilateral'] as bool? ?? null,
  isBodyweight: json['isBodyweight'] as bool? ?? null,
  difficultyDelta: (json['difficultyDelta'] as num?)?.toInt() ?? null,
);

Map<String, dynamic> _$ExerciseVariantModelToJson(
  _ExerciseVariantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameI18n': const MapConverter().toJson(instance.nameI18n),
  'descriptionI18n': const MapConverter().toJson(instance.descriptionI18n),
  'tipsI18n': const MapConverter().toJson(instance.tipsI18n),
  'difficultyLevel': instance.difficultyLevel,
  'mechanicsType': instance.mechanicsType,
  'forceType': instance.forceType,
  'isUnilateral': instance.isUnilateral,
  'isBodyweight': instance.isBodyweight,
  'difficultyDelta': instance.difficultyDelta,
};
