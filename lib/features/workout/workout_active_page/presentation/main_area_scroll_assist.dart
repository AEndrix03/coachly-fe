import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract final class MainAreaScrollPolicy {
  static const approachingViewportFraction = .5;
  static const overshootViewportFraction = .18;

  static bool shouldAssist({
    required double currentOffset,
    required double targetOffset,
    required double viewportExtent,
    required double settleTolerance,
  }) {
    final delta = targetOffset - currentOffset;
    if (delta.abs() <= settleTolerance) return false;
    final proximity = delta.isNegative
        ? viewportExtent * overshootViewportFraction
        : viewportExtent * approachingViewportFraction;
    return delta.abs() <= proximity;
  }
}

class MainAreaScrollAssist extends StatefulWidget {
  final String mainIdentity;
  final Widget leading;
  final Widget? beforeMain;
  final Widget main;

  const MainAreaScrollAssist({
    super.key,
    required this.mainIdentity,
    required this.leading,
    required this.main,
    this.beforeMain,
  });

  @override
  State<MainAreaScrollAssist> createState() => _MainAreaScrollAssistState();
}

class _MainAreaScrollAssistState extends State<MainAreaScrollAssist> {
  final _controller = ScrollController();
  final _mainKey = GlobalKey();
  bool _settling = false;

  @override
  void initState() {
    super.initState();
    _scheduleInitialAlignment();
  }

  @override
  void didUpdateWidget(covariant MainAreaScrollAssist oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mainIdentity != widget.mainIdentity) {
      _scheduleInitialAlignment();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scheduleInitialAlignment() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final target = _targetOffset();
      if (target == null) return;
      final duration = context.motion.resolve(context, context.motion.quick);
      if (duration == Duration.zero) {
        _controller.jumpTo(target);
        return;
      }
      await _controller.animateTo(
        target,
        duration: duration,
        curve: context.motion.enter,
      );
    });
  }

  double? _targetOffset() {
    final renderObject = _mainKey.currentContext?.findRenderObject();
    if (renderObject == null || !_controller.hasClients) return null;
    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) return null;
    final rawTarget = viewport.getOffsetToReveal(renderObject, 0).offset;
    final breathingRoom = context.spacing.sm;
    return (rawTarget - breathingRoom).clamp(
      _controller.position.minScrollExtent,
      _controller.position.maxScrollExtent,
    );
  }

  Future<void> _assistIfNear() async {
    if (_settling || !_controller.hasClients) return;
    final target = _targetOffset();
    if (target == null) return;
    final position = _controller.position;
    if (!MainAreaScrollPolicy.shouldAssist(
      currentOffset: position.pixels,
      targetOffset: target,
      viewportExtent: position.viewportDimension,
      settleTolerance: context.spacing.xs,
    )) {
      return;
    }

    final duration = context.motion.resolve(context, context.motion.slow);
    if (duration == Duration.zero) {
      _controller.jumpTo(target);
      return;
    }

    _settling = true;
    try {
      await _controller.animateTo(
        target,
        duration: duration,
        curve: context.motion.standardCurve,
      );
    } finally {
      _settling = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.depth == 0) _assistIfNear();
        return false;
      },
      child: CustomScrollView(
        key: const PageStorageKey('active-workout-content'),
        controller: _controller,
        slivers: [
          SliverToBoxAdapter(child: widget.leading),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              context.spacing.pageHorizontal,
              context.spacing.xl,
              context.spacing.pageHorizontal,
              context.spacing.xxl,
            ),
            sliver: SliverMainAxisGroup(
              slivers: [
                if (widget.beforeMain case final beforeMain?)
                  SliverToBoxAdapter(child: beforeMain),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _mainKey, child: widget.main),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
