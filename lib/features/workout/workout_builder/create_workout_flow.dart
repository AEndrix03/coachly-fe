import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'dart:async';

import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_builder/providers/workout_builder_providers.dart';
import 'package:coachly/features/workout/workout_builder/tour/builder_tour_controller.dart';
import 'package:coachly/features/workout/workout_builder/widgets/builder_assist_rail.dart';
import 'package:coachly/features/workout/workout_builder/widgets/workout_builder_widgets.dart';
import 'package:coachly/features/workout/workout_edit_page/widgets/exercise_picker_sheet.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/guided_tour/coachly_guided_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _CreateStage { identity, structure, review }

class CreateWorkoutFlow extends ConsumerStatefulWidget {
  const CreateWorkoutFlow({super.key});
  @override
  ConsumerState<CreateWorkoutFlow> createState() => _CreateWorkoutFlowState();
}

class _CreateWorkoutFlowState extends ConsumerState<CreateWorkoutFlow> {
  final _title = TextEditingController();
  final _focus = TextEditingController();
  final _titleFocus = FocusNode();
  final _noteFocus = FocusNode();
  _CreateStage stage = _CreateStage.identity;
  bool _showSessionNote = false;
  final _tourRegistry = CoachlyTourTargetRegistry();
  bool _autoTourAttempted = false;
  bool _showReplayHint = false;
  Timer? _replayHintTimer;

