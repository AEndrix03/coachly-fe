import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/rest_timer_provider.dart';
import 'set_row.dart';

class ExerciseCard extends ConsumerStatefulWidget {
  final String workoutId;
  final int exerciseIndex;
  final bool isInitiallyExpanded;

  const ExerciseCard({
    super.key,
    required this.workoutId,
    required this.exerciseIndex,
    this.isInitiallyExpanded = false,
  });

  @override
  ConsumerState<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<ExerciseCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
    );
    if (_isExpanded) {
      _expandController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  ActiveWorkout get _notifier =>
      ref.read(activeWorkoutProvider(widget.workoutId).notifier);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final workoutState = ref.watch(activeWorkoutProvider(widget.workoutId));
    if (workoutState.exercises.length <= widget.exerciseIndex) {
      return const SizedBox.shrink();
    }

    final exercise = workoutState.exercises[widget.exerciseIndex];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          scheme.surfaceContainerHigh.withValues(alpha: 0.84),
          scheme.surface,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              exercise.completedSets == exercise.totalSets &&
                  exercise.totalSets > 0
              ? scheme.primary.withValues(alpha: 0.42)
              : scheme.outlineVariant.withValues(alpha: 0.75),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(18),
            child: _buildHeader(exercise, scheme),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                Divider(
                  color: scheme.outlineVariant.withValues(alpha: 0.6),
                  height: 1,
                ),
                _buildSetsSection(exercise),
                _buildAddSetButton(scheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ActiveExerciseState exercise, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scheme.primary.withValues(alpha: 0.92),
                  scheme.primaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.exerciseIndex + 1}',
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.displayName,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildProgressBadge(exercise, scheme),
                    const SizedBox(width: 8),
                    Text(
                      '${exercise.repsRange} rep',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.62),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _roundActionIcon(
            scheme: scheme,
            icon: Icons.info_rounded,
            onTap: () => _openExerciseDetail(context, exercise),
            tooltip: context.tr('exercise.info'),
          ),
          const SizedBox(width: 4),
          _buildExerciseMenu(exercise, scheme),
          const SizedBox(width: 2),
          Icon(
            _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            color: scheme.onSurface.withValues(alpha: 0.62),
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBadge(ActiveExerciseState exercise, ColorScheme scheme) {
    final done = exercise.completedSets;
    final total = exercise.totalSets;
    final allDone = done == total && total > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: allDone
            ? scheme.primary.withValues(alpha: 0.14)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        '$done/$total',
        style: TextStyle(
          color: allDone
              ? scheme.primary
              : scheme.onSurface.withValues(alpha: 0.75),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildExerciseMenu(ActiveExerciseState exercise, ColorScheme scheme) {
    return PopupMenuButton<String>(
      tooltip: context.tr('exercise.actions'),
      icon: Icon(
        Icons.more_horiz_rounded,
        color: scheme.onSurface.withValues(alpha: 0.65),
        size: 22,
      ),
      color: scheme.surfaceContainerHigh,
      offset: const Offset(0, 40),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant, width: 1),
      ),
      onSelected: (value) {
        if (value == 'add_set') {
          _notifier.addSet(widget.exerciseIndex);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'add_set',
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: scheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('exercise.add_set'),
                style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetsSection(ActiveExerciseState exercise) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: exercise.sets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, setIdx) {
        final set = exercise.sets[setIdx];
        return SetRow(
          type: set.setType,
          weight: set.weight,
          reps: set.reps,
          completed: set.completed,
          onCompleteToggle: (completed) {
            _notifier.completeSet(widget.exerciseIndex, setIdx, completed);
            if (completed) {
              _onSetCompleted(exercise);
            }
          },
          onWeightChanged: (w) =>
              _notifier.updateSetWeight(widget.exerciseIndex, setIdx, w),
          onRepsChanged: (r) =>
              _notifier.updateSetReps(widget.exerciseIndex, setIdx, r),
          onTypeChanged: (t) =>
              _notifier.updateSetType(widget.exerciseIndex, setIdx, t),
          onDelete: () => _notifier.deleteSet(widget.exerciseIndex, setIdx),
          onDuplicate: () =>
              _notifier.duplicateSet(widget.exerciseIndex, setIdx),
        );
      },
    );
  }

  Widget _buildAddSetButton(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _notifier.addSet(widget.exerciseIndex),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
          label: Text(
            context.tr('exercise.add_set'),
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.primary,
            side: BorderSide(color: scheme.primary.withValues(alpha: 0.45)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundActionIcon({
    required ColorScheme scheme,
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(
          icon,
          color: scheme.onSurface.withValues(alpha: 0.72),
          size: 20,
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  void _onSetCompleted(ActiveExerciseState exercise) {
    final restSeconds = exercise.restSeconds > 0 ? exercise.restSeconds : 90;
    ref.read(restTimerProvider.notifier).startTimer(restSeconds);

    // Auto-collapse when all sets in this exercise are done.
    final updated = ref
        .read(activeWorkoutProvider(widget.workoutId))
        .exercises[widget.exerciseIndex];
    if (updated.completedSets == updated.totalSets && _isExpanded) {
      Future.microtask(() {
        if (mounted) {
          _toggleExpanded();
        }
      });
    }
  }

  void _openExerciseDetail(BuildContext context, ActiveExerciseState exercise) {
    final exerciseId = exercise.exercise.exercise.id?.trim();
    if (exerciseId == null || exerciseId.isEmpty) {
      return;
    }

    context.push(
      '/workouts/workout/${widget.workoutId}/workout_exercise_page/$exerciseId',
    );
  }
}
