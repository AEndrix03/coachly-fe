import 'dart:ui';

import 'package:flutter/material.dart';

class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color iconColor;
  final double marginRight;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 22,
    this.iconColor = Colors.white,
    this.marginRight = 0,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _animate() async {
    setState(() => _scale = 0.85);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: widget.marginRight),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: IconButton(
              icon: Icon(
                widget.icon,
                color: widget.iconColor,
                size: widget.size,
              ),
              onPressed: _animate,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
