// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutModel _$WorkoutModelFromJson(Map<String, dynamic> json) =>
    _WorkoutModel(
      id: json['id'] as String,
      titleI18n: Map<String, String>.from(json['titleI18n'] as Map),
      descriptionI18n: (json['descriptionI18n'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      coachId: json['coachId'] as String?,
      coachName: json['coachName'] as String?,
      progress: (json['progress'] as num).toDouble(),
      exercises: (json['exercises'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      goal: json['goal'] as String,
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      active: json['active'] as bool? ?? true,
    );

Map<String, dynamic> _$WorkoutModelToJson(_WorkoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleI18n': instance.titleI18n,
      'descriptionI18n': instance.descriptionI18n,
      'coachId': instance.coachId,
      'coachName': instance.coachName,
      'progress': instance.progress,
      'exercises': instance.exercises,
      'durationMinutes': instance.durationMinutes,
      'goal': instance.goal,
      'lastUsed': instance.lastUsed.toIso8601String(),
      'active': instance.active,
    };
