import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Come viene eseguita la serie: drop set, rest-pause, myo-reps, cluster.
class SetTechniqueActions extends StatelessWidget {
  final SetTechnique selected;
  final VoidCallback onAddDrop;
  final ValueChanged<SetTechnique> onSelected;

  const SetTechniqueActions({
    super.key,
    required this.selected,
    required this.onAddDrop,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        // `Flexible` sul bottone di sinistra: la riga sforava di 20px su uno
        // schermo da 390, e i due interruttori a destra sono bersagli da
        // toccare — restringere loro non e' un'opzione, cedere spazio
        // all'etichetta di sinistra si'.
        Flexible(
          child: TextButton.icon(
            onPressed: onAddDrop,
            style: TextButton.styleFrom(
              backgroundColor: scheme.surface.withValues(alpha: 0),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              context.activeTr('addDrop'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Spacer(),
        TechniqueToggle(
          label: context.l10n.workoutActiveCluster,
          color: scheme.tertiary,
          selected: selected == SetTechnique.cluster,
          onTap: () => onSelected(SetTechnique.cluster),
        ),
        const SizedBox(width: 6),
        TechniqueToggle(
          label: context.l10n.workoutActiveFailure,
          color: scheme.error,
          selected: selected == SetTechnique.failure,
          onTap: () => onSelected(SetTechnique.failure),
        ),
      ],
    );
  }
}

class TechniqueToggle extends StatefulWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const TechniqueToggle({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  State<TechniqueToggle> createState() => TechniqueToggleState();
}

class TechniqueToggleState extends State<TechniqueToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _trailController;
  late final Animation<double> _activationScale;

  @override
  void initState() {
    super.initState();
    _trailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );
    _activationScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: .96), weight: 16),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: .96,
          end: 1.055,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 34,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.055,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 50,
      ),
    ]).animate(_trailController);
  }

  @override
  void didUpdateWidget(covariant TechniqueToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.selected && widget.selected) {
      _trailController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _trailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
      child: RepaintBoundary(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ScaleTransition(
              scale: _activationScale,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onTap();
                },
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  constraints: const BoxConstraints(
                    minWidth: 62,
                    minHeight: 44,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: widget.selected
                        ? widget.color.withValues(alpha: .14)
                        : scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.selected
                          ? widget.color
                          : scheme.outlineVariant,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        scale: widget.selected ? 1.03 : 1,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        child: Text(
                          widget.label,
                          style: context.scale.captionTight.heavy.copyWith(
                            color: widget.selected
                                ? widget.color
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          width: widget.selected ? 18 : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _trailController,
                  builder: (context, _) => CustomPaint(
                    painter: TechniqueTrailPainter(
                      progress: _trailController.value,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TechniqueTrailPainter extends CustomPainter {
  final double progress;
  final Color color;

  // `CustomPainter` non e' un widget: nessuna `key`.
  const TechniqueTrailPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final rightUpper = Path()
      ..moveTo(size.width - 5, size.height * .42)
      ..quadraticBezierTo(
        size.width + 8,
        size.height * .2,
        size.width + 18,
        size.height * .13,
      );
    final rightLower = Path()
      ..moveTo(size.width - 4, size.height * .62)
      ..quadraticBezierTo(
        size.width + 9,
        size.height * .78,
        size.width + 16,
        size.height * .9,
      );
    final leftUpper = Path()
      ..moveTo(5, size.height * .39)
      ..quadraticBezierTo(-7, size.height * .22, -15, size.height * .18);
    final leftLower = Path()
      ..moveTo(4, size.height * .65)
      ..quadraticBezierTo(-8, size.height * .8, -14, size.height * .86);

    _paintTrail(canvas, rightUpper, progress, delay: 0, strength: 1);
    _paintTrail(canvas, leftLower, progress, delay: .04, strength: .82);
    _paintTrail(canvas, rightLower, progress, delay: .1, strength: .62);
    _paintTrail(canvas, leftUpper, progress, delay: .15, strength: .5);
  }

  void _paintTrail(
    Canvas canvas,
    Path path,
    double globalProgress, {
    required double delay,
    required double strength,
  }) {
    final local = ((globalProgress - delay) / (1 - delay)).clamp(0.0, 1.0);
    if (local <= 0 || local >= 1) return;
    final head = Curves.easeOutCubic.transform(local);
    final fade = local < .58 ? 1.0 : (1 - local) / .42;
    final metric = path.computeMetrics().first;
    final end = metric.length * head;
    final start = (end - metric.length * (.3 - local * .08)).clamp(
      0.0,
      metric.length,
    );
    final opacity = (.82 * fade * strength).clamp(0.0, 1.0);
    final trail = metric.extractPath(start, end);
    final softPaint = Paint()
      ..color = color.withValues(alpha: opacity * .18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final trailPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.45
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(trail, softPaint)
      ..drawPath(trail, trailPaint);
    final tangent = metric.getTangentForOffset(end);
    if (tangent != null) {
      canvas.drawCircle(
        tangent.position,
        1.35,
        Paint()..color = color.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant TechniqueTrailPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
