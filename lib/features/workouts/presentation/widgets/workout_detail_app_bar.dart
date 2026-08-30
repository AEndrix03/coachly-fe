import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorkoutDetailAppBar extends StatelessWidget {
  final String title;
  final bool editing;
  final bool saving;
  final ValueListenable<double> scrollOffset;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDone;

  const WorkoutDetailAppBar({
    super.key,
    required this.title,
    required this.editing,
    required this.saving,
    required this.scrollOffset,
    required this.onBack,
    required this.onEdit,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: CoachlyAthleteTheme.background,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: editing
          ? Text(title, style: context.scale.subtitle.bold)
          : ValueListenableBuilder<double>(
              valueListenable: scrollOffset,
              builder: (_, offset, _) {
                final opacity = ((offset - 72) / 52).clamp(0.0, 1.0);
                return Opacity(
                  opacity: opacity,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.scale.subtitle.semibold,
                  ),
                );
              },
            ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: saving ? null : (editing ? onDone : onEdit),
          style: TextButton.styleFrom(
            minimumSize: const Size(
              CoachlyAthleteTheme.touchTarget,
              CoachlyAthleteTheme.touchTarget,
            ),
            foregroundColor: CoachlyAthleteTheme.primary,
          ),
          child: saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  context.tr(editing ? 'workout.detail.done' : 'common.edit'),
                ),
        ),
        if (!editing) ...[
          PopupMenuButton<String>(
            tooltip: context.l10n.workoutActions,
            icon: const Icon(Icons.more_horiz_rounded),
            color: CoachlyAthleteTheme.surfaceElevated,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'duplicate',
                child: Text(context.l10n.commonDuplicate),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  context.l10n.commonDelete,
                  style: const TextStyle(color: CoachlyAthleteTheme.danger),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ],
    );
  }
}
