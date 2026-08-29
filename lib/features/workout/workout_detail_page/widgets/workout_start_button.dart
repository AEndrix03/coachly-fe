import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutStartButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const WorkoutStartButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: FilledButton.icon(
        onPressed: enabled
            ? () {
                HapticFeedback.mediumImpact();
                onPressed();
              }
            : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: CoachlyAthleteTheme.primary,
          disabledBackgroundColor: CoachlyAthleteTheme.surfaceElevated,
          foregroundColor: CoachlyAthleteTheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              CoachlyAthleteTheme.actionRadius,
            ),
          ),
        ),
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(
          context.l10n.workoutStart,
          style: context.scale.bodyLoose.heavy,
        ),
      ),
    );
  }
}
