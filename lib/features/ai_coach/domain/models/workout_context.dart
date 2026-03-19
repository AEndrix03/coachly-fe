import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_context.freezed.dart';
part 'workout_context.g.dart';

@freezed
abstract class WorkoutContext with _$WorkoutContext {
  const factory WorkoutContext({
    required String exerciseName,
    required int currentSet,
    required int totalSets,
    required double weightKg,
    required int targetReps,
    int? completedReps,
    double? fatigueIndex,
    List<double>? recentWeights,
    required DateTime sessionStart,
  }) = _WorkoutContext;

  factory WorkoutContext.fromJson(Map<String, dynamic> json) =>
      _$WorkoutContextFromJson(json);
}
