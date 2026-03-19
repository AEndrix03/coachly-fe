import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:flutter/material.dart';

class ContextPill extends StatefulWidget {
  const ContextPill({super.key, required this.context});

  final WorkoutContext context;

  @override
  State<ContextPill> createState() => _ContextPillState();
}

class _ContextPillState extends State<ContextPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutesAgo = DateTime.now()
        .difference(widget.context.sessionStart)
        .inMinutes;
    final timeAgo = minutesAgo <= 0 ? 'adesso' : '${minutesAgo}m fa';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AiCoachTheme.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AiCoachTheme.borderMid),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AiCoachTheme.accentBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${widget.context.exerciseName} - Set ${widget.context.currentSet}/${widget.context.totalSets} - ${widget.context.weightKg.toStringAsFixed(1)} kg - $timeAgo',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AiCoachTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FadeTransition(
            opacity: Tween<double>(
              begin: 0.3,
              end: 1,
            ).animate(_blinkController),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: AiCoachTheme.liveGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
