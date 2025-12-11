// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutModel _$WorkoutModelFromJson(Map<String, dynamic> json) => WorkoutModel(
  id: json['id'] as String,
  title: json['title'] as String,
  coach: json['coach'] as String,
  progress: (json['progress'] as num).toInt(),
  exercises: (json['exercises'] as num).toInt(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  goal: json['goal'] as String,
  lastUsed: json['lastUsed'] as String,
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$WorkoutModelToJson(WorkoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coach': instance.coach,
      'progress': instance.progress,
      'exercises': instance.exercises,
      'durationMinutes': instance.durationMinutes,
      'goal': instance.goal,
      'lastUsed': instance.lastUsed,
      'active': instance.active,
    };
