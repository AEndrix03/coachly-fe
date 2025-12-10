// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuscleModel _$MuscleModelFromJson(Map<String, dynamic> json) => MuscleModel(
  name: json['name'] as String,
  activation: (json['activation'] as num).toInt(),
  color: (json['color'] as num).toInt(),
);

Map<String, dynamic> _$MuscleModelToJson(MuscleModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'activation': instance.activation,
      'color': instance.color,
    };
