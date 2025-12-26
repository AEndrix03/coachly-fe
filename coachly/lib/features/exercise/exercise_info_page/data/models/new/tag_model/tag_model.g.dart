// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TagModel _$TagModelFromJson(Map<String, dynamic> json) => _TagModel(
  id: json['id'] as String,
  code: json['code'] as String,
  nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
  descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
  tagType: json['tagType'] as String,
);

Map<String, dynamic> _$TagModelToJson(_TagModel instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'nameI18n': instance.nameI18n,
  'descriptionI18n': instance.descriptionI18n,
  'tagType': instance.tagType,
};
