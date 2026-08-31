import 'package:coachly/features/workouts/presentation/widgets/exercise_display_name.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutGroupCard extends StatefulWidget {
  final WorkoutGroupBlockViewData group;
  final String label;
  final ValueChanged<WorkoutExerciseViewData> onOpenExercise;

  const WorkoutGroupCard({
    super.key,
    required this.group,
    required this.label,
    required this.onOpenExercise,
  });

  @override
  State<WorkoutGroupCard> createState() => _WorkoutGroupCardState();
}

class _WorkoutGroupCardState extends State<WorkoutGroupCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final typeLabel = switch (group.type) {
      WorkoutGroupType.superset => context.l10n.workoutDetailSuperset,
      WorkoutGroupType.triset => context.l10n.workoutDetailTriset,
      WorkoutGroupType.giantSet => context.l10n.workoutDetailGiantSet,
      WorkoutGroupType.circuit => context.l10n.workoutDetailCircuit,
    };
    final exerciseCount = _exerciseCountLabel(context, group.exercises.length);
    final roundCount = _roundCountLabel(context, group.rounds);
    return Semantics(
      container: true,
      expanded: _expanded,
      label: [
        typeLabel,
        exerciseCount,
        roundCount,
        group.exercises
            .map((exercise) => exerciseDisplayName(context, exercise))
            .join(', '),
        context.tr(
          _expanded
              ? 'workout.detail.collapse_group'
              : 'workout.detail.expand_group',
        ),
      ].join('. '),
      child: CoachlySurface(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
        color: CoachlyAthleteTheme.surfaceElevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CoachlyAthleteTheme.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(
                      CoachlyAthleteTheme.compactRadius,
                    ),
                  ),
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$typeLabel · $roundCount',
                    style: context.scale.captionLoose.heavy.copyWith(
                      color: CoachlyAthleteTheme.textPrimary,
                      letterSpacing: .45,
                    ),
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 44,
                  ),
                  tooltip: context.l10n.workoutDetailExplainConcept,
                  onPressed: () => _showGroupInfo(context, typeLabel),
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: CoachlyAthleteTheme.textSecondary,
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 44,
                  ),
                  tooltip: _expanded
                      ? context.l10n.workoutDetailCollapseGroup
                      : context.l10n.workoutDetailExpandGroup,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _expanded = !_expanded);
                  },
                  icon: AnimatedRotation(
                    turns: _expanded ? .5 : 0,
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : CoachlyAthleteTheme.expandDuration,
                    curve: CoachlyAthleteTheme.standardCurve,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...group.exercises
                .take(_expanded ? group.exercises.length : 2)
                .indexed
                .map(
                  (item) => _GroupExerciseRow(
                    key: ValueKey(item.$2.instanceId),
                    exercise: item.$2,
                    label: '${widget.label}${item.$1 + 1}',
                    detailed: _expanded,
                    onTap: item.$2.isMissing
                        ? null
                        : () => widget.onOpenExercise(item.$2),
                  ),
                ),
            AnimatedSize(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : CoachlyAthleteTheme.expandDuration,
              curve: CoachlyAthleteTheme.standardCurve,
              child: _expanded && group.restBetweenExercisesSeconds != null
                  ? _RestRow(
                      label: context.l10n.workoutDetailRestBetweenExercises,
                      seconds: group.restBetweenExercisesSeconds!,
                    )
                  : const SizedBox.shrink(),
            ),
            if (group.restAfterRoundSeconds != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '${context.l10n.workoutDetailRestAfterRound} · ${_formatSeconds(group.restAfterRoundSeconds!)}',
                  style: context.scale.caption.semibold.copyWith(
                    color: CoachlyAthleteTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showGroupInfo(BuildContext context, String typeLabel) {
    final definitionKey = switch (widget.group.type) {
      WorkoutGroupType.superset => 'workout.detail.superset_definition',
      WorkoutGroupType.triset => 'workout.detail.triset_definition',
      WorkoutGroupType.giantSet => 'workout.detail.giant_set_definition',
      WorkoutGroupType.circuit => 'workout.detail.circuit_definition',
    };
    CoachlyInfoSheet.show(
      context,
      title: typeLabel,
      primaryActionLabel: context.l10n.commonGotIt,
      sections: [
        CoachlyInfoSection(
          context.l10n.workoutDetailWhatIsIt,
          context.tr(definitionKey),
        ),
        CoachlyInfoSection(
          context.l10n.workoutDetailHowToRead,
          '${_roundCountLabel(context, widget.group.rounds)} · ${widget.group.exercises.map((e) => exerciseDisplayName(context, e)).join(' → ')}',
        ),
      ],
    );
  }
}

class _RestRow extends StatelessWidget {
  final String label;
  final int seconds;

  const _RestRow({required this.label, required this.seconds});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.scale.caption.copyWith(
              color: CoachlyAthleteTheme.textSecondary,
            ),
          ),
        ),
        Text(
          _formatSeconds(seconds),
          style: context.scale.caption.bold.copyWith(
            color: CoachlyAthleteTheme.textPrimary,
          ),
        ),
      ],
    ),
  );
}

