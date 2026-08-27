import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/active_workout_strings.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';

typedef SetValueChanged = void Function(ActiveSetState set, num value);

/// The active-workout presentation is deliberately a workspace: the full
/// session stays visible while only the active exercise and set expand.
class AdaptiveWorkoutWorkspace extends StatelessWidget {
  final ActiveWorkoutState state;
  final String title;
  final Duration elapsed;
  final RestTimerState rest;
  final CoachDecision? decision;
  final VoidCallback onBack;
  final VoidCallback onMenu;
  final ValueChanged<String> onExercise;
  final ValueChanged<String> onSet;
  final SetValueChanged onWeight;
  final SetValueChanged onReps;
  final ValueChanged<int> onRir;
  final ValueChanged<String> onComplete;
  final ValueChanged<String> onUndo;
  final ValueChanged<String> onAddSet;
  final ValueChanged<String> onTechnique;
  final ValueChanged<String> onRole;
  final ValueChanged<String> onAddDrop;
  final ValueChanged<String> onExerciseInfo;
  final ValueChanged<String> onSkipExercise;
  final ValueChanged<List<String>> onCreateGroup;
  final VoidCallback onAddExercise;
  final ValueChanged<String> onUngroup;
  final VoidCallback onCompleteWorkout;
  final VoidCallback onSkipRest;
  final ValueChanged<int> onRestAdjust;
  final VoidCallback onRestTogglePause;
  final VoidCallback onDismissGuard;
  final String? undoSetId;

  const AdaptiveWorkoutWorkspace({
    super.key,
    required this.state,
    required this.title,
    required this.elapsed,
    required this.rest,
    required this.decision,
    required this.onBack,
    required this.onMenu,
    required this.onExercise,
    required this.onSet,
    required this.onWeight,
    required this.onReps,
    required this.onRir,
    required this.onComplete,
    required this.onUndo,
    required this.onAddSet,
    required this.onTechnique,
    required this.onRole,
    required this.onAddDrop,
    required this.onExerciseInfo,
    required this.onSkipExercise,
    required this.onCreateGroup,
    required this.onAddExercise,
    required this.onUngroup,
    required this.onCompleteWorkout,
    required this.onSkipRest,
    required this.onRestAdjust,
    required this.onRestTogglePause,
    required this.onDismissGuard,
    this.undoSetId,
  });

