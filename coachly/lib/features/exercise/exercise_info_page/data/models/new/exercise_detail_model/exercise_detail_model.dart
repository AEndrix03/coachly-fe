import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_variant_model/exercise_variant_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_category_model/exercise_category_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_environment_model/exercise_environment_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_equipment_model/exercise_equipment_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_instruction_model/exercise_instruction_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_media_model/exercise_media_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_movement_pattern_model/exercise_movement_pattern_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_muscle_model/exercise_muscle_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_safety_contraindication_model/exercise_safety_contraindication_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_safety_model/exercise_safety_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/tag_model/tag_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_detail_model.freezed.dart';
part 'exercise_detail_model.g.dart';

@freezed
abstract class ExerciseDetailModel with _$ExerciseDetailModel {
  const factory ExerciseDetailModel({
    required String id,
    required Map<String, String> nameI18n,
    required Map<String, String> descriptionI18n,
    required Map<String, String> tipsI18n,
    required String difficultyLevel,
    required String mechanicsType,
    required String forceType,
    required bool isUnilateral,
    required bool isBodyweight,
    ExerciseEnvironmentModel? environment,
    @Default([]) List<ExerciseInstructionModel> instructions,
    ExerciseMovementPatternModel? movementPattern,
    @Default([]) List<ExerciseVariantModel> variants,
    @Default([]) List<ExerciseMediaModel> media,
    @Default([]) List<ExerciseCategoryModel> categories,
    @Default([]) List<ExerciseSafetyModel> safety,
    @Default([])
    List<ExerciseSafetyContraindicationModel> safetyContraindications,
    @Default([]) List<ExerciseMuscleModel> muscles,
    @Default([]) List<ExerciseEquipmentModel> equipments,
    @Default([]) List<TagModel> tags,
  }) = _ExerciseDetailModel;

  factory ExerciseDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDetailModelFromJson(json);
}
