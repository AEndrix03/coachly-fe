// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TagModel _$TagModelFromJson(Map<String, dynamic> json) => _TagModel(
  id: json['id'] as String? ?? null,
  code: json['code'] as String? ?? null,
  nameI18n: json['nameI18n'] == null
      ? null
      : const MapConverter().fromJson(json['nameI18n']),
  descriptionI18n: json['descriptionI18n'] == null
      ? null
      : const MapConverter().fromJson(json['descriptionI18n']),
  tagType: json['tagType'] as String? ?? null,
);

Map<String, dynamic> _$TagModelToJson(_TagModel instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'nameI18n': const MapConverter().toJson(instance.nameI18n),
  'descriptionI18n': const MapConverter().toJson(instance.descriptionI18n),
  'tagType': instance.tagType,
};
