import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:coachly/shared/widgets/buttons/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutHeader extends ConsumerWidget {
  final WorkoutStatsModel? stats;
  final bool isLoading;
  final VoidCallback? onNotifications;

  const WorkoutHeader({
    super.key,
    this.stats,
    this.isLoading = false,
    this.onNotifications,
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
          children: [_buildAppBar(context, ref, scheme), _buildContent(scheme)],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: scheme.onPrimary.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.onPrimary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fitness_center, color: Colors.white, size: 15),
                const SizedBox(width: 7),
                Text(
                  'Allenamenti',
                  style: TextStyle(
                    color: scheme.onPrimary.withOpacity(0.95),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    _showLogoutDialog(context, ref);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
              ),
              const SizedBox(width: 8),
              _buildNotificationButton(scheme),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma Logout'),
          content: const Text('Sei sicuro di voler uscire?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authProvider.notifier).logout();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationButton(ColorScheme scheme) {
    return Stack(
      children: [
        GlassIconButton(
          icon: Icons.notifications_outlined,
          onPressed: onNotifications,
          iconColor: Colors.white,
          size: 20,
        ),
        // Se serve un badge, aggiungilo qui
      ],
    );
  }

  Widget _buildContent(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'I Tuoi Allenamenti',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickStats(scheme),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ColorScheme scheme) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.onPrimary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final data = stats ?? _defaultStats;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.trending_up,
                label: 'Streak',
                value: '${data.currentStreak} giorni',
                scheme: scheme,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: scheme.onPrimary.withOpacity(0.3),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.access_time,
                label: 'Settimana',
                value: '${data.weeklyWorkouts} workout',
                scheme: scheme,
              ),
            ),
          ],
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
            color: scheme.onPrimary.withOpacity(0.8),
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
