import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_detail_model.freezed.dart';
part 'workout_detail_model.g.dart';

@freezed
@JsonSerializable()
class WorkoutDetailModel with _$WorkoutDetailModel {
  final String title;
  final String coachName;
  final List<String> muscleTags;
  final double progress;
  final int sessionsCount;
  final int lastSessionDays;

  const WorkoutDetailModel({
    required this.title,
    required this.coachName,
    required this.muscleTags,
    required this.progress,
    required this.sessionsCount,
    required this.lastSessionDays,
  });

  factory WorkoutDetailModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutDetailModelToJson(this);
}
