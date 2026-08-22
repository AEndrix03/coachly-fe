import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/features/workout/workout_builder/tour/builder_tour_controller.dart';
import 'package:coachly/shared/design_system/coachly_floating_bubble.dart';
import 'package:coachly/shared/guided_tour/coachly_guided_tour.dart';
import 'package:flutter/material.dart';

class BuilderAssistRail extends StatefulWidget {
  final VoidCallback onDiscover;
  final VoidCallback onWorkoutCheck;
  final String discoverLabel;
  final String workoutCheckLabel;
  final String workoutCheckHeroTag;
  final CoachlyTourTargetRegistry? tourRegistry;
  final bool showReplayHint;
  final String replayHintLabel;

  const BuilderAssistRail({
    super.key,
    required this.onDiscover,
    required this.onWorkoutCheck,
    required this.discoverLabel,
    required this.workoutCheckLabel,
    required this.workoutCheckHeroTag,
    this.tourRegistry,
    this.showReplayHint = false,
    this.replayHintLabel = '',
  });

  @override
  State<BuilderAssistRail> createState() => _BuilderAssistRailState();
}

class _BuilderAssistRailState extends State<BuilderAssistRail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _highlightController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didUpdateWidget(covariant BuilderAssistRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showReplayHint && !oldWidget.showReplayHint) {
      if (MediaQuery.disableAnimationsOf(context)) {
        _highlightController.value = 1;
      } else {
        _highlightController.repeat(reverse: true);
      }
    } else if (!widget.showReplayHint && oldWidget.showReplayHint) {
      _highlightController.stop();
      _highlightController.value = 0;
    }
  }

  @override
  void dispose() {
    _highlightController.dispose();
    super.dispose();
  }

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
            Stack(
              clipBehavior: Clip.none,
              children: [
                _DiscoverBubbleTarget(
                  registry: widget.tourRegistry,
                  child: AnimatedBuilder(
                    animation: _highlightController,
                    builder: (context, child) => DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: widget.showReplayHint
                            ? [
                                BoxShadow(
                                  color: context.exerciseTheme.primary
                                      .withValues(
                                        alpha:
                                            .12 +
                                            _highlightController.value * .16,
                                      ),
                                  blurRadius:
                                      8 + _highlightController.value * 8,
                                  spreadRadius:
                                      1 + _highlightController.value * 2,
                                ),
                              ]
                            : const [],
                      ),
                      child: child,
                    ),
                    child: CoachlyFloatingBubble(
                      semanticsLabel: widget.discoverLabel,
                      emphasis: CoachlyBubbleEmphasis.low,
                      onTap: widget.onDiscover,
                      icon: const CoachlyDiscoverGlyph(),
                    ),
                  ),
                ),
                Positioned(
                  right: 60,
                  top: 2,
                  child: IgnorePointer(
                    child: AnimatedScale(
                      scale: widget.showReplayHint ? 1 : .96,
                      duration: const Duration(milliseconds: 180),
                      child: AnimatedOpacity(
                        opacity: widget.showReplayHint ? 1 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 230),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: context.exerciseTheme.surfaceElevated,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: context.exerciseTheme.border,
                            ),
                          ),
                          child: Text(
                            widget.replayHintLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: context.exerciseTheme.textPrimary,
                                  height: 1.3,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _TourBubbleTarget(
              registry: widget.tourRegistry,
              child: CoachlyFloatingBubble(
                semanticsLabel: widget.workoutCheckLabel,
                emphasis: CoachlyBubbleEmphasis.high,
                onTap: widget.onWorkoutCheck,
                heroTag: widget.workoutCheckHeroTag,
                icon: const CoachlyWorkoutCheckGlyph(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverBubbleTarget extends StatelessWidget {
  final CoachlyTourTargetRegistry? registry;
  final Widget child;

  const _DiscoverBubbleTarget({required this.registry, required this.child});

  @override
  Widget build(BuildContext context) => registry == null
      ? child
      : CoachlyTourTarget(
          id: BuilderTourTarget.discover,
          registry: registry!,
          child: child,
        );
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
