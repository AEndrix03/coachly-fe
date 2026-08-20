import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_builder/providers/workout_builder_providers.dart';
import 'package:coachly/features/workout/workout_builder/widgets/workout_builder_widgets.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/features/workout/workout_edit_page/widgets/exercise_picker_sheet.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
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
          .read(workoutPageRepositoryProvider)
          .getWorkout(widget.workoutId);
      source = response.data;
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
              tooltip: context.tr('common.cancel'),
              icon: const Icon(Icons.close),
            ),
            title: Text(context.tr('workout.builder.edit_title')),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                tooltip: context.tr('workout.builder.workout_actions'),
                icon: const Icon(Icons.more_horiz_rounded),
                onSelected: (_) => _editWorkoutNotes(state.draft.focus),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'notes',
                    child: Text(context.tr('workout.builder.add_notes')),
                  ),
                ],
              ),
              IconButton(
                onPressed: state.isSaving || _source == null ? null : _commit,
                tooltip: context.tr('common.confirm'),
                icon: state.isSaving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
              ),
            ],
          ),
          body: _source == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  top: false,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                    children: [
                      InkWell(
                        onTap: _editMetadata,
                        borderRadius: BorderRadius.circular(
                          CoachlyAthleteTheme.compactRadius,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                                color: context.exerciseTheme.textSecondary,
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
                            .reorderInSection(section, oldIndex, newIndex),
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
                        exerciseLabel: state.draft.sections.isEmpty
                            ? null
                            : context.tr(
                                'workout.builder.add_exercise_to_section',
                                params: {
                                  'section':
                                      state.draft.sections.last.name ??
                                      context.tr(
                                        'workout.builder.main_section',
                                      ),
                                },
                              ),
                        onAddSection: _addSection,
                        onCreateBlock: _createGroup,
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
                  context.tr('workout.builder.info_title'),
                  style: TextStyle(
                    color: context.exerciseTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: title,
                  maxLength: 60,
                  onChanged: (value) => setSheetState(() => title = value),
                  decoration: InputDecoration(
                    labelText: context.tr('workout.builder.title_label'),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: goal,
                  decoration: InputDecoration(
                    labelText: context.tr('workout.builder.goal_label'),
                  ),
                  items: ['hypertrophy', 'strength', 'general']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            context.tr('workout.builder.goal_$value'),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setSheetState(() => goal = value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: focus,
                  minLines: 2,
                  maxLines: 4,
                  maxLength: 180,
                  onChanged: (value) => focus = value,
                  decoration: InputDecoration(
                    labelText: context.tr('workout.builder.focus_label'),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: title.trim().isEmpty
                      ? null
                      : () => Navigator.pop(context, true),
                  child: Text(context.tr('workout.builder.apply')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        .addExercise(configured, sectionId: sectionId);
    HapticFeedback.lightImpact();
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
          content: Text(context.tr('workout.builder.item_removed')),
          action: SnackBarAction(
            label: context.tr('common.undo'),
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
    final candidates = ref
        .read(editWorkoutControllerProvider(widget.workoutId))
        .draft
        .sections
        .expand((s) => s.items)
        .whereType<WorkoutExerciseItemDraft>()
        .toList();
    if (candidates.length < 2) return;
    final selected = <String>{};
    final notesController = TextEditingController();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.exerciseTheme.surfaceElevated,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('workout.builder.create_superset'),
                style: TextStyle(
                  color: context.exerciseTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              ...candidates.map(
                (item) => CheckboxListTile(
                  value: selected.contains(item.id),
                  title: Text(item.exercise.name),
                  onChanged: (value) => update(
                    () => value == true
                        ? selected.add(item.id)
                        : selected.remove(item.id),
                  ),
                ),
              ),
              TextField(
                controller: notesController,
                minLines: 2,
                maxLines: 4,
                maxLength: 300,
                decoration: InputDecoration(
                  labelText: context.tr('workout.builder.add_notes'),
                  hintText: context.tr('workout.builder.notes_hint'),
                ),
              ),
              FilledButton(
                onPressed: selected.length > 1
                    ? () => Navigator.pop(context, true)
                    : null,
                child: Text(context.tr('workout.builder.add_superset')),
              ),
            ],
          ),
        ),
      ),
    );
    final notes = notesController.text.trim();
    notesController.dispose();
    if (ok == true) {
      ref
          .read(editWorkoutControllerProvider(widget.workoutId).notifier)
          .createGroup(
            type: WorkoutGroupType.superset,
            itemIds: selected.toList(),
            notes: notes.isEmpty ? null : notes,
          );
    }
  }

  Future<void> _commit() async {
    final source = _source;
    if (source == null) return;
    final result = await ref
        .read(editWorkoutControllerProvider(widget.workoutId).notifier)
        .commit(source);
    if (!mounted || result == null) return;
    HapticFeedback.mediumImpact();
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
    if (discard == true && mounted) {
      ref
          .read(editWorkoutControllerProvider(widget.workoutId).notifier)
          .discard();
      context.pop();
    }
  }
}