  @override
  void dispose() {
    _title.dispose();
    _focus.dispose();
    _titleFocus.dispose();
    _noteFocus.dispose();
    _replayHintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createWorkoutControllerProvider);
    final tourState = ref.watch(builderTourProvider);
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: PopScope(
        canPop:
            !tourState.isActive &&
            stage == _CreateStage.identity &&
            !state.isDirty,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            if (tourState.isActive) {
              ref.read(builderTourProvider.notifier).close();
            } else {
              _back();
            }
          }
        },
        child: Scaffold(
          backgroundColor: context.exerciseTheme.background,
          appBar: AppBar(
            backgroundColor: context.exerciseTheme.background,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: _back,
              icon: Icon(
                stage == _CreateStage.identity ? Icons.close : Icons.arrow_back,
              ),
            ),
            title: Text(
              context.tr(switch (stage) {
                _CreateStage.identity => 'workout.builder.create_title',
                _CreateStage.structure => 'workout.builder.structure_title',
                _CreateStage.review => 'workout.builder.review_title',
              }),
            ),
            actions: stage == _CreateStage.structure
                ? [
                    PopupMenuButton<String>(
                      tooltip: context.tr('workout.builder.workout_actions'),
                      icon: const Icon(Icons.more_horiz_rounded),
                      onSelected: (_) => _editWorkoutNotes(state.draft.focus),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'notes',
                          child: Row(
                            children: [
                              const Icon(Icons.notes_rounded),
                              const SizedBox(width: 12),
                              Text(context.tr('workout.builder.add_notes')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
                : null,
          ),
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : CoachlyAthleteTheme.pageDuration,
                  switchInCurve: CoachlyAthleteTheme.standardCurve,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(.035, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: switch (stage) {
                    _CreateStage.identity => _identity(state),
                    _CreateStage.structure => _structure(state),
                    _CreateStage.review => _review(state),
                  },
                ),
                if (tourState.isActive)
                  CoachlyTourOverlay(
                    step: _tourSteps[tourState.currentStepIndex],
                    stepIndex: tourState.currentStepIndex,
                    stepCount: _tourSteps.length,
                    registry: _tourRegistry,
                    dontShowAgain: tourState.dontShowAgain,
                    onClose: () =>
                        ref.read(builderTourProvider.notifier).close(),
                    onNext: _advanceTour,
                    onDontShowAgainChanged: (value) => ref
                        .read(builderTourProvider.notifier)
                        .setDontShowAgain(value),
                    stepLabel: context.tr(
                      'workout.builder.tour_step',
                      params: {
                        'current': '${tourState.currentStepIndex + 1}',
                        'total': '${_tourSteps.length}',
                      },
                    ),
                    nextLabel: context.tr('workout.builder.tour_next'),
                    doneLabel: context.tr('workout.builder.tour_done'),
                    dontShowAgainLabel: context.tr(
                      'workout.builder.tour_dont_show_again',
                    ),
                    closeLabel: context.tr('common.close'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _identity(WorkoutBuilderState state) => Column(
    key: const ValueKey('identity'),
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            Text(
              context.tr('workout.builder.identity_heading'),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: context.exerciseTheme.textPrimary,
                height: 1.08,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              context.tr('workout.builder.identity_subtitle'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.exerciseTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: CoachlyAthleteTheme.sectionGap),
            WorkoutBuilderUnderlineField(
              controller: _title,
              focusNode: _titleFocus,
              label: context.tr('workout.builder.title_label'),
              hint: context.tr('workout.builder.title_hint'),
              maxLength: 60,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onChanged: (value) => ref
                  .read(createWorkoutControllerProvider.notifier)
                  .updateMetadata(title: value),
            ),
            const SizedBox(height: CoachlyAthleteTheme.sectionGap),
            WorkoutGoalSelector(
              selectedGoal: state.draft.trainingGoal,
              onInfo: _showGoalInfo,
              onSelected: (goal) => ref
                  .read(createWorkoutControllerProvider.notifier)
                  .updateMetadata(goal: goal),
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : CoachlyAthleteTheme.expandDuration,
              switchInCurve: CoachlyAthleteTheme.standardCurve,
              transitionBuilder: (child, animation) => SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: _showSessionNote
                  ? WorkoutBuilderUnderlineField(
                      key: const ValueKey('session-note'),
                      controller: _focus,
                      focusNode: _noteFocus,
                      label: context.tr('workout.builder.session_note'),
                      hint: context.tr('workout.builder.focus_hint'),
                      helper: context.tr('workout.builder.optional'),
                      maxLength: 180,
                      minLines: 2,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) => ref
                          .read(createWorkoutControllerProvider.notifier)
                          .updateMetadata(
                            focus: value.trim().isEmpty ? null : value,
                          ),
                    )
                  : Align(
                      key: const ValueKey('add-session-note'),
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() => _showSessionNote = true);
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _noteFocus.requestFocus(),
                          );
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(
                            CoachlyAthleteTheme.touchTarget,
                            CoachlyAthleteTheme.touchTarget,
                          ),
                          foregroundColor: context.exerciseTheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(
                          context.tr('workout.builder.add_session_note'),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      _BottomAction(
        label: context.tr('workout.builder.continue_action'),
        enabled: state.draft.title.trim().isNotEmpty,
        trailingIcon: Icons.arrow_forward,
        onPressed: () {
          FocusScope.of(context).unfocus();
          setState(() => stage = _CreateStage.structure);
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _maybeStartTour(),
          );
        },
      ),
    ],
  );

  Widget _structure(WorkoutBuilderState state) => Column(
    key: const ValueKey('structure'),
    children: [
      Expanded(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
              children: [
                WorkoutBuilderSummary(draft: state.draft, compact: true),
                const SizedBox(height: 26),
                AnimatedSize(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : CoachlyAthleteTheme.expandDuration,
                  curve: CoachlyAthleteTheme.standardCurve,
                  alignment: Alignment.topCenter,
                  child: WorkoutDraftStructure(
                    draft: state.draft,
                    onEditExercise: (exercise) =>
                        _editExercise(exercise, false),
                    onEditBlock: _editBlock,
                    onUpdateExercise: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .updateExercise,
                    onUpdateBlock: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .updateGroup,
                    onOpenExercise: _openExerciseDetail,
                    onReorder: (section, oldIndex, newIndex) => ref
                        .read(createWorkoutControllerProvider.notifier)
                        .reorderInSection(section, oldIndex, newIndex),
                    onReorderSections: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .reorderSections,
                    onRemove: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .removeItem,
                    onRemoveExercise: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .removeExercise,
                    onDuplicate: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .duplicateItem,
                    onMove: _moveItem,
                    onAddExercise: _addExercise,
                    onAddSection: _addSection,
                    onCreateBlock: _createBlock,
                    onEditSection: _editSection,
                    onUpdateSection: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .updateSection,
                    onRemoveSection: ref
                        .read(createWorkoutControllerProvider.notifier)
                        .removeSection,
                    tourRegistry: _tourRegistry,
                  ),
                ),
                WorkoutStructureComposer(
                  onAddExercise: () => _addExercise(null),
                  onAddSection: _addSection,
                  onCreateBlock: _createBlock,
                  tourRegistry: _tourRegistry,
                ),
              ],
            ),
            if (_showReplayHint)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _dismissReplayHint,
                ),
              ),
            Positioned(
              right: 16,
              bottom: 16,
              child: BuilderAssistRail(
                tourRegistry: _tourRegistry,
                discoverLabel: context.tr('workout.builder.discover'),
                workoutCheckLabel: context.tr('workout.check.open'),
                workoutCheckHeroTag:
                    'workout-check-${state.draft.localDraftId}',
                showReplayHint: _showReplayHint,
                replayHintLabel: context.tr('workout.builder.tour_replay_hint'),
                onDiscover: () {
                  _dismissReplayHint();
                  ref
                      .read(builderTourProvider.notifier)
                      .start(BuilderTourOrigin.manual);
                },
                onWorkoutCheck: () => _openWorkoutCheck(state.draft),
              ),
            ),
          ],
        ),
      ),
      CoachlyTourTarget(
        id: BuilderTourTarget.reviewWorkout,
        registry: _tourRegistry,
        child: _BottomAction(
          label: context.tr('workout.builder.review_action'),
          enabled: state.draft.exerciseCount > 0,
          summary: context.tr(
            'workout.builder.review_summary',
            params: {
              'exercises': context.tr(
                state.draft.exerciseCount == 1
                    ? 'workout.detail.exercise_count_one'
                    : 'workout.detail.exercise_count_other',
                params: {'count': '${state.draft.exerciseCount}'},
              ),
              'minutes': '${state.draft.estimatedDurationMinutes}',
            },
          ),
          trailingIcon: Icons.arrow_forward,
          onPressed: () => setState(() => stage = _CreateStage.review),
        ),
      ),
    ],
  );

  Widget _review(WorkoutBuilderState state) => Column(
    key: const ValueKey('review'),
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          children: [
            WorkoutBuilderSummary(draft: state.draft),
            const SizedBox(height: 24),
            if (state.draft.focus?.isNotEmpty == true) ...[
              Text(
                context.tr('workout.focus'),
                style: TextStyle(
                  color: context.exerciseTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.draft.focus!,
                style: TextStyle(
                  color: context.exerciseTheme.textPrimary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 26),
            ],
            WorkoutDraftStructure(
              draft: state.draft,
              editable: false,
              onEditExercise: (_) {},
              onEditBlock: (_) {},
              onUpdateExercise: (_) {},
              onUpdateBlock: (_) {},
              onOpenExercise: _openExerciseDetail,
              onReorder: (_, _, _) {},
              onReorderSections: (_, _) {},
              onRemove: (_) {},
              onRemoveExercise: (_) {},
              onDuplicate: (_) {},
              onMove: (_) {},
              onAddExercise: (_) {},
              onAddSection: () {},
              onCreateBlock: () {},
              onUpdateSection: (_) {},
              onRemoveSection: (_) {},
            ),
          ],
        ),
      ),
      _BottomAction(
        label: context.tr('workout.builder.create_action'),
        loading: state.isSaving,
        enabled: state.validation.isValid,
        onPressed: _commit,
      ),
    ],
  );

  List<CoachlyTourStepDefinition> get _tourSteps => [
    CoachlyTourStepDefinition(
      id: 'intro',
      title: context.tr('workout.builder.tour_intro_title'),
      body: context.tr('workout.builder.tour_intro_body'),
    ),
    CoachlyTourStepDefinition(
      id: 'exercise',
      title: context.tr('workout.builder.tour_exercise_title'),
      body: context.tr('workout.builder.tour_exercise_body'),
      targets: const [BuilderTourTarget.addExercise],
    ),
    CoachlyTourStepDefinition(
      id: 'sections',
      title: context.tr('workout.builder.tour_sections_title'),
      body: context.tr('workout.builder.tour_sections_body'),
      targets: const [
        BuilderTourTarget.mainSectionHeader,
        BuilderTourTarget.sectionsAction,
      ],
    ),
    CoachlyTourStepDefinition(
      id: 'notes',
      title: context.tr('workout.builder.tour_notes_title'),
      body: context.tr('workout.builder.tour_notes_body'),
      secondary: context.tr('workout.builder.tour_notes_secondary'),
      targets: const [BuilderTourTarget.mainSectionMenu],
    ),
    CoachlyTourStepDefinition(
      id: 'blocks',
      title: context.tr('workout.builder.tour_blocks_title'),
      body: context.tr('workout.builder.tour_blocks_body'),
      secondary: context.tr('workout.builder.tour_blocks_secondary'),
      targets: const [BuilderTourTarget.blocksAction],
    ),
    CoachlyTourStepDefinition(
      id: 'check',
      title: context.tr('workout.builder.tour_check_title'),
      body: context.tr('workout.builder.tour_check_body'),
      secondary: context.tr('workout.builder.tour_check_secondary'),
      targets: const [BuilderTourTarget.workoutCheck],
    ),
    CoachlyTourStepDefinition(
      id: 'review',
      title: context.tr('workout.builder.tour_review_title'),
      body: context.tr('workout.builder.tour_review_body'),
      targets: const [BuilderTourTarget.reviewWorkout],
    ),
  ];

  void _maybeStartTour() {
    if (_autoTourAttempted || stage != _CreateStage.structure) return;
    _autoTourAttempted = true;
    final controller = ref.read(builderTourProvider.notifier);
    if (controller.shouldAutoShow) {
      controller.start(BuilderTourOrigin.automatic);
    }
  }

  void _advanceTour() {
    final tour = ref.read(builderTourProvider);
    final completed = tour.currentStepIndex == _tourSteps.length - 1;
    ref.read(builderTourProvider.notifier).next();
    if (completed) {
      unawaited(HapticFeedback.lightImpact());
      _showDiscoverReplayHint();
    }
  }

  void _showDiscoverReplayHint() {
    _replayHintTimer?.cancel();
    setState(() => _showReplayHint = true);
    _replayHintTimer = Timer(const Duration(seconds: 4), _dismissReplayHint);
  }

  void _dismissReplayHint() {
    _replayHintTimer?.cancel();
    if (mounted && _showReplayHint) setState(() => _showReplayHint = false);
  }

  Future<void> _openWorkoutCheck(WorkoutDraft draft) async {
    final addExercise = await context.push<bool>(
      '/workouts/workout/new/check',
      extra: draft,
    );
    if (addExercise == true && mounted) await _addExercise(null);
  }

  Future<WorkoutExerciseDraft?> _addExercise(String? sectionId) async {
    var destinationId = sectionId;
    if (destinationId == null) {
      final sections = ref.read(createWorkoutControllerProvider).draft.sections;
      if (sections.isNotEmpty) {
        destinationId = await showWorkoutSectionPicker(context, sections);
        if (destinationId == null || !mounted) return null;
      }
    }
    WorkoutExerciseDraft? picked;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExercisePickerSheet(
        onExerciseSelected: (selected) {
          picked = WorkoutExerciseDraft(
            localId: _localId(),
            exerciseId: selected.exerciseId,
            name: selected.name,
          );
        },
      ),
    );
    if (!mounted || picked == null) return null;
    final configured = await showPrescriptionEditor(
      context,
      picked!,
      adding: true,
    );
    if (configured == null || !mounted) return null;
    ref
        .read(createWorkoutControllerProvider.notifier)
        .addExercise(configured, sectionId: destinationId);
    unawaited(HapticFeedback.lightImpact());
    return configured;
  }

  Future<void> _editExercise(WorkoutExerciseDraft exercise, bool adding) async {
    final updated = await showPrescriptionEditor(
      context,
      exercise,
      adding: adding,
    );
    if (updated != null) {
      ref
          .read(createWorkoutControllerProvider.notifier)
          .updateExercise(updated);
    }
  }

  Future<void> _editBlock(WorkoutExerciseGroupDraft group) async {
    final updated = await showWorkoutBlockEditor(context, group);
    if (updated == null || !mounted) return;
    ref.read(createWorkoutControllerProvider.notifier).updateGroup(updated);
  }

  Future<void> _openExerciseDetail(WorkoutExerciseDraft exercise) async {
    await context.push('/exercises/${exercise.exerciseId}?mode=view');
  }

  Future<void> _moveItem(String itemId) async {
    final sections = ref.read(createWorkoutControllerProvider).draft.sections;
    if (sections.length < 2) return;
    final destination = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      backgroundColor: context.exerciseTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('workout.builder.move_to_section'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.exerciseTheme.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...sections.map(
              (section) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  section.name ?? context.tr('workout.builder.main_section'),
                ),
                onTap: () => Navigator.pop(context, section.id),
              ),
            ),
          ],
        ),
      ),
    );
    if (destination == null || !mounted) return;
    ref
        .read(createWorkoutControllerProvider.notifier)
        .moveItemToSection(itemId, destination);
  }

  Future<void> _addSection() async {
    final result = await showWorkoutSectionNameSheet(context);
    if (result?.name.isNotEmpty == true) {
      ref
          .read(createWorkoutControllerProvider.notifier)
          .addSection(result!.name, notes: result.notes);
    }
  }

  Future<void> _editWorkoutNotes(String? initialValue) async {
    final notes = await showWorkoutNotesSheet(
      context,
      initialValue: initialValue,
    );
    if (notes == null || !mounted) return;
    _focus.text = notes;
    ref
        .read(createWorkoutControllerProvider.notifier)
        .updateMetadata(focus: notes.isEmpty ? null : notes);
  }

  Future<void> _editSection(WorkoutSectionDraft section) async {
    final result = await showWorkoutSectionNameSheet(context, initial: section);
    if (result?.name.isNotEmpty != true || !mounted) return;
    ref
        .read(createWorkoutControllerProvider.notifier)
        .updateSection(
          section.copyWith(name: result!.name, notes: result.notes),
        );
  }

  Future<void> _createBlock() async {
    final draft = ref.read(createWorkoutControllerProvider).draft;
    await showWorkoutBlockCreationFlow(
      context,
      draft: draft,
      onAddExercise: (sectionId) async {
        final exercise = await _addExercise(sectionId);
        if (exercise == null) return null;
        final latest = ref.read(createWorkoutControllerProvider).draft;
        final section = latest.sections.firstWhere(
          (entry) => entry.items.any((item) => item.id == exercise.localId),
        );
        return (sectionId: section.id, exercise: exercise);
      },
      onCreate: (selection) => ref
          .read(createWorkoutControllerProvider.notifier)
          .createGroup(
            type: selection.type,
            itemIds: selection.itemIds,
            rounds: selection.rounds,
            restBetweenExercisesSeconds: selection.restBetweenExercisesSeconds,
            restAfterRoundSeconds: selection.restAfterRoundSeconds,
            notes: selection.notes,
          ),
    );
  }

  Future<void> _commit() async {
    final workout = await ref
        .read(createWorkoutControllerProvider.notifier)
        .commit();
    if (!mounted || workout == null) return;
    unawaited(HapticFeedback.mediumImpact());
    context.go('/workouts/workout/${workout.id}', extra: workout);
  }

  Future<void> _back() async {
    if (stage == _CreateStage.review) {
      setState(() => stage = _CreateStage.structure);
      return;
    }
    if (stage == _CreateStage.structure) {
      setState(() => stage = _CreateStage.identity);
      return;
    }
    final state = ref.read(createWorkoutControllerProvider);
    if (state.isDirty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: context.exerciseTheme.surfaceElevated,
          title: Text(context.tr('workout.detail.unsaved_title')),
          content: Text(context.tr('workout.detail.unsaved_body')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.tr('workout.detail.continue_editing')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                context.tr('workout.detail.discard'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      );
      if (discard != true || !mounted) return;
    }
    context.pop();
  }

  void _showGoalInfo() => CoachlyInfoSheet.show(
    context,
    title: context.tr('workout.builder.goal_label'),
    sections: [
      CoachlyInfoSection(
        context.tr('workout.builder.goal_info_title'),
        context.tr('workout.builder.goal_info_body'),
      ),
    ],
    primaryActionLabel: context.tr('common.got_it'),
  );
}

