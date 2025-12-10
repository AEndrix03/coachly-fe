// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseVariantModel _$ExerciseVariantModelFromJson(
  Map<String, dynamic> json,
) => ExerciseVariantModel(
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  emphasis: json['emphasis'] as String,
  iconCodePoint: (json['iconCodePoint'] as num).toInt(),
);

Map<String, dynamic> _$ExerciseVariantModelToJson(
  ExerciseVariantModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'subtitle': instance.subtitle,
  'emphasis': instance.emphasis,
  'iconCodePoint': instance.iconCodePoint,
};
