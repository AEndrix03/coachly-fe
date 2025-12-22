import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_model.freezed.dart';
part 'workout_model.g.dart';

@freezed
abstract class WorkoutModel with _$WorkoutModel {
  const factory WorkoutModel({
    required String id,
    required Map<String, String> titleI18n,
    Map<String, String>? descriptionI18n,
    String? coachId,
    String? coachName,
    required double progress,
    required int exercises,
    required int durationMinutes,
    required String goal,
    required DateTime lastUsed,
    @Default(true) bool active,
  }) = _WorkoutModel;

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);
}