/// A row, not another card: a grouped block must retain one visual surface.
class _GroupExerciseRow extends StatelessWidget {
  final WorkoutExerciseViewData exercise;
  final String label;
  final bool detailed;
  final VoidCallback? onTap;

  const _GroupExerciseRow({
    super.key,
    required this.exercise,
    required this.label,
    required this.detailed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (exercise.isNameLoading) {
      return _GroupExerciseLoadingRow(label: label);
    }
    final target = exercise.prescription.compactTarget;
    final targetLoad = detailed ? _targetLoad(exercise) : null;
    return Semantics(
      button: onTap != null,
      label: '$label, ${exerciseDisplayName(context, exercise)}, $target',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  label,
                  style: context.scale.caption.heavy.copyWith(
                    color: CoachlyAthleteTheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  exerciseDisplayName(context, exercise),
                  style: context.scale.body.bold.copyWith(
                    color: CoachlyAthleteTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      target,
                      textAlign: TextAlign.end,
                      style: context.scale.captionLoose.semibold.copyWith(
                        color: CoachlyAthleteTheme.textSecondary,
                      ),
                    ),
                    if (targetLoad != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        targetLoad,
                        textAlign: TextAlign.end,
                        style: context.scale.caption.bold.copyWith(
                          color: CoachlyAthleteTheme.textPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupExerciseLoadingRow extends StatelessWidget {
  final String label;

  const _GroupExerciseLoadingRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.workoutDetailExerciseLoading,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  label,
                  style: context.scale.caption.heavy.copyWith(
                    color: CoachlyAthleteTheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: CoachlyAthleteTheme.surface,
                  highlightColor: CoachlyAthleteTheme.border,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: CoachlyAthleteTheme.surface,
                      borderRadius: BorderRadius.circular(
                        CoachlyAthleteTheme.compactRadius,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatSeconds(int seconds) => seconds < 60
    ? '${seconds}s'
    : '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

String _exerciseCountLabel(BuildContext context, int count) => context.tr(
  count == 1
      ? 'workout.detail.exercise_count_one'
      : 'workout.detail.exercise_count_other',
  params: {'count': '$count'},
);

String _roundCountLabel(BuildContext context, int count) => context.tr(
  count == 1
      ? 'workout.detail.round_count_one'
      : 'workout.detail.round_count_other',
  params: {'count': '$count'},
);

String? _targetLoad(WorkoutExerciseViewData exercise) {
  final block = exercise.prescription.blocks
      .where((item) => item.targetLoad != null)
      .firstOrNull;
  if (block == null) return null;
  final value = block.targetLoad! == block.targetLoad!.roundToDouble()
      ? block.targetLoad!.toInt().toString()
      : block.targetLoad!.toStringAsFixed(1);
  return '$value ${block.loadUnit ?? 'kg'}';
}
