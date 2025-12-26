// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_safety_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseSafetyModel _$ExerciseSafetyModelFromJson(Map<String, dynamic> json) =>
    _ExerciseSafetyModel(
      id: json['id'] as String,
      overallRiskLevel: json['overallRiskLevel'] as String,
      spotterRequired: json['spotterRequired'] as bool,
      safetyNotesI18n: Map<String, String>.from(json['safetyNotesI18n'] as Map),
    );

Map<String, dynamic> _$ExerciseSafetyModelToJson(
  _ExerciseSafetyModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'overallRiskLevel': instance.overallRiskLevel,
  'spotterRequired': instance.spotterRequired,
  'safetyNotesI18n': instance.safetyNotesI18n,
};
