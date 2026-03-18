import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/active_app_bar.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/active_bottom_bar.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/exercise_card.dart';
import 'package:coachly/features/workout/workout_active_page/widgets/rest_complete_dialog.dart';
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
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: switch (workoutState.status) {
          ActiveWorkoutStatus.loading => _buildLoading(),
          ActiveWorkoutStatus.error => _buildError(workoutState.errorMessage),
          _ => _buildContent(workoutState),
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFEF4444),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Errore nel caricamento.',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF374151)),
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: workoutState.exercises.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
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
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF374151), width: 1.5),
        ),
        title: const Text(
          'Completa allenamento?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Tutti i dati verranno salvati e la sessione registrata.',
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Annulla',
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Completa',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (result != true || !mounted) return;

    final notifier = ref.read(
      activeWorkoutProvider(widget.workoutId).notifier,
    );
    final success = await notifier.completeWorkout();

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Allenamento completato e salvato!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      final errorMessage = ref
          .read(activeWorkoutProvider(widget.workoutId))
          .errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Errore nel salvataggio.'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }
}
