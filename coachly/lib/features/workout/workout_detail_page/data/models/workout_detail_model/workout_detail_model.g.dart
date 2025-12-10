// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutDetailModel _$WorkoutDetailModelFromJson(Map<String, dynamic> json) =>
    WorkoutDetailModel(
      title: json['title'] as String,
      coachName: json['coachName'] as String,
      muscleTags: (json['muscleTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      progress: (json['progress'] as num).toDouble(),
      sessionsCount: (json['sessionsCount'] as num).toInt(),
      lastSessionDays: (json['lastSessionDays'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      type: json['type'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$WorkoutDetailModelToJson(WorkoutDetailModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'coachName': instance.coachName,
      'muscleTags': instance.muscleTags,
      'progress': instance.progress,
      'sessionsCount': instance.sessionsCount,
      'lastSessionDays': instance.lastSessionDays,
      'durationMinutes': instance.durationMinutes,
      'type': instance.type,
      'description': instance.description,
    };
