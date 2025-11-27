import 'package:coachly/features/workout/workout_page/data/models/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/section_header.dart';
import 'widgets/workout_card.dart';
import 'widgets/workout_header.dart';
import 'widgets/workout_recent_card.dart';
import 'widgets/workout_stats_overview.dart';

class WorkoutPage extends ConsumerWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutListProvider);
    final statsState = ref.watch(workoutStatsProvider);

    ref.listen(workoutListProvider, (previous, next) {
      if (previous == null) {
        ref.read(workoutListProvider.notifier).loadWorkouts();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      floatingActionButton: _buildFAB(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(workoutListProvider.notifier).refresh();
          await ref.read(workoutStatsProvider.notifier).refresh();
        },
        child: Container(
          color: const Color(0xFF0F0F1E),
          child: _buildBody(context, ref, workoutState, statsState),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    WorkoutListState workoutState,
    WorkoutStatsState statsState,
  ) {
    if (workoutState.hasError) {
      return _buildErrorState(workoutState.errorMessage!);
    }

    if (workoutState.isLoading && workoutState.workouts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2196F3)),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(
            stats: statsState.stats,
            isLoading: statsState.isLoading,
            onSettings: () => _showSettings(context),
            onNotifications: () => _showNotifications(context),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WorkoutStatsOverview(
              stats: statsState.stats,
              isLoading: statsState.isLoading,
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Schede Recenti'),
          const SizedBox(height: 10),
          _buildRecentWorkouts(workoutState.recentWorkouts),
          const SizedBox(height: 28),
          _buildAllWorkoutsHeader(workoutState.workouts.length),
          const SizedBox(height: 10),
          _buildActiveSubtitle(workoutState.workouts.length),
          const SizedBox(height: 10),
          _buildAllWorkouts(workoutState.workouts),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRecentWorkouts(List<Workout> workouts) {
    if (workouts.isEmpty) {
      return const SizedBox(
        height: 365,
        child: Center(
          child: Text(
            'Nessuna scheda recente',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return SizedBox(
      height: 365,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: workouts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 290,
            child: WorkoutRecentCard(workout: workouts[index]),
          );
        },
      ),
    );
  }

  Widget _buildAllWorkouts(List<Workout> workouts) {
    if (workouts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Nessuna scheda disponibile',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (int i = 0; i < workouts.length; i++) ...[
            WorkoutCard(workout: workouts[i]),
            if (i < workouts.length - 1) const SizedBox(height: 11),
          ],
        ],
      ),
    );
  }

  Widget _buildAllWorkoutsHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SectionHeader(title: 'Tutte le Schede', showIcon: true),
          _buildOrganizeButton(),
        ],
      ),
    );
  }

  Widget _buildActiveSubtitle(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            'Attive',
            style: TextStyle(
              fontSize: 13,
              color: Color.fromRGBO(255, 255, 255, 0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(76, 175, 80, 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizeButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(33, 150, 243, 0.2),
            const Color.fromRGBO(123, 75, 193, 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Color.fromRGBO(33, 150, 243, 0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tune, color: Color(0xFF2196F3), size: 15),
          SizedBox(width: 5),
          Text(
            'Organizza',
            style: TextStyle(
              color: Color(0xFF2196F3),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(33, 150, 243, 0.4),
            blurRadius: 14,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          // TODO: Implementa la navigazione verso la pagina di creazione scheda workout
          // Navigator.of(context).pushNamed('/createWorkout');
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, size: 26, color: Colors.white),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings'), duration: Duration(seconds: 1)),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifiche'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

// Fix per il tipo stats: cast esplicito se necessario
// Dove usato: WorkoutHeader e WorkoutStatsOverview
// Esempio:
// stats: statsState.stats as WorkoutStats?
