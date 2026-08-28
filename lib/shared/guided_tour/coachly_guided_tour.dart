import 'dart:math' as math;

import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';

class CoachlyTourTargetRegistry {
  final Map<Object, GlobalKey> _keys = {};

  GlobalKey keyFor(Object id) => _keys.putIfAbsent(id, GlobalKey.new);

  Future<bool> ensureVisible(Object id, {double alignment = .42}) async {
    final context = _keys[id]?.currentContext;
    if (context == null) return false;
    final renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return false;
    await Scrollable.ensureVisible(
      context,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 340),
      curve: CoachlyAthleteTheme.standardCurve,
      alignment: alignment,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );
    await WidgetsBinding.instance.endOfFrame;
    return true;
  }

  Rect? rectFor(Object id, BuildContext overlayContext) {
    final targetContext = _keys[id]?.currentContext;
    final target = targetContext?.findRenderObject() as RenderBox?;
    final overlay = overlayContext.findRenderObject() as RenderBox?;
    if (target == null ||
        overlay == null ||
        !target.hasSize ||
        !overlay.hasSize) {
      return null;
    }
    final global = target.localToGlobal(Offset.zero);
    final local = overlay.globalToLocal(global);
    return local & target.size;
  }
}

class CoachlyTourTarget extends StatelessWidget {
  final Object id;
  final CoachlyTourTargetRegistry registry;
  final Widget child;

  const CoachlyTourTarget({
    super.key,
    required this.id,
    required this.registry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: registry.keyFor(id), child: child);
}

class CoachlyTourStepDefinition {
  final String id;
  final String title;
  final String body;
  final String? secondary;
  final List<Object> targets;

  const CoachlyTourStepDefinition({
    required this.id,
    required this.title,
    required this.body,
    this.secondary,
    this.targets = const [],
  });
}

class CoachlyTourOverlay extends StatefulWidget {
  final CoachlyTourStepDefinition step;
  final int stepIndex;
  final int stepCount;
  final CoachlyTourTargetRegistry registry;
  final bool dontShowAgain;
  final VoidCallback onClose;
  final VoidCallback onNext;
  final ValueChanged<bool> onDontShowAgainChanged;
  final String stepLabel;
  final String nextLabel;
  final String doneLabel;
  final String dontShowAgainLabel;
  final String closeLabel;

  const CoachlyTourOverlay({
    super.key,
    required this.step,
    required this.stepIndex,
    required this.stepCount,
    required this.registry,
    required this.dontShowAgain,
    required this.onClose,
    required this.onNext,
    required this.onDontShowAgainChanged,
    required this.stepLabel,
    required this.nextLabel,
    required this.doneLabel,
    required this.dontShowAgainLabel,
    required this.closeLabel,
  });

