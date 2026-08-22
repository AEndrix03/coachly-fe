import 'package:coachly/features/workout/workout_builder/tour/builder_tour_controller.dart';
import 'package:coachly/shared/design_system/coachly_floating_bubble.dart';
import 'package:coachly/shared/guided_tour/coachly_guided_tour.dart';
import 'package:flutter/material.dart';

class BuilderAssistRail extends StatelessWidget {
  final VoidCallback onDiscover;
  final VoidCallback onWorkoutCheck;
  final String discoverLabel;
  final String workoutCheckLabel;
  final String workoutCheckHeroTag;
  final CoachlyTourTargetRegistry? tourRegistry;

  const BuilderAssistRail({
    super.key,
    required this.onDiscover,
    required this.onWorkoutCheck,
    required this.discoverLabel,
    required this.workoutCheckLabel,
    required this.workoutCheckHeroTag,
    this.tourRegistry,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: keyboardOpen ? 0 : 1,
      child: IgnorePointer(
        ignoring: keyboardOpen,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CoachlyFloatingBubble(
              semanticsLabel: discoverLabel,
              emphasis: CoachlyBubbleEmphasis.low,
              onTap: onDiscover,
              icon: const CoachlyDiscoverGlyph(),
            ),
            const SizedBox(height: 10),
            _TourBubbleTarget(
              registry: tourRegistry,
              child: CoachlyFloatingBubble(
                semanticsLabel: workoutCheckLabel,
                emphasis: CoachlyBubbleEmphasis.high,
                onTap: onWorkoutCheck,
                heroTag: workoutCheckHeroTag,
                icon: const CoachlyWorkoutCheckGlyph(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TourBubbleTarget extends StatelessWidget {
  final CoachlyTourTargetRegistry? registry;
  final Widget child;
  const _TourBubbleTarget({required this.registry, required this.child});

  @override
  Widget build(BuildContext context) => registry == null
      ? child
      : CoachlyTourTarget(
          id: BuilderTourTarget.workoutCheck,
          registry: registry!,
          child: child,
        );
}
