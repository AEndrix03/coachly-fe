import 'dart:math' as math;

import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:flutter/material.dart';

enum CoachlyBubbleEmphasis { low, normal, high }

class CoachlyFloatingBubble extends StatelessWidget {
  final Widget icon;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final CoachlyBubbleEmphasis emphasis;
  final Widget? statusMarker;
  final String? heroTag;

  const CoachlyFloatingBubble({
    super.key,
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    this.emphasis = CoachlyBubbleEmphasis.normal,
    this.statusMarker,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final size = switch (emphasis) {
      CoachlyBubbleEmphasis.low => 48.0,
      CoachlyBubbleEmphasis.normal => 50.0,
      CoachlyBubbleEmphasis.high => 54.0,
    };
    final bubble = CoachlyPressable(
      onTap: onTap,
      semanticLabel: semanticsLabel,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: emphasis == CoachlyBubbleEmphasis.high
              ? context.exerciseTheme.surfaceElevated
              : context.exerciseTheme.surface,
          border: Border.all(
            color: emphasis == CoachlyBubbleEmphasis.high
                ? context.exerciseTheme.primary.withValues(alpha: .28)
                : context.exerciseTheme.border,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: IgnorePointer(child: icon)),
            if (statusMarker != null)
              Positioned(top: -2, right: -2, child: statusMarker!),
          ],
        ),
      ),
    );
    return Tooltip(
      message: semanticsLabel,
      child: heroTag == null
          ? bubble
          : Hero(
              tag: heroTag!,
              child: Material(color: Colors.transparent, child: bubble),
            ),
    );
  }
}

class CoachlyDiscoverGlyph extends StatefulWidget {
  final double size;
  const CoachlyDiscoverGlyph({super.key, this.size = 25});

  @override
  State<CoachlyDiscoverGlyph> createState() => _CoachlyDiscoverGlyphState();
}

class _CoachlyDiscoverGlyphState extends State<CoachlyDiscoverGlyph>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTapDown: (_) {
      if (!MediaQuery.disableAnimationsOf(context)) controller.forward(from: 0);
    },
    child: AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Transform.rotate(
        angle: math.sin(controller.value * math.pi) * .24,
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _DiscoverGlyphPainter(context.exerciseTheme.primary),
        ),
      ),
    ),
  );
}

class CoachlyWorkoutCheckGlyph extends StatelessWidget {
  final double size;
  const CoachlyWorkoutCheckGlyph({super.key, this.size = 27});

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _WorkoutCheckGlyphPainter(
      context.exerciseTheme.textPrimary,
      context.exerciseTheme.primary,
    ),
  );
}

class _DiscoverGlyphPainter extends CustomPainter {
  final Color color;
  const _DiscoverGlyphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.7;
    final rect = Rect.fromCircle(center: center, radius: size.width * .34);
    canvas.drawArc(rect, -.75, 1.8, false, paint);
    canvas.drawArc(rect, 2.0, 1.75, false, paint);
    canvas.drawCircle(center, 2.1, Paint()..color = color);
    canvas.drawCircle(
      Offset(size.width * .77, size.height * .35),
      2.4,
      Paint()..color = color.withValues(alpha: .82),
    );
    final needle = Path()
      ..moveTo(center.dx - 1.5, center.dy + 2)
      ..lineTo(center.dx + 5, center.dy - 6)
      ..lineTo(center.dx + 1.5, center.dy + 1)
      ..close();
    canvas.drawPath(needle, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _DiscoverGlyphPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _WorkoutCheckGlyphPainter extends CustomPainter {
  final Color foreground;
  final Color accent;
  const _WorkoutCheckGlyphPainter(this.foreground, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final star = Path()
      ..moveTo(c.dx, size.height * .08)
      ..quadraticBezierTo(c.dx + 2, c.dy - 3, size.width * .77, c.dy)
      ..quadraticBezierTo(c.dx + 2, c.dy + 3, c.dx, size.height * .92)
      ..quadraticBezierTo(c.dx - 2, c.dy + 3, size.width * .23, c.dy)
      ..quadraticBezierTo(c.dx - 2, c.dy - 3, c.dx, size.height * .08)
      ..close();
    canvas.drawPath(star, Paint()..color = foreground);
    canvas.drawCircle(
      Offset(size.width * .79, size.height * .24),
      2.2,
      Paint()..color = accent,
    );
  }

  @override
  bool shouldRepaint(covariant _WorkoutCheckGlyphPainter oldDelegate) =>
      oldDelegate.foreground != foreground || oldDelegate.accent != accent;
}
