import 'package:equatable/equatable.dart';

class WorkoutStats extends Equatable {
  final int activeWorkouts;
  final int completedWorkouts;
  final double progressPercentage;
  final int currentStreak;
  final int weeklyWorkouts;

  const WorkoutStats({
    required this.activeWorkouts,
    required this.completedWorkouts,
    required this.progressPercentage,
    required this.currentStreak,
    required this.weeklyWorkouts,
  });

  factory WorkoutStats.fromJson(Map<String, dynamic> json) {
    return WorkoutStats(
      activeWorkouts: json['activeWorkouts'] ?? 0,
      completedWorkouts: json['completedWorkouts'] ?? 0,
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
      currentStreak: json['currentStreak'] ?? 0,
      weeklyWorkouts: json['weeklyWorkouts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'activeWorkouts': activeWorkouts,
    'completedWorkouts': completedWorkouts,
    'progressPercentage': progressPercentage,
    'currentStreak': currentStreak,
    'weeklyWorkouts': weeklyWorkouts,
  };

  WorkoutStats copyWith({
    int? activeWorkouts,
    int? completedWorkouts,
    double? progressPercentage,
    int? currentStreak,
    int? weeklyWorkouts,
  }) {
    return WorkoutStats(
      activeWorkouts: activeWorkouts ?? this.activeWorkouts,
      completedWorkouts: completedWorkouts ?? this.completedWorkouts,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      currentStreak: currentStreak ?? this.currentStreak,
      weeklyWorkouts: weeklyWorkouts ?? this.weeklyWorkouts,
    );
  }

  @override
  List<Object?> get props => [
    activeWorkouts,
    completedWorkouts,
    progressPercentage,
    currentStreak,
    weeklyWorkouts,
  ];
}
