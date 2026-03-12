// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseCategoryModel _$ExerciseCategoryModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseCategoryModel(
  id: json['id'] as String? ?? null,
  code: json['code'] as String? ?? null,
  nameI18n: json['nameI18n'] == null
      ? null
      : const MapConverter().fromJson(json['nameI18n']),
  descriptionI18n: json['descriptionI18n'] == null
      ? null
      : const MapConverter().fromJson(json['descriptionI18n']),
  categoryLevel: (json['categoryLevel'] as num?)?.toInt() ?? null,
  isPrimary: json['isPrimary'] as bool? ?? null,
  children:
      (json['children'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      null,
);

Map<String, dynamic> _$ExerciseCategoryModelToJson(
  _ExerciseCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'nameI18n': const MapConverter().toJson(instance.nameI18n),
  'descriptionI18n': const MapConverter().toJson(instance.descriptionI18n),
  'categoryLevel': instance.categoryLevel,
  'isPrimary': instance.isPrimary,
  'children': instance.children,
};
