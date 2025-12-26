// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutExerciseModel _$WorkoutExerciseModelFromJson(
  Map<String, dynamic> json,
) => _WorkoutExerciseModel(
  exercise: ExerciseDetailModel.fromJson(
    json['exercise'] as Map<String, dynamic>,
  ),
  sets: json['sets'] as String,
  rest: json['rest'] as String,
  weight: json['weight'] as String,
  progress: (json['progress'] as num).toDouble(),
);

Map<String, dynamic> _$WorkoutExerciseModelToJson(
  _WorkoutExerciseModel instance,
) => <String, dynamic>{
  'exercise': instance.exercise,
  'sets': instance.sets,
  'rest': instance.rest,
  'weight': instance.weight,
  'progress': instance.progress,
};
