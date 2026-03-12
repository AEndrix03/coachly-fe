import 'package:coachly/shared/widgets/cards/stat_card.dart';
import 'package:flutter/material.dart';

class WorkoutDetailStatsCards extends StatelessWidget {
  final int exercisesCount;
  final String duration;
  final String focus;

  const WorkoutDetailStatsCards({
    super.key,
    required this.exercisesCount,
    required this.duration,
    required this.focus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.fitness_center,
              value: exercisesCount.toString(),
              label: 'Esercizi',
              borderColor: const Color(0xFF2196F3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.timer_outlined,
              value: duration,
              label: 'Durata',
              borderColor: const Color(0xFF9C27B0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.local_fire_department,
              value: focus,
              label: 'Focus',
              borderColor: const Color(0xFFFF9800),
            ),
          ),
        ],
      ),
    );
  }
}
