// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contraction_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContractionTypeModel _$ContractionTypeModelFromJson(
  Map<String, dynamic> json,
) => _ContractionTypeModel(
  id: json['id'] as String,
  code: json['code'] as String,
  nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
  descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
);

Map<String, dynamic> _$ContractionTypeModelToJson(
  _ContractionTypeModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'nameI18n': instance.nameI18n,
  'descriptionI18n': instance.descriptionI18n,
};
