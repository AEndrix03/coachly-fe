import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    );
  }
}
