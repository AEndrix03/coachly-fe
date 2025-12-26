import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_environment_model.g.dart';
part 'exercise_environment_model.freezed.dart';

@freezed
abstract class ExerciseEnvironmentModel with _$ExerciseEnvironmentModel {
  const factory ExerciseEnvironmentModel({
    required String id,
    required bool canDoAtHome,
    required bool canDoInGym,
    required bool equipmentSetupRequired,
  }) = _ExerciseEnvironmentModel;

  factory ExerciseEnvironmentModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseEnvironmentModelFromJson(json);
}
