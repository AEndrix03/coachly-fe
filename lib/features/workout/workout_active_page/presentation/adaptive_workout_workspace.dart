import 'dart:async';
import 'package:coachly/core/assets/app_assets.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/active_workout_strings.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/main_area_scroll_assist.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SetValueChanged = void Function(ActiveSetState set, num value);
typedef DropWeightChanged =
    void Function(String setId, String dropId, double weight);
typedef DropRepsChanged = void Function(String setId, String dropId, int reps);
typedef DropRemoved = void Function(String setId, String dropId);
typedef SetNoteChanged =
    void Function(String setId, String text, Set<SetNoteTag> tags);
typedef BlockCreate =
    void Function(List<String> exerciseIds, ExerciseGroupType type);
typedef BlockExerciseAdd = Future<({String id, String name})?> Function();

const _disclosureSpring = SpringDescription(
  mass: 1,
  stiffness: 280,
  damping: 32,
);

/// The active-workout presentation is deliberately a workspace: the full
/// session stays visible while only the active exercise and set expand.
class AdaptiveWorkoutWorkspace extends StatelessWidget {
  final ActiveWorkoutState state;
  final String title;
  final Duration elapsed;
  final RestTimerState rest;
  final VoidCallback onBack;
  final VoidCallback onMenu;
  final ValueChanged<String> onExercise;
  final ValueChanged<String> onSet;
  final SetValueChanged onWeight;
  final SetValueChanged onReps;
  final ValueChanged<int> onRir;
  final ValueChanged<String> onComplete;
  final ValueChanged<String> onAddSet;
  final ValueChanged<String> onTechnique;
  final ValueChanged<String> onRole;
  final ValueChanged<String> onAddDrop;
  final DropWeightChanged onDropWeight;
  final DropRepsChanged onDropReps;
  final DropRemoved onDropRemoved;
  final String loadUnit;
  final ValueChanged<String> onExerciseInfo;
  final BlockCreate onCreateGroup;
  final VoidCallback onAddExercise;
  final BlockExerciseAdd onAddBlockExercise;
  final ValueChanged<String> onUngroup;
  final VoidCallback onCompleteWorkout;
  final VoidCallback onSkipRest;
  final ValueChanged<int> onRestAdjust;
  final VoidCallback onRestTogglePause;
  final VoidCallback onRestToggleBell;
  final SetNoteChanged onNote;

