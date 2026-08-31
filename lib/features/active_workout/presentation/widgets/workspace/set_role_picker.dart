import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/spring_reveal.dart';

/// A cosa serve la serie: riscaldamento, top set, back-off, di lavoro.
///
/// Separato dalla tecnica di proposito: sono due assi indipendenti, e un
/// riscaldamento a cedimento e' una combinazione normale.
class SetRolePicker extends StatefulWidget {
  final int position;
  final SetRole selected;
  final ValueChanged<SetRole> onSelected;

  const SetRolePicker({
    super.key,
    required this.position,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<SetRolePicker> createState() => SetRolePickerState();
}

class SetRolePickerState extends State<SetRolePicker> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'SET ${widget.position + 1}',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => _open = !_open),
              label: Text(roleName(widget.selected)),
              iconAlignment: IconAlignment.end,
              icon: AnimatedRotation(
                turns: _open ? .5 : 0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ],
        ),
        SpringReveal(
          visible: _open,
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < SetRole.values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == SetRole.values.length - 1 ? 0 : 4,
                      ),
                      child: SetRoleTile(
                        role: SetRole.values[index],
                        selected: widget.selected == SetRole.values[index],
                        onTap: () {
                          widget.onSelected(SetRole.values[index]);
                          setState(() => _open = false);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SetRoleTile extends StatelessWidget {
  final SetRole role;
  final bool selected;
  final VoidCallback onTap;

  const SetRoleTile({
    super.key,
    required this.role,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = switch (role) {
      SetRole.working => Icons.fitness_center_rounded,
      SetRole.warmup => Icons.local_fire_department_rounded,
      SetRole.topSet => Icons.vertical_align_top_rounded,
      SetRole.backoff => Icons.trending_down_rounded,
    };
    return Semantics(
      button: true,
      selected: selected,
      label: roleName(role),
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: .12)
                  : scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(height: 7),
                Text(
                  roleName(role),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.scale.micro.heavy.copyWith(
                    color: selected ? scheme.primary : scheme.onSurface,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
