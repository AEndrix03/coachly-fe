// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EquipmentModel _$EquipmentModelFromJson(Map<String, dynamic> json) =>
    _EquipmentModel(
      id: json['id'] as String,
      code: json['code'] as String,
      nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
      descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
    );

Map<String, dynamic> _$EquipmentModelToJson(_EquipmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'nameI18n': instance.nameI18n,
      'descriptionI18n': instance.descriptionI18n,
    };
