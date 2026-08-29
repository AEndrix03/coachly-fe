import 'dart:math' as math;
import 'dart:ui';

import 'package:coachly/design_system/components/product/muscle_anatomy_view.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/coachly_concept_guide_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/widgets/exercise_detail_widgets.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_detail_view_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show Drag;
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum ExerciseQuickNavItem { biomechanics, muscles, variants }

const _quickNavRailGutter = 54.0;
const _quickNavDeployStartViewportFactor = 0.82;

double _quickNavEntryProgress({
  required double offset,
  required double sourceTop,
  required double safeTop,
}) {
  final entryStart = sourceTop - safeTop - 62;
  return ((offset - entryStart) / 150).clamp(0.0, 1.0);
}

double _quickNavDeployProgress({
  required double offset,
  required List<Rect>? destinationDocumentRects,
  required double viewportHeight,
}) {
  final firstDestinationTop = destinationDocumentRects?.firstOrNull?.top;
  if (firstDestinationTop == null || viewportHeight <= 0) return 0;
  final destinationViewportTop = firstDestinationTop - offset;
  final morphStart = viewportHeight * _quickNavDeployStartViewportFactor;
  return ((morphStart - destinationViewportTop) / 150).clamp(0.0, 1.0);
}

extension on ExerciseQuickNavItem {
  /// Metodo e non getter: l'etichetta è localizzata e serve il context.
  String label(BuildContext context) => switch (this) {
    ExerciseQuickNavItem.biomechanics => context.tr(
      'exercise.biomechanics.title',
    ),
    ExerciseQuickNavItem.muscles => context.tr('exercise.muscles.title'),
    ExerciseQuickNavItem.variants => context.tr('exercise.variants.title'),
  };

  String get actionLabel => switch (this) {
    ExerciseQuickNavItem.biomechanics => 'Analizza la biomeccanica',
    ExerciseQuickNavItem.muscles => 'Esplora i muscoli',
    ExerciseQuickNavItem.variants => 'Esplora le varianti',
  };

  IconData get icon => switch (this) {
    ExerciseQuickNavItem.biomechanics => Icons.insights_rounded,
    ExerciseQuickNavItem.muscles => Icons.accessibility_new_rounded,
    ExerciseQuickNavItem.variants => Icons.alt_route_rounded,
  };

  String path(String exerciseId) =>
      '/exercises/$exerciseId/${name.toLowerCase()}';
}

class ExercisePage extends ConsumerWidget {
  final String id;
  final bool isVariantDetail;
  final bool showAddButton;

