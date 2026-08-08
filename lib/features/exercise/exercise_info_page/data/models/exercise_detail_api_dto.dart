class ExerciseDetailApiDto {
  final String id;
  final String code;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;
  final Map<String, String> tipsI18n;
  final String? catalogStatus;
  final String? exerciseKind;
  final String? technicalDemand;
  final String? jointClass;
  final String? kineticChain;
  final bool unilateral;
  final bool bodyweight;
  final Map<String, List<String>> commonMistakesI18n;
  final ExerciseMovementProfileApiDto movementProfile;
  final List<ExerciseMuscleApiDto> muscles;
  final ExerciseBiomechanicsApiDto? biomechanics;
  final ExerciseSafetyApiDto? safety;
  final List<ExerciseEquipmentApiDto> equipments;
  final List<ExerciseVariantApiDto> variants;
  final List<ExerciseMediaApiDto> media;

  const ExerciseDetailApiDto({
    required this.id,
    required this.code,
    required this.nameI18n,
    required this.descriptionI18n,
    required this.tipsI18n,
    required this.catalogStatus,
    required this.exerciseKind,
    required this.technicalDemand,
    required this.jointClass,
    required this.kineticChain,
    required this.unilateral,
    required this.bodyweight,
    required this.commonMistakesI18n,
    required this.movementProfile,
    required this.muscles,
    required this.biomechanics,
    required this.safety,
    required this.equipments,
    required this.variants,
    required this.media,
  });

  factory ExerciseDetailApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseDetailApiDto(
      id: _string(json['id']),
      code: _string(json['code']),
      nameI18n: _i18n(json['nameI18n']),
      descriptionI18n: _i18n(json['descriptionI18n']),
      tipsI18n: _i18n(json['tipsI18n']),
      catalogStatus: _nullableString(json['catalogStatus']),
      exerciseKind: _nullableString(json['exerciseKind']),
      technicalDemand: _nullableString(json['technicalDemand']),
      jointClass: _nullableString(json['jointClass']),
      kineticChain: _nullableString(json['kineticChain']),
      // Jackson normally strips the `is` prefix from Java boolean getters.
      // Accept both forms so the adapter is robust to mapper configuration.
      unilateral: _bool(json['unilateral'] ?? json['isUnilateral']),
      bodyweight: _bool(json['bodyweight'] ?? json['isBodyweight']),
      commonMistakesI18n: _i18nList(json['commonMistakesI18n']),
      movementProfile: ExerciseMovementProfileApiDto.fromJson(
        _jsonMap(json['movementProfile']),
      ),
      muscles: _jsonList(
        json['muscles'],
      ).map(ExerciseMuscleApiDto.fromJson).toList(growable: false),
      biomechanics: json['biomechanics'] == null
          ? null
          : ExerciseBiomechanicsApiDto.fromJson(_jsonMap(json['biomechanics'])),
      safety: json['safety'] == null
          ? null
          : ExerciseSafetyApiDto.fromJson(_jsonMap(json['safety'])),
      equipments: _jsonList(
        json['equipments'],
      ).map(ExerciseEquipmentApiDto.fromJson).toList(growable: false),
      variants: _jsonList(
        json['variants'],
      ).map(ExerciseVariantApiDto.fromJson).toList(growable: false),
      media: _jsonList(
        json['media'],
      ).map(ExerciseMediaApiDto.fromJson).toList(growable: false),
    );
  }
}

class ExerciseMovementProfileApiDto {
  final List<ExerciseMovementPatternApiDto> patterns;
  final List<ExerciseJointActionApiDto> jointActions;

  const ExerciseMovementProfileApiDto({
    required this.patterns,
    required this.jointActions,
  });

  factory ExerciseMovementProfileApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseMovementProfileApiDto(
      patterns: _jsonList(
        json['patterns'],
      ).map(ExerciseMovementPatternApiDto.fromJson).toList(growable: false),
      jointActions: _jsonList(
        json['jointActions'],
      ).map(ExerciseJointActionApiDto.fromJson).toList(growable: false),
    );
  }
}

class ExerciseMovementPatternApiDto {
  final String code;
  final Map<String, String> nameI18n;
  final String? role;

  const ExerciseMovementPatternApiDto({
    required this.code,
    required this.nameI18n,
    required this.role,
  });

  factory ExerciseMovementPatternApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseMovementPatternApiDto(
      code: _string(json['code']),
      nameI18n: _i18n(json['nameI18n']),
      role: _nullableString(json['role']),
    );
  }
}

class ExerciseJointActionApiDto {
  final String jointCode;
  final String actionCode;
  final Map<String, String> nameI18n;

  const ExerciseJointActionApiDto({
    required this.jointCode,
    required this.actionCode,
    required this.nameI18n,
  });

  factory ExerciseJointActionApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseJointActionApiDto(
      jointCode: _string(json['jointCode']),
      actionCode: _string(json['actionCode']),
      nameI18n: _i18n(json['nameI18n']),
    );
  }
}

class ExerciseMuscleApiDto {
  final ExerciseNamedResourceApiDto muscle;
  final String? involvement;
  final ExerciseTensionProfileApiDto? tensionProfile;

  const ExerciseMuscleApiDto({
    required this.muscle,
    required this.involvement,
    required this.tensionProfile,
  });

  factory ExerciseMuscleApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseMuscleApiDto(
      muscle: ExerciseNamedResourceApiDto.fromJson(_jsonMap(json['muscle'])),
      involvement: _nullableString(json['involvement']),
      tensionProfile: json['tensionProfile'] == null
          ? null
          : ExerciseTensionProfileApiDto.fromJson(
              _jsonMap(json['tensionProfile']),
            ),
    );
  }
}

