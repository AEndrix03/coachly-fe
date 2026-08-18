// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseMediaModel _$ExerciseMediaModelFromJson(Map<String, dynamic> json) =>
    _ExerciseMediaModel(
      id: json['id'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      mediaPurpose: json['mediaPurpose'] as String? ?? '',
      viewAngle: json['viewAngle'] as String? ?? '',
      isPrimary: json['primary'] as bool? ?? false,
      isPublic: json['public'] as bool? ?? false,
    );

Map<String, dynamic> _$ExerciseMediaModelToJson(_ExerciseMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediaType': instance.mediaType,
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'mediaPurpose': instance.mediaPurpose,
      'viewAngle': instance.viewAngle,
      'primary': instance.isPrimary,
      'public': instance.isPublic,
    };
