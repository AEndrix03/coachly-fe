import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_exercise_model.freezed.dart';
part 'workout_exercise_model.g.dart';

@freezed
abstract class WorkoutExerciseModel with _$WorkoutExerciseModel {
  const factory WorkoutExerciseModel({
    required String id,
    required ExerciseDetailModel exercise,
    required String sets,
    required String rest,
    required String weight,
    required double progress,
  }) = _WorkoutExerciseModel;

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseModelFromJson(json);
}
