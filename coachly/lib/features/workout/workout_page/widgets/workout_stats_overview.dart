import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:coachly/shared/widgets/cards/stat_card.dart';
import 'package:flutter/material.dart';

class WorkoutStatsOverview extends StatelessWidget {
  final WorkoutStatsModel? stats;
  final bool isLoading;

  const WorkoutStatsOverview({super.key, this.stats, this.isLoading = false});

  Color blendWithBackground(BuildContext context, Color color, double opacity) {
    final bg = Theme.of(context).colorScheme.surface;
    return Color.alphaBlend(color.withAlpha((opacity * 255).round()), bg);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final data = stats ?? _defaultStats;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.assignment_outlined,
              value: '${data.activeWorkouts}',
              label: 'Schede\nAttive',
              borderColor: scheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.history,
              value: '${data.completedWorkouts}',
              label: 'Completate',
              borderColor: scheme.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.show_chart,
              value: '+${data.progressPercentage.toStringAsFixed(0)}%',
              label: 'Progresso',
              borderColor: scheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  static const _defaultStats = WorkoutStatsModel(
    activeWorkouts: 0,
    completedWorkouts: 0,
    progressPercentage: 0,
    currentStreak: 0,
    weeklyWorkouts: 0,
  );
}
