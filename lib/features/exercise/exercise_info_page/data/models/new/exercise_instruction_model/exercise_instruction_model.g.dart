// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_instruction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseInstructionModel _$ExerciseInstructionModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseInstructionModel(
  id: json['id'] as String,
  instructionType: json['instructionType'] as String,
  stepNumber: (json['stepNumber'] as num).toInt(),
  instructionTextI18n: Map<String, String>.from(
    json['instructionTextI18n'] as Map,
  ),
  isCritical: json['isCritical'] as bool,
);

Map<String, dynamic> _$ExerciseInstructionModelToJson(
  _ExerciseInstructionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'instructionType': instance.instructionType,
  'stepNumber': instance.stepNumber,
  'instructionTextI18n': instance.instructionTextI18n,
  'isCritical': instance.isCritical,
};
