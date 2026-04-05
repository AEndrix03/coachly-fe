import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_variant_model/exercise_variant_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_category_model/exercise_category_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_equipment_model/exercise_equipment_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_media_model/exercise_media_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_muscle_model/exercise_muscle_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_safety_model/exercise_safety_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/tag_model/tag_model.dart';
import 'package:coachly/shared/json_converters/map_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_detail_model.freezed.dart';
part 'exercise_detail_model.g.dart';

@freezed
abstract class ExerciseDetailModel with _$ExerciseDetailModel {
  const factory ExerciseDetailModel({
    @Default(null) String? id,
    @Default(null) String? createdBy,
    @Default(false) bool isPersonal,
    @MapConverter() @Default(null) Map<String, String>? nameI18n,
    @MapConverter() @Default(null) Map<String, String>? descriptionI18n,
    @MapConverter() @Default(null) Map<String, String>? tipsI18n,
    @Default(null) String? difficultyLevel,
    @Default(null) String? mechanicsType,
    @Default(null) String? forceType,
    @Default(null) bool? isUnilateral,
    @Default(null) bool? isBodyweight,
    @Default(null) List<ExerciseVariantModel>? variants,
    @Default(null) List<ExerciseMediaModel>? media,
    @Default(null) List<ExerciseCategoryModel>? categories,
    @Default(null) List<ExerciseSafetyModel>? safety,
    @Default(null) List<ExerciseMuscleModel>? muscles,
    @Default(null) List<ExerciseEquipmentModel>? equipments,
    @Default(null) List<TagModel>? tags,
  }) = _ExerciseDetailModel;

  factory ExerciseDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDetailModelFromJson(json);
}
