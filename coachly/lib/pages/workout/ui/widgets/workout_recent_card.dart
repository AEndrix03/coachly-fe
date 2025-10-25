import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/workout_model.dart';

class WorkoutRecentCard extends StatelessWidget {
  final Workout workout;

  static final _badgeDecoration = BoxDecoration(
    color: Colors.orangeAccent.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
  );

  static final _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  const WorkoutRecentCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: _badgeDecoration,
                  child: const Text(
                    'Coach',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'di Coach ${workout.coach}',
              style: const TextStyle(fontSize: 13, color: Colors.white60),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progresso',
                  style: TextStyle(fontSize: 13, color: Colors.white60),
                ),
                Text(
                  '${workout.progress}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: workout.progress / 100,
                color: theme.colorScheme.primary,
                backgroundColor: Colors.white10,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.fitness_center,
              text: '${workout.exercises} esercizi',
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.timer_outlined,
              text: '~${workout.durationMinutes} min',
            ),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.flag_outlined, text: workout.goal),
            const SizedBox(height: 8),
            Text(
              'Ultima: ${workout.lastUsed}',
              style: const TextStyle(fontSize: 12, color: Colors.white38),
            ),
            const Spacer(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/workouts/workout/${workout.id}'),
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text(
                  'Inizia Workout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: _buttonShape,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white60),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    );
  }
}