  @override
  Widget build(BuildContext context) {
    final completedExercises = state.exercises
        .where(
          (exercise) =>
              exercise.sets.isNotEmpty &&
              exercise.sets.every((set) => set.completed || set.skipped),
        )
        .length;
    final activeId = state.currentExercise?.exercise.id;
    final allDone = state.currentTarget == null;
    return Column(
      children: [
        _WorkoutHeader(
          title: title,
          elapsed: elapsed,
          completedExercises: completedExercises,
          totalExercises: state.totalExercises,
          rest: rest,
          onBack: onBack,
          onMenu: onMenu,
          onTimerTap: () => _showRestSheet(context),
        ),
        _SessionNavigator(
          exercises: state.exercises,
          groups: state.groups,
          activeExerciseId: activeId,
          onTap: onExercise,
        ),
        Expanded(
          child: allDone
              ? _CompletedWorkspace(onComplete: onCompleteWorkout)
              : CustomScrollView(
                  key: const PageStorageKey('active-workout-content'),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 104),
                      sliver: SliverMainAxisGroup(
                        slivers: _buildSlivers(context, activeId),
                      ),
                    ),
                  ],
                ),
        ),
        _WorkoutActionDock(
          guardCount: decision == null ? 0 : 1,
          onStructure: () => _showStructureSheet(context),
          onAdd: () => _showQuickAddSheet(context),
          onGuard: () => _showPlanGuardSheet(context),
        ),
      ],
    );
  }

  List<Widget> _buildSlivers(BuildContext context, String? activeId) {
    final handledGroupIds = <String>{};
    final result = <Widget>[];
    for (final exercise in state.exercises) {
      final group = state.groups
          .where((group) => group.exerciseIds.contains(exercise.exercise.id))
          .firstOrNull;
      if (group != null) {
        if (!handledGroupIds.add(group.id)) continue;
        final members = state.exercises
            .where((item) => group.exerciseIds.contains(item.exercise.id))
            .toList();
        result.add(
          SliverToBoxAdapter(
            child: _ExerciseGroupCard(
              group: group,
              exercises: members,
              activeExerciseId: activeId,
              card: _exerciseCard,
              onUngroup: () => onUngroup(group.id),
            ),
          ),
        );
      } else {
        result.add(
          SliverToBoxAdapter(
            child: _exerciseCard(
              context,
              exercise,
              activeId == exercise.exercise.id,
              null,
            ),
          ),
        );
      }
      result.add(const SliverToBoxAdapter(child: SizedBox(height: 10)));
    }
    return result;
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
    decision: active ? decision : null,
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
    onInfo: () => onExerciseInfo(exercise.exercise.id),
    onSkip: () => onSkipExercise(exercise.exercise.id),
  );

  void _showRestSheet(BuildContext context) {
    if (!rest.isActive) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                sheetContext.activeTr('rest'),
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onRestAdjust(-30),
                      child: const Text('−30 s'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onRestAdjust(30),
                      child: const Text('+30 s'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  onRestTogglePause();
                  Navigator.pop(sheetContext);
                },
                child: Text(rest.isPaused ? 'Resume' : 'Pause'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  onSkipRest();
                },
                child: Text(sheetContext.activeTr('skip')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickAddSheet(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.fitness_center_rounded),
            title: Text(sheetContext.activeTr('addExercise')),
            onTap: () {
              Navigator.pop(sheetContext);
              onAddExercise();
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_list_numbered_rounded),
            title: Text(sheetContext.activeTr('addSet')),
            onTap: () {
              Navigator.pop(sheetContext);
              final id = state.currentExercise?.exercise.id;
              if (id != null) onAddSet(id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.link_rounded),
            title: Text(sheetContext.activeTr('createGroup')),
            onTap: () {
              Navigator.pop(sheetContext);
              _showCreateGroupSheet(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_add_outlined),
            title: Text(sheetContext.activeTr('quickNote')),
            onTap: () => Navigator.pop(sheetContext),
          ),
        ],
      ),
    ),
  );

  void _showCreateGroupSheet(BuildContext context) {
    final selected = <String>{state.currentExercise?.exercise.id ?? ''}
      ..remove('');
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.activeTr('createGroup'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...state.exercises.map(
                  (exercise) => CheckboxListTile(
                    value: selected.contains(exercise.exercise.id),
                    title: Text(exercise.displayName),
                    onChanged: (value) => setSheetState(
                      () => value == true
                          ? selected.add(exercise.exercise.id)
                          : selected.remove(exercise.exercise.id),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: selected.length < 2
                        ? null
                        : () {
                            Navigator.pop(context);
                            onCreateGroup(selected.toList());
                          },
                    child: Text(context.activeTr('createSuperset')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStructureSheet(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: state.exercises
            .map(
              (exercise) => ListTile(
                title: Text(exercise.displayName),
                trailing: Text(
                  '${exercise.completedSets}/${exercise.totalSets}',
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  onExercise(exercise.exercise.id);
                },
              ),
            )
            .toList(),
      ),
    ),
  );

  void _showPlanGuardSheet(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sheetContext.activeTr('planGuard'),
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (decision == null)
              Text(sheetContext.activeTr('noSuggestions'))
            else ...[
              Text(
                sheetContext.activeTr(decision!.primary.titleKey),
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(sheetContext.activeTr(decision!.primary.reasonKey)),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(sheetContext.activeTr('details')),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      onDismissGuard();
                      Navigator.pop(sheetContext);
                    },
                    child: Text(sheetContext.activeTr('dismiss')),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
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
  const _WorkoutHeader({
    required this.title,
    required this.elapsed,
    required this.completedExercises,
    required this.totalExercises,
    required this.rest,
    required this.onBack,
    required this.onMenu,
    required this.onTimerTap,
  });
  @override
  Widget build(BuildContext context) {
    final seconds = rest.isActive ? rest.remainingSeconds : elapsed.inSeconds;
    final time =
        '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Row(
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
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
            label: rest.isActive ? '${context.activeTr('rest')} $time' : time,
            child: TextButton(
              onPressed: onTimerTap,
              child: Text(
                rest.isPaused
                    ? 'PAUSED'
                    : rest.isActive
                    ? '${context.activeTr('rest')} $time'
                    : time,
                style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onMenu,
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
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
    height: 64,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: group == null ? 116 : 126,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: active
                    ? CoachlyAthleteTheme.surfaceElevated
                    : CoachlyAthleteTheme.surface,
                border: Border.all(
                  color: active
                      ? CoachlyAthleteTheme.primary
                      : CoachlyAthleteTheme.border,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (group != null)
                    Text(
                      _groupName(group.type),
                      style: const TextStyle(
                        fontSize: 9,
                        color: CoachlyAthleteTheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      exercise.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    done
                        ? '✓'
                        : '${exercise.completedSets}/${exercise.totalSets}',
                    style: TextStyle(
                      fontSize: 11,
                      color: done
                          ? CoachlyAthleteTheme.primary
                          : CoachlyAthleteTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _ExerciseGroupCard extends StatelessWidget {
  final ActiveExerciseGroup group;
  final List<ActiveExerciseState> exercises;
  final String? activeExerciseId;
  final Widget Function(BuildContext, ActiveExerciseState, bool, String?) card;
  final VoidCallback onUngroup;
  const _ExerciseGroupCard({
    required this.group,
    required this.exercises,
    required this.activeExerciseId,
    required this.card,
    required this.onUngroup,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: CoachlyAthleteTheme.surface,
      borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
      border: Border.all(color: CoachlyAthleteTheme.border),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
          child: Row(
            children: [
              Text(
                '${_groupName(group.type)} ${_groupLetter(group.id)}',
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.1,
                  color: CoachlyAthleteTheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                group.restAfterRoundSeconds == null
                    ? ''
                    : 'REST ${group.restAfterRoundSeconds}s',
                style: const TextStyle(
                  fontSize: 11,
                  color: CoachlyAthleteTheme.textSecondary,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'ungroup') onUngroup();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'ungroup',
                    child: Text(context.activeTr('ungroup')),
                  ),
                ],
              ),
            ],
          ),
        ),
        ...exercises.map(
          (exercise) => card(
            context,
            exercise,
            exercise.exercise.id == activeExerciseId,
            _groupName(group.type),
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
  final CoachDecision? decision;
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
  final VoidCallback onInfo;
  final VoidCallback onSkip;
  const _ExerciseCard({
    required this.exercise,
    required this.activeSetId,
    required this.groupLabel,
    required this.active,
    required this.decision,
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
    required this.onInfo,
    required this.onSkip,
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
                      style: const TextStyle(
                        fontSize: 11,
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
    return AnimatedSize(
      duration: CoachlyAthleteTheme.expandDuration,
      curve: CoachlyAthleteTheme.standardCurve,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onInfo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (groupLabel != null)
                          Text(
                            groupLabel!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: CoachlyAthleteTheme.primary,
                            ),
                          ),
                        Text(
                          exercise.displayName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          '${exercise.completedSets + 1} / ${exercise.totalSets}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CoachlyAthleteTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'add') onAddSet();
                    if (value == 'skip') onSkip();
                    if (value == 'info') onInfo();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'add',
                      child: Text(context.activeTr('addSet')),
                    ),
                    PopupMenuItem(
                      value: 'skip',
                      child: Text(context.activeTr('skip')),
                    ),
                    PopupMenuItem(
                      value: 'info',
                      child: Text(context.activeTr('details')),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SetTable(
              exercise: exercise,
              activeSetId: activeSetId,
              onSet: onSet,
            ),
            if (activeSetId != null) ...[
              const SizedBox(height: 12),
              _ActiveSetEditor(
                set: exercise.sets.firstWhere((set) => set.id == activeSetId),
                onWeight: onWeight,
                onReps: onReps,
                onRir: onRir,
                onComplete: onComplete,
                onTechnique: onTechnique,
                onRole: onRole,
                onAddDrop: onAddDrop,
              ),
            ],
            if (decision != null) _GuardHint(decision: decision!),
          ],
        ),
      ),
    );
  }
}

class _SetTable extends StatelessWidget {
  final ActiveExerciseState exercise;
  final String? activeSetId;
  final ValueChanged<String> onSet;
  const _SetTable({
    required this.exercise,
    required this.activeSetId,
    required this.onSet,
  });
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Row(
        children: [
          SizedBox(width: 38, child: Text('SET', style: _labelStyle)),
          Expanded(child: Text('PREV', style: _labelStyle)),
          SizedBox(width: 52, child: Text('KG', style: _labelStyle)),
          SizedBox(width: 54, child: Text('REPS', style: _labelStyle)),
          SizedBox(width: 34, child: Text('RIR', style: _labelStyle)),
        ],
      ),
      ...exercise.sets.map((set) {
        final current = set.id == activeSetId;
        final symbol = set.completed
            ? '✓'
            : current
            ? '●'
            : set.skipped
            ? '–'
            : '○';
        return Semantics(
          button: true,
          selected: current,
          label:
              'Set ${set.position + 1}, ${_number(set.weight)} kilograms, ${set.reps} repetitions${set.rir == null ? '' : ', RIR ${set.rir}'}${current ? ', in progress' : ''}',
          child: InkWell(
            onTap: () => onSet(set.id),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: current
                    ? Border.all(color: CoachlyAthleteTheme.primary)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 38,
                    child: Text(
                      '$symbol ${_setPrefix(set)}',
                      style: TextStyle(
                        color: set.completed || current
                            ? CoachlyAthleteTheme.primary
                            : CoachlyAthleteTheme.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${_number(set.weight)}×${set.reps}',
                      style: const TextStyle(
                        color: CoachlyAthleteTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 52, child: Text(_number(set.weight))),
                  SizedBox(width: 54, child: Text('${set.reps}')),
                  SizedBox(width: 34, child: Text(set.rir?.toString() ?? '–')),
                ],
              ),
            ),
          ),
        );
      }),
    ],
  );
}

const _labelStyle = TextStyle(
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
  const _ActiveSetEditor({
    required this.set,
    required this.onWeight,
    required this.onReps,
    required this.onRir,
    required this.onComplete,
    required this.onTechnique,
    required this.onRole,
    required this.onAddDrop,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: CoachlyAthleteTheme.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              '${context.activeTr('sets')} ${set.position + 1}',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _showTechniqueSheet(context),
              child: Text(
                '${_roleName(set.role)} · ${_techniqueName(set.technique)}',
              ),
            ),
          ],
        ),
        _Stepper(
          label: context.activeTr('weight'),
          value: '${_number(set.weight)} kg',
          onMinus: () => onWeight(set, set.weight - 2.5),
          onPlus: () => onWeight(set, set.weight + 2.5),
          onDirect: () => _showNumberInput(
            context,
            set.weight,
            (value) => onWeight(set, value),
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
          ),
        ),
        if (set.technique == SetTechnique.dropSet) ...[
          const SizedBox(height: 8),
          ...set.drops.asMap().entries.map(
            (entry) => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DROP ${entry.key + 1}  ${_number(entry.value.weight)} × ${entry.value.reps}',
                style: const TextStyle(
                  fontSize: 12,
                  color: CoachlyAthleteTheme.textSecondary,
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => onAddDrop(set.id),
            icon: const Icon(Icons.add, size: 16),
            label: Text(context.activeTr('addDrop')),
          ),
        ],
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final rir in [0, 1, 2, 3, 4])
              ChoiceChip(
                label: Text(rir == 4 ? '4+' : '$rir'),
                selected: set.rir == rir,
                onSelected: (_) => onRir(rir),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: () => onComplete(set.id),
            child: Text(context.activeTr('completeSet')),
          ),
        ),
      ],
    ),
  );
  void _showTechniqueSheet(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ...SetRole.values.map(
            (role) => ListTile(
              title: Text(_roleName(role)),
              trailing: role == set.role
                  ? const Icon(Icons.check, color: CoachlyAthleteTheme.primary)
                  : null,
              onTap: () {
                Navigator.pop(sheetContext);
                onRole(role.name);
              },
            ),
          ),
          const Divider(),
          ...SetTechnique.values.map(
            (technique) => ListTile(
              title: Text(_techniqueName(technique)),
              trailing: technique == set.technique
                  ? const Icon(Icons.check, color: CoachlyAthleteTheme.primary)
                  : null,
              onTap: () {
                Navigator.pop(sheetContext);
                onTechnique(technique.name);
              },
            ),
          ),
        ],
      ),
    ),
  );
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
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 62,
          child: Text(label.toUpperCase(), style: _labelStyle),
        ),
        IconButton(onPressed: onMinus, icon: const Icon(Icons.remove_rounded)),
        Expanded(
          child: InkWell(
            onTap: onDirect,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        IconButton(onPressed: onPlus, icon: const Icon(Icons.add_rounded)),
      ],
    ),
  );
}

