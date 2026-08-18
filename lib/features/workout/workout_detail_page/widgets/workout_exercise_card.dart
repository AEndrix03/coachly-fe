import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final rest = exercise.prescription.primaryRestSeconds;
    final intensity = exercise.prescription.compactIntensity;
    final semantics = [
      exercise.name,
      exercise.prescription.compactTarget,
      if (intensity != null) intensity,
      if (rest != null)
        '${context.tr('workout.detail.rest')} ${_duration(rest)}',
    ].join('. ');

    return CoachlyPressable(
      semanticLabel: semantics,
      onTap: () => _toggleExpanded(reduceMotion),
      child: CoachlySurface(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      style: const TextStyle(
                        color: CoachlyAthleteTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.isMissing
                              ? context.tr(
                                  'workout.detail.exercise_unavailable',
                                )
                              : exercise.name,
                          maxLines: 2,
                          style: const TextStyle(
                            color: CoachlyAthleteTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.22,
                          ),
                        ),
                        if (exercise.metadata != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            exercise.metadata!,
                            style: const TextStyle(
                              color: CoachlyAthleteTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          exercise.prescription.compactTarget,
                          style: const TextStyle(
                            color: CoachlyAthleteTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          [
                            if (intensity != null) intensity,
                            if (rest != null)
                              '${context.tr('workout.detail.rest')} ${_duration(rest)}',
                          ].join(' · '),
                          style: const TextStyle(
                            color: CoachlyAthleteTheme.textSecondary,
                            fontSize: 13,
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
    final rows = <(String, String)>[
      (
        context.tr('workout.detail.target'),
        exercise.prescription.compactTarget,
      ),
      if (exercise.prescription.compactIntensity case final value?)
        (context.tr('workout.detail.intensity'), value),
      if (exercise.prescription.primaryRestSeconds case final value?)
        (context.tr('workout.detail.recovery'), _duration(value)),
      if (_targetLoad(exercise.prescription) case final value?)
        (context.tr('workout.detail.target_load'), value),
      if (exercise.prescription.note case final value?)
        (context.tr('workout.detail.notes'), value),
    ];
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(height: 1, color: CoachlyAthleteTheme.border),
        const SizedBox(height: 14),
        ...rows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 108,
                  child: Text(
                    row.$1,
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row.$2,
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  child: Text(context.tr('common.edit')),
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
                child: Text(context.tr('workout.detail.exercise_detail')),
              ),
            ),
          ],
        ),
      ],
    );
  }
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
