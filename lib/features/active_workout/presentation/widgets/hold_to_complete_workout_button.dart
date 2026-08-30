import 'dart:math' as math;

import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/guided_tour/coachly_guided_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoldToCompleteWorkoutButton extends StatefulWidget {
  final String label;
  final String holdHint;
  final String releasedHint;
  final VoidCallback onCompleted;

  const HoldToCompleteWorkoutButton({
    super.key,
    required this.label,
    required this.holdHint,
    required this.releasedHint,
    required this.onCompleted,
  });

  @override
  State<HoldToCompleteWorkoutButton> createState() =>
      _HoldToCompleteWorkoutButtonState();
}

class _HoldToCompleteWorkoutButtonState
    extends State<HoldToCompleteWorkoutButton>
    with TickerProviderStateMixin {
  late final AnimationController _holdController = AnimationController(
    vsync: this,
  )..addStatusListener(_handleHoldStatus);
  late final AnimationController _shimmerController = AnimationController(
    vsync: this,
  );

  bool _pressed = false;
  bool _showReleasedHint = false;
  bool _didComplete = false;
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    _holdController.duration = context.motion.confirmHold;
    _shimmerController.duration = context.motion.confirmHold;
    if (_reduceMotion) {
      _shimmerController
        ..stop()
        ..value = 0;
    } else if (!_shimmerController.isAnimating) {
      _shimmerController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _holdController
      ..removeStatusListener(_handleHoldStatus)
      ..dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleHoldStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _didComplete) return;
    _didComplete = true;
    HapticFeedback.mediumImpact();
    widget.onCompleted();
  }

  void _startHold(TapDownDetails _) {
    if (_didComplete) return;
    setState(() {
      _pressed = true;
      _showReleasedHint = false;
    });
    _holdController.forward();
  }

  void _releaseHold() {
    if (_didComplete) return;
    _holdController.reverse();
    setState(() {
      _pressed = false;
      _showReleasedHint = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii.action;
    return Semantics(
      button: true,
      label: widget.label,
      hint: widget.holdHint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _holdController,
                _shimmerController,
              ]),
              builder: (context, _) {
                final holdProgress = _reduceMotion
                    ? 0.0
                    : _holdController.value;
                final shimmer = _reduceMotion ? 0.5 : _shimmerController.value;
                final activeFill = _pressed || holdProgress > 0;
                return CustomPaint(
                  foregroundPainter: _HoldCompletionPainter(
                    progress: holdProgress,
                    pulse: activeFill && !_reduceMotion ? shimmer : 0,
                    fillColor: colors.feedbackSuccess,
                    edgeColor: colors.feedbackWarning,
                    borderAccent: colors.surfaceAccent,
                    borderHighlight: colors.textPrimary,
                    showBorder: activeFill,
                    reduceMotion: _reduceMotion,
                    radius: radius,
                    strokeWidth: context.spacing.xxs / 2,
                    waveAmplitude: context.spacing.xs,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      gradient: colors.completeWorkoutGradient(
                        phase: shimmer,
                        active: activeFill,
                      ),
                      boxShadow: _pressed && !_reduceMotion
                          ? [
                              BoxShadow(
                                color: colors.feedbackWarning.withValues(
                                  alpha: 0.22 + shimmer * 0.2,
                                ),
                                blurRadius:
                                    context.spacing.sm +
                                    shimmer * context.spacing.sm,
                                spreadRadius: shimmer * context.spacing.xxs,
                              ),
                            ]
                          : const [],
                    ),
                    child: Material(
                      color: colors.surface.withValues(alpha: 0),
                      borderRadius: BorderRadius.circular(radius),
                      child: InkWell(
                        key: const Key('hold-to-complete-workout'),
                        onTapDown: _startHold,
                        onTapUp: (_) => _releaseHold(),
                        onTapCancel: _releaseHold,
                        borderRadius: BorderRadius.circular(radius),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: context.sizes.primaryActionHeight,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.spacing.md,
                              vertical: context.spacing.sm,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  color: colors.textOnAccent,
                                  size: context.sizes.iconMd,
                                ),
                                SizedBox(width: context.spacing.sm),
                                Flexible(
                                  child: Text(
                                    widget.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.scale.body.black.copyWith(
                                      color: colors.textOnAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_showReleasedHint) ...[
            SizedBox(height: context.spacing.xs),
            Text(
              widget.releasedHint,
              key: const Key('hold-to-complete-workout-hint'),
              textAlign: TextAlign.center,
              style: context.scale.captionLoose.semibold.copyWith(
                color: colors.feedbackWarning,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HoldCompletionPainter extends CustomPainter {
  final double progress;
  final double pulse;
  final Color fillColor;
  final Color edgeColor;
  final Color borderAccent;
  final Color borderHighlight;
  final bool showBorder;
  final bool reduceMotion;
  final double radius;
  final double strokeWidth;
  final double waveAmplitude;

  const _HoldCompletionPainter({
    required this.progress,
    required this.pulse,
    required this.fillColor,
    required this.edgeColor,
    required this.borderAccent,
    required this.borderHighlight,
    required this.showBorder,
    required this.reduceMotion,
    required this.radius,
    required this.strokeWidth,
    required this.waveAmplitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final clip = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.save();
    canvas.clipRRect(clip);

    if (progress > 0) {
      if (progress >= 1) {
        canvas.drawRect(
          rect,
          Paint()..color = fillColor.withValues(alpha: 0.68),
        );
      } else {
        final phase = pulse * math.pi * 2;
        canvas.drawPath(
          _wavePath(
            size,
            progress: progress,
            phase: phase + math.pi,
            amplitude: waveAmplitude,
          ),
          Paint()..color = edgeColor.withValues(alpha: 0.46),
        );
        canvas.drawPath(
          _wavePath(
            size,
            progress: progress,
            phase: phase,
            amplitude: waveAmplitude * 0.72,
          ),
          Paint()..color = fillColor.withValues(alpha: 0.58),
        );
      }
    }

    if (showBorder) {
      final edgeRect = rect.deflate(strokeWidth);
      CoachlyAnimatedBorderPainter.paintBorder(
        canvas,
        rrect: RRect.fromRectAndRadius(edgeRect, Radius.circular(radius)),
        phase: pulse,
        reduceMotion: reduceMotion,
        accent: borderAccent,
        highlight: borderHighlight,
        strokeWidth: strokeWidth,
      );
    }
    canvas.restore();
  }

  Path _wavePath(
    Size size, {
    required double progress,
    required double phase,
    required double amplitude,
  }) {
    const samples = 12;
    final front = size.width * progress;
    final path = Path()..moveTo(0, 0);
    for (var sample = 0; sample <= samples; sample++) {
      final fraction = sample / samples;
      final y = size.height * fraction;
      final wave = math.sin(fraction * math.pi * 2 + phase) * amplitude;
      path.lineTo((front + wave).clamp(0, size.width), y);
    }
    return path
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _HoldCompletionPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      pulse != oldDelegate.pulse ||
      fillColor != oldDelegate.fillColor ||
      edgeColor != oldDelegate.edgeColor ||
      borderAccent != oldDelegate.borderAccent ||
      borderHighlight != oldDelegate.borderHighlight ||
      showBorder != oldDelegate.showBorder ||
      reduceMotion != oldDelegate.reduceMotion ||
      radius != oldDelegate.radius ||
      strokeWidth != oldDelegate.strokeWidth ||
      waveAmplitude != oldDelegate.waveAmplitude;
}
