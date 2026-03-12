import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddFabButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Gradient? gradient;
  final double size;
  final Color? iconColor;
  final double borderRadius;

  const AddFabButton({
    Key? key,
    this.onPressed,
    this.icon = Icons.add,
    this.gradient,
    this.size = 56,
    this.iconColor,
    this.borderRadius = 14,
  }) : super(key: key);

  @override
  State<AddFabButton> createState() => _AddFabButtonState();
}

class _AddFabButtonState extends State<AddFabButton> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Gradient effectiveGradient =
        widget.gradient ??
        LinearGradient(
          colors: [scheme.primary, scheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    final double scale = _pressed ? 0.92 : 1.0;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      elevation: 6,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: effectiveGradient,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withAlpha(102),
                  blurRadius: 14,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? Colors.white,
                size: widget.size * 0.46,
              ),
            ),
          ).animate().scale(duration: 180.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}