class _BlockCandidate {
  final String sectionId;
  final WorkoutExerciseItemDraft item;
  const _BlockCandidate({required this.sectionId, required this.item});
}

typedef WorkoutBlockExerciseInsertion = ({
  String sectionId,
  WorkoutExerciseDraft exercise,
});

typedef WorkoutBlockCreationSelection = ({
  WorkoutGroupType type,
  List<String> itemIds,
  int rounds,
  int restBetweenExercisesSeconds,
  int restAfterRoundSeconds,
  String? notes,
});

Future<void> showWorkoutBlockCreationFlow(
  BuildContext context, {
  required WorkoutDraft draft,
  required Future<WorkoutBlockExerciseInsertion?> Function(String? sectionId)
  onAddExercise,
  required ValueChanged<WorkoutBlockCreationSelection> onCreate,
}) async {
  final candidates = <_BlockCandidate>[];
  for (final section in draft.sections) {
    for (final item in section.items.whereType<WorkoutExerciseItemDraft>()) {
      candidates.add(_BlockCandidate(sectionId: section.id, item: item));
    }
  }
  if (candidates.isEmpty) {
    await onAddExercise(null);
    return;
  }
  if (!context.mounted) return;
  final selection = await showModalBottomSheet<_BlockSelection>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.exerciseTheme.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _CreateBlockSheet(
      candidates: candidates,
      onAddExercise: (sectionId) async {
        final inserted = await onAddExercise(sectionId);
        if (inserted == null) return null;
        return _BlockCandidate(
          sectionId: inserted.sectionId,
          item: WorkoutExerciseItemDraft(inserted.exercise),
        );
      },
    ),
  );
  if (selection == null || !context.mounted) return;
  onCreate((
    type: selection.type,
    itemIds: selection.itemIds,
    rounds: selection.rounds,
    restBetweenExercisesSeconds: selection.restBetweenExercisesSeconds,
    restAfterRoundSeconds: selection.restAfterRoundSeconds,
    notes: selection.notes,
  ));
  unawaited(HapticFeedback.lightImpact());
}

