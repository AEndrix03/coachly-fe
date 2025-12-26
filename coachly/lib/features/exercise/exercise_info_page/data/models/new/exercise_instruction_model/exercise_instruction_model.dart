import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_instruction_model.freezed.dart';
part 'exercise_instruction_model.g.dart';

@freezed
abstract class ExerciseInstructionModel with _$ExerciseInstructionModel {
  const factory ExerciseInstructionModel({
    required String id,
    required String instructionType,
    required int stepNumber,
    required Map<String, String> instructionTextI18n,
    required bool isCritical,
  }) = _ExerciseInstructionModel;

  factory ExerciseInstructionModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseInstructionModelFromJson(json);
}
