// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseDetailModel _$ExerciseDetailModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseDetailModel(
  id: json['id'] as String? ?? null,
  createdBy: json['createdBy'] as String? ?? null,
  isPersonal: json['personal'] as bool? ?? false,
  nameI18n: json['nameI18n'] == null
      ? null
      : const MapConverter().fromJson(json['nameI18n']),
  descriptionI18n: json['descriptionI18n'] == null
      ? null
      : const MapConverter().fromJson(json['descriptionI18n']),
  tipsI18n: json['tipsI18n'] == null
      ? null
      : const MapConverter().fromJson(json['tipsI18n']),
  commonMistakesI18n:
      (json['commonMistakesI18n'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      null,
  difficultyLevel: json['difficultyLevel'] as String? ?? null,
  mechanicsType: json['mechanicsType'] as String? ?? null,
  forceType: json['forceType'] as String? ?? null,
  kineticChain: json['kineticChain'] as String? ?? null,
  isUnilateral: json['unilateral'] as bool? ?? null,
  isBodyweight: json['bodyweight'] as bool? ?? null,
  variants:
      (json['variants'] as List<dynamic>?)
          ?.map((e) => ExerciseVariantModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => ExerciseMediaModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      null,
  safety: json['safety'] == null
      ? null
      : ExerciseSafetyModel.fromJson(json['safety'] as Map<String, dynamic>),
  muscles:
      (json['muscles'] as List<dynamic>?)
          ?.map((e) => ExerciseMuscleModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
  equipments:
      (json['equipments'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseEquipmentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      null,
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      null,
);

Map<String, dynamic> _$ExerciseDetailModelToJson(
  _ExerciseDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdBy': instance.createdBy,
  'personal': instance.isPersonal,
  'nameI18n': const MapConverter().toJson(instance.nameI18n),
  'descriptionI18n': const MapConverter().toJson(instance.descriptionI18n),
  'tipsI18n': const MapConverter().toJson(instance.tipsI18n),
  'commonMistakesI18n': instance.commonMistakesI18n,
  'difficultyLevel': instance.difficultyLevel,
  'mechanicsType': instance.mechanicsType,
  'forceType': instance.forceType,
  'kineticChain': instance.kineticChain,
  'unilateral': instance.isUnilateral,
  'bodyweight': instance.isBodyweight,
  'variants': instance.variants,
  'media': instance.media,
  'categories': instance.categories,
  'safety': instance.safety,
  'muscles': instance.muscles,
  'equipments': instance.equipments,
  'tags': instance.tags,
};
