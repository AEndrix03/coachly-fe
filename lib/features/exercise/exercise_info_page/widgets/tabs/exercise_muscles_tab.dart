import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_muscle_model/exercise_muscle_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/material.dart';

class ExerciseMusclesTab extends StatelessWidget {
  final List<ExerciseMuscleModel> muscles;

  const ExerciseMusclesTab({super.key, required this.muscles});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final sortedMuscles = [...muscles]
      ..sort((a, b) {
        final activationA = a.activationPercentage ?? -1;
        final activationB = b.activationPercentage ?? -1;
        return activationB.compareTo(activationA);
      });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sortedMuscles.isEmpty)
            _buildEmptyState()
          else
            _buildMuscleSection(muscles: sortedMuscles, locale: locale),
        ],
      ),
    );
  }

  Widget _buildMuscleSection({
    required List<ExerciseMuscleModel> muscles,
    required Locale locale,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muscoli Coinvolti',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
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
          color: const Color(0xFF2196F3).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exerciseMuscle.muscle?.nameI18n.fromI18n(locale) ?? 'N/A',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (exerciseMuscle.activationPercentage != null) ...[
            const SizedBox(height: 6),
            Text(
              'Attivazione ${exerciseMuscle.activationPercentage}%',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: Text(
        'Nessun dato muscolare disponibile.',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
    );
  }
}
