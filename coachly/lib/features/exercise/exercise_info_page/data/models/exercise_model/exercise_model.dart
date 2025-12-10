import 'package:coachly/features/exercise/exercise_info_page/data/models/exercise_technique_model/exercise_technique_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/exercise_variant_model/exercise_variant_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/muscle_model/muscle_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
@JsonSerializable()
class ExerciseModel with _$ExerciseModel {
  final String id;
  final String name;
  final String videoUrl;
  final List<String> tags;
  final String difficulty;
  final String mechanics;
  final String type;
  final String description;
  final List<MuscleModel> primaryMuscles;
  final List<MuscleModel> secondaryMuscles;
  final List<ExerciseTechniqueModel> techniqueSteps;
  final List<ExerciseVariantModel> variants;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.videoUrl,
    required this.tags,
    required this.difficulty,
    required this.mechanics,
    required this.type,
    required this.description,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.techniqueSteps,
    required this.variants,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);
}
