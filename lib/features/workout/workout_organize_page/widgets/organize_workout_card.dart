import 'dart:ui';

import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/badges/coach_badge_widget.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrganizeWorkoutCard extends ConsumerStatefulWidget {
  final WorkoutModel workout;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onEdit;

  const OrganizeWorkoutCard({
    super.key,
    required this.workout,
    required this.onDelete,
    required this.onToggleActive,
    required this.onEdit,
  });

  @override
  ConsumerState<OrganizeWorkoutCard> createState() =>
      _OrganizeWorkoutCardState();
}

class _OrganizeWorkoutCardState extends ConsumerState<OrganizeWorkoutCard> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.workout.active;
  }

  @override
  void didUpdateWidget(covariant OrganizeWorkoutCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workout != oldWidget.workout) {
      setState(() {
        _isActive = widget.workout.active;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isActive ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colors.surfaceElevated.withValues(alpha: 0.85),
              context.colors.surfaceSunken.withValues(alpha: 0.65),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.colors.surfaceAccent.withValues(alpha: 0.14),
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.surface.withValues(alpha: 0.45),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIconSection(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.workout.titleI18n?.fromI18n(language) ??
                                    '',
                                style: context.text.bodyM.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.textPrimary,
                                  letterSpacing: 0.15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // `fontSize` qui e' un parametro del widget, non
                            // un TextStyle: la regola non puo' distinguerli.
                            const CoachBadgeWidget(
                              // ignore: no_literal_text_style
                              fontSize: 9,
                              iconSize: 10,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _buildInfoChip(
                              Icons.fitness_center,
                              context.l10n.workoutOrganizeExercisesCount(
                                '${widget.workout.workoutExercises.length}',
                              ),
                            ),
                            _buildInfoChip(
                              Icons.person_outline,
                              context.l10n.workoutOrganizeCoach(
                                widget.workout.coachName ??
                                    context.l10n.commonNa,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: context.colors.textPrimary,
                    ),
                    onSelected: (String result) {
                      if (result == 'toggleActive') {
                        setState(() {
                          _isActive = !_isActive;
                        });
                        widget.onToggleActive(_isActive);
                      } else if (result == 'edit') {
                        widget.onEdit();
                      } else if (result == 'delete') {
                        widget.onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'toggleActive',
                            child: Text(
                              _isActive
                                  ? context.l10n.commonDeactivate
                                  : context.l10n.commonActivate,
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text(context.l10n.commonEdit),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(context.l10n.commonDelete),
                          ),
                        ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.surfaceAccent,
            context.colors.surfaceAccentMuted,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: context.colors.surfaceAccent.withValues(alpha: 0.16),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        Icons.assignment,
        color: context.colors.textOnAccent,
        size: 18,
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.textPrimary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: context.colors.textPrimary.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: context.colors.textSecondary, size: 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: context.scale.micro.medium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
