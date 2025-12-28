import 'package:coachly/features/workout/workout_page/data/models/tag_dto/tag_dto.dart'; // Import for TagDto
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_model.freezed.dart';
part 'workout_model.g.dart';

@freezed
abstract class WorkoutModel with _$WorkoutModel {
  const factory WorkoutModel({
    required String id,
    required Map<String, String> titleI18n,
    required Map<String, String> descriptionI18n,
    String? coachId,
    String? coachName,
    @Default(0.0) double progress,
    @Default(0) int durationMinutes,
    required String goal,
    required DateTime lastUsed,
    @Default([]) List<TagDto> muscleTags, // Changed to List<TagDto>
    @Default(0) int exercises,
    @Default(0) int sessionsCount,
    @Default(0) int lastSessionDays,
    required String type,
    @Default([]) List<WorkoutExerciseModel> workoutExercises,
    @Default(true) bool active,
    @Default(false) bool dirty,
    @Default(false) bool delete,
  }) = _WorkoutModel;

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);
}