  @override
  State<CoachlyTourOverlay> createState() => _CoachlyTourOverlayState();
}

class _CoachlyTourOverlayState extends State<CoachlyTourOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController borderController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );
  List<Rect> rects = const [];
  int _resolutionId = 0;

  @override
  void initState() {
    super.initState();
    _resolveTargets();
  }

  @override
  void didUpdateWidget(covariant CoachlyTourOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step.id != widget.step.id) _resolveTargets();
  }

  Future<void> _resolveTargets() async {
    final resolutionId = ++_resolutionId;
    borderController.stop();
    if (mounted && rects.isNotEmpty) setState(() => rects = const []);

    // A tour can be rebuilt during a hot reload or an AnimatedSize pass.
    // Never start a scroll while a reorderable sliver is still attaching.
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || resolutionId != _resolutionId) return;

    if (widget.step.targets.isNotEmpty) {
      // The last target is the actionable anchor for multi-target steps.
      // Centering it leaves room for the message card and avoids merely
      // keeping a partially obscured element at the viewport edge.
      await widget.registry.ensureVisible(widget.step.targets.last);
    }
    if (!mounted || resolutionId != _resolutionId) return;
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || resolutionId != _resolutionId) return;
    final viewport = Offset.zero & MediaQuery.sizeOf(context);
    setState(() {
      rects = widget.step.targets
          .map((target) => widget.registry.rectFor(target, context))
          .whereType<Rect>()
          .where((rect) => rect.overlaps(viewport))
          .map((rect) => rect.inflate(5))
          .toList();
    });
    if (!MediaQuery.disableAnimationsOf(context)) borderController.repeat();
  }

  @override
  void dispose() {
    _resolutionId++;
    borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final safe = MediaQuery.paddingOf(context);
    final targetCenter = rects.isEmpty
        ? size.height / 2
        : rects.map((rect) => rect.center.dy).reduce((a, b) => a + b) /
              rects.length;
    final cardAbove = targetCenter > size.height * .52;
    return Positioned.fill(
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        label: '${widget.stepLabel}. ${widget.step.title}. ${widget.step.body}',
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: CoachlyTourHighlightPainter(
                    rects: rects,
                    animation: borderController,
                    reduceMotion: MediaQuery.disableAnimationsOf(context),
                    accent: context.exerciseTheme.primary,
                    scrim: context.colors.surface,
                    highlight: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
            Positioned.fill(child: ModalBarrier(color: Colors.transparent)),
            Positioned(
              left: 18,
              right: 18,
              top: cardAbove ? safe.top + 18 : null,
              bottom: cardAbove ? null : safe.bottom + 18,
              child: CoachlyTourMessageCard(
                title: widget.step.title,
                body: widget.step.body,
                secondary: widget.step.secondary,
                progress: widget.stepLabel,
                dontShowAgain: widget.dontShowAgain,
                onDontShowAgainChanged: widget.onDontShowAgainChanged,
                onClose: widget.onClose,
                onNext: widget.onNext,
                nextLabel: widget.stepIndex == widget.stepCount - 1
                    ? widget.doneLabel
                    : widget.nextLabel,
                dontShowAgainLabel: widget.dontShowAgainLabel,
                closeLabel: widget.closeLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoachlyTourMessageCard extends StatelessWidget {
  final String title;
  final String body;
  final String? secondary;
  final String progress;
  final bool dontShowAgain;
  final ValueChanged<bool> onDontShowAgainChanged;
  final VoidCallback onClose;
  final VoidCallback onNext;
  final String nextLabel;
  final String dontShowAgainLabel;
  final String closeLabel;

  const CoachlyTourMessageCard({
    super.key,
    required this.title,
    required this.body,
    required this.secondary,
    required this.progress,
    required this.dontShowAgain,
    required this.onDontShowAgainChanged,
    required this.onClose,
    required this.onNext,
    required this.nextLabel,
    required this.dontShowAgainLabel,
    required this.closeLabel,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 330),
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
      decoration: BoxDecoration(
        color: context.exerciseTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        border: Border.all(color: context.exerciseTheme.border),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: context.exerciseTheme.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  progress,
                  style: TextStyle(
                    color: context.exerciseTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  tooltip: closeLabel,
                  icon: const Icon(Icons.close_rounded, size: 19),
                ),
              ],
            ),
            Text(
              body,
              style: TextStyle(
                color: context.exerciseTheme.textPrimary,
                height: 1.42,
              ),
            ),
            if (secondary != null) ...[
              const SizedBox(height: 8),
              Text(
                secondary!,
                style: TextStyle(
                  color: context.exerciseTheme.textSecondary,
                  height: 1.38,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onDontShowAgainChanged(!dontShowAgain),
                    borderRadius: BorderRadius.circular(10),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Row(
                        children: [
                          Icon(
                            dontShowAgain
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                            size: 20,
                            color: dontShowAgain
                                ? context.exerciseTheme.primary
                                : context.exerciseTheme.textSecondary,
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              dontShowAgainLabel,
                              style: TextStyle(
                                color: context.exerciseTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.exerciseTheme.primary,
                    foregroundColor: context.exerciseTheme.background,
                  ),
                  onPressed: onNext,
                  child: Text(nextLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class CoachlyTourHighlightPainter extends CustomPainter {
  final List<Rect> rects;
  final Animation<double> animation;
  final bool reduceMotion;
  final Color accent;

  /// Fondale dello scrim e punta di luce del bordo: passati dal chiamante
  /// perché un painter non ha accesso al `BuildContext`.
  final Color scrim;
  final Color highlight;

  CoachlyTourHighlightPainter({
    required this.rects,
    required this.animation,
    required this.reduceMotion,
    required this.accent,
    required this.scrim,
    required this.highlight,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..fillType = PathFillType.evenOdd;
    path.addRect(Offset.zero & size);
    for (final rect in rects) {
      path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)));
    }
    canvas.drawPath(path, Paint()..color = scrim.withValues(alpha: .55));
    for (final rect in rects) {
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));
      final border = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..shader = reduceMotion
            ? null
            : SweepGradient(
                transform: GradientRotation(animation.value * math.pi * 2),
                colors: [
                  Colors.transparent,
                  accent,
                  Color.lerp(accent, highlight, .45)!,
                  Colors.transparent,
                ],
              ).createShader(rect);
      if (reduceMotion) border.color = accent;
      canvas.drawRRect(rrect, border);
    }
  }

  @override
  bool shouldRepaint(covariant CoachlyTourHighlightPainter oldDelegate) =>
      oldDelegate.rects != rects ||
      oldDelegate.reduceMotion != reduceMotion ||
      oldDelegate.accent != accent;
}
