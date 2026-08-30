// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_safety_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseSafetyModel _$ExerciseSafetyModelFromJson(Map<String, dynamic> json) =>
    _ExerciseSafetyModel(
      spotterPolicy: json['spotterPolicy'] as String? ?? null,
      notesI18n: json['notesI18n'] == null
          ? null
          : const MapConverter().fromJson(json['notesI18n']),
      notesListI18n:
          (json['notesListI18n'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>).map((e) => e as String).toList(),
            ),
          ) ??
          null,
    );

Map<String, dynamic> _$ExerciseSafetyModelToJson(
  _ExerciseSafetyModel instance,
) => <String, dynamic>{
  'spotterPolicy': instance.spotterPolicy,
  'notesI18n': const MapConverter().toJson(instance.notesI18n),
  'notesListI18n': instance.notesListI18n,
};
