import 'dart:async';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/features/active_workout/application/rest_timer_provider.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:coachly/features/active_workout/presentation/widgets/hold_to_complete_workout_button.dart';
import 'package:coachly/features/active_workout/presentation/widgets/main_area_scroll_assist.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/add_to_workout_sheet.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/completed_workspace.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/exercise_card.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/quick_note_sheet.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/rest_live_bar.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/session_navigator.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workout_action_dock.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workout_header.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_callbacks.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

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
          WorkoutHeader(
            title: title,
            elapsed: elapsed,
            completedExercises: completedExercises,
            totalExercises: state.totalExercises,
            rest: rest,
            onBack: onBack,
            onMenu: () => _showCompleteWorkoutDialog(context),
            onToggleBell: onRestToggleBell,
            onTimerTap: () => _showRestSheet(context),
          ),
          Expanded(
            child: allDone
                ? CompletedWorkspace(onComplete: onCompleteWorkout)
                : MainAreaScrollAssist(
                    mainIdentity: activeId ?? '',
                    leading: SessionNavigator(
                      exercises: state.exercises,
                      groups: state.groups,
                      activeExerciseId: activeId,
                      onTap: onExercise,
                    ),
                    beforeMain: _buildStructuralContext(),
                    main: _buildMainArea(context),
                  ),
          ),
          if (rest.isActive)
            RestLiveBar(
              rest: rest,
              onOpen: () => _showRestSheet(context),
              onMinus: () => onRestAdjust(-30),
              onPlus: () => onRestAdjust(30),
              onSkip: onSkipRest,
            )
          else
            WorkoutActionDock(
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
        : StructuralContext(sectionTitle: block!.sectionTitle!);
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
      group == null ? null : groupName(group.type),
    );
  }

  Widget _exerciseCard(
    BuildContext context,
    ActiveExerciseState exercise,
    bool active,
    String? groupLabel,
  ) => ExerciseCard(
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
    rest: rest,
    onRestOpen: () => _showRestSheet(context),
    workoutReadyToComplete: state.phase == WorkoutPhase.completed,
    onCompleteWorkout: onCompleteWorkout,
  );

  Future<void> _showCompleteWorkoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('workout.complete_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(dialogContext.tr('workout.complete_content')),
            SizedBox(height: dialogContext.spacing.lg),
            HoldToCompleteWorkoutButton(
              label: dialogContext.activeTr('completeWorkout'),
              holdHint: dialogContext.tr('workout.active.complete_hold_hint'),
              releasedHint: dialogContext.tr(
                'workout.active.complete_hold_released',
              ),
              onCompleted: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // La route completa il proprio Future prima che la transizione d'uscita
    // abbia rimosso l'OverlayEntry. Non smontare nello stesso frame anche la
    // pagina sottostante.
    await Future<void>.delayed(context.motion.slow);
    if (!context.mounted) return;
    onMenu();
  }

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
      builder: (sheetContext) => QuickNoteSheet(
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
                    clock(liveRest.remainingSeconds),
                    textAlign: TextAlign.center,
                    style: Theme.of(sheetContext).textTheme.displaySmall
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                  Text(
                    'of ${clock(liveRest.initialSeconds)}',
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
                          child: Text(context.l10n.workoutActiveRestMinus30),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => onRestAdjust(30),
                          child: Text(context.l10n.workoutActiveRestPlus30),
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
      builder: (sheetContext) => AddToWorkoutSheet(
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
                style: labelStyle.copyWith(
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
            programmingBlockLabel(null, block.groupType),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      );
      children.addAll(
        exercises.map(
          (exercise) => StructureExerciseRow(
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
          (exercise) => StructureExerciseRow(
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