class _GuardHint extends StatelessWidget {
  final CoachDecision decision;
  const _GuardHint({required this.decision});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Text(
      '◎ ${context.activeTr(decision.primary.titleKey)}',
      style: const TextStyle(fontSize: 12, color: CoachlyAthleteTheme.primary),
    ),
  );
}

class _WorkoutActionDock extends StatelessWidget {
  final int guardCount;
  final VoidCallback onStructure;
  final VoidCallback onAdd;
  final VoidCallback onGuard;
  const _WorkoutActionDock({
    required this.guardCount,
    required this.onStructure,
    required this.onAdd,
    required this.onGuard,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
    decoration: const BoxDecoration(
      color: CoachlyAthleteTheme.background,
      border: Border(top: BorderSide(color: CoachlyAthleteTheme.border)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DockButton(
          icon: Icons.format_list_bulleted_rounded,
          label: context.activeTr('structure'),
          onTap: onStructure,
        ),
        _DockButton(
          icon: Icons.add_rounded,
          label: context.activeTr('add'),
          onTap: onAdd,
          primary: true,
        ),
        _DockButton(
          icon: Icons.shield_outlined,
          label: guardCount == 0
              ? context.activeTr('guard')
              : '${context.activeTr('guard')} $guardCount',
          onTap: onGuard,
          badge: guardCount,
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
  final int badge;
  const _DockButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
    this.badge = 0,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: const BoxConstraints(minWidth: 68, minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: primary ? CoachlyAthleteTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primary ? Colors.black : CoachlyAthleteTheme.textPrimary,
            ),
            if (badge > 0)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
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
  ValueChanged<double> onSubmit,
) {
  final controller = TextEditingController(text: _number(initial));
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (value) {
              final number = double.tryParse(value.replaceAll(',', '.'));
              if (number != null) onSubmit(number);
              Navigator.pop(sheetContext);
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final number = double.tryParse(
                  controller.text.replaceAll(',', '.'),
                );
                if (number != null) onSubmit(number);
                Navigator.pop(sheetContext);
              },
              child: Text(sheetContext.activeTr('confirm')),
            ),
          ),
        ],
      ),
    ),
  );
}

