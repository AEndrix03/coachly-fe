// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_movement_pattern_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseMovementPatternModel _$ExerciseMovementPatternModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseMovementPatternModel(
  id: json['id'] as String,
  movementPlane: json['movementPlane'] as String,
  movementPattern: json['movementPattern'] as String,
  powerGenerationLevel: json['powerGenerationLevel'] as String,
);

Map<String, dynamic> _$ExerciseMovementPatternModelToJson(
  _ExerciseMovementPatternModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'movementPlane': instance.movementPlane,
  'movementPattern': instance.movementPattern,
  'powerGenerationLevel': instance.powerGenerationLevel,
};
