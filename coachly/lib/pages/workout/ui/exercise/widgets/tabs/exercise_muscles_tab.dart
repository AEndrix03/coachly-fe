import 'package:flutter/material.dart';

class ExerciseMusclesTab extends StatelessWidget {
  const ExerciseMusclesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMuscleMapSection(),
          const SizedBox(height: 24),
          _buildMuscleGroupSection(
            title: 'MUSCOLI PRIMARI',
            muscles: [
              MuscleData(
                name: 'Pettorale',
                activation: 5,
                color: const Color(0xFFFF5252),
              ),
              MuscleData(
                name: 'Tricipite Brachiale',
                activation: 4,
                color: const Color(0xFFFF5252),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildMuscleGroupSection(
            title: 'MUSCOLI SECONDARI',
            muscles: [
              MuscleData(
                name: 'Deltoide Anteriore',
                activation: 3,
                color: const Color(0xFFFF9800),
              ),
              MuscleData(
                name: 'Dentato Anteriore',
                activation: 2,
                color: const Color(0xFFFF9800),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAiInsightsSection(),
        ],
      ),
    );
  }

  Widget _buildMuscleMapSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9800).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mappa Muscolare',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupSection({
    required String title,
    required List<MuscleData> muscles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...muscles
            .map(
              (muscle) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMuscleCard(muscle),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildMuscleCard(MuscleData muscle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: muscle.color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  muscle.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildActivationBar(muscle.activation, muscle.color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivationBar(int level, Color color) {
    return Row(
      children: List.generate(
        5,
        (index) => Container(
          margin: const EdgeInsets.only(right: 6),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: index < level ? color : color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildAiInsightsSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lightbulb, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Massima tensione muscolare raggiunta a 90° di flessione del gomito. Per massimizzare l\'ipertrofia, mantieni la fase eccentrica lenta.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MuscleData {
  final String name;
  final int activation;
  final Color color;

  const MuscleData({
    required this.name,
    required this.activation,
    required this.color,
  });
}
