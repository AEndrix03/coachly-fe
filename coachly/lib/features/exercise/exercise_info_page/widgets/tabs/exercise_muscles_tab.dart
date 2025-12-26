import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_muscle_model/exercise_muscle_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart'; // Import for fromI18n
import 'package:flutter/material.dart';

class ExerciseMusclesTab extends StatelessWidget {
  final List<ExerciseMuscleModel> muscles;

  const ExerciseMusclesTab({super.key, required this.muscles});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context); // Get locale here
    final primaryMuscles = [];
    final secondaryMuscles = [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMuscleMapSection(),
          const SizedBox(height: 24),
          if (primaryMuscles.isNotEmpty)
            _buildMuscleGroupSection(
              title: 'MUSCOLI PRIMARI',
              muscles: [],
              locale: locale,
            ),
          const SizedBox(height: 20),
          if (secondaryMuscles.isNotEmpty)
            _buildMuscleGroupSection(
              title: 'MUSCOLI SECONDARI',
              muscles: [],
              locale: locale,
            ),
          const SizedBox(height: 20),
          _buildAiInsightsSection(),
        ],
      ),
    );
  }

  Widget _buildMuscleMapSection() {
    // This section can be enhanced to show a real muscle map in the future
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha((255 * 0.1).toInt()),
          width: 1,
        ),
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
                  color: const Color(0xFFFF9800).withAlpha((255 * 0.4).toInt()),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.accessibility_new,
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
    required List<ExerciseMuscleModel> muscles,
    required Locale locale,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withAlpha((255 * 0.5).toInt()),
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
                child: _buildMuscleCard(muscle, locale),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildMuscleCard(ExerciseMuscleModel exerciseMuscle, Locale locale) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2196F3).withAlpha((255 * 0.2).toInt()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseMuscle.muscle.nameI18n.fromI18n(locale),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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
            color: const Color(0xFF2196F3).withAlpha((255 * 0.3).toInt()),
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
                  'Dati non ancora disponibili. Il coach AI sta analizzando il tuo profilo per fornire consigli personalizzati.',
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
