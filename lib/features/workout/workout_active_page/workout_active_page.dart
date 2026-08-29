import 'dart:async';

import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/features/workout/workout_active_page/coach/providers/workout_coach_provider.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/adaptive_workout_workspace.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
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
  Duration _elapsed = Duration.zero;
  final String _loadUnit = 'kg';

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
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.exerciseTheme.background,
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
        ),
      ),
    );
  }

  Widget _workspace(BuildContext context, ActiveWorkoutState state) {
    return AdaptiveWorkoutWorkspace(
      state: state,
      title: _title(state),
      elapsed: _elapsed,
      rest: ref.watch(restTimerProvider),
      onBack: context.pop,
      onMenu: _completeWorkout,
      onExercise: _controller.goToExercise,
      onSet: _controller.goToSet,
      onWeight: (set, value) {
        HapticFeedback.lightImpact();
        _controller.updateSetWeight(
          _exerciseIndexForSet(set.id),
          set.position,
          value.toDouble().clamp(0, 9999),
        );
      },
      onReps: (set, value) {
        HapticFeedback.lightImpact();
        _controller.updateSetReps(
          _exerciseIndexForSet(set.id),
          set.position,
          value.toInt().clamp(0, 999),
        );
      },
      onRir: (rir) {
        HapticFeedback.selectionClick();
        final id = _state.currentSet?.id;
        if (id != null) _controller.updateSetRir(id, rir);
      },
      onComplete: _completeSet,
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
      onDropWeight: _controller.updateDropWeight,
      onDropReps: _controller.updateDropReps,
      onDropRemoved: _controller.removeDrop,
      onExerciseInfo: _openExercise,
      onCreateGroup: (ids, type) {
        HapticFeedback.mediumImpact();
        _controller.createExerciseGroup(ids, type);
      },
      onAddExercise: _showAddExerciseSheet,
      onAddBlockExercise: _addExerciseForBlock,
      onUngroup: _controller.ungroupExercises,
      onCompleteWorkout: _completeWorkout,
      onSkipRest: () => ref.read(restTimerProvider.notifier).stopTimer(),
      onRestAdjust: (seconds) =>
          ref.read(restTimerProvider.notifier).addTime(seconds),
      onRestTogglePause: () =>
          ref.read(restTimerProvider.notifier).togglePause(),
      onRestToggleBell: () => ref.read(restTimerProvider.notifier).toggleBell(),
      loadUnit: _loadUnit,
      onNote: _controller.updateSetNote,
    );
  }

  int _exerciseIndex(String id) =>
      _state.exercises.indexWhere((exercise) => exercise.exercise.id == id);
  int _exerciseIndexForSet(String setId) => _state.exercises.indexWhere(
    (exercise) => exercise.sets.any((set) => set.id == setId),
  );

  void _completeSet(String setId) {
    HapticFeedback.mediumImpact();
    _controller.completeSetAndStartRest(setId);
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
      context.push('/exercises/$id?mode=view');
    }
  }

  String _title(ActiveWorkoutState state) {
    final names = state.workout?.titleI18n;
    final locale = Localizations.localeOf(context).languageCode;
    return names?[locale] ??
        names?['en'] ??
        names?.values.firstOrNull ??
        'Workout';
  }

  Future<void> _showAddExerciseSheet() async {
    final catalog = await ref
        .read(exerciseInfoPageRepositoryProvider)
        .getDownloadedDetails();
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

  Future<({String id, String name})?> _addExerciseForBlock() async {
    final catalog = await ref
        .read(exerciseInfoPageRepositoryProvider)
        .getDownloadedDetails();
    if (!mounted) return null;
    final exercise = await showModalBottomSheet<ExerciseDetailModel>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _LocalExercisePicker(
        exercises: catalog,
        onSelected: (exercise) => Navigator.pop(sheetContext, exercise),
      ),
    );
    if (exercise == null || !mounted) return null;
    final id = _controller.addExercise(exercise);
    if (id == null) return null;
    final added = _state.exercises
        .where((item) => item.exercise.id == id)
        .firstOrNull;
    return (id: id, name: added?.displayName ?? 'Exercise');
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
                title: Text(context.tr('workout.active.add_to_group')),
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
              title: Text(context.tr('workout.active.end_of_workout')),
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
          OutlinedButton(
            onPressed: onBack,
            child: Text(context.tr('common.back')),
          ),
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
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: context.tr('workout.active.search_exercises'),
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
