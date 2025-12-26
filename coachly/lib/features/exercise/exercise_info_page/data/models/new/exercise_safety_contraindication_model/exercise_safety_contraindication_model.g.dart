// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_safety_contraindication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseSafetyContraindicationModel
_$ExerciseSafetyContraindicationModelFromJson(Map<String, dynamic> json) =>
    _ExerciseSafetyContraindicationModel(
      id: json['id'] as String,
      contraindicationType: json['contraindicationType'] as String,
      conditionName: json['conditionName'] as String,
      warningTextI18n: Map<String, String>.from(json['warningTextI18n'] as Map),
    );

Map<String, dynamic> _$ExerciseSafetyContraindicationModelToJson(
  _ExerciseSafetyContraindicationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'contraindicationType': instance.contraindicationType,
  'conditionName': instance.conditionName,
  'warningTextI18n': instance.warningTextI18n,
};
