import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

/// Segnaposto della sezione community.
///
/// Sostituisce la card di esempio di Flutter ("The Enchanted Nightingale") che
/// era finita in produzione come contenuto del tab `/community`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.spacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: context.sizes.iconXl,
              color: context.colors.textSecondary,
            ),
            SizedBox(height: context.spacing.md),
            Text(
              context.tr('community.placeholder_title'),
              textAlign: TextAlign.center,
              style: context.text.titleM.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: context.spacing.xs),
            Text(
              context.tr('community.placeholder_body'),
              textAlign: TextAlign.center,
              style: context.text.bodyM.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
