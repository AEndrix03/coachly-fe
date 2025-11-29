import 'package:flutter/material.dart';

class SectionBar extends StatelessWidget {
  final String title;
  final Gradient? gradient;
  final double barWidth;
  final double barHeight;
  final double barRadius;
  final TextStyle? textStyle;
  final IconData? icon;
  final VoidCallback? onIconTap;
  final EdgeInsetsGeometry? padding;

  const SectionBar({
    Key? key,
    required this.title,
    this.gradient,
    this.barWidth = 8,
    this.barHeight = 22,
    this.barRadius = 6,
    this.textStyle,
    this.icon,
    this.onIconTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: barWidth,
            height: barHeight,
            decoration: BoxDecoration(
              gradient:
                  gradient ??
                  LinearGradient(
                    colors: [scheme.primary, scheme.secondaryContainer],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
              borderRadius: BorderRadius.circular(barRadius),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style:
                textStyle ??
                TextStyle(
                  color: scheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onIconTap,
              child: Icon(icon, color: scheme.onSurface, size: 22),
            ),
          ],
        ],
      ),
    );
  }
}
