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

class _WorkoutDetailPageState extends ConsumerState<WorkoutDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  bool _editing = false;

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
    super.dispose();
  }

  void _handleScroll() {
    _scrollOffset.value = _scrollController.hasClients
        ? _scrollController.offset
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    final resolved = ref
        .watch(workoutListProvider)
        .maybeWhen(
          data: (workouts) =>
              workouts
                  .where((item) => item.id == widget.workout.id)
                  .firstOrNull ??
              widget.workout,
          orElse: () => widget.workout,
        );
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
        body: RefreshIndicator(
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
                onEdit: () => _enterEdit(resolved),
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
                SliverToBoxAdapter(child: WorkoutIdentity(workout: viewData)),
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
                    onEdit: () => _enterEdit(resolved),
                    onOpenExercise: (exercise) => context.push(
                      '/workouts/workout/${resolved.id}/workout_exercise_page/${exercise.exerciseId}',
                    ),
                    onAddExercise: () => _enterEdit(resolved),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
                SliverToBoxAdapter(child: WorkoutOverview(workout: viewData)),
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
      ),
    );
  }

  void _enterEdit(WorkoutModel workout) {
    ref.read(workoutEditDraftProvider(workout.id).notifier).initialize(workout);
    HapticFeedback.selectionClick();
    setState(() => _editing = true);
  }

  Future<void> _saveAndFinish() async {
    final result = await ref
        .read(workoutEditDraftProvider(widget.workout.id).notifier)
        .save();
    if (!mounted || result == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _editing = false);
    final state = ref.read(workoutEditDraftProvider(widget.workout.id));
    if (state.savedOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('workout.detail.saved_offline'))),
      );
    }
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
