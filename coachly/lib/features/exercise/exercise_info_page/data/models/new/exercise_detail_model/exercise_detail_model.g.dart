// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseDetailModel _$ExerciseDetailModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseDetailModel(
  id: json['id'] as String,
  nameI18n: Map<String, String>.from(json['nameI18n'] as Map),
  descriptionI18n: Map<String, String>.from(json['descriptionI18n'] as Map),
  tipsI18n: Map<String, String>.from(json['tipsI18n'] as Map),
  difficultyLevel: json['difficultyLevel'] as String,
  mechanicsType: json['mechanicsType'] as String,
  forceType: json['forceType'] as String,
  isUnilateral: json['isUnilateral'] as bool,
  isBodyweight: json['isBodyweight'] as bool,
  environment: json['environment'] == null
      ? null
      : ExerciseEnvironmentModel.fromJson(
          json['environment'] as Map<String, dynamic>,
        ),
  instructions:
      (json['instructions'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseInstructionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  movementPattern: json['movementPattern'] == null
      ? null
      : ExerciseMovementPatternModel.fromJson(
          json['movementPattern'] as Map<String, dynamic>,
        ),
  variants:
      (json['variants'] as List<dynamic>?)
          ?.map((e) => ExerciseVariantModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => ExerciseMediaModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  safety:
      (json['safety'] as List<dynamic>?)
          ?.map((e) => ExerciseSafetyModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  safetyContraindications:
      (json['safetyContraindications'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseSafetyContraindicationModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  muscles:
      (json['muscles'] as List<dynamic>?)
          ?.map((e) => ExerciseMuscleModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  equipments:
      (json['equipments'] as List<dynamic>?)
          ?.map(
            (e) => ExerciseEquipmentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExerciseDetailModelToJson(
  _ExerciseDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameI18n': instance.nameI18n,
  'descriptionI18n': instance.descriptionI18n,
  'tipsI18n': instance.tipsI18n,
  'difficultyLevel': instance.difficultyLevel,
  'mechanicsType': instance.mechanicsType,
  'forceType': instance.forceType,
  'isUnilateral': instance.isUnilateral,
  'isBodyweight': instance.isBodyweight,
  'environment': instance.environment,
  'instructions': instance.instructions,
  'movementPattern': instance.movementPattern,
  'variants': instance.variants,
  'media': instance.media,
  'categories': instance.categories,
  'safety': instance.safety,
  'safetyContraindications': instance.safetyContraindications,
  'muscles': instance.muscles,
  'equipments': instance.equipments,
  'tags': instance.tags,
};
