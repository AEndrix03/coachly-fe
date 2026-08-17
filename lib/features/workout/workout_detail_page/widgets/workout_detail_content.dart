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
          if (workout.focus != null) ...[
            const SizedBox(height: 8),
            Text(
              workout.focus!,
              style: const TextStyle(
                color: CoachlyAthleteTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (workout.syncPending) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 15,
                  color: CoachlyAthleteTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  context.tr('workout.detail.sync_pending'),
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class WorkoutSummaryStrip extends StatelessWidget {
  final WorkoutDetailViewData workout;

  const WorkoutSummaryStrip({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final duration = workout.estimatedDuration;
    final minutes = duration == null
        ? '—'
        : '~${(duration.inSeconds / 60).ceil()} min';
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: CoachlySurface(
        child: Row(
          children: [
            _SummaryMetric(
              value: '${workout.exerciseCount}',
              label: context.tr('workout.detail.exercises'),
            ),
            const _SummaryDivider(),
            _SummaryMetric(
              value: '${workout.workingSets}',
              label: context.tr('workout.detail.working_sets'),
            ),
            const _SummaryDivider(),
            _SummaryMetric(
              value: minutes,
              label: context.tr('workout.duration'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textSecondary,
              fontSize: 11,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 42,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    color: CoachlyAthleteTheme.border,
  );
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
          child: Text(
            '${section.title!.toUpperCase()} · ${section.exerciseCount} ${context.tr('workout.detail.exercises').toLowerCase()}',
            style: const TextStyle(
              color: CoachlyAthleteTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: .75,
            ),
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

class WorkoutProgrammingDetails extends StatelessWidget {
  final WorkoutDetailViewData workout;

  const WorkoutProgrammingDetails({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    if (workout.workingSets == 0) return const SizedBox.shrink();
    final ranges = <String, int>{};
    for (final exercise in _exercises(workout)) {
      for (final block in exercise.prescription.blocks.where(
        (block) => block.isWorking,
      )) {
        final label = block.repsMin == null
            ? 'AMRAP'
            : block.repsMax != null && block.repsMax != block.repsMin
            ? '${block.repsMin}–${block.repsMax}'
            : '${block.repsMin}';
        ranges.update(
          label,
          (value) => value + block.sets,
          ifAbsent: () => block.sets,
        );
      }
    }
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: CoachlySurface(
        padding: EdgeInsets.zero,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: CoachlyAthleteTheme.primary,
            collapsedIconColor: CoachlyAthleteTheme.textSecondary,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Text(
              context.tr('workout.detail.programming_details'),
              style: const TextStyle(
                color: CoachlyAthleteTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            children: [
              _DetailRow(
                label: context.tr('workout.detail.working_sets'),
                value: '${workout.workingSets}',
              ),
              ...ranges.entries.map(
                (entry) => _DetailRow(
                  label:
                      '${context.tr('workout.detail.rep_range')} ${entry.key}',
                  value:
                      '${entry.value} ${context.tr('workout.sets').toLowerCase()}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: CoachlyAthleteTheme.textSecondary),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: CoachlyAthleteTheme.textPrimary,
            fontWeight: FontWeight.w700,
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

Iterable<WorkoutExerciseViewData> _exercises(
  WorkoutDetailViewData workout,
) sync* {
  for (final block in workout.sections.expand((section) => section.blocks)) {
    switch (block) {
      case WorkoutExerciseBlockViewData():
        yield block.exercise;
      case WorkoutGroupBlockViewData():
        yield* block.exercises;
    }
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
