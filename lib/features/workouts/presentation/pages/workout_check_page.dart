import 'package:coachly/design_system/components/product/coachly_loading.dart';
import 'package:coachly/features/exercises/domain/exercise_detail_view_data.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/design_system/components/product/muscle_anatomy_view.dart';
import 'package:coachly/features/workouts/domain/workout_draft.dart';
import 'package:coachly/features/workouts/domain/workout_check_models.dart';
import 'package:coachly/features/workouts/application/workout_check_provider.dart';
import 'package:coachly/shared/design_system/coachly_floating_bubble.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutCheckPage extends ConsumerWidget {
  final WorkoutDraft draft;

  const WorkoutCheckPage({super.key, required this.draft});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(workoutCheckProvider(draft));
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: Scaffold(
        backgroundColor: context.exerciseTheme.background,
        appBar: AppBar(
          backgroundColor: context.exerciseTheme.background,
          surfaceTintColor: Colors.transparent,
          title: Text(context.l10n.workoutCheckTitle),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Hero(
                tag: 'workout-check-${draft.localDraftId}',
                child: const Material(
                  color: Colors.transparent,
                  child: CoachlyWorkoutCheckGlyph(size: 26),
                ),
              ),
            ),
          ],
        ),
        body: draft.exerciseCount == 0
            ? _EmptyWorkoutCheck(onAddExercise: () => context.pop(true))
            : report.when(
                loading: () =>
                    const CoachlyLoadingSection(sceneKey: 'workout-check'),
                error: (_, _) => _CheckUnavailable(
                  onRetry: () => ref.invalidate(workoutCheckProvider(draft)),
                ),
                data: (value) => _WorkoutCheckReportView(report: value),
              ),
      ),
    );
  }
}

class _EmptyWorkoutCheck extends StatelessWidget {
  final VoidCallback onAddExercise;
  const _EmptyWorkoutCheck({required this.onAddExercise});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
    children: [
      const Center(child: CoachlyWorkoutCheckGlyph(size: 44)),
      const SizedBox(height: 24),
      Text(
        context.l10n.workoutCheckEmptyTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: context.exerciseTheme.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        context.l10n.workoutCheckEmptyBody,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: context.exerciseTheme.textSecondary,
          height: 1.45,
        ),
      ),
      const SizedBox(height: 26),
      CoachlySurface(
        child: Column(
          children: [
            for (final key in const [
              'muscles',
              'patterns',
              'overlap',
              'structure',
              'goal',
            ])
              _CapabilityRow(
                label: context.tr('workout.check.capability_$key'),
              ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: context.exerciseTheme.primary,
          foregroundColor: context.exerciseTheme.background,
          minimumSize: const Size.fromHeight(56),
        ),
        onPressed: onAddExercise,
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.workoutBuilderAddExercise),
      ),
    ],
  );
}

class _CapabilityRow extends StatelessWidget {
  final String label;
  const _CapabilityRow({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(
          Icons.check_rounded,
          size: 18,
          color: context.exerciseTheme.primary,
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
      ],
    ),
  );
}

class _WorkoutCheckReportView extends StatelessWidget {
  final WorkoutCheckReport report;
  const _WorkoutCheckReportView({required this.report});

  @override
  Widget build(BuildContext context) {
    final muscles = report.muscleSetExposure.entries
        .map(
          (entry) => MuscleViewData(
            id: entry.key.toLowerCase().replaceAll(' ', '-'),
            name: entry.key,
            role: MuscleRole.primary,
            tension: const MuscleTensionViewData(
              lengthened: TensionLevel.none,
              midRange: TensionLevel.none,
              shortened: TensionLevel.none,
            ),
          ),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Text(
          context.l10n.workoutCheckModeBodybuilding,
          style: TextStyle(
            color: context.exerciseTheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.workoutCheckSummary(
            '${report.positiveCount}',
            '${report.reviewCount}',
            '${report.insufficientCount}',
          ),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: context.exerciseTheme.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (report.dataQuality != WorkoutCheckDataQuality.complete) ...[
          const SizedBox(height: 10),
          Text(
            context.tr(
              report.dataQuality == WorkoutCheckDataQuality.insufficient
                  ? 'workout.check.data_insufficient'
                  : 'workout.check.data_partial',
            ),
            style: TextStyle(
              color: context.exerciseTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ],
        if (muscles.isNotEmpty) ...[
          const SizedBox(height: 26),
          Text(
            context.l10n.workoutCheckMuscleCoverage,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          CoachlySurface(
            child: Column(
              children: [
                SizedBox(
                  height: 210,
                  child: MuscleAnatomyView(muscles: muscles),
                ),
                for (final entry in report.muscleSetExposure.entries.take(6))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(entry.key)),
                        Text(
                          context.l10n.workoutCheckSetExposure(
                            '${entry.value}',
                          ),
                          style: TextStyle(
                            color: context.exerciseTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 26),
        for (final finding in report.findings) ...[
          _FindingCard(finding: finding),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _FindingCard extends StatelessWidget {
  final WorkoutCheckFinding finding;
  const _FindingCard({required this.finding});

  @override
  Widget build(BuildContext context) {
    final color = switch (finding.severity) {
      WorkoutCheckSeverity.positive => context.exerciseTheme.primary,
      WorkoutCheckSeverity.information => context.exerciseTheme.info,
      WorkoutCheckSeverity.review => context.exerciseTheme.warning,
      WorkoutCheckSeverity.insufficientData =>
        context.exerciseTheme.textSecondary,
    };
    final icon = switch (finding.severity) {
      WorkoutCheckSeverity.positive => Icons.check_circle_outline_rounded,
      WorkoutCheckSeverity.information => Icons.insights_outlined,
      WorkoutCheckSeverity.review => Icons.rate_review_outlined,
      WorkoutCheckSeverity.insufficientData => Icons.more_horiz_rounded,
    };
    return CoachlySurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  context.tr(finding.titleKey, params: finding.params),
                  style: TextStyle(
                    color: context.exerciseTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(finding.explanationKey, params: finding.params),
            style: TextStyle(
              color: context.exerciseTheme.textSecondary,
              height: 1.42,
            ),
          ),
          if (finding.evidence.isNotEmpty)
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                context.l10n.workoutCheckWhy,
                style: TextStyle(
                  color: context.exerciseTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.workoutCheckUsedData,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      for (final evidence in finding.evidence)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• ${context.tr(evidence.key, params: evidence.params)}',
                            style: TextStyle(
                              color: context.exerciseTheme.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CheckUnavailable extends StatelessWidget {
  final VoidCallback onRetry;
  const _CheckUnavailable({required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.workoutCheckUnavailable),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
        ],
      ),
    ),
  );
}
