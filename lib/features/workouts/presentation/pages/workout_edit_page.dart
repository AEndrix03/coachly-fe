import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'dart:async';

import 'package:coachly/features/workouts/domain/workout_draft.dart';
import 'package:coachly/features/workouts/presentation/pages/create_workout_flow.dart';
import 'package:coachly/features/workouts/application/workout_builder_providers.dart';
import 'package:coachly/features/workouts/presentation/widgets/workout_builder_widgets.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/workouts/presentation/widgets/exercise_picker_sheet.dart';
import 'package:coachly/features/workouts/domain/models/workout_model.dart';
import 'package:coachly/features/workouts/application/workout_access_controller.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutEditPage extends ConsumerStatefulWidget {
  final String workoutId;
  final WorkoutModel? workout;
  const WorkoutEditPage({super.key, required this.workoutId, this.workout});
  @override
  ConsumerState<WorkoutEditPage> createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends ConsumerState<WorkoutEditPage> {
  WorkoutModel? _source;

  @override
  void initState() {
    super.initState();
    _source = widget.workout;
    Future.microtask(_initialize);
  }

  Future<void> _initialize() async {
    var source = _source;
    if (source == null) {
      final response = await ref
          .read(workoutAccessControllerProvider)
          .workout(widget.workoutId);
      source = response.valueOrNull;
    }
    if (!mounted || source == null) return;
    _source = source;
    ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .initialize(source);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editWorkoutControllerProvider(widget.workoutId));
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: PopScope(
        canPop: !state.isDirty,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _close();
        },
        child: Scaffold(
          backgroundColor: context.exerciseTheme.background,
          appBar: AppBar(
            backgroundColor: context.exerciseTheme.background,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: _close,
              tooltip: context.l10n.commonCancel,
              icon: const Icon(Icons.close),
            ),
            title: Text(context.l10n.workoutBuilderEditTitle),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                tooltip: context.l10n.workoutBuilderWorkoutActions,
                icon: const Icon(Icons.more_horiz_rounded),
                onSelected: (_) => _editWorkoutNotes(state.draft.focus),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'notes',
                    child: Text(context.l10n.workoutBuilderAddNotes),
                  ),
                ],
              ),
            ],
          ),
          body: _source == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                          children: [
                            InkWell(
                              onTap: _editMetadata,
                              borderRadius: BorderRadius.circular(
                                CoachlyAthleteTheme.compactRadius,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: WorkoutBuilderSummary(
                                        draft: state.draft,
                                        compact: true,
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit_outlined,
                                      color:
                                          context.exerciseTheme.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            WorkoutDraftStructure(
                              draft: state.draft,
                              onEditExercise: _editExercise,
                              onEditBlock: _editBlock,
                              onUpdateExercise: ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .updateExercise,
                              onUpdateBlock: ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .updateGroup,
                              onOpenExercise: _openExerciseDetail,
                              onReorder: (section, oldIndex, newIndex) => ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .reorderInSection(
                                    section,
                                    oldIndex,
                                    newIndex,
                                  ),
                              onReorderSections: ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .reorderSections,
                              onRemove: _removeItem,
                              onRemoveExercise: ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .removeExercise,
                              onDuplicate: (id) => ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .duplicateItem(id),
                              onMove: _moveItem,
                              onAddExercise: _addExercise,
                              onAddSection: _addSection,
                              onCreateBlock: _createGroup,
                              onEditSection: _editSection,
                              onUpdateSection: ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .updateSection,
                              onRemoveSection: ref
                                  .read(
                                    editWorkoutControllerProvider(
                                      widget.workoutId,
                                    ).notifier,
                                  )
                                  .removeSection,
                            ),
                            const SizedBox(height: 8),
                            WorkoutStructureComposer(
                              onAddExercise: () => _addExercise(null),
                              onAddSection: _addSection,
                              onCreateBlock: _createGroup,
                            ),
                          ],
                        ),
                      ),
                      _EditSaveBar(
                        summary: context.l10n.workoutBuilderReviewSummary(
                          context.tr(
                            state.draft.exerciseCount == 1
                                ? 'workout.detail.exercise_count_one'
                                : 'workout.detail.exercise_count_other',
                            params: {'count': '${state.draft.exerciseCount}'},
                          ),
                          '${state.draft.estimatedDurationMinutes}',
                        ),
                        loading: state.isSaving,
                        enabled: state.isDirty && state.validation.isValid,
                        onPressed: _commit,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _editMetadata() async {
    final draft = ref
        .read(editWorkoutControllerProvider(widget.workoutId))
        .draft;
    var title = draft.title;
    var focus = draft.focus ?? '';
    var goal = draft.trainingGoal;
    var showNotes = focus.trim().isNotEmpty;
    final titleController = TextEditingController(text: title);
    final notesController = TextEditingController(text: focus);
    final titleFocus = FocusNode();
    final notesFocus = FocusNode();
    final apply = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.exerciseTheme.surfaceElevated,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.workoutBuilderInfoTitle,
                  style: context.scale.display.heavy.copyWith(
                    color: context.exerciseTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                WorkoutBuilderUnderlineField(
                  controller: titleController,
                  focusNode: titleFocus,
                  maxLength: 60,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setSheetState(() => title = value),
                  label: context.l10n.workoutBuilderTitleLabel,
                  hint: context.l10n.workoutBuilderTitleHint,
                ),
                const SizedBox(height: 18),
                WorkoutGoalSelector(
                  selectedGoal: goal,
                  onSelected: (value) => setSheetState(() => goal = value),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.workoutBuilderSessionNote,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.exerciseTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AnimatedSize(
                  duration: CoachlyAthleteTheme.expandDuration,
                  alignment: Alignment.topCenter,
                  child: showNotes
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: WorkoutBuilderUnderlineField(
                            controller: notesController,
                            focusNode: notesFocus,
                            label: context.l10n.workoutBuilderSessionNote,
                            hint: context.l10n.workoutBuilderFocusHint,
                            helper: context.l10n.workoutBuilderOptional,
                            minLines: 2,
                            maxLines: 4,
                            maxLength: 180,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) => focus = value,
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: context.exerciseTheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            onPressed: () {
                              setSheetState(() => showNotes = true);
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => notesFocus.requestFocus(),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: Text(
                              context.l10n.workoutBuilderAddSessionNote,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.exerciseTheme.primary,
                    foregroundColor: context.exerciseTheme.background,
                  ),
                  onPressed: title.trim().isEmpty
                      ? null
                      : () => Navigator.pop(context, true),
                  child: Text(context.l10n.workoutBuilderApply),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    titleController.dispose();
    notesController.dispose();
    titleFocus.dispose();
    notesFocus.dispose();
    if (apply == true) {
      ref
          .read(editWorkoutControllerProvider(widget.workoutId).notifier)
          .updateMetadata(
            title: title.trim(),
            goal: goal,
            focus: focus.trim().isEmpty ? null : focus.trim(),
          );
    }
  }

  Future<void> _editWorkoutNotes(String? initialValue) async {
    final notes = await showWorkoutNotesSheet(
      context,
      initialValue: initialValue,
    );
    if (notes == null || !mounted) return;
    ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .updateMetadata(focus: notes.isEmpty ? null : notes);
  }

  Future<void> _addExercise(String? sectionId) async {
    var destinationId = sectionId;
    if (destinationId == null) {
      final sections = ref
          .read(editWorkoutControllerProvider(widget.workoutId))
          .draft
          .sections;
      if (sections.isNotEmpty) {
        destinationId = await showWorkoutSectionPicker(context, sections);
        if (destinationId == null || !mounted) return;
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
            localId: 'entry_${DateTime.now().microsecondsSinceEpoch}',
            exerciseId: selected.exerciseId,
            name: selected.name,
          );
        },
      ),
    );
    if (!mounted || picked == null) return;
    final configured = await showPrescriptionEditor(
      context,
      picked!,
      adding: true,
    );
    if (configured == null || !mounted) return;
    ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .addExercise(configured, sectionId: destinationId);
    unawaited(HapticFeedback.lightImpact());
  }

  Future<void> _editExercise(WorkoutExerciseDraft exercise) async {
    final updated = await showPrescriptionEditor(
      context,
      exercise,
      adding: false,
    );
    if (updated != null) {
      ref
          .read(editWorkoutControllerProvider(widget.workoutId).notifier)
          .updateExercise(updated);
    }
  }

  Future<void> _editBlock(WorkoutExerciseGroupDraft group) async {
    final updated = await showWorkoutBlockEditor(context, group);
    if (updated == null || !mounted) return;
    ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .updateGroup(updated);
  }

  Future<void> _openExerciseDetail(WorkoutExerciseDraft exercise) async {
    await context.push('/exercises/${exercise.exerciseId}?mode=view');
  }

  Future<void> _moveItem(String itemId) async {
    final sections = ref
        .read(editWorkoutControllerProvider(widget.workoutId))
        .draft
        .sections;
    if (sections.length < 2) return;
    final destination = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      backgroundColor: context.exerciseTheme.surfaceElevated,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.workoutBuilderMoveToSection,
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
                  section.name ?? context.l10n.workoutBuilderMainSection,
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
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .moveItemToSection(itemId, destination);
  }

  void _removeItem(String id) {
    final state = ref.read(editWorkoutControllerProvider(widget.workoutId));
    WorkoutStructureItemDraft? removed;
    for (final item in state.draft.items) {
      if (item.id == id) removed = item;
    }
    ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .removeItem(id);
    if (removed != null) {
      final removedItem = removed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.workoutBuilderItemRemoved),
          action: SnackBarAction(
            label: context.l10n.commonUndo,
            onPressed: () {
              for (final exercise in removedItem.exercises) {
                ref
                    .read(
                      editWorkoutControllerProvider(widget.workoutId).notifier,
                    )
                    .addExercise(exercise);
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> _addSection() async {
    final result = await showWorkoutSectionNameSheet(context);
    if (result?.name.isNotEmpty == true) {
      ref
          .read(editWorkoutControllerProvider(widget.workoutId).notifier)
          .addSection(result!.name, notes: result.notes);
    }
  }

  Future<void> _editSection(WorkoutSectionDraft section) async {
    final result = await showWorkoutSectionNameSheet(context, initial: section);
    if (result?.name.isNotEmpty != true || !mounted) return;
    ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .updateSection(
          section.copyWith(name: result!.name, notes: result.notes),
        );
  }

  Future<void> _createGroup() async {
    final draft = ref
        .read(editWorkoutControllerProvider(widget.workoutId))
        .draft;
    await showWorkoutBlockCreationFlow(
      context,
      draft: draft,
      onAddExercise: (sectionId) async {
        await _addExercise(sectionId);
        final latest = ref
            .read(editWorkoutControllerProvider(widget.workoutId))
            .draft;
        final beforeIds = draft.items.map((item) => item.id).toSet();
        final added = latest.items
            .whereType<WorkoutExerciseItemDraft>()
            .where((item) => !beforeIds.contains(item.id))
            .lastOrNull;
        if (added == null) return null;
        final section = latest.sections.firstWhere(
          (entry) => entry.items.any((item) => item.id == added.id),
        );
        return (sectionId: section.id, exercise: added.exercise);
      },
      onCreate: (selection) => ref
          .read(editWorkoutControllerProvider(widget.workoutId).notifier)
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
    final source = _source;
    if (source == null) return;
    final result = await ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .commit(source);
    if (!mounted || result == null) return;
    unawaited(HapticFeedback.mediumImpact());
    context.pop(result);
  }

  Future<void> _close() async {
    final state = ref.read(editWorkoutControllerProvider(widget.workoutId));
    if (!state.isDirty) {
      context.pop();
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.exerciseTheme.surfaceElevated,
        title: Text(context.l10n.workoutDetailUnsavedTitle),
        content: Text(context.l10n.workoutDetailUnsavedBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.workoutDetailContinueEditing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              context.l10n.workoutDetailDiscard,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (discard == true && mounted) {
      ref
          .read(editWorkoutControllerProvider(widget.workoutId).notifier)
          .discard();
      context.pop();
    }
  }
}

class _EditSaveBar extends StatelessWidget {
  final String summary;
  final bool loading;
  final bool enabled;
  final VoidCallback onPressed;

  const _EditSaveBar({
    required this.summary,
    required this.loading,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(
      20,
      10,
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
        Text(
          summary,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.exerciseTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: CoachlyAthleteTheme.primaryActionHeight,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.exerciseTheme.primary,
              foregroundColor: context.exerciseTheme.background,
              disabledBackgroundColor: context.exerciseTheme.surfaceElevated,
              disabledForegroundColor: context.exerciseTheme.textSecondary,
            ),
            onPressed: enabled && !loading ? onPressed : null,
            child: loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.workoutBuilderSaveChanges),
          ),
        ),
      ],
    ),
  );
}
