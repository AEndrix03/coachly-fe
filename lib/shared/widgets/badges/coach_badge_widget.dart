import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';

class CoachBadgeWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const CoachBadgeWidget({
    Key? key,
    this.label = 'Coach',
    this.fontSize = 9,
    this.iconSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.feedbackWarning.withValues(alpha: 0.3),
            context.colors.feedbackDanger.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: context.colors.feedbackWarning.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: context.colors.feedbackWarning,
            size: iconSize,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: context.colors.feedbackWarning,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
