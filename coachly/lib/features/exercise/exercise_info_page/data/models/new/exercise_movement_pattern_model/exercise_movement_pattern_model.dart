import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_movement_pattern_model.freezed.dart';
part 'exercise_movement_pattern_model.g.dart';

@freezed
abstract class ExerciseMovementPatternModel
    with _$ExerciseMovementPatternModel {
  const factory ExerciseMovementPatternModel({
    required String id,
    required String movementPlane,
    required String movementPattern,
    required String powerGenerationLevel,
  }) = _ExerciseMovementPatternModel;

  factory ExerciseMovementPatternModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseMovementPatternModelFromJson(json);
}
