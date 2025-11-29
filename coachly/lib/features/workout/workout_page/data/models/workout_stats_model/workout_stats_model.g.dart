// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutStatsModel _$WorkoutStatsModelFromJson(Map<String, dynamic> json) =>
    WorkoutStatsModel(
      activeWorkouts: (json['activeWorkouts'] as num).toInt(),
      completedWorkouts: (json['completedWorkouts'] as num).toInt(),
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      weeklyWorkouts: (json['weeklyWorkouts'] as num).toInt(),
    );

Map<String, dynamic> _$WorkoutStatsModelToJson(WorkoutStatsModel instance) =>
    <String, dynamic>{
      'activeWorkouts': instance.activeWorkouts,
      'completedWorkouts': instance.completedWorkouts,
      'progressPercentage': instance.progressPercentage,
      'currentStreak': instance.currentStreak,
      'weeklyWorkouts': instance.weeklyWorkouts,
    };
