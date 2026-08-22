import 'dart:math' as math;

import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/providers/workout_edit_draft_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/providers/workout_detail_view_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_content.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_app_bar.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_structural_edit.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_start_button.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutDetailPage extends ConsumerStatefulWidget {
  final WorkoutModel workout;
  final bool initiallyEditing;

  const WorkoutDetailPage({
    super.key,
    required this.workout,
    this.initiallyEditing = false,
  });

  @override
  ConsumerState<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends ConsumerState<WorkoutDetailPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  bool _editing = false;
  WorkoutModel? _latestWorkout;
  OverlayEntry? _saveConfirmationOverlay;
  late final AnimationController _saveConfirmationController =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1100),
      );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _editing = widget.initiallyEditing;
    if (_editing) {
      ref
          .read(workoutEditDraftProvider(widget.workout.id).notifier)
          .initialize(widget.workout);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _scrollOffset.dispose();
    _saveConfirmationOverlay?.remove();
    _saveConfirmationOverlay = null;
    _saveConfirmationController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    _scrollOffset.value = _scrollController.hasClients
        ? _scrollController.offset
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    final cachedWorkout = ref
        .watch(workoutListProvider)
        .maybeWhen(
          data: (workouts) => workouts
              .where((item) => item.id == widget.workout.id)
              .firstOrNull,
          orElse: () => null,
        );
    final resolved = _latestWorkout ?? cachedWorkout ?? widget.workout;
    final locale = ref.watch(languageProvider);
    final draft = ref.watch(workoutEditDraftProvider(resolved.id));
    final presented = _editing && draft.isInitialized
        ? resolved.copyWith(programmingBlocks: draft.blocks)
        : resolved;
    final unresolvedIds = WorkoutDetailAdapter.unresolvedExerciseIds(
      presented,
      locale,
    ).toList()..sort();
    final resolvedExerciseNames = <String, String>{};
    final resolvingExerciseIds = <String>{};
    for (final id in unresolvedIds) {
      final name = ref.watch(
        _exerciseNameProvider('${locale.languageCode}|$id'),
      );
      name.when(
        data: (value) {
          if (value != null && value.isNotEmpty) {
            resolvedExerciseNames[id] = value;
          }
        },
        loading: () => resolvingExerciseIds.add(id),
        error: (_, _) {},
      );
    }
    final viewData = ref.watch(
      workoutDetailViewDataProvider(
        WorkoutDetailViewRequest(
          workout: presented,
          locale: locale,
          resolvedExerciseNames: resolvedExerciseNames,
          resolvingExerciseIds: resolvingExerciseIds,
        ),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: CoachlyAthleteTheme.background,
        body: Stack(
          children: [
            RefreshIndicator(
              color: CoachlyAthleteTheme.primary,
              onRefresh: _editing
                  ? () async {}
                  : () async => ref.invalidate(workoutListProvider),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  WorkoutDetailAppBar(
                    title: _editing
                        ? context.tr('workout.detail.edit_session')
                        : viewData.title,
                    editing: _editing,
                    saving: draft.isSaving,
                    scrollOffset: _scrollOffset,
                    onBack: _handleBack,
                    onEdit: () => _openBuilderEdit(resolved),
                    onDone: _saveAndFinish,
                  ),
                  if (_editing) ...[
                    const SliverToBoxAdapter(child: SizedBox(height: 18)),
                    SliverToBoxAdapter(
                      child: WorkoutStructuralEdit(
                        workoutId: resolved.id,
                        viewData: viewData,
                        onAddExercise: () => _openExerciseCatalog(resolved),
                      ),
                    ),
                  ] else ...[
                    SliverToBoxAdapter(
                      child: WorkoutIdentity(workout: viewData),
                    ),
                    if (viewData.goal != null) ...[
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      SliverToBoxAdapter(
                        child: WorkoutGoalSection(goal: viewData.goal!),
                      ),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 22)),
                    SliverToBoxAdapter(
                      child: WorkoutStartButton(
                        enabled: viewData.exerciseCount > 0,
                        onPressed: () => context.go(
                          '/workouts/workout/${resolved.id}/active',
                          extra: resolved,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 30)),
                    SliverToBoxAdapter(
                      child: WorkoutStructure(
                        workout: viewData,
                        onOpenExercise: (exercise) => context.push(
                          '/workouts/workout/${resolved.id}/workout_exercise_page/${exercise.exerciseId}',
                        ),
                        onAddExercise: () => _openBuilderEdit(resolved),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 28)),
                    SliverToBoxAdapter(
                      child: WorkoutOverview(workout: viewData),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 28)),
                    SliverToBoxAdapter(
                      child: WorkoutConceptsSection(workout: viewData),
                    ),
                  ],
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 36 + MediaQuery.paddingOf(context).bottom,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openBuilderEdit(WorkoutModel workout) async {
    HapticFeedback.selectionClick();
    final updated = await context.push<WorkoutModel>(
      '/workouts/workout/${workout.id}/edit',
      extra: workout,
    );
    if (!mounted || updated == null) return;
    setState(() => _latestWorkout = updated);
    _showSaveConfirmation();
    ref.invalidate(workoutListProvider);
  }

  Future<void> _saveAndFinish() async {
    final result = await ref
        .read(workoutEditDraftProvider(widget.workout.id).notifier)
        .save();
    if (!mounted || result == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _editing = false);
    _showSaveConfirmation();
  }

  void _showSaveConfirmation() {
    _saveConfirmationOverlay?.remove();
    late final OverlayEntry overlay;
    overlay = OverlayEntry(
      builder: (overlayContext) {
        final safePadding = MediaQuery.viewPaddingOf(overlayContext);
        return Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                safePadding.top,
                0,
                safePadding.bottom,
              ),
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _WorkoutSavedBorderPainter(
                    animation: _saveConfirmationController,
                    color: CoachlyAthleteTheme.primary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    _saveConfirmationOverlay = overlay;
    Overlay.of(context, rootOverlay: true).insert(overlay);

    void removeOverlay() {
      if (_saveConfirmationOverlay != overlay) return;
      overlay.remove();
      _saveConfirmationOverlay = null;
    }

    if (MediaQuery.disableAnimationsOf(context)) {
      _saveConfirmationController.value = .5;
      Future<void>.delayed(const Duration(milliseconds: 420), () {
        if (mounted) _saveConfirmationController.value = 0;
        removeOverlay();
      });
      return;
    }
    _saveConfirmationController.forward(from: 0).whenComplete(removeOverlay);
  }

  Future<void> _handleBack() async {
    if (!_editing) {
      context.pop();
      return;
    }
    final state = ref.read(workoutEditDraftProvider(widget.workout.id));
    if (!state.isDirty) {
      setState(() => _editing = false);
      return;
    }
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CoachlyAthleteTheme.surfaceElevated,
        title: Text(context.tr('workout.detail.unsaved_title')),
        content: Text(context.tr('workout.detail.unsaved_body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'continue'),
            child: Text(context.tr('workout.detail.continue_editing')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: Text(
              context.tr('workout.detail.discard'),
              style: const TextStyle(color: CoachlyAthleteTheme.danger),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: Text(context.tr('workout.detail.save_exit')),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (action == 'discard') {
      ref.read(workoutEditDraftProvider(widget.workout.id).notifier).discard();
      setState(() => _editing = false);
    } else if (action == 'save') {
      await _saveAndFinish();
    }
  }

  void _openExerciseCatalog(WorkoutModel resolved) {
    context.push('/workouts/workout/${resolved.id}/add-exercise');
  }
}

class _WorkoutSavedBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  _WorkoutSavedBorderPainter({required this.animation, required this.color})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final intensity = math.sin(animation.value * math.pi).clamp(0.0, 1.0);
    if (intensity == 0) return;
    final rect = (Offset.zero & size).deflate(3);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(18));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withValues(alpha: .35 * intensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withValues(alpha: .9 * intensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
  }

  @override
  bool shouldRepaint(covariant _WorkoutSavedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

final _exerciseNameProvider = FutureProvider.autoDispose
    .family<String?, String>((ref, argument) async {
      final repository = ref.watch(exerciseInfoPageRepositoryProvider);
      final parts = argument.split('|');
      final locale = parts.first;
      final response = await repository.getExerciseDetail(parts.last);
      final translations = response.data?.nameI18n;
      return translations?[locale] ??
          translations?.values.firstWhere(
            (value) => value.trim().isNotEmpty,
            orElse: () => '',
          );
    });
