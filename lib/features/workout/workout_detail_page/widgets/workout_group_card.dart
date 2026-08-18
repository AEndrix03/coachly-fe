import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_exercise_card.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

class WorkoutGroupCard extends StatelessWidget {
  final WorkoutGroupBlockViewData group;
  final String label;
  final ValueChanged<WorkoutExerciseViewData> onOpenExercise;

  const WorkoutGroupCard({
    super.key,
    required this.group,
    required this.label,
    required this.onOpenExercise,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = group.type == WorkoutGroupType.superset
        ? context.tr('workout.detail.superset')
        : context.tr('workout.detail.circuit');
    return CoachlySurface(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      color: CoachlyAthleteTheme.surfaceElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CoachlyAthleteTheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$typeLabel · ${group.rounds} ${context.tr('workout.detail.rounds')}',
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .45,
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints.tightFor(
                  width: 44,
                  height: 44,
                ),
                tooltip: context.tr('workout.detail.explain_concept'),
                onPressed: () => _showGroupInfo(context, typeLabel),
                icon: const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: CoachlyAthleteTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...group.exercises.indexed.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: WorkoutExerciseCard(
                key: ValueKey(item.$2.instanceId),
                exercise: item.$2,
                indexLabel: '$label${item.$1 + 1}',
                onOpenDetail: () => onOpenExercise(item.$2),
              ),
            ),
          ),
          if (group.restAfterRoundSeconds != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '${context.tr('workout.detail.rest_after_round')} · ${_formatSeconds(group.restAfterRoundSeconds!)}',
                style: const TextStyle(
                  color: CoachlyAthleteTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showGroupInfo(BuildContext context, String typeLabel) {
    final isSuperset = group.type == WorkoutGroupType.superset;
    CoachlyInfoSheet.show(
      context,
      title: typeLabel,
      sections: [
        CoachlyInfoSection(
          context.tr('workout.detail.what_is_it'),
          context.tr(
            isSuperset
                ? 'workout.detail.superset_definition'
                : 'workout.detail.circuit_definition',
          ),
        ),
        CoachlyInfoSection(
          context.tr('workout.detail.how_to_read'),
          '${group.rounds} ${context.tr('workout.detail.rounds')} · ${group.exercises.map((e) => e.name).join(' → ')}',
        ),
      ],
    );
  }
}

String _formatSeconds(int seconds) => seconds < 60
    ? '${seconds}s'
    : '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
