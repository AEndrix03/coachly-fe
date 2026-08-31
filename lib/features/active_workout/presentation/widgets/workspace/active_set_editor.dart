import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/features/active_workout/application/rest_timer_provider.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:coachly/features/active_workout/presentation/widgets/hold_to_complete_workout_button.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_callbacks.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/set_stepper.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/set_role_picker.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/set_technique_actions.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/drop_set_editor.dart';

/// L'inserimento della serie corrente.
///
/// Il gesto piu' ripetuto della app: decine di volte per allenamento,
/// con le mani sudate. Da qui i bersagli da 56px e le cifre tabulari
/// (`docs/product/01-active-workout.md`).
class ActiveSetEditor extends StatelessWidget {
  final ActiveSetState set;
  final SetValueChanged onWeight;
  final SetValueChanged onReps;
  final ValueChanged<int> onRir;
  final ValueChanged<String> onComplete;
  final ValueChanged<String> onTechnique;
  final ValueChanged<String> onRole;
  final ValueChanged<String> onAddDrop;
  final DropWeightChanged onDropWeight;
  final DropRepsChanged onDropReps;
  final DropRemoved onDropRemoved;
  final String loadUnit;
  final RestTimerState rest;
  final VoidCallback onRestOpen;
  final bool workoutReadyToComplete;
  final VoidCallback onCompleteWorkout;
  const ActiveSetEditor({
    super.key,
    required this.set,
    required this.onWeight,
    required this.onReps,
    required this.onRir,
    required this.onComplete,
    required this.onTechnique,
    required this.onRole,
    required this.onAddDrop,
    required this.onDropWeight,
    required this.onDropReps,
    required this.onDropRemoved,
    required this.loadUnit,
    required this.rest,
    required this.onRestOpen,
    required this.workoutReadyToComplete,
    required this.onCompleteWorkout,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.only(top: context.spacing.sm),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
    child: Column(
      children: [
        SetRolePicker(
          position: set.position,
          selected: set.role,
          onSelected: (role) => onRole(role.name),
        ),
        SetStepper(
          label: context.activeTr('weight'),
          value: '${number(displayWeight(set.weight, loadUnit))} $loadUnit',
          onMinus: () => onWeight(
            set,
            storedWeight(
              displayWeight(set.weight, loadUnit) -
                  (loadUnit == 'lbs' ? 5 : 2.5),
              loadUnit,
            ),
          ),
          onPlus: () => onWeight(
            set,
            storedWeight(
              displayWeight(set.weight, loadUnit) +
                  (loadUnit == 'lbs' ? 5 : 2.5),
              loadUnit,
            ),
          ),
          onDirect: () => showNumberInput(
            context,
            displayWeight(set.weight, loadUnit),
            (value) => onWeight(set, storedWeight(value, loadUnit)),
            label: context.activeTr('weight'),
            unit: loadUnit,
            step: loadUnit == 'lbs' ? 5 : 2.5,
          ),
        ),
        SetStepper(
          label: context.activeTr('reps'),
          value: '${set.reps}',
          onMinus: () => onReps(set, set.reps - 1),
          onPlus: () => onReps(set, set.reps + 1),
          onDirect: () => showNumberInput(
            context,
            set.reps.toDouble(),
            (value) => onReps(set, value.round()),
            label: context.activeTr('reps'),
            step: 1,
          ),
        ),
        if (set.drops.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...set.drops.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DropEditor(
                index: entry.key,
                drop: entry.value,
                loadUnit: loadUnit,
                onWeight: (weight) =>
                    onDropWeight(set.id, entry.value.id, weight),
                onReps: (reps) => onDropReps(set.id, entry.value.id, reps),
                onRemove: () => onDropRemoved(set.id, entry.value.id),
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        SetTechniqueActions(
          selected: set.technique,
          onAddDrop: () => onAddDrop(set.id),
          onSelected: (technique) => onTechnique(
            technique == set.technique
                ? SetTechnique.none.name
                : technique.name,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.l10n.workoutActiveRirExplained,
            style: labelStyle,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final rir in [0, 1, 2, 3, 4])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: RirChoice(
                    value: rir,
                    selected: set.rir == rir,
                    onTap: () => onRir(rir),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        if (workoutReadyToComplete)
          HoldToCompleteWorkoutButton(
            label: context.activeTr('completeWorkout'),
            holdHint: context.tr('workout.active.complete_hold_hint'),
            releasedHint: context.tr('workout.active.complete_hold_released'),
            onCompleted: onCompleteWorkout,
          )
        else
          CompleteSetButton(
            label: rest.isActive
                ? '${context.activeTr('rest')} · ${clock(rest.remainingSeconds)}'
                : context.activeTr('completeSet'),
            onPressed: rest.isActive ? onRestOpen : () => onComplete(set.id),
          ),
      ],
    ),
  );
}

class CompleteSetButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const CompleteSetButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<CompleteSetButton> createState() => CompleteSetButtonState();
}

class CompleteSetButtonState extends State<CompleteSetButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deepGreen = Color.lerp(scheme.primary, scheme.surface, .22)!;
    final brightGreen = Color.lerp(scheme.primary, scheme.onSurface, .08)!;
    final foreground = scheme.onPrimary;
    return Semantics(
      button: true,
      label: widget.label,
      child: AnimatedScale(
        scale: _pressed ? .985 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          height: CoachlyAthleteTheme.primaryActionHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _pressed
                  ? [deepGreen, scheme.primary]
                  : [brightGreen, scheme.primary, deepGreen],
              stops: _pressed ? const [0, 1] : const [0, .5, 1],
            ),
            borderRadius: BorderRadius.circular(
              CoachlyAthleteTheme.actionRadius,
            ),
            border: Border.all(color: scheme.onSurface.withValues(alpha: .1)),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: _pressed ? .1 : .2),
                blurRadius: _pressed ? 9 : 18,
                offset: Offset(0, _pressed ? 3 : 8),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      CoachlyAthleteTheme.actionRadius,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        scheme.onSurface.withValues(alpha: .12),
                        scheme.onSurface.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: scheme.onSurface.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(
                  CoachlyAthleteTheme.actionRadius,
                ),
                child: InkWell(
                  onTap: widget.onPressed,
                  onHighlightChanged: (pressed) {
                    if (_pressed != pressed) {
                      setState(() => _pressed = pressed);
                    }
                  },
                  borderRadius: BorderRadius.circular(
                    CoachlyAthleteTheme.actionRadius,
                  ),
                  splashColor: foreground.withValues(alpha: .1),
                  highlightColor: foreground.withValues(alpha: .05),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: foreground.withValues(alpha: .1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: foreground.withValues(alpha: .16),
                            ),
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: foreground,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.label.toUpperCase(),
                          style: context.scale.captionLoose.black.copyWith(
                            color: foreground,
                            height: 1,
                            letterSpacing: .85,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
