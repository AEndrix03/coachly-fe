import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/workout_detail_description.dart';
import 'widgets/workout_detail_exercise_list_section.dart';
import 'widgets/workout_detail_header.dart';
import 'widgets/workout_detail_stats_cards.dart';

class WorkoutDetailPage extends StatelessWidget {
  final String id;

  const WorkoutDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from BLoC/Provider
    final exercises = _getMockExercises();

    return Scaffold(
      body: Container(
        color: const Color(0xFF0F0F1E),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkoutDetailHeader(
                title: 'PETTO & TRICIPITI',
                coachName: 'Coach Luca Bianchi',
                muscleTags: const ['Petto', 'Tricipiti', 'Deltoidi Anteriori'],
                progress: 0.8,
                sessionsCount: 12,
                lastSessionDays: 2,
                onBack: () => Navigator.of(context).pop(),
                onShare: () {},
                onEdit: () {},
              ),
              const SizedBox(height: 20),
              const WorkoutDetailStatsCards(
                exercisesCount: 6,
                duration: '45\'',
                focus: 'Ipertrofia',
              ),
              const SizedBox(height: 20),
              const WorkoutDetailDescription(
                description:
                    'Programma intensivo focalizzato sullo sviluppo della massa muscolare di petto e tricipiti. Combina esercizi composti e di isolamento per uno stimolo completo.',
              ),
              const SizedBox(height: 20),
              _buildStartButton(context),
              const SizedBox(height: 20),
              WorkoutDetailExerciseListSection(exercises: exercises),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => context.go('/workouts/workout/start'),
          icon: const Icon(Icons.play_arrow, size: 22),
          label: const Text(
            'Inizia Allenamento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  List<ExerciseData> _getMockExercises() {
    return const [
      ExerciseData(
        number: 1,
        name: 'Panca Piana con Bilanciere',
        muscle: 'Petto',
        difficulty: 'Intermedio',
        sets: '4 × 8-10',
        rest: '120s',
        weight: '85 kg',
        progress: '+5%',
        accentColor: Color(0xFF2196F3),
      ),
      ExerciseData(
        number: 2,
        name: 'Panca Inclinata Manubri',
        muscle: 'Petto Alto',
        difficulty: 'Intermedio',
        sets: '4 × 10-12',
        rest: '90s',
        weight: '32 kg',
        progress: '+3%',
        accentColor: Color(0xFF2196F3),
      ),
      ExerciseData(
        number: 3,
        name: 'Croci ai Cavi',
        muscle: 'Petto',
        difficulty: 'Base',
        sets: '3 × 12-15',
        rest: '60s',
        weight: '20 kg',
        progress: '',
        accentColor: Color(0xFF2196F3),
      ),
      ExerciseData(
        number: 4,
        name: 'Panca Stretta',
        muscle: 'Tricipiti',
        difficulty: 'Intermedio',
        sets: '4 × 8-10',
        rest: '90s',
        weight: '70 kg',
        progress: '+7%',
        accentColor: Color(0xFF9C27B0),
      ),
      ExerciseData(
        number: 5,
        name: 'French Press',
        muscle: 'Tricipiti',
        difficulty: 'Base',
        sets: '3 × 10-12',
        rest: '75s',
        weight: '30 kg',
        progress: '',
        accentColor: Color(0xFF9C27B0),
      ),
      ExerciseData(
        number: 6,
        name: 'Push Down Cavi',
        muscle: 'Tricipiti',
        difficulty: 'Base',
        sets: '3 × 12-15',
        rest: '60s',
        weight: '35 kg',
        progress: '+2%',
        accentColor: Color(0xFF9C27B0),
      ),
    ];
  }
}
