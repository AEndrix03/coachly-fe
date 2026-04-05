// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseFilterModel _$ExerciseFilterModelFromJson(Map<String, dynamic> json) =>
    _ExerciseFilterModel(
      scope: json['scope'] as String? ?? null,
      textFilter: json['textFilter'] as String?,
      langFilter: json['langFilter'] as String?,
      difficultyLevel: json['difficultyLevel'] as String?,
      mechanicsType: json['mechanicsType'] as String?,
      forceType: json['forceType'] as String?,
      isUnilateral: json['isUnilateral'] as bool?,
      isBodyweight: json['isBodyweight'] as bool?,
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      muscleIds: (json['muscleIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ExerciseFilterModelToJson(
  _ExerciseFilterModel instance,
) => <String, dynamic>{
  'scope': instance.scope,
  'textFilter': instance.textFilter,
  'langFilter': instance.langFilter,
  'difficultyLevel': instance.difficultyLevel,
  'mechanicsType': instance.mechanicsType,
  'forceType': instance.forceType,
  'isUnilateral': instance.isUnilateral,
  'isBodyweight': instance.isBodyweight,
  'categoryIds': instance.categoryIds,
  'muscleIds': instance.muscleIds,
};
