import 'package:flutter/material.dart';
import 'dart:ui';

class WorkoutStatsOverview extends StatelessWidget {
  const WorkoutStatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(
          icon: Icons.assignment_outlined,
          label: 'Schede Attive',
          value: '4',
          color: const Color(0xFF2196F3),
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(
          icon: Icons.history,
          label: 'Completate',
          value: '24',
          color: const Color(0xFF4CAF50),
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(
          icon: Icons.show_chart,
          label: 'Progresso',
          value: '+12%',
          color: const Color(0xFF9C27B0),
        )),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