  const ExercisePage({
    super.key,
    required this.id,
    this.isVariantDetail = false,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(exerciseDetailViewProvider(id));
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: asyncData.when(
        skipLoadingOnReload: false,
        skipLoadingOnRefresh: false,
        loading: () => const ExerciseLoadingView(),
        error: (_, _) => ExerciseErrorView(
          onRetry: () => ref.invalidate(exerciseDetailViewProvider(id)),
        ),
        data: (data) => ExerciseOverviewContent(
          data: data,
          showAddButton: showAddButton,
          onAdd: () => Navigator.of(context).pop(
            ExerciseDetailModel(
              id: data.id,
              nameI18n: {'it': data.name, 'en': data.name},
              descriptionI18n: {'it': data.description, 'en': data.description},
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseOverviewContent extends StatefulWidget {
  final ExerciseDetailViewData data;
  final VoidCallback onAdd;
  final bool showAddButton;

  const ExerciseOverviewContent({
    super.key,
    required this.data,
    required this.onAdd,
    this.showAddButton = true,
  });

  @override
  State<ExerciseOverviewContent> createState() =>
      _ExerciseOverviewContentState();
}

class _ExerciseOverviewContentState extends State<ExerciseOverviewContent> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ValueNotifier<double> _railGutter = ValueNotifier(0);
  final ValueNotifier<int> _anchorRevision = ValueNotifier(0);
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _sourceKey = GlobalKey();
  final List<GlobalKey> _destinationKeys = List.generate(3, (_) => GlobalKey());

  double? _sourceDocumentTop;
  List<Rect>? _destinationDocumentRects;
  bool _favorite = false;
  bool _expandedExecution = false;
  bool _expandedMistakes = false;
  double _viewportHeight = 0;
  double _safeTop = 0;
  bool _reduceMotion = false;
  int _lastDeployMeasurementBucket = -1;
  bool _anchorRefreshScheduled = false;
  Drag? _overlayDrag;
  late final Listenable _quickNavChanges;

  @override
  void initState() {
    super.initState();
    _quickNavChanges = Listenable.merge([_scrollOffset, _anchorRevision]);
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAnchors());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final media = MediaQuery.of(context);
    _viewportHeight = media.size.height;
    _safeTop = media.padding.top;
    _reduceMotion = media.disableAnimations;
    _updateRailGutter();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _measureAnchors(force: true),
    );
  }

  @override
  void dispose() {
    _overlayDrag?.cancel();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _scrollOffset.dispose();
    _railGutter.dispose();
    _anchorRevision.dispose();
    super.dispose();
  }

  void _handleScroll() {
    _scrollOffset.value = _scrollController.offset;
    _updateRailGutter();
    _scheduleDestinationAnchorRefresh();
  }

  void _updateRailGutter() {
    if (!_scrollController.hasClients || _sourceDocumentTop == null) {
      _railGutter.value = 0;
      return;
    }
    var entryProgress = _quickNavEntryProgress(
      offset: _scrollController.offset,
      sourceTop: _sourceDocumentTop!,
      safeTop: _safeTop,
    );
    var deployProgress = _quickNavDeployProgress(
      offset: _scrollController.offset,
      destinationDocumentRects: _destinationDocumentRects,
      viewportHeight: _viewportHeight,
    );
    if (_reduceMotion) {
      entryProgress = entryProgress > 0.5 ? 1 : 0;
      deployProgress = deployProgress > 0.5 ? 1 : 0;
    }
    final gutterRelease = deployProgress >= 0.78
        ? 1.0
        : Curves.easeOutCubic.transform(deployProgress);
    _railGutter.value =
        _quickNavRailGutter * entryProgress * (1 - gutterRelease);
  }

  void _scheduleDestinationAnchorRefresh() {
    final deployProgress = _quickNavDeployProgress(
      offset: _scrollController.offset,
      destinationDocumentRects: _destinationDocumentRects,
      viewportHeight: _viewportHeight,
    );
    if (deployProgress <= 0) {
      _lastDeployMeasurementBucket = -1;
      return;
    }
    final bucket = (deployProgress * 4).floor().clamp(0, 4);
    if (bucket == _lastDeployMeasurementBucket || _anchorRefreshScheduled) {
      return;
    }
    _lastDeployMeasurementBucket = bucket;
    _anchorRefreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _anchorRefreshScheduled = false;
      _measureAnchors(force: true);
    });
  }

  void _measureAnchors({bool force = false}) {
    if (!mounted || !_scrollController.hasClients) return;
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final sourceBox =
        _sourceKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || !stackBox.hasSize) return;
    final stackOrigin = stackBox.localToGlobal(Offset.zero);
    if (sourceBox != null &&
        sourceBox.hasSize &&
        (_sourceDocumentTop == null || force)) {
      _sourceDocumentTop =
          sourceBox.localToGlobal(Offset.zero).dy -
          stackOrigin.dy +
          _scrollController.offset;
    }

    final boxes = _destinationKeys
        .map((key) => key.currentContext?.findRenderObject())
        .whereType<RenderBox>()
        .toList();
    if (boxes.length == _destinationKeys.length) {
      _destinationDocumentRects = boxes.map((box) {
        final origin = box.localToGlobal(Offset.zero) - stackOrigin;
        return Rect.fromLTWH(
          origin.dx,
          origin.dy + _scrollController.offset,
          box.size.width,
          box.size.height,
        );
      }).toList();
    }
    _updateRailGutter();
    _anchorRevision.value++;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: widget.showAddButton
          ? ExerciseAddAction(onTap: widget.onAdd)
          : null,
      body: Stack(
        key: _stackKey,
        children: [
          CustomScrollView(
            key: const Key('exercise-overview-scroll'),
            controller: _scrollController,
            slivers: [
              _ExerciseHeader(
                title: widget.data.name,
                scrollOffset: _scrollOffset,
                favorite: _favorite,
                onFavorite: () => setState(() => _favorite = !_favorite),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverList.list(
                  children: [
                    _Entrance(child: _Identity(data: widget.data)),
                    const SizedBox(height: 22),
                    _Entrance(
                      delay: const Duration(milliseconds: 25),
                      child: ExerciseMediaHero(media: widget.data.media),
                    ),
                    const SizedBox(height: 18),
                    _Entrance(
                      delay: const Duration(milliseconds: 45),
                      child: _QuickNavSourceVisibility(
                        changes: _quickNavChanges,
                        scrollOffset: _scrollOffset,
                        sourceDocumentTop: () => _sourceDocumentTop,
                        child: ExerciseQuickNavAnchor(
                          key: _sourceKey,
                          onTap: _openDetail,
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    _RailSafeSection(
                      gutter: _railGutter,
                      child: _Description(text: widget.data.description),
                    ),
                    const SizedBox(height: 34),
                    _RailSafeSection(
                      gutter: _railGutter,
                      paddingKey: const Key('quick-nav-dynamic-gutter'),
                      child: _ExecutionSection(
                        execution: widget.data.execution,
                        expandedExecution: _expandedExecution,
                        expandedMistakes: _expandedMistakes,
                        onToggleExecution: () => setState(
                          () => _expandedExecution = !_expandedExecution,
                        ),
                        onToggleMistakes: () => setState(
                          () => _expandedMistakes = !_expandedMistakes,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _RailSafeSection(
                      gutter: _railGutter,
                      child: _MusclesPreview(
                        data: widget.data,
                        onOpen: () => _openDetail(ExerciseQuickNavItem.muscles),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _RailSafeSection(
                      gutter: _railGutter,
                      child: _BiomechanicsPreview(
                        data: widget.data,
                        onOpen: () =>
                            _openDetail(ExerciseQuickNavItem.biomechanics),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _RailSafeSection(
                      gutter: _railGutter,
                      child: _EquipmentSection(
                        equipment: widget.data.equipment,
                      ),
                    ),
                    if (widget.data.safetyNote.isNotEmpty) ...[
                      const SizedBox(height: 36),
                      _RailSafeSection(
                        gutter: _railGutter,
                        paddingKey: const Key('quick-nav-bottom-gutter'),
                        child: _SafetySection(note: widget.data.safetyNote),
                      ),
                    ],
                    const SizedBox(height: 40),
                    Divider(color: colors.border),
                    const SizedBox(height: 24),
                    ExerciseQuickNavDestination(
                      keys: _destinationKeys,
                      onTap: _openDetail,
                      onLaidOut: () => _measureAnchors(force: true),
                    ),
                    const SizedBox(height: 128),
                  ],
                ),
              ),
            ],
          ),
          ExerciseQuickNavMorph(
            changes: _quickNavChanges,
            scrollOffset: _scrollOffset,
            sourceDocumentTop: () => _sourceDocumentTop,
            destinationDocumentRects: () => _destinationDocumentRects,
            onTap: _openDetail,
            onVerticalDragStart: _handleOverlayVerticalDragStart,
            onVerticalDragUpdate: _handleOverlayVerticalDragUpdate,
            onVerticalDragEnd: _handleOverlayVerticalDragEnd,
            onVerticalDragCancel: _handleOverlayVerticalDragCancel,
          ),
        ],
      ),
    );
  }

  void _openDetail(ExerciseQuickNavItem item) {
    HapticFeedback.lightImpact();
    context.push(item.path(widget.data.id));
  }

  void _handleOverlayVerticalDragStart(DragStartDetails details) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position is! ScrollPositionWithSingleContext) return;

    _overlayDrag?.cancel();
    _overlayDrag = position.drag(details, () => _overlayDrag = null);
  }

  void _handleOverlayVerticalDragUpdate(DragUpdateDetails details) {
    _overlayDrag?.update(details);
  }

  void _handleOverlayVerticalDragEnd(DragEndDetails details) {
    final drag = _overlayDrag;
    _overlayDrag = null;
    drag?.end(details);
  }

  void _handleOverlayVerticalDragCancel() {
    final drag = _overlayDrag;
    _overlayDrag = null;
    drag?.cancel();
  }
}

class _ExerciseHeader extends StatelessWidget {
  final String title;
  final ValueListenable<double> scrollOffset;
  final bool favorite;
  final VoidCallback onFavorite;

  const _ExerciseHeader({
    required this.title,
    required this.scrollOffset,
    required this.favorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: colors.background.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
      foregroundColor: colors.textPrimary,
      leading: IconButton(
        tooltip: context.tr('common.back'),
        onPressed: () => Navigator.of(context).maybePop(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: colors.textPrimary,
        ),
      ),
      title: ValueListenableBuilder<double>(
        valueListenable: scrollOffset,
        builder: (_, offset, _) {
          final opacity = ((offset - 72) / 52).clamp(0.0, 1.0);
          return Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color.lerp(
                Colors.transparent,
                colors.textPrimary,
                opacity,
              ),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
      centerTitle: true,
      actions: [
        IconButton(
          key: const Key('exercise-favorite'),
          tooltip: favorite ? 'Rimuovi dai preferiti' : 'Aggiungi ai preferiti',
          onPressed: onFavorite,
          icon: Icon(
            favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: favorite ? colors.primary : colors.textPrimary,
          ),
        ),
        PopupMenuButton<String>(
          tooltip: context.tr('common.more_actions'),
          color: colors.surfaceElevated,
          icon: const Icon(Icons.more_horiz_rounded),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'share',
              child: Text(context.tr('common.share')),
            ),
          ],
        ),
      ],
    );
  }
}

class _Identity extends StatelessWidget {
  final ExerciseDetailViewData data;

  const _Identity({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.name,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          '${data.movementProfile.pattern}  ·  ${data.movementProfile.jointClass}  ·  ${data.movementProfile.resistanceSource}',
          style: TextStyle(color: colors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

class ExerciseQuickNavAnchor extends StatelessWidget {
  final ValueChanged<ExerciseQuickNavItem> onTap;

  const ExerciseQuickNavAnchor({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final item in ExerciseQuickNavItem.values)
          Semantics(
            button: true,
            label: 'Apri ${item.label(context)}',
            child: InkResponse(
              key: Key('quick-nav-${item.name}'),
              radius: 34,
              onTap: () => onTap(item),
              child: SizedBox(
                width: 82,
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border),
                      ),
                      child: Icon(item.icon, color: colors.primary, size: 21),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.label(context),
                      maxLines: 1,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickNavSourceVisibility extends StatelessWidget {
  final Listenable changes;
  final ValueListenable<double> scrollOffset;
  final double? Function() sourceDocumentTop;
  final Widget child;

  const _QuickNavSourceVisibility({
    required this.changes,
    required this.scrollOffset,
    required this.sourceDocumentTop,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: changes,
      child: child,
      builder: (context, child) {
        final offset = scrollOffset.value;
        final sourceTop = sourceDocumentTop();
        final isMoving =
            sourceTop != null &&
            _quickNavEntryProgress(
                  offset: offset,
                  sourceTop: sourceTop,
                  safeTop: MediaQuery.paddingOf(context).top,
                ) >
                0;
        return IgnorePointer(
          ignoring: isMoving,
          child: Opacity(
            key: const Key('quick-nav-static-source-opacity'),
            opacity: isMoving ? 0 : 1,
            child: child,
          ),
        );
      },
    );
  }
}

class ExerciseQuickNavDestination extends StatefulWidget {
  final List<GlobalKey> keys;
  final ValueChanged<ExerciseQuickNavItem> onTap;
  final VoidCallback onLaidOut;

  const ExerciseQuickNavDestination({
    super.key,
    required this.keys,
    required this.onTap,
    required this.onLaidOut,
  });

  @override
  State<ExerciseQuickNavDestination> createState() =>
      _ExerciseQuickNavDestinationState();
}

class _ExerciseQuickNavDestinationState
    extends State<ExerciseQuickNavDestination> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onLaidOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Opacity(
          key: const Key('quick-nav-static-destination-opacity'),
          opacity: 0,
          child: Column(
            children: [
              for (
                var index = 0;
                index < ExerciseQuickNavItem.values.length;
                index++
              ) ...[
                if (index > 0) const SizedBox(height: 10),
                SizedBox(
                  key: widget.keys[index],
                  width: double.infinity,
                  height: 58,
                  child: OutlinedButton(
                    key: Key(
                      'quick-nav-destination-${ExerciseQuickNavItem.values[index].name}',
                    ),
                    onPressed: () =>
                        widget.onTap(ExerciseQuickNavItem.values[index]),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.border),
                      backgroundColor: colors.surfaceElevated,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          ExerciseQuickNavItem.values[index].icon,
                          color: colors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ExerciseQuickNavItem.values[index].actionLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colors.textSecondary,
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseQuickNavMorph extends StatelessWidget {
  final Listenable changes;
  final ValueListenable<double> scrollOffset;
  final double? Function() sourceDocumentTop;
  final List<Rect>? Function() destinationDocumentRects;
  final ValueChanged<ExerciseQuickNavItem> onTap;
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final GestureDragCancelCallback onVerticalDragCancel;

  const ExerciseQuickNavMorph({
    super.key,
    required this.changes,
    required this.scrollOffset,
    required this.sourceDocumentTop,
    required this.destinationDocumentRects,
    required this.onTap,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    required this.onVerticalDragCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Positioned.fill(
      child: ListenableBuilder(
        listenable: changes,
        builder: (context, _) {
          final offset = scrollOffset.value;
          final sourceTop = sourceDocumentTop();
          if (sourceTop == null) {
            return const SizedBox.shrink();
          }
          final size = MediaQuery.sizeOf(context);
          final safeTop = MediaQuery.paddingOf(context).top;
          final entryProgress = _quickNavEntryProgress(
            offset: offset,
            sourceTop: sourceTop,
            safeTop: safeTop,
          );
          if (entryProgress <= 0) return const SizedBox.shrink();

          final destinations = destinationDocumentRects();
          final deployProgress = _quickNavDeployProgress(
            offset: offset,
            destinationDocumentRects: destinations,
            viewportHeight: size.height,
          );
          final reduceMotion = MediaQuery.disableAnimationsOf(context);
          final effectiveEntryProgress = reduceMotion
              ? (entryProgress > 0.5 ? 1.0 : 0.0)
              : entryProgress;
          final effectiveDeployProgress = reduceMotion
              ? (deployProgress > 0.5 ? 1.0 : 0.0)
              : deployProgress;

          final rowWidth = size.width - 40;
          const sourceItemWidth = 82.0;
          const sourceBubbleSize = 48.0;
          final freeSpace = math.max(
            0.0,
            rowWidth - sourceItemWidth * ExerciseQuickNavItem.values.length,
          );
          final itemSpace = freeSpace / ExerciseQuickNavItem.values.length;

          return RepaintBoundary(
            child: Stack(
              children: [
                for (
                  var index = 0;
                  index < ExerciseQuickNavItem.values.length;
                  index++
                )
                  _MorphButton(
                    item: ExerciseQuickNavItem.values[index],
                    entryProgress: effectiveEntryProgress,
                    deployProgress: effectiveDeployProgress,
                    naturalRect: Rect.fromLTWH(
                      20 +
                          itemSpace / 2 +
                          index * (sourceItemWidth + itemSpace) +
                          (sourceItemWidth - sourceBubbleSize) / 2,
                      sourceTop - offset,
                      sourceBubbleSize,
                      sourceBubbleSize,
                    ),
                    railRect: Rect.fromLTWH(
                      size.width - 62,
                      safeTop + size.height * 0.34 + index * 58,
                      46,
                      46,
                    ),
                    destinationRect:
                        destinations?[index].translate(0, -offset) ??
                        Rect.fromLTWH(
                          20,
                          size.height - 264 + index * 68,
                          size.width - 40,
                          58,
                        ),
                    colors: colors,
                    onTap: () => onTap(ExerciseQuickNavItem.values[index]),
                    onVerticalDragStart: onVerticalDragStart,
                    onVerticalDragUpdate: onVerticalDragUpdate,
                    onVerticalDragEnd: onVerticalDragEnd,
                    onVerticalDragCancel: onVerticalDragCancel,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MorphButton extends StatelessWidget {
  final ExerciseQuickNavItem item;
  final double entryProgress;
  final double deployProgress;
  final Rect naturalRect;
  final Rect railRect;
  final Rect destinationRect;
  final CoachlyExerciseTheme colors;
  final VoidCallback onTap;
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final GestureDragCancelCallback onVerticalDragCancel;

  const _MorphButton({
    required this.item,
    required this.entryProgress,
    required this.deployProgress,
    required this.naturalRect,
    required this.railRect,
    required this.destinationRect,
    required this.colors,
    required this.onTap,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    required this.onVerticalDragCancel,
  });

  @override
  Widget build(BuildContext context) {
    final entryRect = Rect.lerp(naturalRect, railRect, entryProgress)!;
    final rect = Rect.lerp(entryRect, destinationRect, deployProgress)!;
    final labelOpacity = ((deployProgress - 0.34) / 0.66).clamp(0.0, 1.0);
    final radius = lerpDouble(23, 16, deployProgress)!;
    return Positioned.fromRect(
      rect: rect,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: onVerticalDragStart,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        onVerticalDragCancel: onVerticalDragCancel,
        child: Semantics(
          button: true,
          label: item.actionLabel,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: Key('floating-quick-nav-${item.name}'),
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: Color.lerp(
                      colors.border,
                      colors.primary.withValues(alpha: 0.18),
                      0.35,
                    )!,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.surface.withValues(alpha: 0.55),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: lerpDouble(
                        (rect.width - 20) / 2,
                        16,
                        Curves.easeInOutCubic.transform(deployProgress),
                      ),
                      top: (rect.height - 20) / 2,
                      child: Icon(item.icon, size: 20, color: colors.primary),
                    ),
                    if (deployProgress > 0.3) ...[
                      Positioned(
                        left: 48,
                        right: 44,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.actionLabel,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Color.lerp(
                                Colors.transparent,
                                colors.textPrimary,
                                labelOpacity,
                              ),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: (rect.height - 21) / 2,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color.lerp(
                            Colors.transparent,
                            colors.textSecondary,
                            labelOpacity,
                          ),
                          size: 21,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RailSafeSection extends StatelessWidget {
  final ValueListenable<double> gutter;
  final Key? paddingKey;
  final Widget child;

  const _RailSafeSection({
    required this.gutter,
    this.paddingKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: gutter,
      child: child,
      builder: (_, value, child) => Padding(
        key: paddingKey,
        padding: EdgeInsets.only(right: value),
        child: child,
      ),
    );
  }
}

class _Description extends StatefulWidget {
  final String text;

  const _Description({required this.text});

  @override
  State<_Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<_Description> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.text,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 16,
              height: 1.55,
              letterSpacing: -0.1,
            ),
          ),
        ),
        if (widget.text.length > 150)
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Mostra meno' : 'Mostra altro'),
          ),
      ],
    );
  }
}

class _ExecutionSection extends StatelessWidget {
  final ExerciseExecutionViewData execution;
  final bool expandedExecution;
  final bool expandedMistakes;
  final VoidCallback onToggleExecution;
  final VoidCallback onToggleMistakes;

  const _ExecutionSection({
    required this.execution,
    required this.expandedExecution,
    required this.expandedMistakes,
    required this.onToggleExecution,
    required this.onToggleMistakes,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final steps = expandedExecution
        ? execution.steps
        : execution.steps.take(3).toList();
    final mistakes = expandedMistakes
        ? execution.commonMistakes
        : execution.commonMistakes.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExerciseSectionTitle('Come eseguirlo'),
        const SizedBox(height: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              for (var index = 0; index < steps.length; index++)
                _ExecutionRow(index: index + 1, text: steps[index]),
            ],
          ),
        ),
        if (execution.steps.length > 3)
          ExerciseLinkButton(
            label: expandedExecution
                ? 'Riduci passaggi'
                : 'Vedi tutti i passaggi',
            onTap: onToggleExecution,
          ),
        if (execution.commonMistakes.isNotEmpty) ...[
          const SizedBox(height: 26),
          Text(
            context.tr('exercise.common_mistakes'),
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 11),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                for (final mistake in mistakes) _MistakeRow(text: mistake),
              ],
            ),
          ),
          if (execution.commonMistakes.length > 2)
            ExerciseLinkButton(
              label: expandedMistakes
                  ? 'Mostra meno'
                  : 'Mostra altri ${execution.commonMistakes.length - 2}',
              onTap: onToggleMistakes,
            ),
        ],
      ],
    );
  }
}

class _ExecutionRow extends StatelessWidget {
  final int index;
  final String text;

  const _ExecutionRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MistakeRow extends StatelessWidget {
  final String text;

  const _MistakeRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.close_rounded, size: 19, color: colors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: colors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _MusclesPreview extends StatelessWidget {
  final ExerciseDetailViewData data;
  final VoidCallback onOpen;

  const _MusclesPreview({required this.data, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final primary = data.muscles
        .where((muscle) => muscle.role == MuscleRole.primary)
        .toList();
    final secondary = data.muscles
        .where((muscle) => muscle.role == MuscleRole.secondary)
        .toList();
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExerciseSectionTitle('Muscoli coinvolti'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 96,
                height: 164,
                child: _OptionalMuscleHero(
                  tag: 'exercise-muscles-${data.id}',
                  child: MuscleAnatomyView(muscles: data.muscles),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MuscleGroup(
                      label: context.tr('exercise.muscles_primary'),
                      muscles: primary,
                    ),
                    const SizedBox(height: 16),
                    _MuscleGroup(
                      label: context.tr('exercise.muscles_secondary'),
                      muscles: secondary.take(3).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ExerciseLinkButton(
          label: context.tr('exercise.explore_muscles'),
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _MuscleGroup extends StatelessWidget {
  final String label;
  final List<MuscleViewData> muscles;

  const _MuscleGroup({required this.label, required this.muscles});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: colors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        for (final muscle in muscles)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              muscle.name,
              style: TextStyle(color: colors.textPrimary, fontSize: 14),
            ),
          ),
      ],
    );
  }
}

class _BiomechanicsPreview extends StatelessWidget {
  final ExerciseDetailViewData data;
  final VoidCallback onOpen;

  const _BiomechanicsPreview({required this.data, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final training = data.biomechanics.training;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseSectionTitle(
          context.tr('exercise.biomechanics.title'),
          onInfo: () => showCoachlyInfoSheet(
            context,
            title: 'Stabilità richiesta',
            description:
                'Indica quanto controllo esterno offre l’esercizio e quanta stabilizzazione devi produrre tu.',
            whyItMatters:
                'Un esercizio stabile può aiutare a concentrarsi sul target, senza essere automaticamente migliore.',
            guideTopic: CoachlyGuideTopic.stability,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Metric(
                value: data.movementProfile.pattern,
                label: context.tr('exercise.pattern'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Metric(
                value: training.stability,
                label: context.tr('exercise.stability'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Metric(
                value: training.spinalLoad,
                label: context.tr('exercise.spinal_load'),
              ),
            ),
          ],
        ),
        ExerciseLinkButton(
          label: context.tr('exercise.explore_biomechanics'),
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;

  const _Metric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 2,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: colors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _EquipmentSection extends StatelessWidget {
  final List<EquipmentViewData> equipment;

  const _EquipmentSection({required this.equipment});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExerciseSectionTitle('Attrezzatura'),
        const SizedBox(height: 10),
        for (final item in equipment)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(Icons.cable_rounded, color: colors.primary, size: 21),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(color: colors.textPrimary),
                  ),
                ),
                if (item.required)
                  Text(
                    context.tr('exercise.required'),
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SafetySection extends StatelessWidget {
  final String note;

  const _SafetySection({required this.note});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.warning.withValues(alpha: 0.17)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: colors.warning,
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('exercise.remember'),
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  note,
                  style: TextStyle(color: colors.textSecondary, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionalMuscleHero extends StatelessWidget {
  final String tag;
  final Widget child;

  const _OptionalMuscleHero({required this.tag, required this.child});

  @override
  Widget build(BuildContext context) {
    final material = Material(color: Colors.transparent, child: child);
    if (MediaQuery.disableAnimationsOf(context)) return material;
    return Hero(tag: tag, child: material);
  }
}

class _Entrance extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _Entrance({required this.child, this.delay = Duration.zero});

  @override
  State<_Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<_Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final totalMilliseconds = 250 + widget.delay.inMilliseconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMilliseconds),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        widget.delay.inMilliseconds / totalMilliseconds,
        1,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (_, child) => Opacity(
        opacity: _animation.value,
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - _animation.value)),
          child: child,
        ),
      ),
    );
  }
}
