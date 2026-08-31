import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

/// Le scalate di peso dentro una serie.
class DropEditor extends StatelessWidget {
  final int index;
  final DropSetState drop;
  final String loadUnit;
  final ValueChanged<double> onWeight;
  final ValueChanged<int> onReps;
  final VoidCallback onRemove;

  const DropEditor({
    super.key,
    required this.index,
    required this.drop,
    required this.loadUnit,
    required this.onWeight,
    required this.onReps,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final displayedWeight = displayWeight(drop.weight, loadUnit);
    final weightStep = loadUnit == 'lbs' ? 5.0 : 2.5;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              color: scheme.primary.withValues(alpha: .72),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'DROP ${index + 1}',
                          style: labelStyle.copyWith(color: scheme.primary),
                        ),
                      ),
                      IconButton(
                        onPressed: onRemove,
                        tooltip: 'Remove drop ${index + 1}',
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 19,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  DropValueRow(
                    label: context.l10n.workoutActiveWeight,
                    value: '${number(displayedWeight)} $loadUnit',
                    onMinus: () => onWeight(
                      storedWeight(
                        (displayedWeight - weightStep).clamp(
                          0,
                          double.infinity,
                        ),
                        loadUnit,
                      ),
                    ),
                    onPlus: () => onWeight(
                      storedWeight(displayedWeight + weightStep, loadUnit),
                    ),
                    onValueTap: () => showNumberInput(
                      context,
                      displayedWeight,
                      (value) => onWeight(storedWeight(value, loadUnit)),
                      label: 'Drop ${index + 1} weight',
                      unit: loadUnit,
                      step: weightStep,
                    ),
                  ),
                  Divider(height: 1, color: scheme.outlineVariant),
                  DropValueRow(
                    label: context.l10n.workoutActiveReps,
                    value: '${drop.reps}',
                    onMinus: () => onReps((drop.reps - 1).clamp(0, 999)),
                    onPlus: () => onReps((drop.reps + 1).clamp(0, 999)),
                    onValueTap: () => showNumberInput(
                      context,
                      drop.reps.toDouble(),
                      (value) => onReps(value.round()),
                      label: 'Drop ${index + 1} reps',
                      step: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropValueRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onValueTap;

  const DropValueRow({
    super.key,
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    required this.onValueTap,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Row(
      children: [
        SizedBox(width: 58, child: Text(label, style: labelStyle)),
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove_rounded, size: 19),
        ),
        Expanded(
          child: InkWell(
            onTap: onValueTap,
            borderRadius: BorderRadius.circular(8),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: context.scale.subtitle.heavy.copyWith(
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_rounded, size: 19),
        ),
      ],
    ),
  );
}
