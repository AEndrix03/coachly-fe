import 'package:coachly/features/exercise/exercise_info_page/data/fixtures/exercise_detail_mock_fixture.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/material.dart';

abstract interface class ExerciseDetailViewService {
  Future<ExerciseDetailViewData> fetch(String exerciseId, Locale locale);
}

class MockExerciseDetailViewService implements ExerciseDetailViewService {
  const MockExerciseDetailViewService();

  @override
  Future<ExerciseDetailViewData> fetch(String exerciseId, Locale locale) async {
    return latPulldownExerciseFixture;
  }
}

class ApiExerciseDetailViewService implements ExerciseDetailViewService {
  final IExerciseInfoPageRepository _repository;

  const ApiExerciseDetailViewService(this._repository);

  @override
  Future<ExerciseDetailViewData> fetch(String exerciseId, Locale locale) async {
    final response = await _repository.getExerciseDetail(exerciseId);
    final exercise = response.data;
    if (!response.success || exercise == null) {
      throw StateError(response.message ?? 'Impossibile caricare l’esercizio');
    }

    final media =
        exercise.media?.where((item) => item.isPrimary).firstOrNull ??
        exercise.media?.firstOrNull;
    final localizedName = exercise.nameI18n?.fromI18n(locale).trim();
    final localizedDescription = exercise.descriptionI18n
        ?.fromI18n(locale)
        .trim();
    final tips = exercise.tipsI18n?.fromI18n(locale).trim() ?? '';
    final steps = tips
        .split(RegExp(r'[\n•]+'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return ExerciseDetailViewData(
      id: exercise.id ?? exerciseId,
      code: exercise.id ?? exerciseId,
      name: localizedName?.isNotEmpty == true ? localizedName! : 'Esercizio',
      description: localizedDescription?.isNotEmpty == true
          ? localizedDescription!
          : 'Scopri tecnica, muscoli coinvolti e caratteristiche del movimento.',
      catalogStatus: exercise.isPersonal ? 'personal' : 'published',
      exerciseKind: exercise.mechanicsType ?? 'Multi-joint',
      unilateral: exercise.isUnilateral ?? false,
      bodyweight: exercise.isBodyweight ?? false,
      media: ExerciseMediaViewData(
        kind: media == null
            ? ExerciseMediaKind.placeholder
            : media.mediaType.toLowerCase().contains('video')
            ? ExerciseMediaKind.video
            : ExerciseMediaKind.image,
        url: media?.mediaUrl,
        thumbnailUrl: media?.thumbnailUrl,
        movementLabel: _humanize(exercise.forceType ?? 'Movement'),
      ),
      movementProfile: ExerciseMovementProfileViewData(
        pattern: _humanize(exercise.forceType ?? 'Movement'),
        jointClass: _humanize(exercise.mechanicsType ?? 'Multi-joint'),
        resistanceSource: exercise.isBodyweight.bodyweightLabel,
        kineticChain: 'Non disponibile',
        laterality: exercise.isUnilateral == true
            ? 'Unilaterale'
            : 'Bilaterale',
      ),
      muscles: [
        for (final item in exercise.muscles ?? const [])
          MuscleViewData(
            id: item.muscle?.id ?? 'muscle',
            name: item.muscle?.nameI18n.fromI18n(locale) ?? 'Muscolo',
            role: MuscleRole.secondary,
            tension: const MuscleTensionViewData(
              lengthened: TensionLevel.moderate,
              midRange: TensionLevel.moderate,
              shortened: TensionLevel.moderate,
            ),
          ),
      ],
      biomechanics: ExerciseBiomechanicsViewData(
        training: ExerciseTrainingCharacteristicsViewData(
          stability: 'Non disponibile',
          spinalLoad: 'Non disponibile',
          technicalDemand: _humanize(exercise.difficultyLevel ?? 'Moderata'),
        ),
        jointActions: const [],
        resistanceProfile: const [],
        evidenceOrigin: 'Dati catalogo Coachly',
        evidenceConfidence: 'In aggiornamento',
      ),
      equipment: [
        for (final item in exercise.equipments ?? const [])
          EquipmentViewData(
            name: item.equipment.nameI18n.fromI18n(locale),
            required: item.isRequired,
          ),
      ],
      execution: ExerciseExecutionViewData(
        steps: steps.isEmpty
            ? const [
                'Imposta una posizione stabile.',
                'Esegui il movimento con controllo.',
                'Mantieni una respirazione regolare.',
              ]
            : steps,
        commonMistakes: const [],
      ),
      variants: [
        for (final item in exercise.variants ?? const [])
          VariantViewData(
            id: item.id ?? '',
            name: item.nameI18n?.fromI18n(locale) ?? 'Variante',
            relationAxis: 'Tecnica',
            similarity: VariantSimilarity.similar,
            summary:
                item.descriptionI18n?.fromI18n(locale) ??
                'Una diversa interpretazione dello stesso pattern.',
          ),
      ],
      safetyNote:
          exercise.safety?.firstOrNull?.safetyNotesI18n.fromI18n(locale) ?? '',
    );
  }

  static String _humanize(String value) => value
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map(
        (part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}

extension on bool? {
  String get bodyweightLabel =>
      this is bool && this == true ? 'Corpo libero' : 'Attrezzatura';
}
