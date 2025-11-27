import 'dart:ui';

import 'package:coachly/features/workout/workout_page/data/models/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutRecentCard extends StatelessWidget {
  final Workout workout;

  const WorkoutRecentCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2196F3).withOpacity(0.15),
            const Color(0xFF1976D2).withOpacity(0.1),
            const Color(0xFF7B4BC1).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildCoachInfo(),
                const SizedBox(height: 14),
                _buildProgressSection(),
                const SizedBox(height: 14),
                _buildStats(),
                const SizedBox(height: 8),
                _buildLastUsed(),
                const SizedBox(height: 14),
                _buildStartButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            workout.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
              letterSpacing: 0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF9800).withOpacity(0.3),
                const Color(0xFFFF5722).withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.5)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Color(0xFFFF9800), size: 10),
              SizedBox(width: 3),
              Text(
                'Coach',
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoachInfo() {
    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: 13,
          color: Colors.white.withOpacity(0.7),
        ),
        const SizedBox(width: 5),
        Text(
          'Coach ${workout.coach}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${workout.progress}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: workout.progress / 100,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF2196F3),
              ),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildStatChip(Icons.fitness_center, '${workout.exercises} esercizi'),
        _buildStatChip(Icons.timer_outlined, '${workout.durationMinutes} min'),
        _buildStatChip(Icons.flag_outlined, workout.goal),
      ],
    );
  }

  Widget _buildLastUsed() {
    return Row(
      children: [
        Icon(Icons.schedule, size: 13, color: Colors.white.withOpacity(0.5)),
        const SizedBox(width: 5),
        Text(
          'Ultima: ${workout.lastUsed}',
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.go('/workouts/workout/${workout.id}'),
        icon: const Icon(Icons.play_arrow, size: 18),
        label: const Text(
          'Inizia Workout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.15),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF2196F3)),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
