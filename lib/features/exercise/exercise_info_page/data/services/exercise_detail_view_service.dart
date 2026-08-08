import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/exercise_detail_api_dto.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/material.dart';

abstract interface class ExerciseDetailViewService {
  Future<ExerciseDetailViewData> fetch(String exerciseId, Locale locale);

  Future<List<ExerciseDetailViewData>> fetchAll(Locale locale);
}

class ApiExerciseDetailViewService implements ExerciseDetailViewService {
  final ApiClient _apiClient;

  const ApiExerciseDetailViewService(this._apiClient);

  @override
  Future<ExerciseDetailViewData> fetch(String exerciseId, Locale locale) async {
    final response = await _apiClient.get<ExerciseDetailApiDto>(
      '/exercises/$exerciseId/details',
      fromJson: (json) =>
          ExerciseDetailApiDto.fromJson(Map<String, dynamic>.from(json as Map)),
    );
    final exercise = response.data;
    if (!response.success || exercise == null) {
      throw StateError(response.message ?? 'Impossibile caricare l’esercizio');
    }

    return _toViewData(exercise, exerciseId, locale);
  }

  @override
  Future<List<ExerciseDetailViewData>> fetchAll(Locale locale) async {
    final response = await _apiClient.get<List<ExerciseDetailApiDto>>(
      '/exercises/filtered',
      fromJson: (json) => (json as List)
          .map(
            (item) => ExerciseDetailApiDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
    );
    final exercises = response.data;
    if (!response.success || exercises == null) {
      throw StateError(response.message ?? 'Impossibile caricare gli esercizi');
    }
    return exercises
        .map((exercise) => _toViewData(exercise, exercise.id, locale))
        .toList(growable: false);
  }

  static ExerciseDetailViewData _toViewData(
    ExerciseDetailApiDto exercise,
    String requestedId,
    Locale locale,
  ) {
    final primaryPattern = _primaryPattern(exercise.movementProfile.patterns);
    final pattern = _localized(
      primaryPattern?.nameI18n ?? const {},
      locale,
      fallback: _humanize(primaryPattern?.code),
    );
    final biomechanics = exercise.biomechanics;
    final media = _preferredMedia(exercise.media);
    final safetyNote = _safetyNote(exercise.safety, locale);

    return ExerciseDetailViewData(
      id: exercise.id.isNotEmpty ? exercise.id : requestedId,
      code: exercise.code.isNotEmpty ? exercise.code : requestedId,
      name: _localized(exercise.nameI18n, locale, fallback: 'Esercizio'),
      description: exercise.descriptionI18n.fromI18n(locale).trim(),
      catalogStatus: _label(exercise.catalogStatus),
      exerciseKind: _label(exercise.exerciseKind),
      unilateral: exercise.unilateral,
      bodyweight: exercise.bodyweight,
      media: ExerciseMediaViewData(
        kind: media == null
            ? ExerciseMediaKind.placeholder
            : media.mediaType?.toLowerCase() == 'video'
            ? ExerciseMediaKind.video
            : ExerciseMediaKind.image,
        url: media?.mediaUrl,
        thumbnailUrl: media?.thumbnailUrl,
        movementLabel: pattern,
      ),
      movementProfile: ExerciseMovementProfileViewData(
        pattern: pattern,
        jointClass: _label(exercise.jointClass),
        resistanceSource: _label(biomechanics?.resistanceSource),
        kineticChain: exercise.kineticChain == null
            ? null
            : _label(exercise.kineticChain),
        laterality: exercise.unilateral ? 'Unilaterale' : 'Bilaterale',
      ),
      muscles: [
        for (final association in exercise.muscles)
          MuscleViewData(
            id: association.muscle.id.isNotEmpty
                ? association.muscle.id
                : association.muscle.code,
            name: _localized(
              association.muscle.nameI18n,
              locale,
              fallback: _humanize(association.muscle.code),
            ),
            role: _muscleRole(association.involvement),
            tension: MuscleTensionViewData(
              lengthened: _tension(association.tensionProfile?.lengthened),
              midRange: _tension(association.tensionProfile?.midrange),
              shortened: _tension(association.tensionProfile?.shortened),
            ),
          ),
      ],
      biomechanics: ExerciseBiomechanicsViewData(
        training: ExerciseTrainingCharacteristicsViewData(
          stability: _label(biomechanics?.stabilityDemand),
          spinalLoad: _label(biomechanics?.spinalLoading),
          technicalDemand: _label(exercise.technicalDemand),
        ),
        jointActions: [
          for (final action in exercise.movementProfile.jointActions)
            JointActionViewData(
              joint: _label(action.jointCode),
              action: _localized(
                action.nameI18n,
                locale,
                fallback: _humanize(action.actionCode),
              ),
            ),
        ],
        resistanceProfile: _resistanceProfile(
          biomechanics?.externalResistanceProfile,
        ),
        evidenceOrigin: _label(biomechanics?.evidenceBasis),
        evidenceConfidence: _label(biomechanics?.confidence),
      ),
      equipment: [
        for (final association in exercise.equipments)
          EquipmentViewData(
            name: _localized(
              association.equipment.nameI18n,
              locale,
              fallback: _humanize(association.equipment.code),
            ),
            required: association.required,
          ),
      ],
      execution: ExerciseExecutionViewData(
        steps: _executionSteps(exercise.tipsI18n.fromI18n(locale)),
        commonMistakes: _localizedList(exercise.commonMistakesI18n, locale),
      ),
      variants: [
        for (final variant in exercise.variants)
          VariantViewData(
            id: variant.id,
            name: _localized(variant.nameI18n, locale, fallback: 'Variante'),
            relationAxis: _label(variant.variationAxis),
            similarity: null,
            summary: variant.descriptionI18n.fromI18n(locale).trim(),
          ),
      ],
      safetyNote: safetyNote,
    );
  }

  static ExerciseMovementPatternApiDto? _primaryPattern(
    List<ExerciseMovementPatternApiDto> patterns,
  ) {
    for (final pattern in patterns) {
      if (pattern.role?.toLowerCase() == 'primary') return pattern;
    }
    return patterns.isEmpty ? null : patterns.first;
  }

  static ExerciseMediaApiDto? _preferredMedia(List<ExerciseMediaApiDto> media) {
    final visible = media.where((item) => item.public).toList(growable: false);
    for (final item in visible) {
      if (item.primary) return item;
    }
    return visible.isEmpty ? null : visible.first;
  }

  static String _localized(
    Map<String, String> values,
    Locale locale, {
    required String fallback,
  }) {
    final localized = values.fromI18n(locale).trim();
    return localized.isEmpty ? fallback : localized;
  }

  static List<String> _localizedList(
    Map<String, List<String>> values,
    Locale locale,
  ) {
    if (values.isEmpty) return const [];
    final language = locale.languageCode.toLowerCase();
    final country = locale.countryCode?.toLowerCase();
    final candidates = [
      if (country != null && country.isNotEmpty) '${language}_$country',
      language,
      'en',
      'en_us',
    ];
    final normalized = {
      for (final entry in values.entries)
        entry.key.toLowerCase().replaceAll('-', '_'): entry.value,
    };
    for (final candidate in candidates) {
      final items = normalized[candidate];
      if (items != null && items.isNotEmpty) return items;
    }
    return normalized.values.firstWhere(
      (items) => items.isNotEmpty,
      orElse: () => const [],
    );
  }

  static List<String> _executionSteps(String tips) => tips
      .split(RegExp(r'(?:\r?\n|•|\s+\d+[.)]\s+)'))
      .map((item) => item.replaceFirst(RegExp(r'^\s*[-–]\s*'), '').trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  static String _safetyNote(ExerciseSafetyApiDto? safety, Locale locale) {
    if (safety == null) return '';
    final note = safety.notesI18n.fromI18n(locale).trim();
    if (note.isNotEmpty) return note;
    return switch (safety.spotterPolicy?.toLowerCase()) {
      'recommended' => 'È consigliata l’assistenza di uno spotter.',
      'recommended_high_effort' =>
        'È consigliata l’assistenza di uno spotter nelle serie ad alta intensità.',
      _ => '',
    };
  }

  static MuscleRole _muscleRole(String? value) =>
      switch (value?.toLowerCase()) {
        'primary' => MuscleRole.primary,
        'stabilizer' => MuscleRole.stabilizer,
        _ => MuscleRole.secondary,
      };

  static TensionLevel _tension(String? value) => switch (value?.toLowerCase()) {
    'low' => TensionLevel.low,
    'moderate' => TensionLevel.moderate,
    'high' => TensionLevel.high,
    _ => TensionLevel.none,
  };

  static List<double> _resistanceProfile(String? value) =>
      switch (value?.toLowerCase()) {
        'early_rom' => const [0.9, 0.8, 0.68, 0.54, 0.42],
        'mid_rom' => const [0.44, 0.64, 0.9, 0.64, 0.44],
        'late_rom' => const [0.4, 0.52, 0.66, 0.8, 0.92],
        'even' => const [0.68, 0.69, 0.68, 0.69, 0.68],
        'variable' => const [0.48, 0.76, 0.56, 0.82, 0.58],
        _ => const [],
      };

  static String _label(String? raw) {
    final value = raw?.toLowerCase();
    const labels = <String, String>{
      'standard': 'Standard',
      'verified': 'Verificato',
      'draft': 'Bozza',
      'resistance': 'Resistenza',
      'mobility': 'Mobilità',
      'conditioning': 'Condizionamento',
      'single_joint': 'Monoarticolare',
      'multi_joint': 'Multiarticolare',
      'open': 'Aperta',
      'closed': 'Chiusa',
      'low': 'Bassa',
      'moderate': 'Moderata',
      'high': 'Alta',
      'none': 'Nessuno',
      'gravity': 'Gravità',
      'cable': 'Cavo',
      'band': 'Elastico',
      'cam_machine': 'Macchina a camma',
      'bodyweight_leverage': 'Peso corporeo',
      'hydraulic': 'Resistenza idraulica',
      'isometric_external': 'Resistenza isometrica esterna',
      'shoulder': 'Spalla',
      'elbow': 'Gomito',
      'scapula': 'Scapola',
      'hip': 'Anca',
      'knee': 'Ginocchio',
      'ankle': 'Caviglia',
      'spine': 'Colonna',
      'grip': 'Presa',
      'unilateral': 'Unilaterale',
      'equipment': 'Attrezzatura',
      'stance': 'Posizione',
      'angle': 'Angolo',
      'rom': 'Range di movimento',
      'resistance_source': 'Resistenza',
      'technique': 'Tecnica',
      'tempo': 'Tempo',
      'assistance': 'Assistenza',
      'measured': 'Misurazioni',
      'literature': 'Letteratura',
      'biomechanical_model': 'Modello biomeccanico',
      'expert_curated': 'Revisione esperta',
      'heuristic': 'Stima euristica',
      'curated': 'Dati revisionati',
      'modeled': 'Dati modellati',
      'estimated': 'Dati stimati',
    };
    return labels[value] ?? _humanize(raw);
  }

  static String _humanize(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    return value
        .replaceAll('_', ' ')
        .trim()
        .split(RegExp(r'\s+'))
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
