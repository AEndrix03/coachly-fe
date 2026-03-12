// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  sub: json['sub'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  exp: (json['exp'] as num).toInt(),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'sub': instance.sub,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'exp': instance.exp,
    };
