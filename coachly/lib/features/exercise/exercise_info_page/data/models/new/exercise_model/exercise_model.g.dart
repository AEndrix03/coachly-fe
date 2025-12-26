// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    _ExerciseModel(
      id: json['id'] as String,
      nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
      descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
      tipsI18n: Map<String, String>.from(json['tipsI18n'] as Map),
      difficultyLevel: json['difficultyLevel'] as String,
      mechanicsType: json['mechanicsType'] as String,
      forceType: json['forceType'] as String,
      isUnilateral: json['isUnilateral'] as bool,
      isBodyweight: json['isBodyweight'] as bool,
    );

Map<String, dynamic> _$ExerciseModelToJson(_ExerciseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameI18n': instance.nameI18n,
      'descriptionI18n': instance.descriptionI18n,
      'tipsI18n': instance.tipsI18n,
      'difficultyLevel': instance.difficultyLevel,
      'mechanicsType': instance.mechanicsType,
      'forceType': instance.forceType,
      'isUnilateral': instance.isUnilateral,
      'isBodyweight': instance.isBodyweight,
    };
