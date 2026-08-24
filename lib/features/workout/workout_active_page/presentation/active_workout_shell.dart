import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/active_workout_strings.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActiveWorkoutSessionHeader extends StatelessWidget {
  final String title;
  final Duration elapsed;
  final int completedExercises;
  final int totalExercises;
  final RestTimerState rest;
  final VoidCallback onBack;
  final VoidCallback onMenu;

  const ActiveWorkoutSessionHeader({
    super.key,
    required this.title,
    required this.elapsed,
    required this.completedExercises,
    required this.totalExercises,
    required this.rest,
    required this.onBack,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '$minutes:$seconds',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  context.activeTr(
                    'exerciseProgress',
                    params: {
                      'done': '$completedExercises',
                      'total': '$totalExercises',
                    },
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMenu,
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
    );
  }
}

class CurrentExerciseHeader extends StatelessWidget {
  final ActiveExerciseState exercise;
  final ActiveSetState set;
  final VoidCallback onExerciseTap;
  final VoidCallback onActions;

  const CurrentExerciseHeader({
    super.key,
    required this.exercise,
    required this.set,
    required this.onExerciseTap,
    required this.onActions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onExerciseTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.displayName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  context.activeTr(
                    'setProgress',
                    params: {
                      'current': '${set.position + 1}',
                      'total': '${exercise.totalSets}',
                    },
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onActions,
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      ],
    );
  }
}

class PreviousTargetContext extends StatelessWidget {
  final ActiveSetState set;
  const PreviousTargetContext({super.key, required this.set});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ContextValue(
              label: context.activeTr('previous'),
              value: context.activeTr('newBaseline'),
            ),
          ),
          Expanded(
            child: _ContextValue(
              label: context.activeTr('target'),
              value:
                  '${_weight(set.weight)} × ${set.reps}${set.rir == null ? '' : ' @${set.rir}'}',
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextValue extends StatelessWidget {
  final String label;
  final String value;
  const _ContextValue({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ],
  );
}

class CurrentSetControls extends StatelessWidget {
  final ActiveSetState set;
  final bool showWeight;
  final bool showReps;
  final bool showRir;
  final ValueChanged<double> onWeight;
  final ValueChanged<int> onReps;
  final ValueChanged<int> onRir;

  const CurrentSetControls({
    super.key,
    required this.set,
    required this.showWeight,
    required this.showReps,
    required this.showRir,
    required this.onWeight,
    required this.onReps,
    required this.onRir,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (showWeight)
        _StepperControl(
          semanticLabel: context.activeTr('weight'),
          value: '${_weight(set.weight)} kg',
          onMinus: () =>
              onWeight((set.weight - 2.5).clamp(0, double.infinity).toDouble()),
          onPlus: () => onWeight(set.weight + 2.5),
        ),
      if (showWeight && showReps) const SizedBox(height: 12),
      if (showReps)
        _StepperControl(
          semanticLabel: context.activeTr('reps'),
          value: '${set.reps} reps',
          onMinus: () => onReps((set.reps - 1).clamp(0, 999).toInt()),
          onPlus: () => onReps(set.reps + 1),
        ),
      if (showRir) ...[
        const SizedBox(height: 18),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'RIR',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final value in [0, 1, 2, 3, 4])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(value == 4 ? '4+' : '$value'),
                    selected: set.rir == value,
                    onSelected: (_) => onRir(value),
                  ),
                ),
              ),
          ],
        ),
      ],
    ],
  );
}

class _StepperControl extends StatelessWidget {
  final String semanticLabel;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  const _StepperControl({
    required this.semanticLabel,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticLabel,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: CoachlyAthleteTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(
            CoachlyAthleteTheme.compactRadius,
          ),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: IconButton(
                onPressed: onMinus,
                icon: const Icon(Icons.remove_rounded),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
            SizedBox(
              width: 64,
              height: 64,
              child: IconButton(
                onPressed: onPlus,
                icon: const Icon(Icons.add_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseSetStrip extends StatelessWidget {
  final ActiveExerciseState exercise;
  final String currentSetId;
  final ValueChanged<String> onSetTap;
  const ExerciseSetStrip({
    super.key,
    required this.exercise,
    required this.currentSetId,
    required this.onSetTap,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.activeTr('sets'),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
      const SizedBox(height: 8),
      for (final set in exercise.sets)
        InkWell(
          onTap: () => onSetTap(set.id),
          child: SizedBox(
            height: CoachlyAthleteTheme.touchTarget,
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '${set.position + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  child: Text(
                    set.id == currentSetId
                        ? context.activeTr('current')
                        : '${_weight(set.weight)} × ${set.reps}',
                    style: TextStyle(
                      color: set.id == currentSetId
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  set.completed
                      ? Icons.check_circle_rounded
                      : set.skipped
                      ? Icons.remove_circle_outline_rounded
                      : Icons.circle_outlined,
                  color: set.completed
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

class CompactRestTimer extends StatelessWidget {
  final RestTimerState state;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onSkip;
  const CompactRestTimer({
    super.key,
    required this.state,
    required this.onMinus,
    required this.onPlus,
    required this.onSkip,
  });
  @override
  Widget build(BuildContext context) {
    if (!state.isActive) return const SizedBox.shrink();
    final time =
        '${(state.remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(state.remainingSeconds % 60).toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
      ),
      child: Row(
        children: [
          Text(
            '${context.activeTr('rest')} $time',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const Spacer(),
          TextButton(onPressed: onMinus, child: const Text('-30s')),
          TextButton(onPressed: onPlus, child: const Text('+30s')),
          TextButton(onPressed: onSkip, child: Text(context.activeTr('skip'))),
        ],
      ),
    );
  }
}

class CoachDecisionCard extends StatelessWidget {
  final CoachDecision decision;
  final VoidCallback onWhy;
  const CoachDecisionCard({
    super.key,
    required this.decision,
    required this.onWhy,
  });
  @override
  Widget build(BuildContext context) {
    final warning = decision.primary.severity == CoachDecisionSeverity.warning;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (warning ? scheme.error : scheme.primary).withValues(alpha: .11),
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
        border: Border.all(
          color: (warning ? scheme.error : scheme.primary).withValues(
            alpha: .35,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            warning ? Icons.warning_amber_rounded : Icons.auto_awesome_rounded,
            color: warning ? scheme.error : scheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.activeTr('coachly'),
                  style: TextStyle(
                    color: warning ? scheme.error : scheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  decision.primary.titleKey,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onWhy, child: Text(context.activeTr('why'))),
        ],
      ),
    );
  }
}

String _weight(double value) => value == value.truncateToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);
