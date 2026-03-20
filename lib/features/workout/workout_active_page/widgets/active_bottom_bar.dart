import 'package:coachly/features/ai_coach/ai_coach.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveBottomBar extends ConsumerWidget {
  final String workoutId;
  final VoidCallback onComplete;

  const ActiveBottomBar({
    super.key,
    required this.workoutId,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final status = ref.watch(
      activeWorkoutProvider(workoutId).select((s) => s.status),
    );
    final isSaving = status == ActiveWorkoutStatus.saving;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            scheme.surfaceContainerHighest.withValues(alpha: 0.88),
            scheme.surface,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.75),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: isSaving ? null : onComplete,
                icon: isSaving
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.flag_rounded, size: 20),
                label: Text(isSaving ? 'Salvataggio...' : 'Completa sessione'),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  disabledBackgroundColor: scheme.surfaceContainerHighest,
                  disabledForegroundColor: scheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton.filledTonal(
                tooltip: 'AI Coach',
                onPressed: () => _showAICoach(context, ref),
                icon: const Icon(Icons.auto_awesome_rounded, size: 22),
                style: IconButton.styleFrom(
                  backgroundColor: AiCoachTheme.accentPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAICoach(BuildContext context, WidgetRef ref) {
    final workoutState = ref.read(activeWorkoutProvider(workoutId));
    final workoutContext = _buildOverrideContext(workoutState);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (_) => ProviderScope(
        overrides: [
          aiCoachWorkoutIdProvider.overrideWithValue(workoutId),
          currentWorkoutContextProvider.overrideWithValue(workoutContext),
        ],
        child: const AiCoachPanel(),
      ),
    );
  }

  WorkoutContext _buildOverrideContext(ActiveWorkoutState state) {
    if (state.exercises.isEmpty) {
      return WorkoutContext(
        exerciseName: 'Workout attivo',
        currentSet: 1,
        totalSets: 1,
        weightKg: 0,
        targetReps: 0,
        fatigueIndex: 0,
        recentWeights: const [],
        sessionStart: state.startedAt ?? DateTime.now(),
      );
    }

    final exercise = state.exercises.firstWhere(
      (item) => item.sets.any((set) => !set.completed),
      orElse: () => state.exercises.first,
    );

    final currentSetIndex = exercise.sets.indexWhere((set) => !set.completed);
    final resolvedSetIndex = currentSetIndex == -1
        ? (exercise.sets.isEmpty ? 0 : exercise.sets.length - 1)
        : currentSetIndex;
    final resolvedSet = exercise.sets[resolvedSetIndex];

    final completedSets = state.exercises
        .expand((item) => item.sets)
        .where((set) => set.completed)
        .length;
    final totalSets = state.exercises.expand((item) => item.sets).length;
    final fatigueIndex = totalSets == 0 ? 0.0 : completedSets / totalSets;

    return WorkoutContext(
      exerciseName: exercise.displayName,
      currentSet: resolvedSetIndex + 1,
      totalSets: exercise.sets.length,
      weightKg: resolvedSet.weight,
      targetReps: resolvedSet.reps,
      completedReps: resolvedSet.completed ? resolvedSet.reps : null,
      fatigueIndex: fatigueIndex.clamp(0.0, 1.0),
      recentWeights: const [],
      sessionStart: state.startedAt ?? DateTime.now(),
      workoutPlan: _buildWorkoutPlanSummary(state.exercises),
    );
  }

  String _buildWorkoutPlanSummary(List<ActiveExerciseState> exercises) {
    if (exercises.isEmpty) return '';
    final currentIdx = exercises.indexWhere(
      (e) => e.sets.any((s) => !s.completed),
    );
    final buf = StringBuffer();
    for (var i = 0; i < exercises.length; i++) {
      final ex = exercises[i];
      final weight = ex.sets.isNotEmpty
          ? ex.sets.first.weight.toStringAsFixed(1)
          : '0.0';
      final reps = ex.sets.isNotEmpty ? ex.sets.first.reps : 0;
      final total = ex.totalSets;
      final done = ex.completedSets;
      final String status;
      if (done == total) {
        status = 'done';
      } else if (i == currentIdx) {
        status = 'active — set $done/$total completed';
      } else if (currentIdx == -1 || i > currentIdx) {
        status = i == currentIdx + 1 ? 'next' : 'pending';
      } else {
        status = 'done';
      }
      buf.writeln(
        '${i + 1}. ${ex.displayName} — ${total}x$reps @ ${weight}kg [$status]',
      );
    }
    return buf.toString().trimRight();
  }
}
