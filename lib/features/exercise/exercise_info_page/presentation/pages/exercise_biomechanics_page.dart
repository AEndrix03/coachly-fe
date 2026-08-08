import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/widgets/exercise_detail_widgets.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_detail_view_provider.dart';
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
      title: 'Biomeccanica',
      exerciseName: data.name,
      body: CustomScrollView(
        key: const Key('biomechanics-page-scroll'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverList.list(
              children: [
                const ExerciseSectionTitle('Profilo del movimento'),
                const SizedBox(height: 14),
                _HeroMetric(
                  value: data.movementProfile.pattern,
                  label: 'Pattern principale',
                ),
                const SizedBox(height: 16),
                _DataRows(
                  rows: [
                    ('Catena cinetica', data.movementProfile.kineticChain),
                    ('Lateralità', data.movementProfile.laterality),
                  ],
                ),
                const SizedBox(height: 34),
                ExerciseSectionTitle(
                  'Azioni articolari',
                  onInfo: () => showCoachlyInfoSheet(
                    context,
                    title: 'Azioni articolari',
                    description:
                        'Descrivono i principali movimenti delle articolazioni durante l’esercizio.',
                    whyItMatters:
                        'Rendono più semplice confrontare esercizi che sembrano simili ma seguono traiettorie diverse.',
                  ),
                ),
                const SizedBox(height: 12),
                if (biomechanics.jointActions.isEmpty)
                  Text(
                    'Dati in aggiornamento',
                    style: TextStyle(color: colors.textSecondary),
                  )
                else
                  _DataRows(
                    rows: [
                      for (final action in biomechanics.jointActions)
                        (action.joint, action.action),
                    ],
                  ),
                const SizedBox(height: 34),
                ExerciseSectionTitle(
                  'Caratteristiche di allenamento',
                  onInfo: () => showCoachlyInfoSheet(
                    context,
                    title: 'Stabilità richiesta',
                    description:
                        'Indica quanto controllo esterno fornisce l’esercizio e quanta stabilizzazione devi produrre tu.',
                    whyItMatters:
                        'Più stabilità può aiutare a concentrarsi sul target, ma non rende automaticamente un esercizio migliore.',
                  ),
                ),
                const SizedBox(height: 12),
                _CharacteristicGrid(training: biomechanics.training),
                const SizedBox(height: 34),
                const ExerciseSectionTitle('Fonte di resistenza'),
                const SizedBox(height: 12),
                _HeroMetric(
                  value: data.movementProfile.resistanceSource,
                  label: 'Resistenza esterna',
                  compact: true,
                ),
                if (biomechanics.resistanceProfile.isNotEmpty) ...[
                  const SizedBox(height: 34),
                  const ExerciseSectionTitle('Profilo di resistenza'),
                  const SizedBox(height: 12),
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
                            Text('Inizio ROM', style: _caption(colors)),
                            Text('Fine ROM', style: _caption(colors)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Profilo indicativo', style: _caption(colors)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 34),
                const ExerciseSectionTitle('Dati e metodologia'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
                      _EvidenceRow(
                        label: 'Origine',
                        value: biomechanics.evidenceOrigin,
                      ),
                      const SizedBox(height: 14),
                      _EvidenceRow(
                        label: 'Affidabilità',
                        value: biomechanics.evidenceConfidence,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => showCoachlyInfoSheet(
                            context,
                            title: 'Come Coachly interpreta i dati',
                            description:
                                'Le indicazioni sintetizzano un modello qualitativo del movimento, non una misura diretta su ogni atleta.',
                            whyItMatters:
                                'Separare stime, osservazioni e misurazioni evita una falsa precisione.',
                          ),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(44, 44),
                            padding: EdgeInsets.zero,
                          ),
                          icon: const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                          ),
                          label: const Text(
                            'Come Coachly interpreta questi dati',
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

  TextStyle _caption(CoachlyExerciseTheme colors) =>
      TextStyle(color: colors.textSecondary, fontSize: 12);
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
      padding: EdgeInsets.all(compact ? 17 : 22),
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
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    rows[index].$1,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
                const SizedBox(width: 18),
                Flexible(
                  child: Text(
                    rows[index].$2,
                    textAlign: TextAlign.end,
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

class _CharacteristicGrid extends StatelessWidget {
  final ExerciseTrainingCharacteristicsViewData training;

  const _CharacteristicGrid({required this.training});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _CharacteristicTile(
              width: itemWidth,
              label: 'Stabilità richiesta',
              value: training.stability,
            ),
            _CharacteristicTile(
              width: itemWidth,
              label: 'Carico spinale',
              value: training.spinalLoad,
            ),
            _CharacteristicTile(
              width: itemWidth,
              label: 'Richiesta tecnica',
              value: training.technicalDemand,
            ),
          ],
        );
      },
    );
  }
}

class _CharacteristicTile extends StatelessWidget {
  final double width;
  final String label;
  final String value;

  const _CharacteristicTile({
    required this.width,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 92),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _EvidenceRow extends StatelessWidget {
  final String label;
  final String value;

  const _EvidenceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: colors.textSecondary)),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
