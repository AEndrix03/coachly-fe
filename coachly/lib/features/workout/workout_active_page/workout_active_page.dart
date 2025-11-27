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
  void _startRestTimer() {
    ref.read(restTimerProvider.notifier).startTimer(90);
  }

  @override
  Widget build(BuildContext context) {
    // Listen per dialog quando timer finisce
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

    // TODO: Implementare provider per stato workout attivo
    // final workoutState = ref.watch(activeWorkoutProvider(workoutId));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                const ActiveAppBar(currentExercise: 2, totalExercises: 11),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: 3, // TODO: Da provider
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ExerciseCard(
                          exerciseNumber: index + 1,
                          title: _getExerciseTitle(index),
                          setsRange: _getSetsRange(index),
                          repsRange: _getRepsRange(index),
                          sets: _getSets(index),
                          isExpanded: index == 0,
                          restSeconds: 90,
                          onSetCompleted: _startRestTimer,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Floating buttons
            const ActiveBottomBar(),
          ],
        ),
      ),
    );
  }

  String _getExerciseTitle(int index) {
    // TODO: Da provider
    final titles = [
      'Panca Piana Bilanciere',
      'Panca Inclinata Manubri',
      'Croci ai Cavi',
    ];
    return titles[index];
  }

  String _getSetsRange(int index) {
    // TODO: Da provider
    return index == 0 ? '2/4' : '0/4';
  }

  String _getRepsRange(int index) {
    // TODO: Da provider
    return index == 0 ? '8-10' : '10-12';
  }

  List<Map<String, dynamic>> _getSets(int index) {
    // TODO: Da provider
    if (index == 0) {
      return [
        {'type': 'Normale', 'weight': 85, 'reps': 10, 'completed': true},
        {'type': 'Normale', 'weight': 85, 'reps': 9, 'completed': true},
        {'type': 'Normale', 'weight': 85, 'reps': 8, 'completed': false},
        {'type': 'Normale', 'weight': 80, 'reps': 10, 'completed': false},
      ];
    }
    return [];
  }
}