class _BlockSelection {
  final WorkoutGroupType type;
  final List<String> itemIds;
  final int rounds;
  final int restBetweenExercisesSeconds;
  final int restAfterRoundSeconds;
  final String? notes;
  const _BlockSelection({
    required this.type,
    required this.itemIds,
    required this.rounds,
    required this.restBetweenExercisesSeconds,
    required this.restAfterRoundSeconds,
    this.notes,
  });
}

class _CreateBlockSheet extends StatefulWidget {
  final List<_BlockCandidate> candidates;
  final Future<_BlockCandidate?> Function(String? sectionId) onAddExercise;
  const _CreateBlockSheet({
    required this.candidates,
    required this.onAddExercise,
  });

  @override
  State<_CreateBlockSheet> createState() => _CreateBlockSheetState();
}

class _CreateBlockSheetState extends State<_CreateBlockSheet> {
  WorkoutGroupType type = WorkoutGroupType.superset;
  final selected = <String>{};
  String? selectedSectionId;
  int step = 0;
  int rounds = 3;
  int restBetweenExercisesSeconds = 0;
  int restAfterRoundSeconds = 90;
  final notesController = TextEditingController();
  final notesFocus = FocusNode();
  bool showNotes = false;

  @override
  void dispose() {
    notesController.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  late final List<_BlockCandidate> candidates = [...widget.candidates];

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    initialChildSize: .78,
    minChildSize: .52,
    maxChildSize: .94,
    expand: false,
    builder: (context, scrollController) => Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: context.exerciseTheme.textSecondary.withValues(alpha: .45),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            children: [
              Text(
                context.tr('workout.builder.create_block_title'),
                style: context.scale.display.heavy.copyWith(
                  color: context.exerciseTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr('workout.builder.create_block_explanation'),
                style: TextStyle(color: context.exerciseTheme.textSecondary),
              ),
              const SizedBox(height: 18),
              _BlockStepper(currentStep: step),
              const SizedBox(height: 22),
              AnimatedSwitcher(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : CoachlyAthleteTheme.expandDuration,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(.04, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: switch (step) {
                  0 => _typeStep(),
                  1 => _exerciseStep(),
                  _ => _setupStep(),
                },
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: CoachlyAthleteTheme.touchTarget,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: context.exerciseTheme.primary,
                foregroundColor: context.exerciseTheme.background,
              ),
              onPressed: _primaryAction,
              child: Text(
                context.tr(
                  step == 1 && !_selectionComplete
                      ? 'workout.builder.add_another_exercise'
                      : step == 2
                      ? 'workout.builder.create_selected_block'
                      : 'workout.builder.continue_action',
                  params: {'type': _groupTypeLabel(context, type)},
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _typeStep() => Column(
    key: const ValueKey('block-type'),
    children: WorkoutGroupType.values
        .map(
          (value) => _BlockTypeTile(
            type: value,
            selected: type == value,
            onTap: () => setState(() {
              type = value;
              selected.clear();
              selectedSectionId = null;
              unawaited(HapticFeedback.selectionClick());
            }),
          ),
        )
        .toList(),
  );

  Widget _exerciseStep() => Column(
    key: const ValueKey('block-exercises'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              context.tr(
                'workout.builder.choose_exercises',
                params: {'count': '$_requiredCount'},
              ),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: context.exerciseTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '${selected.length} / $_requiredCount',
            style: const TextStyle(
              color: CoachlyAthleteTheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      ...candidates.map((candidate) {
        final unavailable =
            selectedSectionId != null &&
            selectedSectionId != candidate.sectionId;
        final checked = selected.contains(candidate.item.id);
        return Semantics(
          selected: checked,
          enabled: !unavailable,
          child: CheckboxListTile(
            value: checked,
            enabled: !unavailable,
            activeColor: context.exerciseTheme.primary,
            checkColor: context.exerciseTheme.background,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(candidate.item.exercise.name),
            onChanged: unavailable
                ? null
                : (value) => setState(() {
                    if (value == true && selected.length < _requiredCount) {
                      selectedSectionId = candidate.sectionId;
                      selected.add(candidate.item.id);
                    } else if (value == false) {
                      selected.remove(candidate.item.id);
                      if (selected.isEmpty) selectedSectionId = null;
                    }
                    unawaited(HapticFeedback.selectionClick());
                  }),
          ),
        );
      }),
      if (!_selectionComplete)
        Text(
          context.tr(
            'workout.builder.select_more_exercises',
            params: {'count': '${_requiredCount - selected.length}'},
          ),
          style: TextStyle(color: context.exerciseTheme.textSecondary),
        ),
    ],
  );

  Widget _setupStep() => Column(
    key: const ValueKey('block-setup'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        context.tr(
          'workout.builder.block_setup_title',
          params: {'type': _groupTypeLabel(context, type)},
        ),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: context.exerciseTheme.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      NumericStepper(
        label: context.tr('workout.detail.rounds'),
        value: rounds,
        min: 1,
        onChanged: (value) => setState(() => rounds = value),
      ),
      DurationStepper(
        label: context.tr('workout.builder.after_each_round'),
        seconds: restAfterRoundSeconds,
        onChanged: (value) => setState(() => restAfterRoundSeconds = value),
      ),
      const SizedBox(height: 12),
      _BlockOptionalFieldAction(
        expanded: showNotes,
        title: context.tr('workout.builder.notes_title'),
        actionLabel: context.tr('workout.builder.add_notes'),
        onPressed: () {
          setState(() => showNotes = true);
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => notesFocus.requestFocus(),
          );
        },
        child: WorkoutBuilderUnderlineField(
          controller: notesController,
          focusNode: notesFocus,
          label: context.tr('workout.builder.notes_title'),
          hint: context.tr('workout.builder.notes_hint'),
          helper: context.tr('workout.builder.optional'),
          minLines: 2,
          maxLines: 4,
          maxLength: 300,
          textInputAction: TextInputAction.done,
          onChanged: (_) {},
        ),
      ),
      const SizedBox(height: 12),
      CoachlySurface(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: selected.indexed.map((pair) {
            final candidate = candidates.firstWhere(
              (entry) => entry.item.id == pair.$2,
            );
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Text('A${pair.$1 + 1}'),
              title: Text(candidate.item.exercise.name),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        context.tr('workout.builder.block_setup_hint'),
        style: TextStyle(
          color: context.exerciseTheme.textSecondary,
          height: 1.4,
        ),
      ),
    ],
  );

  Future<void> _primaryAction() async {
    if (step == 0) {
      setState(() => step = 1);
    } else if (step == 1) {
      if (_selectionComplete) {
        setState(() => step = 2);
      } else {
        final added = await widget.onAddExercise(
          selectedSectionId ?? candidates.firstOrNull?.sectionId,
        );
        if (added == null || !mounted) return;
        setState(() {
          candidates.add(added);
          selectedSectionId = added.sectionId;
          selected.add(added.item.id);
        });
      }
    } else {
      Navigator.pop(
        context,
        _BlockSelection(
          type: type,
          itemIds: selected.toList(),
          rounds: rounds,
          restBetweenExercisesSeconds: restBetweenExercisesSeconds,
          restAfterRoundSeconds: restAfterRoundSeconds,
          notes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
        ),
      );
    }
  }

  int get _requiredCount => switch (type) {
    WorkoutGroupType.superset => 2,
    WorkoutGroupType.triset => 3,
    WorkoutGroupType.giantSet => 4,
    WorkoutGroupType.circuit => 2,
  };

  bool get _selectionComplete => selected.length >= _requiredCount;
}

class _BlockOptionalFieldAction extends StatelessWidget {
  final bool expanded;
  final String title;
  final String actionLabel;
  final VoidCallback onPressed;
  final Widget child;

  const _BlockOptionalFieldAction({
    required this.expanded,
    required this.title,
    required this.actionLabel,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.toUpperCase(),
        style: context.scale.caption.heavy.copyWith(
          color: context.exerciseTheme.textSecondary,
          letterSpacing: .7,
        ),
      ),
      AnimatedSize(
        duration: CoachlyAthleteTheme.expandDuration,
        alignment: Alignment.topCenter,
        child: expanded
            ? Padding(padding: const EdgeInsets.only(top: 10), child: child)
            : TextButton.icon(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: context.exerciseTheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(
                    CoachlyAthleteTheme.touchTarget,
                    CoachlyAthleteTheme.touchTarget,
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(actionLabel),
              ),
      ),
    ],
  );
}

class _BlockStepper extends StatelessWidget {
  final int currentStep;
  const _BlockStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.tr('workout.builder.step_type'),
      context.tr('workout.builder.step_exercises'),
      context.tr('workout.builder.step_setup'),
    ];
    return Semantics(
      label: labels[currentStep],
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              if (index.isOdd) {
                final completed = index ~/ 2 < currentStep;
                return Expanded(
                  child: Container(
                    height: 1.5,
                    color: completed
                        ? context.exerciseTheme.primary
                        : context.exerciseTheme.border,
                  ),
                );
              }
              final stepIndex = index ~/ 2;
              final active = stepIndex <= currentStep;
              return Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? context.exerciseTheme.primary
                      : context.exerciseTheme.surface,
                  border: Border.all(
                    color: active
                        ? context.exerciseTheme.primary
                        : context.exerciseTheme.border,
                  ),
                ),
                child: Text(
                  '${stepIndex + 1}',
                  style: context.scale.caption.heavy.copyWith(
                    color: active
                        ? context.exerciseTheme.background
                        : context.exerciseTheme.textSecondary,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: labels.indexed
                .map(
                  (entry) => Expanded(
                    child: Text(
                      entry.$2,
                      textAlign: switch (entry.$1) {
                        0 => TextAlign.left,
                        2 => TextAlign.right,
                        _ => TextAlign.center,
                      },
                      maxLines: 1,
                      style: context.scale.caption.bold.copyWith(
                        color: entry.$1 <= currentStep
                            ? context.exerciseTheme.textPrimary
                            : context.exerciseTheme.textSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BlockTypeTile extends StatelessWidget {
  final WorkoutGroupType type;
  final bool selected;
  final VoidCallback onTap;
  const _BlockTypeTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: CoachlyPressable(
      onTap: onTap,
      semanticLabel: _groupTypeLabel(context, type),
      child: AnimatedContainer(
        duration: CoachlyAthleteTheme.expandDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? context.exerciseTheme.primaryMuted.withValues(alpha: .42)
              : context.exerciseTheme.surface,
          borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
          border: Border.all(
            color: selected
                ? context.exerciseTheme.primary.withValues(alpha: .5)
                : context.exerciseTheme.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _groupTypeLabel(context, type),
                    style: context.scale.bodyLoose.heavy.copyWith(
                      color: context.exerciseTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr('workout.builder.block_type_${type.name}'),
                    style: TextStyle(
                      color: context.exerciseTheme.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected
                  ? context.exerciseTheme.primary
                  : context.exerciseTheme.textSecondary,
            ),
          ],
        ),
      ),
    ),
  );
}

String _groupTypeLabel(BuildContext context, WorkoutGroupType type) =>
    context.tr(switch (type) {
      WorkoutGroupType.superset => 'workout.detail.superset',
      WorkoutGroupType.triset => 'workout.detail.triset',
      WorkoutGroupType.giantSet => 'workout.detail.giant_set',
      WorkoutGroupType.circuit => 'workout.detail.circuit',
    });

class _BottomAction extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool loading;
  final IconData? trailingIcon;
  final String? summary;
  final VoidCallback onPressed;
  const _BottomAction({
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.loading = false,
    this.trailingIcon,
    this.summary,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(
      20,
      12,
      20,
      12 + MediaQuery.paddingOf(context).bottom,
    ),
    decoration: BoxDecoration(
      color: context.exerciseTheme.background,
      border: Border(top: BorderSide(color: context.exerciseTheme.border)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (summary != null) ...[
          Text(
            summary!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.exerciseTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          height: CoachlyAthleteTheme.primaryActionHeight,
          child: FilledButton(
            onPressed: enabled && !loading ? onPressed : null,
            style: FilledButton.styleFrom(
              backgroundColor: context.exerciseTheme.primary,
              foregroundColor: context.exerciseTheme.background,
              disabledBackgroundColor: context.exerciseTheme.surfaceElevated,
              disabledForegroundColor: context.exerciseTheme.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  CoachlyAthleteTheme.actionRadius,
                ),
              ),
              textStyle: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            child: loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 16),
                        Icon(trailingIcon, size: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    ),
  );
}

String _localId() => 'entry_${DateTime.now().microsecondsSinceEpoch}';
