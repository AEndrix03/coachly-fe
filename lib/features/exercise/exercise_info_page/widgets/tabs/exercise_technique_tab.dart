import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_equipment_model/exercise_equipment_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_safety_model/exercise_safety_model.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseTechniqueTab extends ConsumerWidget {
  final String description;
  final List<ExerciseSafetyModel> safety;
  final List<ExerciseEquipmentModel> equipments;

  const ExerciseTechniqueTab({
    super.key,
    required this.description,
    required this.safety,
    required this.equipments,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final hasDescription = description.trim().isNotEmpty;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDescription) _buildDescriptionCard(context, description),
          if (safety.isNotEmpty) ...[
            SizedBox(height: hasDescription ? 20 : 0),
            _buildSafetySection(context, safety, locale),
          ],
          if (equipments.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildEquipmentSection(context, equipments, locale),
          ],
          if (!hasDescription && safety.isEmpty && equipments.isEmpty)
            _buildEmptyState(context),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, String description) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('workout.description'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        context.tr('exercise.no_technical_data'),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSafetySection(
    BuildContext context,
    List<ExerciseSafetyModel> safetyItems,
    Locale locale,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B1B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF5252).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning,
                  color: Color(0xFFFF5252),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.tr('exercise.safety_tips'),
                style: const TextStyle(
                  color: Color(0xFFFF5252),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...safetyItems.map(
            (item) => _buildSafetyPoint(item.safetyNotesI18n.fromI18n(locale)),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSection(
    BuildContext context,
    List<ExerciseEquipmentModel> equipments,
    Locale locale,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('exercise.required_equipment'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: equipments
                .map(
                  (e) => _buildEquipmentChip(
                    e.equipment.nameI18n.fromI18n(locale),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2196F3).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2196F3),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
