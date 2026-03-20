// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutContext _$WorkoutContextFromJson(Map<String, dynamic> json) =>
    _WorkoutContext(
      exerciseName: json['exerciseName'] as String,
      currentSet: (json['currentSet'] as num).toInt(),
      totalSets: (json['totalSets'] as num).toInt(),
      weightKg: (json['weightKg'] as num).toDouble(),
      targetReps: (json['targetReps'] as num).toInt(),
      completedReps: (json['completedReps'] as num?)?.toInt(),
      fatigueIndex: (json['fatigueIndex'] as num?)?.toDouble(),
      recentWeights: (json['recentWeights'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      sessionStart: DateTime.parse(json['sessionStart'] as String),
      workoutPlan: json['workoutPlan'] as String?,
    );

Map<String, dynamic> _$WorkoutContextToJson(_WorkoutContext instance) =>
    <String, dynamic>{
      'exerciseName': instance.exerciseName,
      'currentSet': instance.currentSet,
      'totalSets': instance.totalSets,
      'weightKg': instance.weightKg,
      'targetReps': instance.targetReps,
      'completedReps': instance.completedReps,
      'fatigueIndex': instance.fatigueIndex,
      'recentWeights': instance.recentWeights,
      'sessionStart': instance.sessionStart.toIso8601String(),
      'workoutPlan': instance.workoutPlan,
    };
