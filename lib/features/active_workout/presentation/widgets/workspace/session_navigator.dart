import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

/// L'orientamento senza navigazione.
///
/// Mostra tutti gli esercizi con quello corrente evidenziato: il piano
/// di lavoro resta visibile, perche' chi si allena salta e torna
/// indietro e non deve navigare per farlo.
class SessionNavigator extends StatelessWidget {
  final List<ActiveExerciseState> exercises;
  final List<ActiveExerciseGroup> groups;
  final String? activeExerciseId;
  final ValueChanged<String> onTap;
  const SessionNavigator({
    super.key,
    required this.exercises,
    required this.groups,
    required this.activeExerciseId,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 82,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      itemCount: exercises.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        final active = exercise.exercise.id == activeExerciseId;
        final done =
            exercise.sets.isNotEmpty &&
            exercise.sets.every((set) => set.completed || set.skipped);
        final group = groups
            .where((group) => group.exerciseIds.contains(exercise.exercise.id))
            .firstOrNull;
        return Semantics(
          button: true,
          selected: active,
          label:
              '${exercise.displayName}, ${done
                  ? 'completed'
                  : active
                  ? 'active'
                  : 'pending'}',
          child: InkWell(
            onTap: () => onTap(exercise.exercise.id),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: group == null ? 132 : 140,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : done
                    ? Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: .7)
                    : Theme.of(context).colorScheme.surfaceContainerHigh,
                border: Border.all(
                  color: active
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .55)
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (group != null)
                    Text(
                      groupName(group.type),
                      style: context.scale.microTight.heavy.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      exercise.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.scale.caption.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          done
                              ? 'COMPLETED'
                              : active
                              ? 'SET ${exercise.completedSets + 1} / ${exercise.totalSets}'
                              : '${exercise.completedSets} / ${exercise.totalSets}',
                          style: context.scale.microTight.semibold.copyWith(
                            color: done
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : active
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            letterSpacing: .5,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      if (done)
                        Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                  if (active) ...[
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: exercise.totalSets == 0
                            ? 0
                            : exercise.completedSets / exercise.totalSets,
                        minHeight: 2,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class StructuralContext extends StatelessWidget {
  final String sectionTitle;

  const StructuralContext({super.key, required this.sectionTitle});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionTitle.toUpperCase(),
                style: labelStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class StructureExerciseRow extends StatelessWidget {
  final int index;
  final ActiveExerciseState exercise;
  final VoidCallback onTap;

  const StructureExerciseRow({
    super.key,
    required this.index,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final completed =
        exercise.totalSets > 0 && exercise.completedSets == exercise.totalSets;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 62),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(
              alpha: completed ? .45 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: completed
                    ? Icon(Icons.check_rounded, color: scheme.primary, size: 19)
                    : Text(
                        '$index',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${exercise.totalSets} set',
                      style: context.scale.captionTight.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${exercise.completedSets}/${exercise.totalSets}',
                style: TextStyle(
                  color: completed ? scheme.primary : scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
