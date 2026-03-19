import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/active_app_bar.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/active_bottom_bar.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/exercise_card.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/rest_complete_dialog.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      body: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.surface,
              Color.alphaBlend(
                scheme.primary.withValues(alpha: 0.07),
                scheme.surface,
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: switch (workoutState.status) {
            ActiveWorkoutStatus.loading => _buildLoading(scheme),
            ActiveWorkoutStatus.error => _buildError(workoutState.errorMessage),
            _ => _buildContent(workoutState),
          },
        ),
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
              message ?? 'Errore nel caricamento.',
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
              child: const Text('Torna indietro'),
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
    final scheme = Theme.of(context).colorScheme;

    final result = await showAppConfirmationDialog(
      context,
      title: 'Completa allenamento?',
      content: 'Tutti i dati verranno salvati e la sessione registrata.',
      confirmLabel: 'Completa',
      icon: Icons.flag_circle_rounded,
    );

    if (result != true || !mounted) return;

    final notifier = ref.read(activeWorkoutProvider(widget.workoutId).notifier);
    final success = await notifier.completeWorkout();

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Allenamento completato e salvato!'),
          backgroundColor: scheme.primary,
        ),
      );
    } else {
      final errorMessage = ref
          .read(activeWorkoutProvider(widget.workoutId))
          .errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Errore nel salvataggio.'),
          backgroundColor: scheme.error,
        ),
      );
    }
  }
}
