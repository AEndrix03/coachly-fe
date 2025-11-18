import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/active_app_bar.dart';
import 'widgets/active_bottom_bar.dart';
import 'widgets/exercise_card.dart';

class WorkoutActivePage extends ConsumerWidget {
  final String workoutId;

  const WorkoutActivePage({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implementare provider per stato workout attivo
    // final workoutState = ref.watch(activeWorkoutProvider(workoutId));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Column(
          children: [
            const ActiveAppBar(
              elapsedTime: '23:45',
              currentExercise: 2,
              totalExercises: 11,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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
                    ),
                  );
                },
              ),
            ),
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
