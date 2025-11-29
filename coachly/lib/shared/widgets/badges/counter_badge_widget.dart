import 'package:flutter/material.dart';

/// Questo file è stato deprecato. Usare ShadBadge al posto di CounterBadgeWidget.
class CounterBadgeWidget extends StatelessWidget {
  final String label;
  final int count;
  final Color? color;
  final Color? badgeColor;
  final TextStyle? labelStyle;
  final TextStyle? countStyle;

  const CounterBadgeWidget({
    Key? key,
    required this.label,
    required this.count,
    this.color,
    this.badgeColor,
    this.labelStyle,
    this.countStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color ?? scheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style:
              labelStyle ??
              TextStyle(
                fontSize: 13,
                color: scheme.onPrimary.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
        ),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor ?? scheme.primaryContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '$count',
            style:
                countStyle ??
                TextStyle(
                  fontSize: 10,
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
