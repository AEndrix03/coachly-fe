// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      videoUrl: json['videoUrl'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      difficulty: json['difficulty'] as String,
      mechanics: json['mechanics'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      primaryMuscles: (json['primaryMuscles'] as List<dynamic>)
          .map((e) => MuscleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>)
          .map((e) => MuscleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      techniqueSteps: (json['techniqueSteps'] as List<dynamic>)
          .map(
            (e) => ExerciseTechniqueModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      variants: (json['variants'] as List<dynamic>)
          .map((e) => ExerciseVariantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'videoUrl': instance.videoUrl,
      'tags': instance.tags,
      'difficulty': instance.difficulty,
      'mechanics': instance.mechanics,
      'type': instance.type,
      'description': instance.description,
      'primaryMuscles': instance.primaryMuscles,
      'secondaryMuscles': instance.secondaryMuscles,
      'techniqueSteps': instance.techniqueSteps,
      'variants': instance.variants,
    };
