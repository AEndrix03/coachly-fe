// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TagDto _$TagDtoFromJson(Map<String, dynamic> json) => _TagDto(
  id: json['id'] as String,
  nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
);

Map<String, dynamic> _$TagDtoToJson(_TagDto instance) => <String, dynamic>{
  'id': instance.id,
  'nameI18n': instance.nameI18n,
};
