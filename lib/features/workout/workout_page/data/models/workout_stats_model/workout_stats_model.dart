import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_stats_model.freezed.dart';
part 'workout_stats_model.g.dart';

@freezed
@JsonSerializable()
class WorkoutStatsModel with _$WorkoutStatsModel {
  final int activeWorkouts;
  final int completedWorkouts;
  final double progressPercentage;
  final int currentStreak;
  final int weeklyWorkouts;

  const WorkoutStatsModel({
    required this.activeWorkouts,
    required this.completedWorkouts,
    required this.progressPercentage,
    required this.currentStreak,
    required this.weeklyWorkouts,
  });

  factory WorkoutStatsModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutStatsModelToJson(this);
}