  const AdaptiveWorkoutWorkspace({
    super.key,
    required this.state,
    required this.title,
    required this.elapsed,
    required this.rest,
    required this.onBack,
    required this.onMenu,
    required this.onExercise,
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
    required this.onExerciseInfo,
    required this.onCreateGroup,
    required this.onAddExercise,
    required this.onAddBlockExercise,
    required this.onUngroup,
    required this.onCompleteWorkout,
    required this.onSkipRest,
    required this.onRestAdjust,
    required this.onRestTogglePause,
    required this.onRestToggleBell,
    required this.onNote,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final completedExercises = state.exercises
        .where(
          (exercise) =>
              exercise.sets.isNotEmpty &&
              exercise.sets.every((set) => set.completed || set.skipped),
        )
        .length;
    final activeId = state.currentExercise?.exercise.id;
    final allDone = state.currentTarget == null;
    return ColoredBox(
      color: scheme.surface,
      child: Column(
        children: [
          _WorkoutHeader(
            title: title,
            elapsed: elapsed,
            completedExercises: completedExercises,
            totalExercises: state.totalExercises,
            rest: rest,
            onBack: onBack,
            onMenu: onMenu,
            onToggleBell: onRestToggleBell,
            onTimerTap: () => _showRestSheet(context),
          ),
          Expanded(
            child: allDone
                ? _CompletedWorkspace(onComplete: onCompleteWorkout)
                : MainAreaScrollAssist(
                    mainIdentity: activeId ?? '',
                    leading: _SessionNavigator(
                      exercises: state.exercises,
                      groups: state.groups,
                      activeExerciseId: activeId,
                      onTap: onExercise,
                    ),
                    beforeMain: _buildStructuralContext(),
                    main: _buildMainArea(context),
                  ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .25),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: rest.isActive
                ? _RestLiveBar(
                    key: const ValueKey('rest-live-bar'),
                    rest: rest,
                    onOpen: () => _showRestSheet(context),
                    onMinus: () => onRestAdjust(-30),
                    onPlus: () => onRestAdjust(30),
                    onSkip: onSkipRest,
                  )
                : const SizedBox.shrink(key: ValueKey('live-area-empty')),
          ),
          _WorkoutActionDock(
            onStructure: () => _showStructureSheet(context),
            onAdd: () => _showAddToWorkoutSheet(context),
            onNotes: () => _showQuickNoteSheet(context),
          ),
        ],
      ),
    );
  }

  Widget? _buildStructuralContext() {
    final exercise = state.currentExercise;
    if (exercise == null) return null;
    final block = state.workout?.programmingBlocks
        .where((item) => item.id == exercise.executionBlockId)
        .firstOrNull;
    return block?.sectionTitle == null
        ? null
        : _StructuralContext(sectionTitle: block!.sectionTitle!);
  }

  Widget _buildMainArea(BuildContext context) {
    final exercise = state.currentExercise!;
    final group = state.groups
        .where((item) => item.exerciseIds.contains(exercise.exercise.id))
        .firstOrNull;
    return _exerciseCard(
      context,
      exercise,
      true,
      group == null ? null : _groupName(group.type),
    );
  }

  Widget _exerciseCard(
    BuildContext context,
    ActiveExerciseState exercise,
    bool active,
    String? groupLabel,
  ) => _ExerciseCard(
    exercise: exercise,
    activeSetId: active ? state.currentSet?.id : null,
    groupLabel: groupLabel,
    active: active,
    onActivate: () => onExercise(exercise.exercise.id),
    onSet: onSet,
    onWeight: onWeight,
    onReps: onReps,
    onRir: onRir,
    onComplete: onComplete,
    onAddSet: () => onAddSet(exercise.exercise.id),
    onTechnique: onTechnique,
    onRole: onRole,
    onAddDrop: onAddDrop,
    onDropWeight: onDropWeight,
    onDropReps: onDropReps,
    onDropRemoved: onDropRemoved,
    loadUnit: loadUnit,
    onInfo: () => onExerciseInfo(exercise.exercise.id),
  );

  void _showQuickNoteSheet(BuildContext context) {
    final exercise = state.currentExercise;
    final set = state.currentSet;
    if (exercise == null || set == null) return;
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: scheme.surfaceContainerHigh,
      barrierColor: scheme.scrim.withValues(alpha: .28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => _QuickNoteSheet(
        exerciseName: exercise.displayName,
        set: set,
        onSave: (text, tags) => onNote(set.id, text, tags),
      ),
    );
  }

  void _showRestSheet(BuildContext context) {
    if (!rest.isActive) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Consumer(
        builder: (context, ref, _) {
          final liveRest = ref.watch(restTimerProvider);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    sheetContext.activeTr('rest').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(sheetContext).textTheme.labelLarge
                        ?.copyWith(
                          color: Theme.of(sheetContext).colorScheme.primary,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _clock(liveRest.remainingSeconds),
                    textAlign: TextAlign.center,
                    style: Theme.of(sheetContext).textTheme.displaySmall
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                  Text(
                    'of ${_clock(liveRest.initialSeconds)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(
                        sheetContext,
                      ).colorScheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => onRestAdjust(-30),
                          child: Text(
                            context.tr('workout.active.rest_minus_30'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => onRestAdjust(30),
                          child: Text(
                            context.tr('workout.active.rest_plus_30'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          onRestTogglePause();
                          Navigator.pop(sheetContext);
                        },
                        icon: Icon(
                          liveRest.isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                        ),
                        label: Text(liveRest.isPaused ? 'Resume' : 'Pause'),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          onSkipRest();
                        },
                        child: Text(sheetContext.activeTr('skip')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddToWorkoutSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radii.xl),
        ),
      ),
      builder: (sheetContext) => _AddToWorkoutSheet(
        exercises: [
          for (final exercise in state.exercises)
            (id: exercise.exercise.id, name: exercise.displayName),
        ],
        initiallySelectedId: state.currentExercise?.exercise.id,
        onAddBlockExercise: onAddBlockExercise,
        onAddSet: () {
          Navigator.pop(sheetContext);
          final id = state.currentExercise?.exercise.id;
          if (id != null) onAddSet(id);
        },
        onAddExercise: () {
          Navigator.pop(sheetContext);
          WidgetsBinding.instance.addPostFrameCallback((_) => onAddExercise());
        },
        onCreateGroup: (ids, type) {
          Navigator.pop(sheetContext);
          onCreateGroup(ids, type);
        },
      ),
    );
  }

  void _showStructureSheet(BuildContext context) {
    final blocks = state.workout?.programmingBlocks ?? const [];
    final children = <Widget>[];
    String? previousSectionKey;

    for (final block in blocks) {
      final sectionKey = block.sectionId ?? '__implicit__';
      if (sectionKey != previousSectionKey) {
        previousSectionKey = sectionKey;
        if (block.sectionTitle != null) {
          children.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
              child: Text(
                block.sectionTitle!.toUpperCase(),
                style: _labelStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }
      }

      final exercises = state.exercises
          .where((item) => item.executionBlockId == block.id)
          .toList();
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 2),
          child: Text(
            _programmingBlockLabel(null, block.groupType),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      );
      children.addAll(
        exercises.map(
          (exercise) => _StructureExerciseRow(
            index: state.exercises.indexOf(exercise) + 1,
            exercise: exercise,
            onTap: () {
              Navigator.pop(context);
              onExercise(exercise.exercise.id);
            },
          ),
        ),
      );
    }

    if (children.isEmpty) {
      children.addAll(
        state.exercises.map(
          (exercise) => _StructureExerciseRow(
            index: state.exercises.indexOf(exercise) + 1,
            exercise: exercise,
            onTap: () {
              Navigator.pop(context);
              onExercise(exercise.exercise.id);
            },
          ),
        ),
      );
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 36,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460, maxHeight: 680),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: .12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_tree_outlined,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dialogContext.activeTr('structure'),
                                style: Theme.of(dialogContext)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '${state.completedSetCount} of ${state.totalSetCount} sets completed',
                                style: context.scale.caption.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          tooltip: MaterialLocalizations.of(
                            dialogContext,
                          ).closeButtonLabel,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: scheme.outlineVariant),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
                      children: children,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StructureExerciseRow extends StatelessWidget {
  final int index;
  final ActiveExerciseState exercise;
  final VoidCallback onTap;

  const _StructureExerciseRow({
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

class _WorkoutHeader extends StatelessWidget {
  final String title;
  final Duration elapsed;
  final int completedExercises;
  final int totalExercises;
  final RestTimerState rest;
  final VoidCallback onBack;
  final VoidCallback onMenu;
  final VoidCallback onTimerTap;
  final VoidCallback onToggleBell;
  const _WorkoutHeader({
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
                  tooltip: context.tr('workout.active.finish'),
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

class _SessionNavigator extends StatelessWidget {
  final List<ActiveExerciseState> exercises;
  final List<ActiveExerciseGroup> groups;
  final String? activeExerciseId;
  final ValueChanged<String> onTap;
  const _SessionNavigator({
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
                      _groupName(group.type),
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

class _StructuralContext extends StatelessWidget {
  final String sectionTitle;

  const _StructuralContext({required this.sectionTitle});

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
                style: _labelStyle.copyWith(
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

class _ExerciseCard extends StatelessWidget {
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
  const _ExerciseCard({
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
          _ExerciseSetDisclosure(
            header: InkWell(
              onTap: onInfo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (groupLabel != null)
                    Text(
                      groupLabel!,
                      style: context.scale.micro.black.copyWith(
                        color: CoachlyAthleteTheme.primary,
                      ),
                    ),
                  Text(
                    exercise.displayName,
                    // Parte da `titleLarge` per ereditare famiglia e colore
                    // dal tema Material: sostituirla con un token scarterebbe
                    // proprio cio' che questa riga va a prendere.
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      // ignore: no_literal_text_style
                      fontSize: 30,
                      height: 1.05,
                      letterSpacing: -.7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            ),
            table: _SetTable(
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
            _ActiveSetEditor(
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
            ),
          ],
        ],
      ),
    );
  }
}

class _ExerciseSetDisclosure extends StatefulWidget {
  final Widget header;
  final Widget table;
  final Widget actions;

  const _ExerciseSetDisclosure({
    required this.header,
    required this.table,
    required this.actions,
  });

  @override
  State<_ExerciseSetDisclosure> createState() => _ExerciseSetDisclosureState();
}

class _ExerciseSetDisclosureState extends State<_ExerciseSetDisclosure>
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
          _disclosureSpring,
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

class _SetTable extends StatelessWidget {
  final ActiveExerciseState exercise;
  final String? activeSetId;
  final ValueChanged<String> onSet;
  final String loadUnit;
  const _SetTable({
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
                  context.tr('workout.active.col_set'),
                  style: _labelStyle,
                ),
              ),
              Expanded(
                child: Text(
                  context.tr('workout.active.col_previous'),
                  style: _labelStyle,
                ),
              ),
              SizedBox(
                width: 54,
                child: Text(loadUnit.toUpperCase(), style: _labelStyle),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  context.tr('workout.active.col_reps'),
                  style: _labelStyle,
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  context.tr('workout.active.col_rir'),
                  style: _labelStyle,
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
                'Set ${set.position + 1}, ${_number(set.weight)} kilograms, ${set.reps} repetitions${set.rir == null ? '' : ', RIR ${set.rir}'}${current ? ', in progress' : ''}',
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
                                _setPrefix(set),
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
                              ? '${_number(_displayWeight(set.weight, loadUnit))} × ${set.reps}'
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
                          _number(_displayWeight(set.weight, loadUnit)),
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
const _labelStyle = TextStyle(
  // ignore: no_literal_text_style
  fontSize: 10,
  fontWeight: FontWeight.w800,
  color: CoachlyAthleteTheme.textSecondary,
  letterSpacing: .7,
);

class _ActiveSetEditor extends StatelessWidget {
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
  const _ActiveSetEditor({
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
        _SetRolePicker(
          position: set.position,
          selected: set.role,
          onSelected: (role) => onRole(role.name),
        ),
        _Stepper(
          label: context.activeTr('weight'),
          value: '${_number(_displayWeight(set.weight, loadUnit))} $loadUnit',
          onMinus: () => onWeight(
            set,
            _storedWeight(
              _displayWeight(set.weight, loadUnit) -
                  (loadUnit == 'lbs' ? 5 : 2.5),
              loadUnit,
            ),
          ),
          onPlus: () => onWeight(
            set,
            _storedWeight(
              _displayWeight(set.weight, loadUnit) +
                  (loadUnit == 'lbs' ? 5 : 2.5),
              loadUnit,
            ),
          ),
          onDirect: () => _showNumberInput(
            context,
            _displayWeight(set.weight, loadUnit),
            (value) => onWeight(set, _storedWeight(value, loadUnit)),
            label: context.activeTr('weight'),
            unit: loadUnit,
            step: loadUnit == 'lbs' ? 5 : 2.5,
          ),
        ),
        _Stepper(
          label: context.activeTr('reps'),
          value: '${set.reps}',
          onMinus: () => onReps(set, set.reps - 1),
          onPlus: () => onReps(set, set.reps + 1),
          onDirect: () => _showNumberInput(
            context,
            set.reps.toDouble(),
            (value) => onReps(set, value.round()),
            label: context.activeTr('reps'),
            step: 1,
          ),
        ),
        if (set.technique == SetTechnique.dropSet) ...[
          const SizedBox(height: 16),
          ...set.drops.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DropEditor(
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
        _SetTechniqueActions(
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
            context.tr('workout.active.rir_explained'),
            style: _labelStyle,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final rir in [0, 1, 2, 3, 4])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _RirChoice(
                    value: rir,
                    selected: set.rir == rir,
                    onTap: () => onRir(rir),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        _CompleteSetButton(
          label: context.activeTr('completeSet'),
          onPressed: () => onComplete(set.id),
        ),
      ],
    ),
  );
}

class _CompleteSetButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _CompleteSetButton({required this.label, required this.onPressed});

  @override
  State<_CompleteSetButton> createState() => _CompleteSetButtonState();
}

class _CompleteSetButtonState extends State<_CompleteSetButton> {
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

class _SetRolePicker extends StatefulWidget {
  final int position;
  final SetRole selected;
  final ValueChanged<SetRole> onSelected;

  const _SetRolePicker({
    required this.position,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_SetRolePicker> createState() => _SetRolePickerState();
}

class _SetRolePickerState extends State<_SetRolePicker> {
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
              label: Text(_roleName(widget.selected)),
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
        _SpringReveal(
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
                      child: _SetRoleTile(
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

class _SpringReveal extends StatefulWidget {
  final bool visible;
  final Widget child;

  const _SpringReveal({required this.visible, required this.child});

  @override
  State<_SpringReveal> createState() => _SpringRevealState();
}

class _SpringRevealState extends State<_SpringReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: widget.visible ? 1 : 0,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.08, .72, curve: Curves.easeOut),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -.025),
      end: Offset.zero,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _SpringReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      _animateTo(widget.visible ? 1 : 0);
    }
  }

  void _animateTo(double target) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = target;
      return;
    }
    final velocity = _controller.velocity;
    _controller.animateWith(
      SpringSimulation(_disclosureSpring, _controller.value, target, velocity),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizeTransition(
        sizeFactor: _controller,
        axisAlignment: -1,
        child: IgnorePointer(
          ignoring: !widget.visible,
          child: FadeTransition(
            opacity: _opacity,
            child: SlideTransition(position: _offset, child: widget.child),
          ),
        ),
      ),
    );
  }
}

class _SetRoleTile extends StatelessWidget {
  final SetRole role;
  final bool selected;
  final VoidCallback onTap;

  const _SetRoleTile({
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
      label: _roleName(role),
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
                  _roleName(role),
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

class _SetTechniqueActions extends StatelessWidget {
  final SetTechnique selected;
  final VoidCallback onAddDrop;
  final ValueChanged<SetTechnique> onSelected;

  const _SetTechniqueActions({
    required this.selected,
    required this.onAddDrop,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        TextButton.icon(
          onPressed: onAddDrop,
          style: TextButton.styleFrom(
            backgroundColor: scheme.surface.withValues(alpha: 0),
          ),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(context.activeTr('addDrop')),
        ),
        const Spacer(),
        _TechniqueToggle(
          label: context.tr('workout.active.cluster'),
          color: scheme.tertiary,
          selected: selected == SetTechnique.cluster,
          onTap: () => onSelected(SetTechnique.cluster),
        ),
        const SizedBox(width: 6),
        _TechniqueToggle(
          label: context.tr('workout.active.failure'),
          color: scheme.error,
          selected: selected == SetTechnique.failure,
          onTap: () => onSelected(SetTechnique.failure),
        ),
      ],
    );
  }
}

class _TechniqueToggle extends StatefulWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _TechniqueToggle({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_TechniqueToggle> createState() => _TechniqueToggleState();
}

class _TechniqueToggleState extends State<_TechniqueToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _trailController;
  late final Animation<double> _activationScale;

  @override
  void initState() {
    super.initState();
    _trailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );
    _activationScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: .96), weight: 16),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: .96,
          end: 1.055,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 34,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.055,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 50,
      ),
    ]).animate(_trailController);
  }

  @override
  void didUpdateWidget(covariant _TechniqueToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.selected && widget.selected) {
      _trailController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _trailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
      child: RepaintBoundary(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ScaleTransition(
              scale: _activationScale,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onTap();
                },
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  constraints: const BoxConstraints(
                    minWidth: 62,
                    minHeight: 44,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: widget.selected
                        ? widget.color.withValues(alpha: .14)
                        : scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.selected
                          ? widget.color
                          : scheme.outlineVariant,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        scale: widget.selected ? 1.03 : 1,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        child: Text(
                          widget.label,
                          style: context.scale.captionTight.heavy.copyWith(
                            color: widget.selected
                                ? widget.color
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          width: widget.selected ? 18 : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _trailController,
                  builder: (context, _) => CustomPaint(
                    painter: _TechniqueTrailPainter(
                      progress: _trailController.value,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechniqueTrailPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _TechniqueTrailPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final rightUpper = Path()
      ..moveTo(size.width - 5, size.height * .42)
      ..quadraticBezierTo(
        size.width + 8,
        size.height * .2,
        size.width + 18,
        size.height * .13,
      );
    final rightLower = Path()
      ..moveTo(size.width - 4, size.height * .62)
      ..quadraticBezierTo(
        size.width + 9,
        size.height * .78,
        size.width + 16,
        size.height * .9,
      );
    final leftUpper = Path()
      ..moveTo(5, size.height * .39)
      ..quadraticBezierTo(-7, size.height * .22, -15, size.height * .18);
    final leftLower = Path()
      ..moveTo(4, size.height * .65)
      ..quadraticBezierTo(-8, size.height * .8, -14, size.height * .86);

    _paintTrail(canvas, rightUpper, progress, delay: 0, strength: 1);
    _paintTrail(canvas, leftLower, progress, delay: .04, strength: .82);
    _paintTrail(canvas, rightLower, progress, delay: .1, strength: .62);
    _paintTrail(canvas, leftUpper, progress, delay: .15, strength: .5);
  }

  void _paintTrail(
    Canvas canvas,
    Path path,
    double globalProgress, {
    required double delay,
    required double strength,
  }) {
    final local = ((globalProgress - delay) / (1 - delay)).clamp(0.0, 1.0);
    if (local <= 0 || local >= 1) return;
    final head = Curves.easeOutCubic.transform(local);
    final fade = local < .58 ? 1.0 : (1 - local) / .42;
    final metric = path.computeMetrics().first;
    final end = metric.length * head;
    final start = (end - metric.length * (.3 - local * .08)).clamp(
      0.0,
      metric.length,
    );
    final opacity = (.82 * fade * strength).clamp(0.0, 1.0);
    final trail = metric.extractPath(start, end);
    final softPaint = Paint()
      ..color = color.withValues(alpha: opacity * .18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final trailPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.45
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(trail, softPaint)
      ..drawPath(trail, trailPaint);
    final tangent = metric.getTangentForOffset(end);
    if (tangent != null) {
      canvas.drawCircle(
        tangent.position,
        1.35,
        Paint()..color = color.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TechniqueTrailPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _DropEditor extends StatelessWidget {
  final int index;
  final DropSetState drop;
  final String loadUnit;
  final ValueChanged<double> onWeight;
  final ValueChanged<int> onReps;
  final VoidCallback onRemove;

  const _DropEditor({
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
    final displayedWeight = _displayWeight(drop.weight, loadUnit);
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
                          style: _labelStyle.copyWith(color: scheme.primary),
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
                  _DropValueRow(
                    label: context.tr('workout.active.weight'),
                    value: '${_number(displayedWeight)} $loadUnit',
                    onMinus: () => onWeight(
                      _storedWeight(
                        (displayedWeight - weightStep).clamp(
                          0,
                          double.infinity,
                        ),
                        loadUnit,
                      ),
                    ),
                    onPlus: () => onWeight(
                      _storedWeight(displayedWeight + weightStep, loadUnit),
                    ),
                    onValueTap: () => _showNumberInput(
                      context,
                      displayedWeight,
                      (value) => onWeight(_storedWeight(value, loadUnit)),
                      label: 'Drop ${index + 1} weight',
                      unit: loadUnit,
                      step: weightStep,
                    ),
                  ),
                  Divider(height: 1, color: scheme.outlineVariant),
                  _DropValueRow(
                    label: context.tr('workout.active.reps'),
                    value: '${drop.reps}',
                    onMinus: () => onReps((drop.reps - 1).clamp(0, 999)),
                    onPlus: () => onReps((drop.reps + 1).clamp(0, 999)),
                    onValueTap: () => _showNumberInput(
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

class _DropValueRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onValueTap;

  const _DropValueRow({
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
        SizedBox(width: 58, child: Text(label, style: _labelStyle)),
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

class _RirChoice extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const _RirChoice({
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

class _Stepper extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDirect;
  const _Stepper({
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
                  Text(label.toUpperCase(), style: _labelStyle),
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

class _AddToWorkoutSheet extends StatefulWidget {
  final VoidCallback onAddSet;
  final VoidCallback onAddExercise;
  final List<({String id, String name})> exercises;
  final String? initiallySelectedId;
  final BlockExerciseAdd onAddBlockExercise;
  final BlockCreate onCreateGroup;

  const _AddToWorkoutSheet({
    required this.onAddSet,
    required this.onAddExercise,
    required this.exercises,
    required this.initiallySelectedId,
    required this.onAddBlockExercise,
    required this.onCreateGroup,
  });

  @override
  State<_AddToWorkoutSheet> createState() => _AddToWorkoutSheetState();
}

class _AddToWorkoutSheetState extends State<_AddToWorkoutSheet> {
  ExerciseGroupType? _blockType;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.sizeOf(context).height -
            MediaQuery.paddingOf(context).top -
            context.spacing.xxl,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spacing.lg,
          0,
          context.spacing.lg,
          context.spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_blockType != null)
                  IconButton(
                    onPressed: () => setState(() => _blockType = null),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: motion.resolve(context, motion.standard),
                    child: Text(
                      _blockType == null
                          ? context.tr('workout.active.add_title')
                          : _blockTitle(_blockType!),
                      key: ValueKey(_blockType),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            SizedBox(height: context.spacing.sm),
            Flexible(
              child: AnimatedSwitcher(
                duration: motion.resolve(context, motion.standard),
                switchInCurve: motion.enter,
                switchOutCurve: motion.exit,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: child,
                  ),
                ),
                child: _blockType == null
                    ? _AddToWorkoutOverview(
                        key: const ValueKey('add-overview'),
                        onAddSet: widget.onAddSet,
                        onAddExercise: widget.onAddExercise,
                        onBlock: (type) => setState(() => _blockType = type),
                      )
                    : _InlineBlockBuilder(
                        key: ValueKey(_blockType),
                        type: _blockType!,
                        exercises: widget.exercises,
                        initiallySelectedId: widget.initiallySelectedId,
                        onAddExercise: widget.onAddBlockExercise,
                        onCreate: (ids) =>
                            widget.onCreateGroup(ids, _blockType!),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToWorkoutOverview extends StatelessWidget {
  final VoidCallback onAddSet;
  final VoidCallback onAddExercise;
  final ValueChanged<ExerciseGroupType> onBlock;

  const _AddToWorkoutOverview({
    super.key,
    required this.onAddSet,
    required this.onAddExercise,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('workout.active.add_subtitle'),
            style: context.text.bodyM.copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: context.spacing.md),
          _AddActionRow(
            icon: Icons.add_rounded,
            title: context.tr('workout.active.add_set'),
            subtitle: context.tr('workout.active.add_set_hint'),
            onTap: onAddSet,
          ),
          SizedBox(height: context.spacing.xs),
          _AddActionRow(
            icon: Icons.fitness_center_rounded,
            title: context.tr('workout.active.add_exercise'),
            subtitle: context.tr('workout.active.add_movement'),
            onTap: onAddExercise,
          ),
          SizedBox(height: context.spacing.lg),
          Text(context.tr('workout.active.blocks'), style: _labelStyle),
          SizedBox(height: context.spacing.xxs),
          Text(
            context.tr('workout.active.combine_hint'),
            style: context.text.bodyS.copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: context.spacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - context.spacing.xs) / 2;
              return Wrap(
                spacing: context.spacing.xs,
                runSpacing: context.spacing.xs,
                children: [
                  for (final type in const [
                    ExerciseGroupType.superset,
                    ExerciseGroupType.triset,
                    ExerciseGroupType.giantSet,
                    ExerciseGroupType.circuit,
                  ])
                    SizedBox(
                      width: tileWidth,
                      child: _BlockTypeTile(
                        type: type,
                        onTap: () => onBlock(type),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AddActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AddActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radii.lg),
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.sizes.touchTargetWorkout,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(context.radii.lg),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: context.sizes.touchTarget,
              height: context.sizes.touchTarget,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(context.radii.md),
              ),
              child: Icon(
                icon,
                size: context.sizes.iconSm,
                color: scheme.primary,
              ),
            ),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: context.spacing.xxs),
                  Text(
                    subtitle,
                    style: context.text.bodyS.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _BlockTypeTile extends StatelessWidget {
  final ExerciseGroupType type;
  final VoidCallback onTap;

  const _BlockTypeTile({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radii.lg),
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.sizes.touchTargetWorkout,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.xs,
          vertical: context.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(context.radii.lg),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BlockGlyph(type: type),
            SizedBox(height: context.spacing.xs),
            Text(
              _blockTitle(type),
              textAlign: TextAlign.center,
              style: context.text.labelStrong,
            ),
            SizedBox(height: context.spacing.xxs),
            Text(
              _blockSubtitle(type),
              textAlign: TextAlign.center,
              style: context.text.bodyS.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockGlyph extends StatelessWidget {
  final ExerciseGroupType type;
  const _BlockGlyph({required this.type});

  @override
  Widget build(BuildContext context) {
    final extent = context.sizes.iconXl + context.spacing.md;
    final cacheExtent = (extent * MediaQuery.devicePixelRatioOf(context))
        .round();
    return SizedBox(
      width: extent,
      height: extent,
      child: Image.asset(
        switch (type) {
          ExerciseGroupType.superset => AppAssets.setTypeSuperset,
          ExerciseGroupType.triset => AppAssets.setTypeTriset,
          ExerciseGroupType.giantSet => AppAssets.setTypeGiantSet,
          ExerciseGroupType.circuit => AppAssets.setTypeCircuit,
          ExerciseGroupType.preparation || ExerciseGroupType.mobility =>
            throw StateError('Unsupported block type: $type'),
        },
        fit: BoxFit.contain,
        alignment: Alignment.center,
        cacheWidth: cacheExtent,
        cacheHeight: cacheExtent,
        excludeFromSemantics: true,
      ),
    );
  }
}

class _InlineBlockBuilder extends StatefulWidget {
  final ExerciseGroupType type;
  final List<({String id, String name})> exercises;
  final String? initiallySelectedId;
  final BlockExerciseAdd onAddExercise;
  final ValueChanged<List<String>> onCreate;

  const _InlineBlockBuilder({
    super.key,
    required this.type,
    required this.exercises,
    required this.initiallySelectedId,
    required this.onAddExercise,
    required this.onCreate,
  });

  @override
  State<_InlineBlockBuilder> createState() => _InlineBlockBuilderState();
}

class _InlineBlockBuilderState extends State<_InlineBlockBuilder> {
  late final List<({String id, String name})> _exercises;
  late final Set<String> _selected;
  bool _addingExercise = false;

  int get _minimum => switch (widget.type) {
    ExerciseGroupType.superset => 2,
    ExerciseGroupType.triset => 3,
    ExerciseGroupType.giantSet => 4,
    ExerciseGroupType.circuit => 2,
    _ => 2,
  };

  int? get _maximum => switch (widget.type) {
    ExerciseGroupType.superset => 2,
    ExerciseGroupType.triset => 3,
    _ => null,
  };

  @override
  void initState() {
    super.initState();
    _exercises = [...widget.exercises];
    _selected = {
      if (widget.initiallySelectedId != null) widget.initiallySelectedId!,
    };
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_maximum == null || _selected.length < _maximum!) {
        _selected.add(id);
      }
    });
  }

  Future<void> _addExercise() async {
    if (_addingExercise) return;
    setState(() => _addingExercise = true);
    final exercise = await widget.onAddExercise();
    if (!mounted) return;
    setState(() {
      _addingExercise = false;
      if (exercise != null) {
        _exercises.add(exercise);
        if (_maximum == null || _selected.length < _maximum!) {
          _selected.add(exercise.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final valid = _selected.length >= _minimum;
    return Column(
      key: ValueKey(widget.type),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _BlockGlyph(type: widget.type),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(
                _blockBuilderInstruction(widget.type),
                style: context.text.bodyM.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing.md),
        Row(
          children: [
            Text(context.tr('workout.active.exercises'), style: _labelStyle),
            const Spacer(),
            Text(
              '${_selected.length}${_maximum == null ? ' / $_minimum+' : ' / $_maximum'}',
              style: TextStyle(
                color: valid ? scheme.primary : scheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing.xs),
        Expanded(
          child: ListView.separated(
            itemCount: _exercises.length,
            separatorBuilder: (_, __) => SizedBox(height: context.spacing.xxs),
            itemBuilder: (context, index) {
              final exercise = _exercises[index];
              final selected = _selected.contains(exercise.id);
              final disabled =
                  !selected &&
                  _maximum != null &&
                  _selected.length >= _maximum!;
              return _BlockExerciseChoice(
                index: index + 1,
                name: exercise.name,
                selected: selected,
                enabled: !disabled,
                onTap: () => _toggle(exercise.id),
              );
            },
          ),
        ),
        SizedBox(height: context.spacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addingExercise ? null : _addExercise,
            icon: _addingExercise
                ? SizedBox.square(
                    dimension: context.sizes.iconXs,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_rounded),
            label: Text(context.tr('workout.active.add_exercise')),
          ),
        ),
        SizedBox(height: context.spacing.xs),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: valid ? () => widget.onCreate(_selected.toList()) : null,
            child: Text(
              context.tr(
                'workout.builder.create_selected_block',
                params: {'type': _blockTitle(widget.type)},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BlockExerciseChoice extends StatelessWidget {
  final int index;
  final String name;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _BlockExerciseChoice({
    required this.index,
    required this.name,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    return AnimatedOpacity(
      duration: motion.resolve(context, motion.quick),
      opacity: enabled || selected ? 1 : .42,
      child: InkWell(
        onTap: enabled || selected ? onTap : null,
        borderRadius: BorderRadius.circular(context.radii.md),
        child: AnimatedContainer(
          duration: motion.resolve(context, motion.quick),
          constraints: BoxConstraints(
            minHeight: context.sizes.touchTargetWorkout,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.sm,
            vertical: context.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: .1)
                : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(context.radii.md),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: context.sizes.iconMd,
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              AnimatedSwitcher(
                duration: motion.resolve(context, motion.quick),
                child: selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('selected'),
                        color: scheme.primary,
                      )
                    : Icon(
                        Icons.add_circle_outline_rounded,
                        key: const ValueKey('available'),
                        color: scheme.onSurfaceVariant,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickNoteSheet extends StatefulWidget {
  final String exerciseName;
  final ActiveSetState set;
  final void Function(String text, Set<SetNoteTag> tags) onSave;

  const _QuickNoteSheet({
    required this.exerciseName,
    required this.set,
    required this.onSave,
  });

  @override
  State<_QuickNoteSheet> createState() => _QuickNoteSheetState();
}

class _QuickNoteSheetState extends State<_QuickNoteSheet> {
  static const _primaryTags = [
    SetNoteTag.goodSet,
    SetNoteTag.feltStrong,
    SetNoteTag.formOff,
  ];
  static const _moreTags = [
    SetNoteTag.greatPump,
    SetNoteTag.lostPosition,
    SetNoteTag.romIssue,
    SetNoteTag.lowEnergy,
    SetNoteTag.gripIssue,
    SetNoteTag.equipment,
  ];

  late final TextEditingController _textController;
  late Set<SetNoteTag> _tags;
  Timer? _debounce;
  Timer? _savedTimer;
  bool _dirty = false;
  bool _saving = false;
  bool _savedVisible = false;
  bool _moreOpen = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.set.note ?? '');
    _tags = {...?widget.set.noteTags};
  }

  void _onTextChanged(String _) {
    _dirty = true;
    _debounce?.cancel();
    setState(() {
      _saving = true;
      _savedVisible = false;
    });
    _debounce = Timer(const Duration(milliseconds: 500), _commit);
  }

  void _toggleTag(SetNoteTag tag) {
    HapticFeedback.selectionClick();
    setState(() {
      _tags.contains(tag) ? _tags.remove(tag) : _tags.add(tag);
      _dirty = true;
      _saving = true;
      _savedVisible = false;
    });
    _debounce?.cancel();
    _commit();
  }

  void _commit({bool updateVisualState = true}) {
    if (!_dirty) return;
    _dirty = false;
    widget.onSave(_textController.text.trim(), {..._tags});
    if (!updateVisualState || !mounted) return;
    _savedTimer?.cancel();
    setState(() {
      _saving = false;
      _savedVisible = true;
    });
    _savedTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _savedVisible = false);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _savedTimer?.cancel();
    _commit(updateVisualState: false);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboard),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: .32),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.activeTr('quickNote'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Set ${widget.set.position + 1} · ${widget.exerciseName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              minLines: 4,
              maxLines: 6,
              onChanged: _onTextChanged,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: context.tr('workout.active.note_hint'),
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: scheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(context.tr('workout.active.quick_add'), style: _labelStyle),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in _primaryTags)
                  _QuickNoteTag(
                    tag: tag,
                    selected: _tags.contains(tag),
                    onTap: () => _toggleTag(tag),
                  ),
                _QuickNoteMoreButton(
                  open: _moreOpen,
                  onTap: () => setState(() => _moreOpen = !_moreOpen),
                ),
              ],
            ),
            _SpringReveal(
              visible: _moreOpen,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in _moreTags)
                      _QuickNoteTag(
                        tag: tag,
                        selected: _tags.contains(tag),
                        onTap: () => _toggleTag(tag),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 20,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _saving
                    ? Text(
                        context.tr('workout.active.saving'),
                        key: const ValueKey('saving'),
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      )
                    : _savedVisible
                    ? Row(
                        key: const ValueKey('saved'),
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            context.tr('workout.active.saved'),
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: scheme.primary,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey('idle')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickNoteTag extends StatelessWidget {
  final SetNoteTag tag;
  final bool selected;
  final VoidCallback onTap;

  const _QuickNoteTag({
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, icon) = _noteTagPresentation(tag);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedScale(
          scale: selected ? 1.02 : 1,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: .14)
                  : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (selected) ...[
                  const SizedBox(width: 5),
                  Icon(Icons.check_rounded, size: 15, color: scheme.primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickNoteMoreButton extends StatelessWidget {
  final bool open;
  final VoidCallback onTap;

  const _QuickNoteMoreButton({required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) => ActionChip(
    onPressed: onTap,
    avatar: const Icon(Icons.more_horiz_rounded, size: 17),
    label: Text(open ? 'Less' : 'More'),
  );
}

class _RestLiveBar extends StatelessWidget {
  final RestTimerState rest;
  final VoidCallback onOpen;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onSkip;

  const _RestLiveBar({
    super.key,
    required this.rest,
    required this.onOpen,
    required this.onMinus,
    required this.onPlus,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final remaining = rest.remainingSeconds;
    final time =
        '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}';
    final total = rest.initialSeconds <= 0 ? 1 : rest.initialSeconds;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FractionallySizedBox(
                widthFactor: (remaining / total).clamp(0.0, 1.0),
                child: Container(height: 2, color: scheme.primary),
              ),
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onOpen,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Text(
                            rest.isPaused ? 'PAUSED' : 'REST',
                            style: context.scale.captionTight.black.copyWith(
                              color: scheme.primary,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$time / ${_clock(total)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _LiveBarAction(label: '−30', onTap: onMinus),
                _LiveBarAction(label: '+30', onTap: onPlus),
                IconButton(
                  tooltip: context.activeTr('skip'),
                  onPressed: onSkip,
                  icon: const Icon(Icons.skip_next_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBarAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LiveBarAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 48,
    height: 48,
    child: TextButton(onPressed: onTap, child: Text(label)),
  );
}

String _clock(int seconds) =>
    '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

class _WorkoutActionDock extends StatelessWidget {
  final VoidCallback onStructure;
  final VoidCallback onAdd;
  final VoidCallback onNotes;
  const _WorkoutActionDock({
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
          child: _DockButton(
            icon: Icons.format_list_bulleted_rounded,
            label: context.activeTr('structure'),
            onTap: onStructure,
          ),
        ),
        Expanded(
          child: _DockButton(
            icon: Icons.add_rounded,
            label: context.activeTr('add'),
            onTap: onAdd,
            primary: true,
          ),
        ),
        Expanded(
          child: _DockButton(
            icon: Icons.edit_note_rounded,
            label: context.activeTr('quickNote'),
            onTap: onNotes,
          ),
        ),
      ],
    ),
  );
}

class _DockButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const _DockButton({
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

class _CompletedWorkspace extends StatelessWidget {
  final VoidCallback onComplete;
  const _CompletedWorkspace({required this.onComplete});
  @override
  Widget build(BuildContext context) => Center(
    child: FilledButton(
      onPressed: onComplete,
      child: Text(context.activeTr('completeWorkout')),
    ),
  );
}

void _showNumberInput(
  BuildContext context,
  double initial,
  ValueChanged<double> onChanged, {
  required String label,
  required double step,
  String? unit,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _NumberInputSheet(
      initial: initial,
      label: label,
      unit: unit,
      step: step,
      onChanged: onChanged,
    ),
  );
}

class _NumberInputSheet extends StatefulWidget {
  final double initial;
  final String label;
  final String? unit;
  final double step;
  final ValueChanged<double> onChanged;

  const _NumberInputSheet({
    required this.initial,
    required this.label,
    required this.unit,
    required this.step,
    required this.onChanged,
  });

  @override
  State<_NumberInputSheet> createState() => _NumberInputSheetState();
}

class _NumberInputSheetState extends State<_NumberInputSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _number(widget.initial));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double? _parsedValue() =>
      double.tryParse(_controller.text.replaceAll(',', '.'));

  void _saveText(String _) {
    final value = _parsedValue();
    if (value != null) widget.onChanged(value);
  }

  void _adjust(double delta) {
    final value = ((_parsedValue() ?? widget.initial) + delta)
        .clamp(0, double.infinity)
        .toDouble();
    final text = _number(value);
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    widget.onChanged(value);
    _focusNode.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedPadding(
      duration: context.motion.resolve(context, context.motion.quick),
      curve: context.motion.enter,
      padding: EdgeInsets.fromLTRB(
        context.spacing.lg,
        0,
        context.spacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + context.spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label.toUpperCase(),
            style: context.text.labelStrong.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.xs),
          Row(
            children: [
              _NumberStepButton(
                icon: Icons.remove_rounded,
                tooltip: context.tr('workout.builder.decrease'),
                onPressed: () => _adjust(-widget.step),
              ),
              SizedBox(width: context.spacing.xs),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: context.text.displayM.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixText: widget.unit,
                    suffixStyle: context.text.titleM,
                  ),
                  onChanged: _saveText,
                ),
              ),
              SizedBox(width: context.spacing.xs),
              _NumberStepButton(
                icon: Icons.add_rounded,
                tooltip: context.tr('workout.builder.increase'),
                onPressed: () => _adjust(widget.step),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberStepButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _NumberStepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: context.sizes.touchTargetWorkout,
    child: IconButton.filledTonal(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
    ),
  );
}

String _number(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);
double _displayWeight(double kilograms, String unit) =>
    unit == 'lbs' ? kilograms * 2.2046226218 : kilograms;
double _storedWeight(double displayed, String unit) =>
    unit == 'lbs' ? displayed / 2.2046226218 : displayed;
String _setPrefix(ActiveSetState set) => switch (set.role) {
  SetRole.warmup => 'W${set.position + 1}',
  SetRole.topSet => 'T${set.position + 1}',
  SetRole.backoff => 'B${set.position + 1}',
  SetRole.working => '${set.position + 1}',
};
String _roleName(SetRole role) => switch (role) {
  SetRole.working => 'Working set',
  SetRole.warmup => 'Warm-up',
  SetRole.topSet => 'Top set',
  SetRole.backoff => 'Back-off',
};
(String, IconData) _noteTagPresentation(SetNoteTag tag) => switch (tag) {
  SetNoteTag.goodSet => ('Good set', Icons.check_circle_outline_rounded),
  SetNoteTag.feltStrong => ('Felt strong', Icons.bolt_rounded),
  SetNoteTag.formOff => ('Form off', Icons.warning_amber_rounded),
  SetNoteTag.greatPump => ('Great pump', Icons.favorite_outline_rounded),
  SetNoteTag.lostPosition => ('Lost position', Icons.swap_vert_rounded),
  SetNoteTag.romIssue => ('ROM issue', Icons.open_in_full_rounded),
  SetNoteTag.lowEnergy => ('Low energy', Icons.battery_2_bar_rounded),
  SetNoteTag.gripIssue => ('Grip issue', Icons.pan_tool_alt_rounded),
  SetNoteTag.equipment => ('Equipment', Icons.build_outlined),
};
String _blockTitle(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => 'Superset',
  ExerciseGroupType.triset => 'Triset',
  ExerciseGroupType.giantSet => 'Giant set',
  ExerciseGroupType.circuit => 'Circuit',
  ExerciseGroupType.preparation => 'Preparation',
  ExerciseGroupType.mobility => 'Mobility',
};
String _blockSubtitle(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => '2 exercises',
  ExerciseGroupType.triset => '3 exercises',
  ExerciseGroupType.giantSet => '4+ exercises',
  ExerciseGroupType.circuit => 'Repeat loop',
  ExerciseGroupType.preparation => 'Prepare',
  ExerciseGroupType.mobility => 'Mobility',
};
String _blockBuilderInstruction(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => 'Choose exactly 2 exercises',
  ExerciseGroupType.triset => 'Choose exactly 3 exercises',
  ExerciseGroupType.giantSet => 'Choose at least 4 exercises',
  ExerciseGroupType.circuit => 'Choose 2 or more exercises to repeat',
  ExerciseGroupType.preparation => 'Choose preparation exercises',
  ExerciseGroupType.mobility => 'Choose mobility exercises',
};
String _groupName(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => 'SUPERSET',
  ExerciseGroupType.triset => 'TRISET',
  ExerciseGroupType.giantSet => 'GIANT SET',
  ExerciseGroupType.circuit => 'CIRCUIT',
  ExerciseGroupType.preparation => 'PREPARATION',
  ExerciseGroupType.mobility => 'MOBILITY',
};
String _programmingBlockLabel(String? label, String? groupType) {
  final normalizedLabel = label?.trim();
  if (normalizedLabel != null && normalizedLabel.isNotEmpty) {
    return normalizedLabel;
  }
  return switch (groupType?.toLowerCase()) {
    'superset' => 'Superset',
    'triset' => 'Triset',
    'giant_set' || 'giantset' => 'Giant set',
    'circuit' => 'Circuit',
    _ => 'Exercise block',
  };
}
