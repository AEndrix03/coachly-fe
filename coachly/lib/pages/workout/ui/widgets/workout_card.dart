import 'package:flutter/material.dart';
import '../../data/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  const WorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(workout.title,
                    style: theme.textTheme.titleLarge!
                        .copyWith(color: Colors.white)),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Coach',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('di Coach ${workout.coach}',
                style: const TextStyle(fontSize: 13, color: Colors.white54)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: workout.progress / 100,
              color: theme.colorScheme.primary,
              backgroundColor: Colors.white10,
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${workout.exercises} esercizi'),
                Text('~${workout.durationMinutes} min'),
                Text(workout.goal),
              ],
            ),
            const SizedBox(height: 6),
            Text('Ultima: ${workout.lastUsed}',
                style: const TextStyle(fontSize: 12, color: Colors.white38)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
              label: const Text('Inizia Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                minimumSize: const Size.fromHeight(36),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
