import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

/// La comparsa elastica di un pannello.
///
/// Condivisa da due punti distanti — il selettore di ruolo e il foglio
/// delle note — quindi non appartiene a nessuno dei due.
class SpringReveal extends StatefulWidget {
  final bool visible;
  final Widget child;

  const SpringReveal({super.key, required this.visible, required this.child});

  @override
  State<SpringReveal> createState() => SpringRevealState();
}

class SpringRevealState extends State<SpringReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: widget.visible ? 1 : 0,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.08, .72, curve: Curves.easeOut),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -.025),
      end: Offset.zero,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant SpringReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      _animateTo(widget.visible ? 1 : 0);
    }
  }

  void _animateTo(double target) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = target;
      return;
    }
    final velocity = _controller.velocity;
    _controller.animateWith(
      SpringSimulation(disclosureSpring, _controller.value, target, velocity),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizeTransition(
        sizeFactor: _controller,
        axisAlignment: -1,
        child: IgnorePointer(
          ignoring: !widget.visible,
          child: FadeTransition(
            opacity: _opacity,
            child: SlideTransition(position: _offset, child: widget.child),
          ),
        ),
      ),
    );
  }
}
