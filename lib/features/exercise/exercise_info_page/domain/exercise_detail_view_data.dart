import 'package:flutter/foundation.dart';

enum ExerciseMediaKind { video, image, placeholder }

enum MuscleRole { primary, secondary, stabilizer }

enum TensionLevel { none, low, moderate, high }

enum VariantSimilarity { verySimilar, similar, different }

@immutable
class ExerciseMediaViewData {
  final ExerciseMediaKind kind;
  final String? url;
  final String? thumbnailUrl;
  final String movementLabel;

  const ExerciseMediaViewData({
    required this.kind,
    this.url,
    this.thumbnailUrl,
    required this.movementLabel,
  });
}

@immutable
class ExerciseMovementProfileViewData {
  final String pattern;
  final String jointClass;
  final String resistanceSource;
  final String? kineticChain;
  final String laterality;

  const ExerciseMovementProfileViewData({
    required this.pattern,
    required this.jointClass,
    required this.resistanceSource,
    required this.kineticChain,
    required this.laterality,
  });
}

@immutable
class ExerciseTrainingCharacteristicsViewData {
  final String stability;
  final String spinalLoad;
  final String technicalDemand;

  const ExerciseTrainingCharacteristicsViewData({
    required this.stability,
    required this.spinalLoad,
    required this.technicalDemand,
  });
}

@immutable
class JointActionViewData {
  final String joint;
  final String action;

  const JointActionViewData({required this.joint, required this.action});
}

@immutable
class MuscleTensionViewData {
  final TensionLevel lengthened;
  final TensionLevel midRange;
  final TensionLevel shortened;

  const MuscleTensionViewData({
    required this.lengthened,
    required this.midRange,
    required this.shortened,
  });
}

@immutable
class MuscleViewData {
  final String id;
  final String name;
  final MuscleRole role;
  final MuscleTensionViewData tension;

  const MuscleViewData({
    required this.id,
    required this.name,
    required this.role,
    required this.tension,
  });
}

@immutable
class EquipmentViewData {
  final String name;
  final bool required;

  const EquipmentViewData({required this.name, required this.required});
}

@immutable
class VariantViewData {
  final String id;
  final String name;
  final String relationAxis;
  final VariantSimilarity? similarity;
  final String summary;

  const VariantViewData({
    required this.id,
    required this.name,
    required this.relationAxis,
    required this.similarity,
    required this.summary,
  });
}

@immutable
class ExerciseBiomechanicsViewData {
  final ExerciseTrainingCharacteristicsViewData training;
  final List<JointActionViewData> jointActions;
  final List<double> resistanceProfile;
  final String evidenceOrigin;
  final String evidenceConfidence;

  const ExerciseBiomechanicsViewData({
    required this.training,
    required this.jointActions,
    required this.resistanceProfile,
    required this.evidenceOrigin,
    required this.evidenceConfidence,
  });
}

@immutable
class ExerciseExecutionViewData {
  final List<String> steps;
  final List<String> commonMistakes;

  const ExerciseExecutionViewData({
    required this.steps,
    required this.commonMistakes,
  });
}

@immutable
class ExerciseDetailViewData {
  final String id;
  final String code;
  final String name;
  final String description;
  final String catalogStatus;
  final String exerciseKind;
  final bool unilateral;
  final bool bodyweight;
  final ExerciseMediaViewData media;
  final ExerciseMovementProfileViewData movementProfile;
  final List<MuscleViewData> muscles;
  final ExerciseBiomechanicsViewData biomechanics;
  final List<EquipmentViewData> equipment;
  final ExerciseExecutionViewData execution;
  final List<VariantViewData> variants;
  final String safetyNote;

  const ExerciseDetailViewData({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.catalogStatus,
    required this.exerciseKind,
    required this.unilateral,
    required this.bodyweight,
    required this.media,
    required this.movementProfile,
    required this.muscles,
    required this.biomechanics,
    required this.equipment,
    required this.execution,
    required this.variants,
    required this.safetyNote,
  });
}
