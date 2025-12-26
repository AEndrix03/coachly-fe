// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseCategoryModel _$ExerciseCategoryModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseCategoryModel(
  id: json['id'] as String,
  code: json['code'] as String,
  nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
  descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
  categoryLevel: (json['categoryLevel'] as num).toInt(),
  isPrimary: json['isPrimary'] as bool?,
  children:
      (json['children'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExerciseCategoryModelToJson(
  _ExerciseCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'nameI18n': instance.nameI18n,
  'descriptionI18n': instance.descriptionI18n,
  'categoryLevel': instance.categoryLevel,
  'isPrimary': instance.isPrimary,
  'children': instance.children,
};
