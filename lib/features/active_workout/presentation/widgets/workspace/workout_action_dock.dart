import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:flutter/material.dart';

/// Le tre azioni in fondo: struttura, aggiungi, nota.
///
/// In basso al centro, dove arriva il pollice di una mano sola.
class WorkoutActionDock extends StatelessWidget {
  final VoidCallback onStructure;
  final VoidCallback onAdd;
  final VoidCallback onNotes;
  const WorkoutActionDock({
    super.key,
    required this.onStructure,
    required this.onAdd,
    required this.onNotes,
  });
  @override
  Widget build(BuildContext context) => Container(
    height: 68,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Row(
      children: [
        Expanded(
          child: DockButton(
            icon: Icons.format_list_bulleted_rounded,
            label: context.activeTr('structure'),
            onTap: onStructure,
          ),
        ),
        Expanded(
          child: DockButton(
            icon: Icons.add_rounded,
            label: context.activeTr('add'),
            onTap: onAdd,
            primary: true,
          ),
        ),
        Expanded(
          child: DockButton(
            icon: Icons.edit_note_rounded,
            label: context.activeTr('quickNote'),
            onTap: onNotes,
          ),
        ),
      ],
    ),
  );
}

class DockButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const DockButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          width: 64,
          height: 56,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: primary ? 48 : 44,
                height: primary ? 48 : 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primary
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: primary ? 26 : 21,
                  color: primary
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (!primary)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Text(
                    label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: context.scale.microTight.bold.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
