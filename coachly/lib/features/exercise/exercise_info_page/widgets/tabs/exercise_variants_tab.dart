import 'package:flutter/material.dart';

class ExerciseVariantsTab extends StatelessWidget {
  const ExerciseVariantsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVariantCard(
            icon: Icons.fitness_center,
            title: 'Panca Inclinata 30°',
            subtitle: 'Intermedio',
            emphasis: 'Petto Alto',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildVariantCard(
            icon: Icons.fitness_center,
            title: 'Panca Declinata',
            subtitle: 'Intermedio',
            emphasis: 'Petto Basso',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildVariantCard(
            icon: Icons.fitness_center,
            title: 'Panca con Manubri',
            subtitle: 'Intermedio',
            emphasis: 'ROM Aumentato',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildVariantCard(
            icon: Icons.fitness_center,
            title: 'Panca Stretta',
            subtitle: 'Intermedio',
            emphasis: 'Tricipiti',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String emphasis,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Color(0xFF2196F3),
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        emphasis,
                        style: const TextStyle(
                          color: Color(0xFF2196F3),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
