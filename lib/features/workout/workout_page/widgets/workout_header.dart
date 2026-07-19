import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutHeader extends ConsumerWidget {
  final WorkoutStatsModel? stats;
  final bool isLoading;
  final VoidCallback? onStatsTap;

  const WorkoutHeader({
    super.key,
    this.stats,
    this.isLoading = false,
    this.onStatsTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF7B4BC1)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context, scheme),
            _buildContent(context, scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: scheme.onPrimary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fitness_center, color: Colors.white, size: 15),
                const SizedBox(width: 7),
                Text(
                  context.tr('common.workouts'),
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.95),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('workout.header_title'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickStats(context, scheme),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, ColorScheme scheme) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.onPrimary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final data = stats ?? _defaultStats;

    return InkWell(
      onTap: onStatsTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.onPrimary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.trending_up,
                  label: context.tr('workout.streak'),
                  value: '${data.currentStreak} ${context.tr('common.days')}',
                  scheme: scheme,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: scheme.onPrimary.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.access_time,
                  label: context.tr('workout.week'),
                  value:
                      '${data.weeklyWorkouts} ${context.tr(data.weeklyWorkouts == 1 ? 'common.workout' : 'common.workouts')}',
                  scheme: scheme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme scheme,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.8),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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
