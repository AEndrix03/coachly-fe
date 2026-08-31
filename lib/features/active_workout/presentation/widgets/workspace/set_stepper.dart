import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

/// Gli scatti di peso e ripetizioni, e la scelta del RIR.
///
/// I bersagli sono larghi 56px in una riga alta 68, non 48: la soglia di
/// accessibilita' e' il minimo per un dito asciutto e fermo, non per un
/// dito sudato dopo uno stacco (`docs/product/01-active-workout.md`).
class SetStepper extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDirect;
  const SetStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    required this.onDirect,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Container(
      height: 68,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: IconButton(
              onPressed: onMinus,
              icon: const Icon(Icons.remove_rounded),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onDirect,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label.toUpperCase(), style: labelStyle),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: context.scale.headline.black.copyWith(
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 56,
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

class RirChoice extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const RirChoice({
    super.key,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: 'RIR ${value == 4 ? '4 or more' : value}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedScale(
          scale: selected ? 1 : .96,
          duration: const Duration(milliseconds: 160),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? scheme.primary : scheme.surfaceContainerHigh,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            child: Text(
              value == 4 ? '4+' : '$value',
              style: TextStyle(
                color: selected ? scheme.onPrimary : scheme.onSurface,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
