import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_variant_model/exercise_variant_model.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseVariantsTab extends ConsumerWidget {
  final List<ExerciseVariantModel> variants;

  const ExerciseVariantsTab({super.key, required this.variants});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (variants.isEmpty) {
      return const Center(
        child: Text(
          'Nessuna variante disponibile.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final locale = ref.watch(languageProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...variants.map(
            (variant) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildVariantCard(variant: variant, locale: locale),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCard({
    required ExerciseVariantModel variant,
    required Locale locale,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to variant detail page
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.sync_alt,
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
                    variant.nameI18n?.fromI18n(locale) ??
                        variant.id ??
                        'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      variant.difficultyLevel ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
