// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_metric_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseMetricModel _$ExerciseMetricModelFromJson(Map<String, dynamic> json) =>
    _ExerciseMetricModel(
      id: json['id'] as String,
      popularityScore: (json['popularityScore'] as num).toInt(),
      usageCount: (json['usageCount'] as num).toInt(),
    );

Map<String, dynamic> _$ExerciseMetricModelToJson(
  _ExerciseMetricModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'popularityScore': instance.popularityScore,
  'usageCount': instance.usageCount,
};
