import 'package:flutter/material.dart';
import 'dart:ui';

class WorkoutHeaderEnhanced extends StatelessWidget {
  const WorkoutHeaderEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
            Color(0xFF7B4BC1),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 12),
              _buildSubtitle(),
              const SizedBox(height: 24),
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Allenamenti',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5252),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'I Tuoi Allenamenti',
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Oggi è giorno gambe. Concentrati sul volume.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.trending_up,
                label: 'Streak',
                value: '7 giorni',
              ),
              _buildDivider(),
              _buildStatItem(
                icon: Icons.access_time,
                label: 'Questa settimana',
                value: '3 allenamenti',
              ),
              _buildDivider(),
              _buildStatItem(
                icon: Icons.local_fire_department,
                label: 'Calorie',
                value: '2,450',
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
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.white.withOpacity(0.3),
    );
  }
}