class ExerciseTensionProfileApiDto {
  final String? lengthened;
  final String? midrange;
  final String? shortened;

  const ExerciseTensionProfileApiDto({
    required this.lengthened,
    required this.midrange,
    required this.shortened,
  });

  factory ExerciseTensionProfileApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseTensionProfileApiDto(
      lengthened: _nullableString(json['lengthened']),
      midrange: _nullableString(json['midrange']),
      shortened: _nullableString(json['shortened']),
    );
  }
}

class ExerciseBiomechanicsApiDto {
  final String? resistanceSource;
  final String? stabilityDemand;
  final String? spinalLoading;
  final String? externalResistanceProfile;
  final String? evidenceBasis;
  final String? confidence;

  const ExerciseBiomechanicsApiDto({
    required this.resistanceSource,
    required this.stabilityDemand,
    required this.spinalLoading,
    required this.externalResistanceProfile,
    required this.evidenceBasis,
    required this.confidence,
  });

  factory ExerciseBiomechanicsApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseBiomechanicsApiDto(
      resistanceSource: _nullableString(json['resistanceSource']),
      stabilityDemand: _nullableString(json['stabilityDemand']),
      spinalLoading: _nullableString(json['spinalLoading']),
      externalResistanceProfile: _nullableString(
        json['externalResistanceProfile'],
      ),
      evidenceBasis: _nullableString(json['evidenceBasis']),
      confidence: _nullableString(json['confidence']),
    );
  }
}

class ExerciseSafetyApiDto {
  final String? spotterPolicy;
  final Map<String, String> notesI18n;
  final Map<String, List<String>> notesListI18n;

  const ExerciseSafetyApiDto({
    required this.spotterPolicy,
    required this.notesI18n,
    required this.notesListI18n,
  });

  factory ExerciseSafetyApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseSafetyApiDto(
      spotterPolicy: _nullableString(json['spotterPolicy']),
      notesI18n: _i18n(json['notesI18n']),
      notesListI18n: _i18nList(json['notesListI18n']),
    );
  }
}

class ExerciseEquipmentApiDto {
  final ExerciseNamedResourceApiDto equipment;
  final bool required;

  const ExerciseEquipmentApiDto({
    required this.equipment,
    required this.required,
  });

  factory ExerciseEquipmentApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseEquipmentApiDto(
      equipment: ExerciseNamedResourceApiDto.fromJson(
        _jsonMap(json['equipment']),
      ),
      required: _bool(json['required'] ?? json['isRequired']),
    );
  }
}

class ExerciseVariantApiDto {
  final String id;
  final Map<String, String> nameI18n;
  final Map<String, String> descriptionI18n;
  final String? variationAxis;

  const ExerciseVariantApiDto({
    required this.id,
    required this.nameI18n,
    required this.descriptionI18n,
    required this.variationAxis,
  });

  factory ExerciseVariantApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseVariantApiDto(
      id: _string(json['id']),
      nameI18n: _i18n(json['nameI18n']),
      descriptionI18n: _i18n(json['descriptionI18n']),
      variationAxis: _nullableString(json['variationAxis']),
    );
  }
}

class ExerciseMediaApiDto {
  final String? mediaType;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final bool primary;
  final bool public;

  const ExerciseMediaApiDto({
    required this.mediaType,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.primary,
    required this.public,
  });

  factory ExerciseMediaApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseMediaApiDto(
      mediaType: _nullableString(json['mediaType']),
      mediaUrl: _nullableString(json['mediaUrl']),
      thumbnailUrl: _nullableString(json['thumbnailUrl']),
      primary: _bool(json['primary'] ?? json['isPrimary']),
      public: _bool(json['public'] ?? json['isPublic']),
    );
  }
}

class ExerciseNamedResourceApiDto {
  final String id;
  final String code;
  final Map<String, String> nameI18n;

  const ExerciseNamedResourceApiDto({
    required this.id,
    required this.code,
    required this.nameI18n,
  });

  factory ExerciseNamedResourceApiDto.fromJson(Map<String, dynamic> json) {
    return ExerciseNamedResourceApiDto(
      id: _string(json['id']),
      code: _string(json['code']),
      nameI18n: _i18n(json['nameI18n']),
    );
  }
}

Map<String, dynamic> _jsonMap(Object? value) {
  if (value is! Map) return const {};
  return value.map((key, item) => MapEntry(key.toString(), item));
}

List<Map<String, dynamic>> _jsonList(Object? value) {
  if (value is! List) return const [];
  return value.whereType<Map>().map(_jsonMap).toList(growable: false);
}

Map<String, String> _i18n(Object? value) {
  if (value is! Map) return const {};
  return {
    for (final entry in value.entries)
      if (entry.value != null)
        entry.key.toString(): entry.value is List
            ? (entry.value as List).join('\n')
            : entry.value.toString(),
  };
}

Map<String, List<String>> _i18nList(Object? value) {
  if (value is! Map) return const {};
  return {
    for (final entry in value.entries)
      entry.key.toString(): switch (entry.value) {
        final List items =>
          items
              .where((item) => item != null)
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList(growable: false),
        final String text =>
          text
              .split(RegExp(r'\r?\n|•'))
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList(growable: false),
        _ => const <String>[],
      },
  };
}

String _string(Object? value) => value?.toString() ?? '';

String? _nullableString(Object? value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}

bool _bool(Object? value) => value == true || value?.toString() == 'true';
