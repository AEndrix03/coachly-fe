import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_filter_model.freezed.dart';
part 'exercise_filter_model.g.dart';

@freezed
abstract class ExerciseFilterModel with _$ExerciseFilterModel {
  const factory ExerciseFilterModel({
    @Default(null) String? scope,
    String? textFilter,
    String? langFilter,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
    List<String>? categoryIds,
    List<String>? muscleIds,
  }) = _ExerciseFilterModel;

  factory ExerciseFilterModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFilterModelFromJson(json);
}
