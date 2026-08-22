import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_exercise_card.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_group_card.dart';
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
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontSize: 32,
              height: 1.12,
              fontWeight: FontWeight.w800,
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
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
            context.tr('workout.detail.goal'),
            style: const TextStyle(
              color: CoachlyAthleteTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.goal,
            maxLines: expanded ? null : 3,
            overflow: expanded ? null : TextOverflow.ellipsis,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontSize: 15,
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
  final VoidCallback onEdit;
  final ValueChanged<WorkoutExerciseViewData> onOpenExercise;
  final VoidCallback onAddExercise;

  const WorkoutStructure({
    super.key,
    required this.workout,
    required this.onEdit,
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
          CoachlySectionHeader(
            title: context.tr('workout.detail.structure'),
            actionLabel: workout.exerciseCount == 0
                ? null
                : context.tr('common.edit'),
            onAction: onEdit,
          ),
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
                style: const TextStyle(
                  color: CoachlyAthleteTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .75,
                ),
              ),
              Text(
                _exerciseCountLabel(context, section.exerciseCount),
                style: const TextStyle(
                  color: CoachlyAthleteTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
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
            context.tr('workout.detail.no_exercises'),
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            context.tr('workout.detail.empty_hint'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textSecondary,
              fontSize: 13,
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
            label: Text(context.tr('workout.detail.add_exercise')),
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
          CoachlySectionHeader(title: context.tr('workout.detail.overview')),
          if (muscles.isNotEmpty)
            _OverviewItem(
              icon: Icons.accessibility_new_rounded,
              title: context.tr('workout.detail.muscle_focus'),
              values: muscles,
            ),
          if (muscles.isNotEmpty && equipment.isNotEmpty)
            const SizedBox(height: 10),
          if (equipment.isNotEmpty)
            _OverviewItem(
              icon: Icons.fitness_center_rounded,
              title: context.tr('workout.detail.equipment'),
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
                        style: const TextStyle(
                          color: CoachlyAthleteTheme.textSecondary,
                          fontSize: 13,
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
          CoachlySectionHeader(
            title: context.tr('workout.detail.concepts_used'),
          ),
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
      primaryActionLabel: context.tr('common.got_it'),
      sections: [
        CoachlyInfoSection(
          context.tr('workout.detail.what_is_it'),
          context.tr('workout.detail.concept_${concept.name}_definition'),
        ),
        CoachlyInfoSection(
          context.tr('workout.detail.how_to_read'),
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

String _durationLabel(BuildContext context, Duration duration) => context.tr(
  'workout.detail.estimated_minutes',
  params: {'count': '${(duration.inSeconds / 60).ceil()}'},
);
