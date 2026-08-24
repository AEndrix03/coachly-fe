import 'dart:async';

import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/features/workout/workout_active_page/coach/providers/workout_coach_provider.dart';
import 'package:coachly/features/workout/workout_active_page/data/active_workout_draft_service.dart';
import 'package:coachly/features/workout/workout_active_page/domain/set_input_configuration.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/active_workout_shell.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/active_workout_strings.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:go_router/go_router.dart';

class WorkoutActivePage extends ConsumerStatefulWidget {
  final String workoutId;
  const WorkoutActivePage({super.key, required this.workoutId});

  @override
  ConsumerState<WorkoutActivePage> createState() => _WorkoutActivePageState();
}

class _WorkoutActivePageState extends ConsumerState<WorkoutActivePage> {
  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();
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
    unawaited(_ringtonePlayer.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RestTimerState>(restTimerProvider, (previous, next) {
      if (previous?.isActive == true &&
          previous!.remainingSeconds > 0 &&
          !next.isActive &&
          next.completedNaturally) {
        HapticFeedback.mediumImpact();
        if (next.isBellEnabled) unawaited(_playRestCompleteAlert());
        unawaited(
          ref
              .read(activeWorkoutDraftServiceProvider)
              .clearRest(widget.workoutId),
        );
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
            onBack: () => context.pop(),
          ),
          _ => _content(state),
        },
      ),
    );
  }

  Widget _content(ActiveWorkoutState state) {
    final exercise = state.currentExercise;
    final set = state.currentSet;
    final rest = ref.watch(restTimerProvider);
    final decision = state.sessionId.isEmpty
        ? null
        : ref.watch(workoutCoachProvider(state.sessionId)).decision;
    final title = _localizedWorkoutTitle(state);
    final completedExercises = state.exercises
        .where(
          (item) =>
              item.sets.isNotEmpty &&
              item.sets.every((set) => set.completed || set.skipped),
        )
        .length;
    final allDone = state.currentTarget == null;

    return Column(
      children: [
        ActiveWorkoutSessionHeader(
          title: title,
          elapsed: _elapsed,
          completedExercises: completedExercises,
          totalExercises: state.totalExercises,
          rest: rest,
          onBack: () => context.pop(),
          onMenu: () => _showSessionMenu(allDone),
        ),
        Expanded(
          child: exercise == null || set == null
              ? _CompletedState(title: title)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                  children: [
                    CurrentExerciseHeader(
                      exercise: exercise,
                      set: set,
                      nextBlockExerciseName: _nextBlockExerciseName(
                        state,
                        exercise,
                      ),
                      onExerciseTap: () => _openExercise(exercise),
                      onActions: () => _showExerciseActions(exercise),
                    ),
                    const SizedBox(height: 20),
                    PreviousTargetContext(set: set),
                    const SizedBox(height: 24),
                    CurrentSetControls(
                      set: set,
                      showWeight: exercise.inputConfiguration.shows(
                        SetInputField.weight,
                      ),
                      showReps:
                          set.leftReps == null &&
                          set.rightReps == null &&
                          exercise.inputConfiguration.shows(SetInputField.reps),
                      showRir: exercise.inputConfiguration.shows(
                        SetInputField.rir,
                      ),
                      onWeight: (value) => _notifier.updateSetWeight(
                        _exerciseIndex(exercise),
                        set.position,
                        value,
                      ),
                      onReps: (value) => _notifier.updateSetReps(
                        _exerciseIndex(exercise),
                        set.position,
                        value,
                      ),
                      onRir: (value) => _notifier.updateSetRir(set.id, value),
                      onLeftReps: (value) =>
                          _notifier.updateSetSideReps(set.id, left: value),
                      onRightReps: (value) =>
                          _notifier.updateSetSideReps(set.id, right: value),
                      onMirror: () => _notifier.updateSetSideReps(
                        set.id,
                        left: set.leftReps ?? set.reps,
                        right: set.leftReps ?? set.reps,
                      ),
                    ),
                    const SizedBox(height: 18),
                    CompactRestTimer(
                      state: rest,
                      onMinus: () =>
                          ref.read(restTimerProvider.notifier).addTime(-30),
                      onPlus: () =>
                          ref.read(restTimerProvider.notifier).addTime(30),
                      onSkip: _skipRest,
                    ),
                    if (decision != null) ...[
                      const SizedBox(height: 16),
                      CoachDecisionCard(
                        decision: decision,
                        onWhy: () => _showCoachReason(decision),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ExerciseSetStrip(
                      exercise: exercise,
                      currentSetId: set.id,
                      onSetTap: _notifier.goToSet,
                    ),
                  ],
                ),
        ),
        _bottomAction(state, exercise, set, allDone),
      ],
    );
  }

  Widget _bottomAction(
    ActiveWorkoutState state,
    ActiveExerciseState? exercise,
    ActiveSetState? set,
    bool allDone,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: const BoxDecoration(
        color: CoachlyAthleteTheme.background,
        border: Border(top: BorderSide(color: CoachlyAthleteTheme.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_undoSetId != null)
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: CoachlyAthleteTheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(context.activeTr('undoCompleted'))),
                TextButton(
                  onPressed: _undo,
                  child: Text(context.tr('common.undo')),
                ),
              ],
            ),
          SizedBox(
            width: double.infinity,
            height: CoachlyAthleteTheme.primaryActionHeight,
            child: FilledButton(
              onPressed: state.status == ActiveWorkoutStatus.saving
                  ? null
                  : allDone
                  ? _completeWorkout
                  : () => _completeSet(exercise!, set!),
              style: FilledButton.styleFrom(
                backgroundColor: CoachlyAthleteTheme.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CoachlyAthleteTheme.actionRadius,
                  ),
                ),
              ),
              child: Text(
                context.activeTr(allDone ? 'completeWorkout' : 'completeSet'),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: .7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ActiveWorkout get _notifier =>
      ref.read(activeWorkoutProvider(widget.workoutId).notifier);
  int _exerciseIndex(ActiveExerciseState exercise) => ref
      .read(activeWorkoutProvider(widget.workoutId))
      .exercises
      .indexWhere((item) => item.exercise.id == exercise.exercise.id);

  void _completeSet(ActiveExerciseState exercise, ActiveSetState set) {
    HapticFeedback.lightImpact();
    _notifier.completeSetById(set.id);
    ref.read(restTimerProvider.notifier).startTimer(exercise.restSeconds);
    unawaited(
      ref
          .read(activeWorkoutDraftServiceProvider)
          .saveRest(
            workoutId: widget.workoutId,
            endsAt: DateTime.now().add(Duration(seconds: exercise.restSeconds)),
            initialSeconds: exercise.restSeconds,
          ),
    );
    _undoTimer?.cancel();
    setState(() => _undoSetId = set.id);
    _undoTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _undoSetId = null);
    });
  }

  void _undo() {
    final setId = _undoSetId;
    if (setId == null) return;
    _undoTimer?.cancel();
    ref.read(restTimerProvider.notifier).stopTimer();
    unawaited(
      ref.read(activeWorkoutDraftServiceProvider).clearRest(widget.workoutId),
    );
    _notifier.undoSetCompletion(setId);
    setState(() => _undoSetId = null);
  }

  void _skipRest() {
    ref.read(restTimerProvider.notifier).stopTimer();
    unawaited(
      ref.read(activeWorkoutDraftServiceProvider).clearRest(widget.workoutId),
    );
  }

  Future<void> _completeWorkout() async {
    final success = await _notifier.completeWorkout();
    if (!mounted) return;
    if (success) {
      context.pop();
    } else {
      ref
          .read(appToastServiceProvider)
          .showError(context, context.tr('workout.save_error'));
    }
  }

  void _openExercise(ActiveExerciseState exercise) {
    final id = exercise.exercise.exercise.id;
    if (id != null && id.isNotEmpty) {
      context.push(
        '/workouts/workout/${widget.workoutId}/workout_exercise_page/$id',
      );
    }
  }

  String? _nextBlockExerciseName(
    ActiveWorkoutState state,
    ActiveExerciseState current,
  ) {
    final blockExercises = state.exercises
        .where(
          (exercise) => exercise.executionBlockId == current.executionBlockId,
        )
        .toList();
    if (blockExercises.length < 2) return null;
    final index = blockExercises.indexOf(current);
    return blockExercises[(index + 1) % blockExercises.length].displayName;
  }

  void _showExerciseActions(ActiveExerciseState exercise) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.add_rounded),
              title: Text(context.tr('exercise.add_set')),
              onTap: () {
                Navigator.pop(context);
                _notifier.addSet(_exerciseIndex(exercise));
              },
            ),
            ListTile(
              leading: const Icon(Icons.skip_next_rounded),
              title: Text(context.activeTr('skip')),
              onTap: () {
                Navigator.pop(context);
                _notifier.skipExercise(exercise.exercise.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(context.tr('exercise.info')),
              onTap: () {
                Navigator.pop(context);
                _openExercise(exercise);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionMenu(bool allDone) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.flag_outlined),
          title: Text(context.activeTr('completeWorkout')),
          enabled: allDone,
          onTap: allDone
              ? () {
                  Navigator.pop(context);
                  _completeWorkout();
                }
              : null,
        ),
      ),
    );
  }

  void _showCoachReason(dynamic decision) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.activeTr('whyTitle'),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                decision.primary.reasonKey,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (decision.primary.evidence.isEmpty)
                Text(context.activeTr('noEvidence'))
              else
                for (final evidence in decision.primary.evidence)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• ${evidence.value}'),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  String _localizedWorkoutTitle(ActiveWorkoutState state) {
    final names = state.workout?.titleI18n;
    final language = Localizations.localeOf(context).languageCode;
    return names?[language] ?? names?['en'] ?? context.tr('common.workout');
  }

  Future<void> _playRestCompleteAlert() async {
    try {
      await _ringtonePlayer.play(
        android: AndroidSounds.alarm,
        ios: IosSounds.alarm,
        volume: .8,
      );
    } catch (_) {
      SystemSound.play(SystemSoundType.alert);
    }
  }
}

class _CompletedState extends StatelessWidget {
  final String title;
  const _CompletedState({required this.title});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: CoachlyAthleteTheme.primary,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );
}

class _ErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onBack;
  const _ErrorState({required this.message, required this.onBack});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48),
          const SizedBox(height: 16),
          Text(
            message ?? context.tr('workout.load_error'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onBack,
            child: Text(context.tr('common.go_back')),
          ),
        ],
      ),
    ),
  );
}
