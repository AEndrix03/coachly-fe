import 'package:coachly/features/exercise/exercise_info_page/widgets/exercise_info_widget.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
    );
    if (_isExpanded) _expandController.value = 1.0;
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
    final workoutState = ref.watch(activeWorkoutProvider(widget.workoutId));
    if (workoutState.exercises.length <= widget.exerciseIndex) {
      return const SizedBox.shrink();
    }
    final exercise = workoutState.exercises[widget.exerciseIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E2A), Color(0xFF14141F)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(16),
            child: _buildHeader(exercise),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(
                  color: Color(0xFF2A2A3A),
                  height: 1,
                  thickness: 1,
                ),
                _buildSetsSection(exercise),
                _buildAddSetButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ActiveExerciseState exercise) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Number badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF3A3A4A),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.exerciseIndex + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildProgressBadge(exercise),
                    const SizedBox(width: 8),
                    Text(
                      '• ${exercise.repsRange} rep',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Info + menu
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.white.withValues(alpha: 0.6),
              size: 22,
            ),
            onPressed: () => _showExerciseInfo(context, exercise.displayName),
          ),
          _buildExerciseMenu(exercise),
        ],
      ),
    );
  }

  Widget _buildProgressBadge(ActiveExerciseState exercise) {
    final done = exercise.completedSets;
    final total = exercise.totalSets;
    final allDone = done == total && total > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: allDone
            ? const Color(0xFF10B981).withValues(alpha: 0.2)
            : const Color(0xFF2A2A3A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: allDone ? const Color(0xFF10B981) : const Color(0xFF3A3A4A),
          width: 1,
        ),
      ),
      child: Text(
        '$done/$total',
        style: TextStyle(
          color: allDone ? const Color(0xFF10B981) : Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildExerciseMenu(ActiveExerciseState exercise) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white.withValues(alpha: 0.6),
        size: 22,
      ),
      color: const Color(0xFF2A2A3A),
      offset: const Offset(0, 40),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF3A3A4A), width: 1),
      ),
      onSelected: (value) {
        if (value == 'add_set') _notifier.addSet(widget.exerciseIndex);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'add_set',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.add_circle_outline, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Aggiungi serie',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            if (completed) _onSetCompleted();
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

  Widget _buildAddSetButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _notifier.addSet(widget.exerciseIndex),
          icon: const Icon(Icons.add, size: 20),
          label: const Text(
            'Serie',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Color(0xFF3A3A4A), width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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

  void _onSetCompleted() {
    // Auto-collapse when all sets in this exercise are done.
    final updated = ref
        .read(activeWorkoutProvider(widget.workoutId))
        .exercises[widget.exerciseIndex];
    if (updated.completedSets == updated.totalSets && _isExpanded) {
      Future.microtask(() {
        if (mounted) _toggleExpanded();
      });
    }
  }

  void _showExerciseInfo(BuildContext context, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseInfoWidget(
        exerciseName: name,
        onClose: () => Navigator.pop(context),
      ),
    );
  }
}
