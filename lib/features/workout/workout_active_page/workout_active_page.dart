import 'dart:async';

import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/features/workout/workout_active_page/coach/providers/workout_coach_provider.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/adaptive_workout_workspace.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_hive_service.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutActivePage extends ConsumerStatefulWidget {
  final String workoutId;
  const WorkoutActivePage({super.key, required this.workoutId});

  @override
  ConsumerState<WorkoutActivePage> createState() => _WorkoutActivePageState();
}

class _WorkoutActivePageState extends ConsumerState<WorkoutActivePage> {
  Timer? _clock;
  Timer? _undoTimer;
  Duration _elapsed = Duration.zero;
  String? _undoSetId;

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    _undoTimer?.cancel();
    super.dispose();
  }

  ActiveWorkout get _controller =>
      ref.read(activeWorkoutProvider(widget.workoutId).notifier);
  ActiveWorkoutState get _state =>
      ref.read(activeWorkoutProvider(widget.workoutId));

  @override
  Widget build(BuildContext context) {
    ref.listen<RestTimerState>(restTimerProvider, (previous, next) {
      if (previous?.isActive == true &&
          !next.isActive &&
          next.completedNaturally) {
        HapticFeedback.mediumImpact();
      }
    });
    final state = ref.watch(activeWorkoutProvider(widget.workoutId));
    return Scaffold(
      backgroundColor: CoachlyAthleteTheme.background,
      body: SafeArea(
        child: switch (state.status) {
          ActiveWorkoutStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          ActiveWorkoutStatus.error => _ErrorState(
            message: state.errorMessage,
            onBack: context.pop,
          ),
          _ => _workspace(context, state),
        },
      ),
    );
  }

  Widget _workspace(BuildContext context, ActiveWorkoutState state) {
    final decision = state.sessionId.isEmpty
        ? null
        : ref.watch(workoutCoachProvider(state.sessionId)).decision;
    return AdaptiveWorkoutWorkspace(
      state: state,
      title: _title(state),
      elapsed: _elapsed,
      rest: ref.watch(restTimerProvider),
      decision: decision,
      undoSetId: _undoSetId,
      onBack: context.pop,
      onMenu: () => _showSessionMenu(context),
      onExercise: _controller.goToExercise,
      onSet: _controller.goToSet,
      onWeight: (set, value) => _controller.updateSetWeight(
        _exerciseIndexForSet(set.id),
        set.position,
        value.toDouble().clamp(0, 9999),
      ),
      onReps: (set, value) => _controller.updateSetReps(
        _exerciseIndexForSet(set.id),
        set.position,
        value.toInt().clamp(0, 999),
      ),
      onRir: (rir) {
        final id = _state.currentSet?.id;
        if (id != null) _controller.updateSetRir(id, rir);
      },
      onComplete: _completeSet,
      onUndo: _undo,
      onAddSet: (exerciseId) => _controller.addSet(_exerciseIndex(exerciseId)),
      onTechnique: (name) {
        final id = _state.currentSet?.id;
        final technique = SetTechnique.values
            .where((item) => item.name == name)
            .firstOrNull;
        if (id != null && technique != null) {
          _controller.changeSetTechnique(id, technique);
        }
      },
      onRole: (name) {
        final id = _state.currentSet?.id;
        final role = SetRole.values
            .where((item) => item.name == name)
            .firstOrNull;
        if (id != null && role != null) {
          _controller.updateSetRole(id, role);
        }
      },
      onAddDrop: (setId) {
        HapticFeedback.selectionClick();
        _controller.addDrop(setId);
      },
      onExerciseInfo: _openExercise,
      onSkipExercise: _controller.skipExercise,
      onCreateGroup: (ids) {
        HapticFeedback.mediumImpact();
        _controller.createExerciseGroup(ids, ExerciseGroupType.superset);
      },
      onAddExercise: _showAddExerciseSheet,
      onUngroup: _controller.ungroupExercises,
      onCompleteWorkout: _completeWorkout,
      onSkipRest: () => ref.read(restTimerProvider.notifier).stopTimer(),
      onRestAdjust: (seconds) =>
          ref.read(restTimerProvider.notifier).addTime(seconds),
      onRestTogglePause: () =>
          ref.read(restTimerProvider.notifier).togglePause(),
      onDismissGuard: () {
        if (state.sessionId.isNotEmpty) {
          ref.read(workoutCoachProvider(state.sessionId).notifier).dismiss();
        }
      },
    );
  }

  int _exerciseIndex(String id) =>
      _state.exercises.indexWhere((exercise) => exercise.exercise.id == id);
  int _exerciseIndexForSet(String setId) => _state.exercises.indexWhere(
    (exercise) => exercise.sets.any((set) => set.id == setId),
  );

  void _completeSet(String setId) {
    HapticFeedback.lightImpact();
    _controller.completeSetAndStartRest(setId);
    _undoTimer?.cancel();
    setState(() => _undoSetId = setId);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Set completed'),
          action: SnackBarAction(label: 'UNDO', onPressed: () => _undo(setId)),
          duration: const Duration(seconds: 6),
        ),
      );
    _undoTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _undoSetId = null);
    });
  }

  void _undo(String setId) {
    _undoTimer?.cancel();
    _controller.undoSetAndRest(setId);
    setState(() => _undoSetId = null);
  }

  Future<void> _completeWorkout() async {
    final success = await _controller.completeWorkout();
    if (!mounted) return;
    if (success) {
      context.pop();
    } else {
      ref
          .read(appToastServiceProvider)
          .showError(context, 'Unable to save workout.');
    }
  }

  void _openExercise(String entryId) {
    final exercise = _state.exercises
        .where((item) => item.exercise.id == entryId)
        .firstOrNull;
    final id = exercise?.exercise.exercise.id;
    if (id != null && id.isNotEmpty) {
      context.push(
        '/workouts/workout/${widget.workoutId}/workout_exercise_page/$id',
      );
    }
  }

  void _showSessionMenu(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Finish workout'),
            onTap: () {
              Navigator.pop(sheetContext);
              _completeWorkout();
            },
          ),
        ],
      ),
    ),
  );

  String _title(ActiveWorkoutState state) {
    final names = state.workout?.titleI18n;
    final locale = Localizations.localeOf(context).languageCode;
    return names?[locale] ??
        names?['en'] ??
        names?.values.firstOrNull ??
        'Workout';
  }

  Future<void> _showAddExerciseSheet() async {
    final catalog = await ref.read(exerciseHiveServiceProvider).getExercises();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _LocalExercisePicker(
        exercises: catalog,
        onSelected: (exercise) {
          Navigator.pop(sheetContext);
          _showExerciseDestination(exercise);
        },
      ),
    );
  }

  void _showExerciseDestination(ExerciseDetailModel exercise) {
    final current = _state.currentExercise;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_downward_rounded),
              title: Text(
                'After ${current?.displayName ?? 'current exercise'}',
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _controller.addExercise(
                  exercise,
                  afterExerciseId: current?.exercise.id,
                );
              },
            ),
            if (current != null && _groupFor(current.exercise.id) != null)
              ListTile(
                leading: const Icon(Icons.link_rounded),
                title: const Text('Add to current group'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _controller.addExercise(
                    exercise,
                    groupId: _groupFor(current.exercise.id)!.id,
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.last_page_rounded),
              title: const Text('End of workout'),
              onTap: () {
                Navigator.pop(sheetContext);
                _controller.addExercise(exercise);
              },
            ),
          ],
        ),
      ),
    );
  }

  ActiveExerciseGroup? _groupFor(String entryId) => _state.groups
      .where((group) => group.exerciseIds.contains(entryId))
      .firstOrNull;
}

class _ErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onBack;
  const _ErrorState({this.message, required this.onBack});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message ?? 'Unable to load workout.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onBack, child: const Text('Back')),
        ],
      ),
    ),
  );
}

class _LocalExercisePicker extends StatefulWidget {
  final List<ExerciseDetailModel> exercises;
  final ValueChanged<ExerciseDetailModel> onSelected;
  const _LocalExercisePicker({
    required this.exercises,
    required this.onSelected,
  });
  @override
  State<_LocalExercisePicker> createState() => _LocalExercisePickerState();
}

class _LocalExercisePickerState extends State<_LocalExercisePicker> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final visible = widget.exercises.where((exercise) {
      final values = exercise.nameI18n?.values.join(' ').toLowerCase() ?? '';
      return values.contains(_query.toLowerCase());
    }).toList();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .72,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Search local exercises',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: visible.length,
                itemBuilder: (_, index) {
                  final exercise = visible[index];
                  final name =
                      exercise.nameI18n?[locale] ??
                      exercise.nameI18n?['en'] ??
                      exercise.nameI18n?.values.firstOrNull ??
                      'Exercise';
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(
                      exercise.isPersonal ? 'Personal' : 'Catalog',
                    ),
                    onTap: () => widget.onSelected(exercise),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
