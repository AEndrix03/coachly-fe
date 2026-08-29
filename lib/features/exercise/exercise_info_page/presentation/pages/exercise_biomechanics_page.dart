import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/coachly_concept_guide_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/widgets/exercise_detail_widgets.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_detail_view_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseBiomechanicsPage extends ConsumerWidget {
  final String exerciseId;

  const ExerciseBiomechanicsPage({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(exerciseDetailViewProvider(exerciseId));
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: asyncData.when(
        loading: () => const ExerciseLoadingView(),
        error: (_, _) => ExerciseErrorView(
          onRetry: () => ref.invalidate(exerciseDetailViewProvider(exerciseId)),
        ),
        data: (data) => ExerciseBiomechanicsContent(data: data),
      ),
    );
  }
}

class ExerciseBiomechanicsContent extends StatelessWidget {
  final ExerciseDetailViewData data;

  const ExerciseBiomechanicsContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final biomechanics = data.biomechanics;
    return ExerciseDetailScaffold(
      title: context.tr('exercise.biomechanics.title'),
      exerciseName: data.name,
      body: CustomScrollView(
        key: const Key('biomechanics-page-scroll'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            sliver: SliverList.list(
              children: [
                const ExerciseSectionTitle('Profilo del movimento'),
                const SizedBox(height: 12),
                _HeroMetric(
                  value: data.movementProfile.pattern,
                  label: context.tr('exercise.biomechanics.main_pattern'),
                ),
                const SizedBox(height: 12),
                _DataRows(
                  rows: [
                    if (data.movementProfile.kineticChain case final chain?)
                      if (chain.isNotEmpty) ('Catena cinetica', chain),
                    ('Lateralità', data.movementProfile.laterality),
                  ],
                ),
                const SizedBox(height: 28),
                ExerciseSectionTitle(
                  'Azioni articolari',
                  onInfo: () => showCoachlyInfoSheet(
                    context,
                    title: 'Azioni articolari',
                    description:
                        'Descrivono i principali movimenti delle articolazioni durante l’esercizio.',
                    whyItMatters:
                        'Rendono più semplice confrontare esercizi che sembrano simili ma seguono traiettorie diverse.',
                    guideTopic: CoachlyGuideTopic.jointActions,
                  ),
                ),
                const SizedBox(height: 12),
                if (biomechanics.jointActions.isEmpty)
                  Text(
                    context.tr('exercise.biomechanics.updating'),
                    style: TextStyle(color: colors.textSecondary),
                  )
                else
                  _DataRows(
                    rows: [
                      for (final action in biomechanics.jointActions)
                        (action.joint, action.action),
                    ],
                  ),
                const SizedBox(height: 28),
                ExerciseSectionTitle(
                  'Caratteristiche di allenamento',
                  onInfo: () => showCoachlyInfoSheet(
                    context,
                    title: 'Caratteristiche di allenamento',
                    description:
                        'Riassumono stabilità richiesta, carico spinale e difficoltà tecnica: tre aspetti distinti del modo in cui affronti l’esercizio.',
                    whyItMatters:
                        'Aiutano a scegliere e confrontare gli esercizi in base al contesto, senza trasformare una singola caratteristica in un giudizio di qualità.',
                    guideTopic: CoachlyGuideTopic.trainingCharacteristics,
                  ),
                ),
                const SizedBox(height: 12),
                _DataRows(
                  rows: [
                    ('Stabilità richiesta', biomechanics.training.stability),
                    (
                      context.tr('exercise.spinal_load'),
                      biomechanics.training.spinalLoad,
                    ),
                    (
                      'Richiesta tecnica',
                      biomechanics.training.technicalDemand,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ExerciseSectionTitle(
                  'Fonte di resistenza',
                  onInfo: () => showCoachlyInfoSheet(
                    context,
                    title: 'Fonte di resistenza',
                    description:
                        'Indica cosa genera la resistenza contro cui lavori, per esempio un cavo, un peso libero, una macchina o il peso corporeo.',
                    whyItMatters:
                        'La fonte influenza la direzione e la continuità della forza durante il movimento, senza determinare da sola quanto un esercizio sia efficace.',
                    guideTopic: CoachlyGuideTopic.resistanceSources,
                  ),
                ),
                const SizedBox(height: 12),
                _HeroMetric(
                  value: data.movementProfile.resistanceSource,
                  label: context.tr('exercise.biomechanics.resistance'),
                  compact: true,
                ),
                const SizedBox(height: 28),
                ExerciseSectionTitle(
                  'Profilo di resistenza',
                  onInfo: () => showCoachlyInfoSheet(
                    context,
                    title: 'Profilo di resistenza nel ROM',
                    description:
                        'Descrive come la richiesta esterna tende a cambiare dall’inizio alla fine del range di movimento.',
                    whyItMatters:
                        'Aiuta a capire in quali parti del gesto l’esercizio può risultare relativamente più o meno impegnativo.',
                    guideTopic: CoachlyGuideTopic.resistanceProfile,
                    disclaimer:
                        'È un profilo qualitativo indicativo, non una misurazione precisa della forza in ogni punto del movimento.',
                  ),
                ),
                const SizedBox(height: 12),
                if (biomechanics.resistanceProfile.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.show_chart_rounded,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            context.tr('exercise.biomechanics.no_profile'),
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: [
                        ResistanceProfileChart(
                          points: biomechanics.resistanceProfile,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.tr('exercise.rom_start'),
                              style: _caption(context, colors),
                            ),
                            Text(
                              context.tr('exercise.rom_end'),
                              style: _caption(context, colors),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.tr('exercise.profile_indicative'),
                          style: _caption(context, colors),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 28),
                const ExerciseSectionTitle('Dati e metodologia'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
                      _DataRows(
                        rows: [
                          ('Origine', biomechanics.evidenceOrigin),
                          ('Affidabilità', biomechanics.evidenceConfidence),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => showCoachlyInfoSheet(
                            context,
                            title: 'Come Coachly interpreta i dati',
                            description:
                                'Le indicazioni sintetizzano un modello qualitativo del movimento, non una misura diretta su ogni atleta.',
                            whyItMatters:
                                'Separare stime, osservazioni e misurazioni evita una falsa precisione.',
                            guideTopic: CoachlyGuideTopic.dataMethodology,
                          ),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(44, 44),
                            padding: EdgeInsets.zero,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  context.tr('exercise.biomechanics.how_read'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _caption(BuildContext context, CoachlyExerciseTheme colors) =>
      context.scale.caption.copyWith(color: colors.textSecondary);
}

class _HeroMetric extends StatelessWidget {
  final String value;
  final String label;
  final bool compact;

  const _HeroMetric({
    required this.value,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 20),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: colors.primary,
              fontSize: compact ? 20 : 26,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: colors.textSecondary)),
        ],
      ),
    );
  }
}

class _DataRows extends StatelessWidget {
  final List<(String, String)> rows;

  const _DataRows({required this.rows});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    rows[index].$1,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 1,
                  child: Text(
                    rows[index].$2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (index != rows.length - 1)
            Divider(height: 1, color: colors.border),
        ],
      ],
    );
  }
}
