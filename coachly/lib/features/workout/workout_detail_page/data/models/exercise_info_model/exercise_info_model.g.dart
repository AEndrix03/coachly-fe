// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseInfoModel _$ExerciseInfoModelFromJson(Map<String, dynamic> json) =>
    ExerciseInfoModel(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      muscle: json['muscle'] as String,
      difficulty: json['difficulty'] as String,
      sets: json['sets'] as String,
      rest: json['rest'] as String,
      weight: json['weight'] as String,
      progress: json['progress'] as String,
      accentColorHex: json['accentColorHex'] as String,
    );

Map<String, dynamic> _$ExerciseInfoModelToJson(ExerciseInfoModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'muscle': instance.muscle,
      'difficulty': instance.difficulty,
      'sets': instance.sets,
      'rest': instance.rest,
      'weight': instance.weight,
      'progress': instance.progress,
      'accentColorHex': instance.accentColorHex,
    };
