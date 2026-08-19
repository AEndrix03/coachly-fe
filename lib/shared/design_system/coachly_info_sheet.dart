import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';

class CoachlyInfoSection {
  final String title;
  final String body;

  const CoachlyInfoSection(this.title, this.body);
}

class CoachlyInfoSheet extends StatelessWidget {
  final String title;
  final List<CoachlyInfoSection> sections;
  final String? primaryActionLabel;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  const CoachlyInfoSheet({
    super.key,
    required this.title,
    required this.sections,
    this.primaryActionLabel,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<CoachlyInfoSection> sections,
    String? primaryActionLabel,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: CoachlyAthleteTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CoachlyInfoSheet(
        title: title,
        sections: sections,
        primaryActionLabel: primaryActionLabel,
        secondaryActionLabel: secondaryActionLabel,
        onSecondaryAction: onSecondaryAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CoachlyAthleteTheme.textSecondary.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 22),
          ...sections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    section.body,
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (primaryActionLabel != null) ...[
            SizedBox(
              width: double.infinity,
              height: CoachlyAthleteTheme.touchTarget,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: CoachlyAthleteTheme.primary,
                  foregroundColor: CoachlyAthleteTheme.background,
                ),
                child: Text(primaryActionLabel!),
              ),
            ),
            if (secondaryActionLabel != null) ...[
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSecondaryAction?.call();
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(
                      CoachlyAthleteTheme.touchTarget,
                      CoachlyAthleteTheme.touchTarget,
                    ),
                    foregroundColor: CoachlyAthleteTheme.primary,
                  ),
                  child: Text(secondaryActionLabel!),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
