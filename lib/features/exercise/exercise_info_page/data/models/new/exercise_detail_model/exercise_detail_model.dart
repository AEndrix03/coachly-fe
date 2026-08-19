// ignore_for_file: invalid_annotation_target

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
    @JsonKey(name: 'personal') @Default(false) bool isPersonal,
    @MapConverter() @Default(null) Map<String, String>? nameI18n,
    @MapConverter() @Default(null) Map<String, String>? descriptionI18n,
    @MapConverter() @Default(null) Map<String, String>? tipsI18n,
    @Default(null) Map<String, List<String>>? commonMistakesI18n,
    @Default(null) String? difficultyLevel,
    @Default(null) String? mechanicsType,
    @Default(null) String? forceType,
    @Default(null) String? kineticChain,
    @JsonKey(name: 'unilateral') @Default(null) bool? isUnilateral,
    @JsonKey(name: 'bodyweight') @Default(null) bool? isBodyweight,
    @Default(null) List<ExerciseVariantModel>? variants,
    @Default(null) List<ExerciseMediaModel>? media,
    @Default(null) List<ExerciseCategoryModel>? categories,
    @Default(null) ExerciseSafetyModel? safety,
    @Default(null) List<ExerciseMuscleModel>? muscles,
    @Default(null) List<ExerciseEquipmentModel>? equipments,
    @Default(null) List<TagModel>? tags,
  }) = _ExerciseDetailModel;

  factory ExerciseDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDetailModelFromJson(_normalizeCollectionFields(json));

  /// The exercise API has historically returned a single relation as an
  /// object, while the current contract exposes every relation as a list.
  /// Normalize the legacy shape at the boundary so the rest of the app can
  /// always work with collections.
  static Map<String, dynamic> _normalizeCollectionFields(
    Map<String, dynamic> json,
  ) {
    const collectionFields = {
      'variants',
      'media',
      'categories',
      'safety',
      'muscles',
      'equipments',
      'tags',
    };

    return json.map((key, value) {
      if (collectionFields.contains(key) && value is Map) {
        return MapEntry(key, [value]);
      }
      return MapEntry(key, value);
    });
  }
}
