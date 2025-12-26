import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/tag_dto/tag_dto.dart'; // Import for TagDto
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
    required double progress,
    required int durationMinutes,
    required String goal,
    required DateTime lastUsed,
    @Default([]) required List<TagDto> muscleTags, // Changed to List<TagDto>
    required int sessionsCount,
    required int lastSessionDays,
    required String type,
    @Default([]) required List<WorkoutExerciseModel> workoutExercises,
    @Default(true) bool active,
    @Default(false) bool dirty,
    @Default(false) bool delete,
  }) = _WorkoutModel;

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);
}
