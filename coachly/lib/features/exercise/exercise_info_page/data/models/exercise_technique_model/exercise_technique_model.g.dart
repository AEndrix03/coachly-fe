// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_technique_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseTechniqueModel _$ExerciseTechniqueModelFromJson(
  Map<String, dynamic> json,
) => ExerciseTechniqueModel(
  title: json['title'] as String,
  description: json['description'] as String,
  iconCodePoint: (json['iconCodePoint'] as num).toInt(),
  iconGradient: (json['iconGradient'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$ExerciseTechniqueModelToJson(
  ExerciseTechniqueModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'iconCodePoint': instance.iconCodePoint,
  'iconGradient': instance.iconGradient,
};
