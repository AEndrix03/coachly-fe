import 'package:coachly/features/active_workout/application/rest_timer_provider.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

/// La testata: titolo, tempo trascorso, uscita.
///
/// Il tempo trascorso e' l'unica informazione che serve sempre durante
/// un allenamento (`docs/product/01-active-workout.md`).
class WorkoutHeader extends StatelessWidget {
  final String title;
  final Duration elapsed;
  final int completedExercises;
  final int totalExercises;
  final RestTimerState rest;
  final VoidCallback onBack;
  final VoidCallback onMenu;
  final VoidCallback onTimerTap;
  final VoidCallback onToggleBell;
  const WorkoutHeader({
    super.key,
    required this.title,
    required this.elapsed,
    required this.completedExercises,
    required this.totalExercises,
    required this.rest,
    required this.onBack,
    required this.onMenu,
    required this.onTimerTap,
    required this.onToggleBell,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final seconds = rest.isActive ? rest.remainingSeconds : elapsed.inSeconds;
    final time =
        '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
    final progress = totalExercises == 0
        ? 0.0
        : completedExercises / totalExercises;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: .98),
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        context.activeTr(
                          'exerciseProgress',
                          params: {
                            'done': '$completedExercises',
                            'total': '$totalExercises',
                          },
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Semantics(
                  button: true,
                  label: rest.isActive
                      ? '${context.activeTr('rest')} $time'
                      : time,
                  child: InkWell(
                    onTap: onTimerTap,
                    borderRadius: BorderRadius.circular(10),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: Text(
                            rest.isActive
                                ? '${context.activeTr('rest').toUpperCase()} $time'
                                : time,
                            style: TextStyle(
                              color: rest.isActive
                                  ? scheme.primary
                                  : scheme.onSurface,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleBell,
                  tooltip: rest.isBellEnabled
                      ? 'Disable timer sounds'
                      : 'Enable timer sounds',
                  icon: Icon(
                    rest.isBellEnabled
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    color: rest.isBellEnabled
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                ),
                IconButton(
                  onPressed: onMenu,
                  tooltip: context.l10n.workoutActiveFinish,
                  icon: const Icon(Icons.flag_outlined),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: scheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
