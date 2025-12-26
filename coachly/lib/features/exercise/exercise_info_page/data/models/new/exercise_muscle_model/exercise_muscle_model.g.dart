// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_muscle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseMuscleModel _$ExerciseMuscleModelFromJson(Map<String, dynamic> json) =>
    _ExerciseMuscleModel(
      muscle: MuscleModel.fromJson(json['muscle'] as Map<String, dynamic>),
      involvementLevel: json['involvementLevel'] as String,
      primaryContractionType: ContractionTypeModel.fromJson(
        json['primaryContractionType'] as Map<String, dynamic>,
      ),
      activationPercentage: (json['activationPercentage'] as num).toInt(),
    );

Map<String, dynamic> _$ExerciseMuscleModelToJson(
  _ExerciseMuscleModel instance,
) => <String, dynamic>{
  'muscle': instance.muscle,
  'involvementLevel': instance.involvementLevel,
  'primaryContractionType': instance.primaryContractionType,
  'activationPercentage': instance.activationPercentage,
};
