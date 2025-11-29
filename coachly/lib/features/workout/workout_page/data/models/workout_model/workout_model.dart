import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_model.freezed.dart';
part 'workout_model.g.dart';

@freezed
@JsonSerializable()
class WorkoutModel with _$WorkoutModel {
  final String id;
  final String title;
  final String coach;
  final int progress;
  final int exercises;
  final int durationMinutes;
  final String goal;
  final String lastUsed;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.coach,
    required this.progress,
    required this.exercises,
    required this.durationMinutes,
    required this.goal,
    required this.lastUsed,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutModelToJson(this);
}
