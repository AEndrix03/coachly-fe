// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_environment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseEnvironmentModel _$ExerciseEnvironmentModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseEnvironmentModel(
  id: json['id'] as String,
  canDoAtHome: json['canDoAtHome'] as bool,
  canDoInGym: json['canDoInGym'] as bool,
  equipmentSetupRequired: json['equipmentSetupRequired'] as bool,
);

Map<String, dynamic> _$ExerciseEnvironmentModelToJson(
  _ExerciseEnvironmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'canDoAtHome': instance.canDoAtHome,
  'canDoInGym': instance.canDoInGym,
  'equipmentSetupRequired': instance.equipmentSetupRequired,
};
