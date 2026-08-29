import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutExerciseCard extends StatefulWidget {
  final WorkoutExerciseViewData exercise;
  final String indexLabel;
  final VoidCallback onOpenDetail;
  final VoidCallback? onEdit;

  const WorkoutExerciseCard({
    super.key,
    required this.exercise,
    required this.indexLabel,
    required this.onOpenDetail,
    this.onEdit,
  });

  @override
  State<WorkoutExerciseCard> createState() => _WorkoutExerciseCardState();
}

class _WorkoutExerciseCardState extends State<WorkoutExerciseCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _showExpandedDetails = false;
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController =
        AnimationController(
          vsync: this,
          duration: CoachlyAthleteTheme.expandDuration,
        )..addStatusListener((status) {
          if (status == AnimationStatus.dismissed && _showExpandedDetails) {
            setState(() => _showExpandedDetails = false);
          }
        });
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: CoachlyAthleteTheme.standardCurve,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded(bool reduceMotion) {
    HapticFeedback.selectionClick();
    final expand = !_expanded;
    setState(() {
      _expanded = expand;
      if (expand) _showExpandedDetails = true;
    });
    if (reduceMotion) {
      _expandController.value = expand ? 1 : 0;
    } else if (expand) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    if (exercise.isNameLoading) {
      return WorkoutExerciseLoadingCard(indexLabel: widget.indexLabel);
    }
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final rest = exercise.prescription.primaryRestSeconds;
    final intensity = exercise.prescription.compactIntensity;
    final displayName = _displayName(context, exercise);
    final semantics = [
      context.l10n.workoutDetailExerciseSemanticsPosition(widget.indexLabel),
      displayName,
      exercise.prescription.compactTarget,
      if (intensity != null) intensity,
      if (rest != null) '${context.l10n.workoutDetailRest} ${_duration(rest)}',
      context.tr(
        _expanded
            ? 'workout.detail.collapse_details'
            : 'workout.detail.expand_details',
      ),
    ].join('. ');

    return CoachlyPressable(
      semanticLabel: semantics,
      semanticExpanded: _expanded,
      excludeChildSemantics: false,
      onTap: () => _toggleExpanded(reduceMotion),
      child: CoachlySurface(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(CoachlyAthleteTheme.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      widget.indexLabel,
                      style: context.scale.caption.heavy.copyWith(
                        color: CoachlyAthleteTheme.primary,
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                  _ExerciseThumbnail(url: exercise.thumbnailUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          button: !exercise.isMissing,
                          label: context.l10n
                              .workoutDetailOpenExerciseSemantics(displayName),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: exercise.isMissing
                                ? null
                                : () {
                                    HapticFeedback.lightImpact();
                                    widget.onOpenDetail();
                                  },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: CoachlyAthleteTheme.touchTarget,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  displayName,
                                  maxLines: 2,
                                  style: context.scale.bodyLoose.bold.copyWith(
                                    color: CoachlyAthleteTheme.textPrimary,
                                    height: 1.22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (exercise.metadata != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            exercise.metadata!,
                            style: context.scale.caption.copyWith(
                              color: CoachlyAthleteTheme.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          exercise.prescription.compactTarget,
                          style: context.scale.body.bold.copyWith(
                            color: CoachlyAthleteTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          [
                            if (intensity != null) intensity,
                            if (rest != null)
                              '${context.l10n.workoutDetailRest} ${_duration(rest)}',
                          ].join(' · '),
                          style: context.scale.captionLoose.copyWith(
                            color: CoachlyAthleteTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? .5 : 0,
                    duration: reduceMotion
                        ? Duration.zero
                        : CoachlyAthleteTheme.expandDuration,
                    curve: CoachlyAthleteTheme.standardCurve,
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: CoachlyAthleteTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizeTransition(
                axis: Axis.vertical,
                axisAlignment: -1,
                sizeFactor: _expandAnimation,
                child: _showExpandedDetails
                    ? _ExpandedExercise(
                        exercise: exercise,
                        onEdit: widget.onEdit,
                        onOpenDetail: widget.onOpenDetail,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutExerciseLoadingCard extends StatelessWidget {
  final String indexLabel;

  const WorkoutExerciseLoadingCard({super.key, required this.indexLabel});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.workoutDetailExerciseLoading,
      child: ExcludeSemantics(
        child: CoachlySurface(
          padding: const EdgeInsets.all(CoachlyAthleteTheme.cardPadding),
          child: Shimmer.fromColors(
            baseColor: CoachlyAthleteTheme.surfaceElevated,
            highlightColor: CoachlyAthleteTheme.border,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 34,
                  child: Text(
                    indexLabel,
                    style: context.scale.caption.heavy.copyWith(
                      color: CoachlyAthleteTheme.primary,
                    ),
                  ),
                ),
                const _LoadingBlock.square(size: 52),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LoadingBlock(height: 18, widthFactor: .76),
                      SizedBox(height: 9),
                      _LoadingBlock(height: 12, widthFactor: .52),
                      SizedBox(height: 16),
                      _LoadingBlock(height: 15, widthFactor: .42),
                      SizedBox(height: 8),
                      _LoadingBlock(height: 12, widthFactor: .62),
                    ],
                  ),
                ),
                const SizedBox(width: 44, height: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  final double height;
  final double? widthFactor;
  final double? fixedWidth;

  const _LoadingBlock({required this.height, this.widthFactor})
    : fixedWidth = null;

  const _LoadingBlock.square({required double size})
    : height = size,
      fixedWidth = size,
      widthFactor = null;

  @override
  Widget build(BuildContext context) {
    final block = Container(
      width: fixedWidth,
      height: height,
      decoration: BoxDecoration(
        color: CoachlyAthleteTheme.surface,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
      ),
    );
    if (widthFactor == null) return block;
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: block,
    );
  }
}

class _ExpandedExercise extends StatelessWidget {
  final WorkoutExerciseViewData exercise;
  final VoidCallback? onEdit;
  final VoidCallback onOpenDetail;

  const _ExpandedExercise({
    required this.exercise,
    required this.onEdit,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <_ExerciseDetailRow>[
      (
        label: context.l10n.workoutDetailWorkingSets,
        value: '${exercise.prescription.workingSets}',
        infoKey: 'workout.detail.working_sets_definition',
      ),
      if (_repRange(exercise.prescription) case final value?)
        (
          label: context.l10n.workoutDetailRepRange,
          value: value,
          infoKey: 'workout.detail.rep_range_definition',
        ),
      if (exercise.prescription.compactIntensity case final value?)
        (
          label: context.l10n.workoutDetailIntensity,
          value: value,
          infoKey: null,
        ),
      if (exercise.prescription.primaryRestSeconds case final value?)
        (
          label: context.l10n.workoutDetailRecovery,
          value: _duration(value),
          infoKey: 'workout.detail.recovery_definition',
        ),
      if (_targetLoad(exercise.prescription) case final value?)
        (
          label: context.l10n.workoutDetailTargetLoad,
          value: value,
          infoKey: null,
        ),
      if (exercise.prescription.note case final value?)
        (label: context.l10n.workoutDetailNotes, value: value, infoKey: null),
    ];
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(height: 1, color: CoachlyAthleteTheme.border),
        const SizedBox(height: 14),
        ...rows.map((row) => _ExerciseInfoRow(row: row)),
        Row(
          children: [
            if (onEdit != null)
              Expanded(
                child: OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    foregroundColor: CoachlyAthleteTheme.textPrimary,
                    side: const BorderSide(color: CoachlyAthleteTheme.border),
                  ),
                  child: Text(context.l10n.commonEdit),
                ),
              ),
            if (onEdit != null) const SizedBox(width: 10),
            Expanded(
              child: TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onOpenDetail();
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  foregroundColor: CoachlyAthleteTheme.primary,
                ),
                child: Text(context.l10n.workoutDetailExerciseDetail),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

typedef _ExerciseDetailRow = ({String label, String value, String? infoKey});

class _ExerciseInfoRow extends StatelessWidget {
  final _ExerciseDetailRow row;

  const _ExerciseInfoRow({required this.row});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 132,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  row.label,
                  style: context.scale.captionLoose.copyWith(
                    color: CoachlyAthleteTheme.textSecondary,
                  ),
                ),
              ),
              if (row.infoKey != null)
                IconButton(
                  constraints: const BoxConstraints.tightFor(
                    width: CoachlyAthleteTheme.touchTarget,
                    height: CoachlyAthleteTheme.touchTarget,
                  ),
                  padding: EdgeInsets.zero,
                  tooltip: context.l10n.workoutDetailExplainConcept,
                  onPressed: () => CoachlyInfoSheet.show(
                    context,
                    title: row.label,
                    primaryActionLabel: context.l10n.commonGotIt,
                    sections: [
                      CoachlyInfoSection(
                        context.l10n.workoutDetailWhatIsIt,
                        context.tr(row.infoKey!),
                      ),
                    ],
                  ),
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: CoachlyAthleteTheme.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            row.value,
            textAlign: TextAlign.end,
            style: context.scale.captionLoose.semibold.copyWith(
              color: CoachlyAthleteTheme.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ExerciseThumbnail extends StatelessWidget {
  final String? url;

  const _ExerciseThumbnail({this.url});

  @override
  Widget build(BuildContext context) {
    const size = 52.0;
    const fallback = ColoredBox(
      color: CoachlyAthleteTheme.surfaceElevated,
      child: Center(
        child: Icon(
          Icons.fitness_center_rounded,
          size: 20,
          color: CoachlyAthleteTheme.textSecondary,
        ),
      ),
    );
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
        child: SizedBox.square(
          dimension: size,
          child: url == null
              ? fallback
              : Image.network(
                  url!,
                  fit: BoxFit.cover,
                  cacheWidth: 104,
                  cacheHeight: 104,
                  errorBuilder: (_, _, _) => fallback,
                ),
        ),
      ),
    );
  }
}

String _displayName(BuildContext context, WorkoutExerciseViewData exercise) {
  if (exercise.isMissing) {
    return context.l10n.workoutDetailExerciseUnavailable;
  }
  if (exercise.name.trim().isEmpty || exercise.name == 'Exercise') {
    return context.l10n.workoutDetailExerciseFallback;
  }
  return exercise.name;
}

String _duration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  final minutes = seconds ~/ 60;
  final remainder = seconds % 60;
  return '$minutes:${remainder.toString().padLeft(2, '0')}';
}

String? _targetLoad(ExercisePrescriptionViewData prescription) {
  final block = prescription.blocks
      .where((block) => block.targetLoad != null)
      .firstOrNull;
  if (block == null) return null;
  final load = block.targetLoad! == block.targetLoad!.roundToDouble()
      ? block.targetLoad!.toInt().toString()
      : block.targetLoad!.toStringAsFixed(1);
  return '$load ${block.loadUnit ?? 'kg'}';
}

String? _repRange(ExercisePrescriptionViewData prescription) {
  final values = prescription.blocks
      .where((block) => block.repsMin != null)
      .map(
        (block) => block.repsMax != null && block.repsMax != block.repsMin
            ? '${block.repsMin}–${block.repsMax}'
            : '${block.repsMin}',
      )
      .toSet();
  return values.isEmpty ? null : values.join(' · ');
}
