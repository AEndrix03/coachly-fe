import 'package:flutter/material.dart';

class SparkleTapAnimation extends StatelessWidget {
  final Offset? position;
  final bool show;
  final double size;
  final Duration duration;
  final VoidCallback? onEnd;

  const SparkleTapAnimation({
    super.key,
    required this.position,
    required this.show,
    this.size = 60,
    this.duration = const Duration(milliseconds: 180),
    this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || position == null) return const SizedBox.shrink();
    return Positioned(
      left: position!.dx - size / 2,
      top: position!.dy - size / 2,
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: duration,
        curve: Curves.easeOut,
        onEnd: onEnd,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.7),
                Colors.blueAccent.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
