import 'dart:ui';

import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/shared/animations/sparkle_tap_animation.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/widgets/badges/coach_badge_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class WorkoutRecentCard extends ConsumerStatefulWidget {
  final WorkoutModel workout;

  const WorkoutRecentCard({super.key, required this.workout});

  @override
  ConsumerState<WorkoutRecentCard> createState() => _WorkoutRecentCardState();
}

class _WorkoutRecentCardState extends ConsumerState<WorkoutRecentCard> {
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
    setState(() {
      _scale = 1.0;
      _showSparkle = false;
    });
    context.go(
      '/workouts/workout/${widget.workout.id}',
      extra: widget.workout,
    );
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
      _showSparkle = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final scheme = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutExpo,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 220, maxWidth: 320),
              decoration: BoxDecoration(
                color: scheme.surface.withOpacity(0.98),
                // Elegante, leggermente staccato dal bg
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scheme.outline.withOpacity(0.08)),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(context, scheme, language),
                        const SizedBox(height: 10),
                        _buildCoachInfo(context, scheme),
                        const SizedBox(height: 14),
                        _buildProgressSection(context, scheme),
                        const SizedBox(height: 14),
                        _buildStats(context, scheme),
                        const SizedBox(height: 10),
                        _buildLastUsed(context, scheme),
                        const SizedBox(height: 16),
                        _buildStartButton(context, scheme),
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
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme scheme,
    Locale language,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.workout.titleI18n.fromI18n(language),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
              height: 1.2,
              letterSpacing: 0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        CoachBadgeWidget(
          label: 'Coach',
          fontSize: 11,
          iconSize: 13,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
      ],
    );
  }

  Widget _buildCoachInfo(BuildContext context, ColorScheme scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.person_outline, size: 15, color: scheme.primary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Coach ${widget.workout.coachName ?? 'N/A'}',
            style: TextStyle(
              fontSize: 13,
              color: scheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${widget.workout.progress}%',
                style: TextStyle(
                  fontSize: 15,
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: widget.workout.progress / 100,
              backgroundColor: scheme.primaryContainer.withOpacity(0.18),
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, ColorScheme scheme) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        _buildStatChip(
          context,
          scheme,
          Icons.fitness_center,
          '${widget.workout.workoutExercises.length} esercizi',
        ),
        _buildStatChip(
          context,
          scheme,
          Icons.timer_outlined,
          '${widget.workout.durationMinutes} min',
        ),
        _buildStatChip(
          context,
          scheme,
          Icons.flag_outlined,
          widget.workout.goal,
        ),
      ],
    );
  }

  Widget _buildLastUsed(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        Icon(Icons.schedule, size: 14, color: scheme.primary),
        const SizedBox(width: 7),
        Text(
          'Ultima: ${DateFormat('dd/MM/yyyy').format(widget.workout.lastUsed)}',
          style: TextStyle(
            fontSize: 11,
            color: scheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.go(
          '/workouts/workout/${widget.workout.id}',
          extra: widget.workout,
        ),
        icon: Icon(Icons.play_arrow, size: 20, color: scheme.onPrimary),
        label: Text(
          'Inizia Workout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.2,
            color: scheme.onPrimary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    ColorScheme scheme,
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: scheme.primary, size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
