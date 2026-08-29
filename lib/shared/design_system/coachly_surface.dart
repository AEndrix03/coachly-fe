import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:flutter/material.dart';

class CoachlySurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const CoachlySurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? context.exerciseTheme.surface,
        borderRadius:
            borderRadius ??
            BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        border: Border.all(color: context.exerciseTheme.border),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class CoachlyPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool? semanticExpanded;
  final bool excludeChildSemantics;
  final BorderRadius borderRadius;

  const CoachlyPressable({
    super.key,
    required this.child,
    required this.onTap,
    this.semanticLabel,
    this.semanticExpanded,
    this.excludeChildSemantics = true,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(CoachlyAthleteTheme.cardRadius),
    ),
  });

  @override
  State<CoachlyPressable> createState() => _CoachlyPressableState();
}

class _CoachlyPressableState extends State<CoachlyPressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      expanded: widget.semanticExpanded,
      excludeSemantics:
          widget.semanticLabel != null && widget.excludeChildSemantics,
      child: AnimatedScale(
        scale: !reduceMotion && _pressed ? 0.985 : 1,
        duration: Duration(milliseconds: _pressed ? 80 : 130),
        curve: CoachlyAthleteTheme.standardCurve,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: widget.borderRadius,
            onTap: widget.onTap,
            onHighlightChanged: widget.onTap == null
                ? null
                : (value) => setState(() => _pressed = value),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class CoachlySectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const CoachlySectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: context.scale.title.bold.copyWith(
              color: CoachlyAthleteTheme.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 44),
              foregroundColor: CoachlyAthleteTheme.primary,
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
