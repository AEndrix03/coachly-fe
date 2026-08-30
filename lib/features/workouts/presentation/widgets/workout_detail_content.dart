import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workouts/presentation/widgets/workout_exercise_card.dart';
import 'package:coachly/features/workouts/presentation/widgets/workout_group_card.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

class WorkoutIdentity extends StatelessWidget {
  final WorkoutDetailViewData workout;

  const WorkoutIdentity({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final metadata = <String>[
      if (workout.focus case final focus?) focus,
      _exerciseCountLabel(context, workout.exerciseCount),
      _setCountLabel(context, workout.workingSets),
      if (workout.estimatedDuration case final duration?)
        _durationLabel(context, duration),
    ];
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.title,
            style: context.scale.hero.heavy.copyWith(
              color: CoachlyAthleteTheme.textPrimary,
              height: 1.12,
              letterSpacing: -.7,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (var index = 0; index < metadata.length; index++) ...[
                if (index > 0)
                  const Text(
                    '·',
                    style: TextStyle(color: CoachlyAthleteTheme.textSecondary),
                  ),
                Text(
                  metadata[index],
                  style: context.scale.bodyTight.semibold.copyWith(
                    color: CoachlyAthleteTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class WorkoutGoalSection extends StatefulWidget {
  final String goal;

  const WorkoutGoalSection({super.key, required this.goal});

  @override
  State<WorkoutGoalSection> createState() => _WorkoutGoalSectionState();
}

class _WorkoutGoalSectionState extends State<WorkoutGoalSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.workoutDetailGoal,
            style: context.scale.caption.bold.copyWith(
              color: CoachlyAthleteTheme.textSecondary,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.goal,
            maxLines: expanded ? null : 3,
            overflow: expanded ? null : TextOverflow.ellipsis,
            style: context.scale.body.copyWith(
              color: CoachlyAthleteTheme.textPrimary,
              height: 1.48,
            ),
          ),
          if (widget.goal.length > 130)
            TextButton(
              onPressed: () => setState(() => expanded = !expanded),
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 44),
                padding: EdgeInsets.zero,
                foregroundColor: CoachlyAthleteTheme.primary,
              ),
              child: Text(
                context.tr(
                  expanded
                      ? 'workout.detail.show_less'
                      : 'workout.detail.show_more',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WorkoutStructure extends StatelessWidget {
  final WorkoutDetailViewData workout;
  final ValueChanged<WorkoutExerciseViewData> onOpenExercise;
  final VoidCallback onAddExercise;

  const WorkoutStructure({
    super.key,
    required this.workout,
    required this.onOpenExercise,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CoachlySectionHeader(title: context.l10n.workoutDetailStructure),
          if (workout.exerciseCount == 0)
            _EmptyWorkout(onAddExercise: onAddExercise)
          else
            ..._sectionWidgets(context),
        ],
      ),
    );
  }

  Iterable<Widget> _sectionWidgets(BuildContext context) sync* {
    var exerciseIndex = 0;
    var groupIndex = 0;
    for (final section in workout.sections) {
      if (section.title != null) {
        yield Padding(
          key: ValueKey(section.id),
          padding: const EdgeInsets.only(top: 18, bottom: 4),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                section.title!.toUpperCase(),
                style: context.scale.captionTight.heavy.copyWith(
                  color: CoachlyAthleteTheme.textSecondary,
                  letterSpacing: .75,
                ),
              ),
              Text(
                _exerciseCountLabel(context, section.exerciseCount),
                style: context.scale.captionTight.semibold.copyWith(
                  color: CoachlyAthleteTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      }
      for (final block in section.blocks) {
        yield const SizedBox(height: 10);
        if (block is WorkoutExerciseBlockViewData) {
          exerciseIndex += 1;
          final exercise = block.exercise;
          yield WorkoutExerciseCard(
            key: ValueKey(exercise.instanceId),
            exercise: exercise,
            indexLabel: exerciseIndex.toString().padLeft(2, '0'),
            onOpenDetail: () => onOpenExercise(exercise),
          );
        } else if (block is WorkoutGroupBlockViewData) {
          groupIndex += 1;
          yield WorkoutGroupCard(
            key: ValueKey(block.id),
            group: block,
            label: String.fromCharCode(64 + groupIndex.clamp(1, 26)),
            onOpenExercise: onOpenExercise,
          );
          exerciseIndex += block.exerciseCount;
        }
      }
    }
  }
}

class _EmptyWorkout extends StatelessWidget {
  final VoidCallback onAddExercise;

  const _EmptyWorkout({required this.onAddExercise});

  @override
  Widget build(BuildContext context) {
    return CoachlySurface(
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Icon(
            Icons.fitness_center_rounded,
            color: CoachlyAthleteTheme.textSecondary,
            size: 30,
          ),
          const SizedBox(height: 14),
          Text(
            context.l10n.workoutDetailNoExercises,
            style: context.scale.subtitle.bold.copyWith(
              color: CoachlyAthleteTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            context.l10n.workoutDetailEmptyHint,
            textAlign: TextAlign.center,
            style: context.scale.captionLoose.copyWith(
              color: CoachlyAthleteTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAddExercise,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: CoachlyAthleteTheme.primary,
              foregroundColor: CoachlyAthleteTheme.background,
            ),
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.workoutDetailAddExercise),
          ),
        ],
      ),
    );
  }
}

/// Derived summaries are deliberately computed from the resolved exercises;
/// they are not persisted on the workout or included in sync payloads.
class WorkoutOverview extends StatelessWidget {
  final WorkoutDetailViewData workout;

  const WorkoutOverview({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final muscles = workout.muscleSummary;
    final equipment = workout.equipmentSummary;
    if (muscles.isEmpty && equipment.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoachlySectionHeader(title: context.l10n.workoutDetailOverview),
          if (muscles.isNotEmpty)
            _OverviewItem(
              icon: Icons.accessibility_new_rounded,
              title: context.l10n.workoutDetailMuscleFocus,
              values: muscles,
            ),
          if (muscles.isNotEmpty && equipment.isNotEmpty)
            const SizedBox(height: 10),
          if (equipment.isNotEmpty)
            _OverviewItem(
              icon: Icons.fitness_center_rounded,
              title: context.l10n.workoutDetailEquipment,
              values: equipment,
            ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> values;

  const _OverviewItem({
    required this.icon,
    required this.title,
    required this.values,
  });

  @override
  Widget build(BuildContext context) => CoachlySurface(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: CoachlyAthleteTheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: CoachlyAthleteTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: values
                    .map(
                      (value) => Text(
                        value,
                        style: context.scale.captionLoose.copyWith(
                          color: CoachlyAthleteTheme.textSecondary,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class WorkoutConceptsSection extends StatelessWidget {
  final WorkoutDetailViewData workout;

  const WorkoutConceptsSection({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final concepts = WorkoutConceptDetector.detect(workout);
    if (concepts.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoachlySectionHeader(title: context.l10n.workoutDetailConceptsUsed),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: concepts.map((concept) {
              final label = _conceptLabel(concept);
              return ActionChip(
                label: Text(label),
                avatar: const Icon(Icons.info_outline_rounded, size: 16),
                onPressed: () => _showConcept(context, concept, label),
                backgroundColor: CoachlyAthleteTheme.surface,
                side: const BorderSide(color: CoachlyAthleteTheme.border),
                labelStyle: const TextStyle(
                  color: CoachlyAthleteTheme.textPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showConcept(
    BuildContext context,
    WorkoutConcept concept,
    String label,
  ) {
    CoachlyInfoSheet.show(
      context,
      title: label,
      primaryActionLabel: context.l10n.commonGotIt,
      sections: [
        CoachlyInfoSection(
          context.l10n.workoutDetailWhatIsIt,
          context.tr('workout.detail.concept_${concept.name}_definition'),
        ),
        CoachlyInfoSection(
          context.l10n.workoutDetailHowToRead,
          context.tr('workout.detail.concept_${concept.name}_example'),
        ),
      ],
    );
  }
}

String _conceptLabel(WorkoutConcept concept) => switch (concept) {
  WorkoutConcept.rir => 'RIR',
  WorkoutConcept.rpe => 'RPE',
  WorkoutConcept.percentage1RM => '%1RM',
  WorkoutConcept.superset => 'Superset',
  WorkoutConcept.circuit => 'Circuit',
  WorkoutConcept.topSet => 'Top set',
  WorkoutConcept.backoff => 'Back-off',
  WorkoutConcept.amrap => 'AMRAP',
};

String _exerciseCountLabel(BuildContext context, int count) => context.tr(
  count == 1
      ? 'workout.detail.exercise_count_one'
      : 'workout.detail.exercise_count_other',
  params: {'count': '$count'},
);

String _setCountLabel(BuildContext context, int count) => context.tr(
  count == 1
      ? 'workout.detail.set_count_one'
      : 'workout.detail.set_count_other',
  params: {'count': '$count'},
);

String _durationLabel(BuildContext context, Duration duration) => context.l10n
    .workoutDetailEstimatedMinutes('${(duration.inSeconds / 60).ceil()}');
