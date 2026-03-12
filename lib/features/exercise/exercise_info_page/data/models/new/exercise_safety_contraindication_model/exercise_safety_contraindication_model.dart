import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_safety_contraindication_model.freezed.dart';
part 'exercise_safety_contraindication_model.g.dart';

@freezed
abstract class ExerciseSafetyContraindicationModel
    with _$ExerciseSafetyContraindicationModel {
  const factory ExerciseSafetyContraindicationModel({
    required String id,
    required String contraindicationType,
    required String conditionName,
    required Map<String, String> warningTextI18n,
  }) = _ExerciseSafetyContraindicationModel;

  factory ExerciseSafetyContraindicationModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ExerciseSafetyContraindicationModelFromJson(json);
}
