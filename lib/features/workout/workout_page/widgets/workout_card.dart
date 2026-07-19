import 'dart:ui';

import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/animations/sparkle_tap_animation.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/badges/coach_badge_widget.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutCard extends ConsumerStatefulWidget {
  final WorkoutModel workout;

  const WorkoutCard({super.key, required this.workout});

  @override
  ConsumerState<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends ConsumerState<WorkoutCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  Offset? _tapPosition;
  bool _showSparkle = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.92;
      _tapPosition = details.localPosition;
      _showSparkle = true;
    });
  }

  void _onTapUp(TapUpDetails details) async {
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() {
      _scale = 1.0;
      _showSparkle = false;
    });
    context.go('/workouts/workout/${widget.workout.id}', extra: widget.workout);
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
      _showSparkle = false;
    });
  }

  Future<void> _onActionSelected(_WorkoutAction action) async {
    final language = ref.read(languageProvider);
    final name = widget.workout.titleI18n?.fromI18n(language) ?? '';

    switch (action) {
      case _WorkoutAction.edit:
        context.push(
          '/workouts/workout/${widget.workout.id}/edit',
          extra: widget.workout,
        );
      case _WorkoutAction.toggleActive:
        final activating = !widget.workout.active;
        final actionLabel = context.tr(
          activating
              ? 'workout.organize.action_activate'
              : 'workout.organize.action_deactivate',
        );
        final confirmed = await showAppConfirmationDialog(
          context,
          title: context.tr('workout.organize.status_title'),
          content: context.tr(
            'workout.organize.status_content',
            params: {'action': actionLabel, 'name': name},
          ),
          confirmLabel: context.tr('common.confirm'),
          icon: Icons.archive_outlined,
        );
        if (!confirmed) return;
        if (activating) {
          await ref
              .read(workoutListProvider.notifier)
              .enableWorkout(widget.workout.id);
        } else {
          await ref
              .read(workoutListProvider.notifier)
              .disableWorkout(widget.workout.id);
        }
      case _WorkoutAction.delete:
        final confirmed = await showAppConfirmationDialog(
          context,
          title: context.tr('workout.organize.delete_title'),
          content: context.tr(
            'workout.organize.delete_content',
            params: {'name': name},
          ),
          confirmLabel: context.tr('common.delete'),
          destructive: true,
          icon: Icons.delete_outline_rounded,
        );
        if (!confirmed) return;
        await ref
            .read(workoutListProvider.notifier)
            .deleteWorkout(widget.workout.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final coachName = widget.workout.coachName?.trim();
    final hasCoachName =
        coachName != null &&
        coachName.isNotEmpty &&
        coachName.toLowerCase() != 'n/a';

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutExpo,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF23233A).withValues(alpha: 0.85),
                      const Color(0xFF2A2A3E).withValues(alpha: 0.65),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF2196F3).withValues(alpha: 0.14),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                        widget.workout.titleI18n?.fromI18n(
                                              language,
                                            ) ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.15,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (hasCoachName) ...[
                                      const SizedBox(width: 6),
                                      const CoachBadgeWidget(
                                        fontSize: 9,
                                        iconSize: 10,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(width: 2),
                                    PopupMenuButton<_WorkoutAction>(
                                      tooltip: context.tr('workout.actions'),
                                      icon: Icon(
                                        Icons.more_horiz_rounded,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                      onSelected: _onActionSelected,
                                      itemBuilder: (context) => [
                                        if (!widget.workout.active)
                                          _toggleActiveMenuItem(context),
                                        PopupMenuItem(
                                          value: _WorkoutAction.edit,
                                          child: _menuItem(
                                            Icons.edit_outlined,
                                            context.tr('common.edit'),
                                          ),
                                        ),
                                        if (widget.workout.active)
                                          _toggleActiveMenuItem(context),
                                        PopupMenuItem(
                                          value: _WorkoutAction.delete,
                                          child: _menuItem(
                                            Icons.delete_outline_rounded,
                                            context.tr('common.delete'),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                        ),
                                      ],
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
                                      context.tr(
                                        'workout.organize.exercises_count',
                                        params: {
                                          'count':
                                              '${widget.workout.workoutExercises.length}',
                                        },
                                      ),
                                    ),
                                    if (hasCoachName)
                                      _buildInfoChip(
                                        Icons.person_outline,
                                        'Coach $coachName',
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SparkleTapAnimation(
                position: _tapPosition,
                show: _showSparkle,
                size: 60,
                duration: const Duration(milliseconds: 180),
              ),
            ],
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
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withValues(alpha: 0.16),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Icon(Icons.assignment, color: Colors.white, size: 18),
    );
  }

  Widget _menuItem(IconData icon, String label, {Color? color}) {
    final foreground = color ?? Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Icon(icon, size: 18, color: foreground),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: foreground)),
      ],
    );
  }

  PopupMenuItem<_WorkoutAction> _toggleActiveMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: _WorkoutAction.toggleActive,
      child: _menuItem(
        widget.workout.active
            ? Icons.archive_outlined
            : Icons.unarchive_outlined,
        context.tr(
          widget.workout.active ? 'common.deactivate' : 'common.activate',
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.80), size: 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

enum _WorkoutAction { edit, toggleActive, delete }
