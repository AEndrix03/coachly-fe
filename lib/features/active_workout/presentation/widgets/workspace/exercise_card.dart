import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/features/active_workout/application/rest_timer_provider.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_callbacks.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/active_set_editor.dart';

/// La scheda dell'esercizio e la sua tabella delle serie.
///
/// E' l'unico blocco che si espande: gli altri restano compatti.
class ExerciseCard extends StatelessWidget {
  final ActiveExerciseState exercise;
  final String? activeSetId;
  final String? groupLabel;
  final bool active;
  final VoidCallback onActivate;
  final ValueChanged<String> onSet;
  final SetValueChanged onWeight;
  final SetValueChanged onReps;
  final ValueChanged<int> onRir;
  final ValueChanged<String> onComplete;
  final VoidCallback onAddSet;
  final ValueChanged<String> onTechnique;
  final ValueChanged<String> onRole;
  final ValueChanged<String> onAddDrop;
  final DropWeightChanged onDropWeight;
  final DropRepsChanged onDropReps;
  final DropRemoved onDropRemoved;
  final String loadUnit;
  final VoidCallback onInfo;
  final RestTimerState rest;
  final VoidCallback onRestOpen;
  final bool workoutReadyToComplete;
  final VoidCallback onCompleteWorkout;
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.activeSetId,
    required this.groupLabel,
    required this.active,
    required this.onActivate,
    required this.onSet,
    required this.onWeight,
    required this.onReps,
    required this.onRir,
    required this.onComplete,
    required this.onAddSet,
    required this.onTechnique,
    required this.onRole,
    required this.onAddDrop,
    required this.onDropWeight,
    required this.onDropReps,
    required this.onDropRemoved,
    required this.loadUnit,
    required this.onInfo,
    required this.rest,
    required this.onRestOpen,
    required this.workoutReadyToComplete,
    required this.onCompleteWorkout,
  });
  @override
  Widget build(BuildContext context) {
    if (!active) {
      return InkWell(
        onTap: onActivate,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: CoachlyAthleteTheme.border),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Exercise · ${exercise.completedSets}/${exercise.totalSets}',
                      style: context.scale.captionTight.copyWith(
                        color: CoachlyAthleteTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: CoachlyAthleteTheme.textSecondary,
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExerciseSetDisclosure(
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (groupLabel != null)
                  Text(
                    groupLabel!,
                    style: context.scale.micro.black.copyWith(
                      color: CoachlyAthleteTheme.primary,
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // `Flexible` con due righe e ellissi: a 30px in w800 un
                    // nome come «Squat con bilanciere» misura piu' della
                    // larghezza disponibile, e senza vincolo sforava di 284px
                    // — cioe' il nome dell'esercizio era in parte invisibile.
                    // I nomi lunghi sono la norma, non il caso limite.
                    Flexible(
                      child: InkWell(
                        key: const Key('active-exercise-detail-link'),
                        onTap: onInfo,
                        borderRadius: BorderRadius.circular(
                          context.radii.compact,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: context.sizes.touchTarget,
                          ),
                          child: Center(
                            child: Text(
                              exercise.displayName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              // Parte da `titleLarge` per ereditare famiglia e
                              // colore dal tema Material: sostituirla con un
                              // token scarterebbe proprio cio' che prende.
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    // ignore: no_literal_text_style
                                    fontSize: 30,
                                    height: 1.05,
                                    letterSpacing: -.7,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  context.activeTr(
                    'setProgress',
                    params: {
                      'current': '${exercise.completedSets + 1}',
                      'total': '${exercise.totalSets}',
                    },
                  ),
                  style: context.scale.captionLoose.semibold.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            table: SetTable(
              exercise: exercise,
              activeSetId: activeSetId,
              onSet: onSet,
              loadUnit: loadUnit,
            ),
            actions: Row(
              children: [
                TextButton.icon(
                  onPressed: onAddSet,
                  icon: const Icon(Icons.add_rounded, size: 19),
                  label: Text(context.activeTr('addSet')),
                ),
              ],
            ),
          ),
          if (activeSetId != null) ...[
            SizedBox(height: context.spacing.sm),
            ActiveSetEditor(
              set: exercise.sets.firstWhere((set) => set.id == activeSetId),
              onWeight: onWeight,
              onReps: onReps,
              onRir: onRir,
              onComplete: onComplete,
              onTechnique: onTechnique,
              onRole: onRole,
              onAddDrop: onAddDrop,
              onDropWeight: onDropWeight,
              onDropReps: onDropReps,
              onDropRemoved: onDropRemoved,
              loadUnit: loadUnit,
              rest: rest,
              onRestOpen: onRestOpen,
              workoutReadyToComplete: workoutReadyToComplete,
              onCompleteWorkout: onCompleteWorkout,
            ),
          ],
        ],
      ),
    );
  }
}

class ExerciseSetDisclosure extends StatefulWidget {
  final Widget header;
  final Widget table;
  final Widget actions;

  const ExerciseSetDisclosure({
    super.key,
    required this.header,
    required this.table,
    required this.actions,
  });

  @override
  State<ExerciseSetDisclosure> createState() => ExerciseSetDisclosureState();
}

class ExerciseSetDisclosureState extends State<ExerciseSetDisclosure>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _size;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _size = _controller;
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.08, .72, curve: Curves.easeOut),
      reverseCurve: const Interval(.28, 1, curve: Curves.easeIn),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -.025),
      end: Offset.zero,
    ).animate(_size);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    final expanded = !_expanded;
    setState(() => _expanded = expanded);
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = expanded ? 1 : 0;
    } else {
      final velocity = _controller.velocity;
      _controller.animateWith(
        SpringSimulation(
          disclosureSpring,
          _controller.value,
          expanded ? 1 : 0,
          velocity,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: widget.header),
            IconButton(
              onPressed: _toggle,
              tooltip: _expanded ? 'Hide set table' : 'Show set table',
              icon: RotationTransition(
                turns: Tween<double>(begin: 0, end: .5).animate(_size),
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ],
        ),
        ClipRect(
          child: SizeTransition(
            sizeFactor: _size,
            axisAlignment: -1,
            child: IgnorePointer(
              ignoring: !_expanded,
              child: FadeTransition(
                opacity: _opacity,
                child: SlideTransition(
                  position: _offset,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [widget.table, widget.actions],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SetTable extends StatelessWidget {
  final ActiveExerciseState exercise;
  final String? activeSetId;
  final ValueChanged<String> onSet;
  final String loadUnit;
  const SetTable({
    super.key,
    required this.exercise,
    required this.activeSetId,
    required this.onSet,
    required this.loadUnit,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 10, bottom: 7),
          child: Row(
            children: [
              SizedBox(
                width: 42,
                child: Text(
                  context.l10n.workoutActiveColSet,
                  style: labelStyle,
                ),
              ),
              Expanded(
                child: Text(
                  context.l10n.workoutActiveColPrevious,
                  style: labelStyle,
                ),
              ),
              SizedBox(
                width: 54,
                child: Text(loadUnit.toUpperCase(), style: labelStyle),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  context.l10n.workoutActiveColReps,
                  style: labelStyle,
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  context.l10n.workoutActiveColRir,
                  style: labelStyle,
                ),
              ),
            ],
          ),
        ),
        ...exercise.sets.map((set) {
          final current = set.id == activeSetId;
          final subdued = !current && !set.completed;
          return Semantics(
            button: true,
            selected: current,
            label:
                'Set ${set.position + 1}, ${number(set.weight)} kilograms, ${set.reps} repetitions${set.rir == null ? '' : ', RIR ${set.rir}'}${current ? ', in progress' : ''}',
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: InkWell(
                onTap: () => onSet(set.id),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: current ? 58 : 50,
                  decoration: BoxDecoration(
                    color: current
                        ? scheme.primary.withValues(alpha: .08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 3,
                        height: current
                            ? 36
                            : set.completed
                            ? 18
                            : 0,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 42,
                        child: Row(
                          children: [
                            if (set.completed)
                              Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: scheme.primary,
                              )
                            else
                              Text(
                                setPrefix(set),
                                style: TextStyle(
                                  color: current
                                      ? scheme.primary
                                      : scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.completed
                              ? '${number(displayWeight(set.weight, loadUnit))} × ${set.reps}'
                              : '—',
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 54,
                        child: Text(
                          number(displayWeight(set.weight, loadUnit)),
                          style: TextStyle(
                            color: subdued ? scheme.onSurfaceVariant : null,
                            fontWeight: current ? FontWeight.w800 : null,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${set.reps}',
                          style: TextStyle(
                            color: subdued ? scheme.onSurfaceVariant : null,
                            fontWeight: current ? FontWeight.w800 : null,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        child: Text(
                          set.rir?.toString() ?? '—',
                          style: TextStyle(
                            color: subdued ? scheme.onSurfaceVariant : null,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// Costante di primo livello: non esiste un BuildContext da cui leggere il
// token. Diventera' convertibile solo spostandola dentro un widget.
