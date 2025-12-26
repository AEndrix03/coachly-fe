import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_metric_model.freezed.dart';
part 'exercise_metric_model.g.dart';

@freezed
abstract class ExerciseMetricModel with _$ExerciseMetricModel {
  const factory ExerciseMetricModel({
    required String id,
    required int popularityScore,
    required int usageCount,
  }) = _ExerciseMetricModel;

  factory ExerciseMetricModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseMetricModelFromJson(json);
}
