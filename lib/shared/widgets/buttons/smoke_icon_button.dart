import 'package:flutter/material.dart';

class SmokeIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double marginRight;
  final Color iconColor;
  final double size;
  final Color backgroundColor;

  const SmokeIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.marginRight = 0,
    this.iconColor = Colors.white,
    this.size = 22,
    this.backgroundColor = const Color(0x26FFFFFF),
  });

  @override
  State<SmokeIconButton> createState() => _SmokeIconButtonState();
}

class _SmokeIconButtonState extends State<SmokeIconButton> {
  double _scale = 1.0;

  void _animate() async {
    setState(() => _scale = 0.85);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: widget.marginRight),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: IconButton(
          icon: Icon(widget.icon, color: widget.iconColor, size: widget.size),
          onPressed: _animate,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
