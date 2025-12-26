import 'package:coachly/features/exercise/exercise_info_page/data/models/new/contraction_type_model/contraction_type_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/muscle_model/muscle_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_muscle_model.freezed.dart';
part 'exercise_muscle_model.g.dart';

@freezed
abstract class ExerciseMuscleModel with _$ExerciseMuscleModel {
  const factory ExerciseMuscleModel({
    required MuscleModel muscle,
    required String involvementLevel,
    required ContractionTypeModel primaryContractionType,
    required int activationPercentage,
  }) = _ExerciseMuscleModel;

  factory ExerciseMuscleModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseMuscleModelFromJson(json);
}