String _number(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);
String _setPrefix(ActiveSetState set) => switch (set.role) {
  SetRole.warmup => 'W${set.position + 1}',
  SetRole.topSet => 'T${set.position + 1}',
  SetRole.backoff => 'B${set.position + 1}',
  SetRole.working => '${set.position + 1}',
};
String _techniqueName(SetTechnique technique) => switch (technique) {
  SetTechnique.none => 'Normal',
  SetTechnique.dropSet => 'Drop set',
  SetTechnique.restPause => 'Rest-pause',
  SetTechnique.myoReps => 'Myo reps',
  SetTechnique.amrap => 'AMRAP',
  SetTechnique.failure => 'Failure',
  SetTechnique.cluster => 'Cluster',
};
String _roleName(SetRole role) => switch (role) {
  SetRole.working => 'Working',
  SetRole.warmup => 'Warm-up',
  SetRole.topSet => 'Top set',
  SetRole.backoff => 'Back-off',
};
String _groupName(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => 'SUPERSET',
  ExerciseGroupType.triset => 'TRISET',
  ExerciseGroupType.giantSet => 'GIANT SET',
  ExerciseGroupType.circuit => 'CIRCUIT',
  ExerciseGroupType.preparation => 'PREPARATION',
  ExerciseGroupType.mobility => 'MOBILITY',
};
String _groupLetter(String id) =>
    String.fromCharCode(65 + (id.hashCode.abs() % 26));
