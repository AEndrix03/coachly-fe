import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/active_app_bar.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/active_bottom_bar.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/exercise_card.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/rest_complete_dialog.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class WorkoutActivePage extends ConsumerStatefulWidget {
  final String workoutId;

  const WorkoutActivePage({super.key, required this.workoutId});

  @override
  ConsumerState<WorkoutActivePage> createState() => _WorkoutActivePageState();
}

class _WorkoutActivePageState extends ConsumerState<WorkoutActivePage> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Rest timer dialog
    ref.listen<RestTimerState>(restTimerProvider, (previous, next) {
      if (previous != null &&
          previous.isActive &&
          previous.remainingSeconds > 0 &&
          next.remainingSeconds == 0 &&
          !next.isActive) {
        if (next.isBellEnabled) {
          _playRestCompleteAlert();
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RestCompleteDialog(),
        );
      }
    });

    final workoutState = ref.watch(activeWorkoutProvider(widget.workoutId));

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: switch (workoutState.status) {
          ActiveWorkoutStatus.loading => _buildLoading(scheme),
          ActiveWorkoutStatus.error => _buildError(workoutState.errorMessage),
          _ => _buildContent(workoutState),
        },
      ),
    );
  }

  Widget _buildLoading(ColorScheme scheme) {
    return Center(child: CircularProgressIndicator(color: scheme.primary));
  }

  Widget _buildError(String? message) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: scheme.error, size: 48),
            const SizedBox(height: 16),
            Text(
              message ?? context.tr('workout.load_error'),
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.onSurface,
                side: BorderSide(color: scheme.outlineVariant),
              ),
              child: Text(context.tr('common.go_back')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ActiveWorkoutState workoutState) {
    return Stack(
      children: [
        Column(
          children: [
            ActiveAppBar(workoutId: widget.workoutId),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 108),
                itemCount: workoutState.exercises.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ExerciseCard(
                      workoutId: widget.workoutId,
                      exerciseIndex: index,
                      isInitiallyExpanded: index == 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ActiveBottomBar(
          workoutId: widget.workoutId,
          onComplete: _showCompleteDialog,
        ),
      ],
    );
  }

  Future<void> _showCompleteDialog() async {
    final result = await showAppConfirmationDialog(
      context,
      title: context.tr('workout.complete_title'),
      content: context.tr('workout.complete_content'),
      confirmLabel: context.tr('workout.complete_confirm'),
      icon: Icons.flag_circle_rounded,
    );

    if (result != true || !mounted) return;

    final notifier = ref.read(activeWorkoutProvider(widget.workoutId).notifier);
    final success = await notifier.completeWorkout();

    if (!mounted) return;

    if (success) {
      ref
          .read(appToastServiceProvider)
          .showSuccess(
            context,
            context.tr('workout.completed_saved'),
            title: context.tr('workout.complete_confirm'),
          );
      Navigator.pop(context);
    } else {
      final errorMessage = ref
          .read(activeWorkoutProvider(widget.workoutId))
          .errorMessage;
      ref
          .read(appToastServiceProvider)
          .showError(
            context,
            errorMessage ?? context.tr('workout.save_error'),
            title: context.tr('workout.save_error'),
          );
    }
  }

  void _playRestCompleteAlert() {
    final player = FlutterRingtonePlayer();
    try {
      player.stop();
      player.play(
        android: AndroidSounds.alarm,
        ios: IosSounds.alarm,
        looping: false,
        volume: 1.0,
        asAlarm: true,
      );
    } catch (_) {
      SystemSound.play(SystemSoundType.alert);
    }
    HapticFeedback.mediumImpact();
  }
}
