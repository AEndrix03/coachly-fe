// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_muscle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseMuscleModel _$ExerciseMuscleModelFromJson(Map<String, dynamic> json) =>
    _ExerciseMuscleModel(
      muscle: json['muscle'] == null
          ? null
          : MuscleModel.fromJson(json['muscle'] as Map<String, dynamic>),
      activationPercentage:
          (json['activationPercentage'] as num?)?.toInt() ?? null,
    );

Map<String, dynamic> _$ExerciseMuscleModelToJson(
  _ExerciseMuscleModel instance,
) => <String, dynamic>{
  'muscle': instance.muscle,
  'activationPercentage': instance.activationPercentage,
};
