// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutModel _$WorkoutModelFromJson(Map<String, dynamic> json) =>
    _WorkoutModel(
      id: json['id'] as String,
      titleI18n: Map<String, String>.from(json['titleI18n'] as Map),
      descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
      coachId: json['coachId'] as String?,
      coachName: json['coachName'] as String?,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      goal: json['goal'] as String,
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      muscleTags:
          (json['muscleTags'] as List<dynamic>?)
              ?.map((e) => TagDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      exercises: (json['exercises'] as num?)?.toInt() ?? 0,
      sessionsCount: (json['sessionsCount'] as num?)?.toInt() ?? 0,
      lastSessionDays: (json['lastSessionDays'] as num?)?.toInt() ?? 0,
      type: json['type'] as String,
      workoutExercises:
          (json['workoutExercises'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      active: json['active'] as bool? ?? true,
      dirty: json['dirty'] as bool? ?? false,
      delete: json['delete'] as bool? ?? false,
    );

Map<String, dynamic> _$WorkoutModelToJson(_WorkoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleI18n': instance.titleI18n,
      'descriptionI18n': instance.descriptionI18n,
      'coachId': instance.coachId,
      'coachName': instance.coachName,
      'progress': instance.progress,
      'durationMinutes': instance.durationMinutes,
      'goal': instance.goal,
      'lastUsed': instance.lastUsed.toIso8601String(),
      'muscleTags': instance.muscleTags,
      'exercises': instance.exercises,
      'sessionsCount': instance.sessionsCount,
      'lastSessionDays': instance.lastSessionDays,
      'type': instance.type,
      'workoutExercises': instance.workoutExercises,
      'active': instance.active,
      'dirty': instance.dirty,
      'delete': instance.delete,
    };
