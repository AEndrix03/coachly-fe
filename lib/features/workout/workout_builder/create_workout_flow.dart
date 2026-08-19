import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_builder/providers/workout_builder_providers.dart';
import 'package:coachly/features/workout/workout_builder/widgets/workout_builder_widgets.dart';
import 'package:coachly/features/workout/workout_edit_page/widgets/exercise_picker_sheet.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
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
  _CreateStage stage = _CreateStage.identity;

  @override
  void dispose() {
    _title.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createWorkoutControllerProvider);
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: PopScope(
        canPop: stage == _CreateStage.identity && !state.isDirty,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _back();
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
                    IconButton(
                      onPressed: _showStructureInfo,
                      tooltip: context.tr('workout.builder.learn_structure'),
                      icon: const Icon(Icons.info_outline),
                    ),
                  ]
                : null,
          ),
          body: SafeArea(
            top: false,
            child: AnimatedSwitcher(
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
          ),
        ),
      ),
    );
  }

  Widget _identity(WorkoutBuilderState state) => ListView(
    key: const ValueKey('identity'),
    padding: EdgeInsets.fromLTRB(
      20,
      28,
      20,
      20 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    children: [
      Text(
        context.tr('workout.builder.identity_heading'),
        style: TextStyle(
          color: context.exerciseTheme.textPrimary,
          fontSize: 34,
          height: 1.1,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 32),
      TextField(
        controller: _title,
        autofocus: true,
        maxLength: 60,
        textInputAction: TextInputAction.next,
        onChanged: (value) => ref
            .read(createWorkoutControllerProvider.notifier)
            .updateMetadata(title: value),
        decoration: InputDecoration(
          labelText: context.tr('workout.builder.title_label'),
          hintText: context.tr('workout.builder.title_hint'),
        ),
      ),
      const SizedBox(height: 14),
      DropdownButtonFormField<String>(
        initialValue: state.draft.trainingGoal,
        decoration: InputDecoration(
          labelText: context.tr('workout.builder.goal_label'),
          suffixIcon: IconButton(
            onPressed: _showGoalInfo,
            icon: const Icon(Icons.info_outline),
          ),
        ),
        items: ['hypertrophy', 'strength', 'general']
            .map(
              (goal) => DropdownMenuItem(
                value: goal,
                child: Text(context.tr('workout.builder.goal_$goal')),
              ),
            )
            .toList(),
        onChanged: (value) => ref
            .read(createWorkoutControllerProvider.notifier)
            .updateMetadata(goal: value),
      ),
      const SizedBox(height: 18),
      TextField(
        controller: _focus,
        maxLength: 180,
        minLines: 2,
        maxLines: 4,
        textInputAction: TextInputAction.done,
        onChanged: (value) => ref
            .read(createWorkoutControllerProvider.notifier)
            .updateMetadata(focus: value.trim().isEmpty ? null : value),
        decoration: InputDecoration(
          labelText: context.tr('workout.builder.focus_label'),
          hintText: context.tr('workout.builder.focus_hint'),
        ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        height: CoachlyAthleteTheme.touchTarget,
        child: FilledButton(
          onPressed: state.draft.title.trim().isEmpty
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  setState(() => stage = _CreateStage.structure);
                },
          child: Text(context.tr('workout.builder.continue_action')),
        ),
      ),
    ],
  );

  Widget _structure(WorkoutBuilderState state) => Column(
    key: const ValueKey('structure'),
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          children: [
            WorkoutBuilderSummary(draft: state.draft, compact: true),
            const SizedBox(height: 26),
            WorkoutDraftStructure(
              draft: state.draft,
              onEditExercise: (exercise) => _editExercise(exercise, false),
              onReorder: (section, oldIndex, newIndex) => ref
                  .read(createWorkoutControllerProvider.notifier)
                  .reorderInSection(section, oldIndex, newIndex),
              onRemove: ref
                  .read(createWorkoutControllerProvider.notifier)
                  .removeItem,
              onAddExercise: _addExercise,
            ),
            if (state.draft.exerciseCount > 0)
              _BuilderActions(
                onAddExercise: () => _addExercise(null),
                onAddSection: _addSection,
              ),
          ],
        ),
      ),
      _BottomAction(
        label: context.tr('workout.builder.review_action'),
        enabled: state.draft.exerciseCount > 0,
        onPressed: () => setState(() => stage = _CreateStage.review),
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
              onReorder: (_, _, _) {},
              onRemove: (_) {},
              onAddExercise: (_) {},
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

  Future<void> _addExercise(String? sectionId) async {
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
    if (!mounted || picked == null) return;
    final configured = await showPrescriptionEditor(
      context,
      picked!,
      adding: true,
    );
    if (configured == null || !mounted) return;
    ref
        .read(createWorkoutControllerProvider.notifier)
        .addExercise(configured, sectionId: sectionId);
    HapticFeedback.lightImpact();
  }

  Future<void> _editExercise(WorkoutExerciseDraft exercise, bool adding) async {
    final updated = await showPrescriptionEditor(
      context,
      exercise,
      adding: adding,
    );
    if (updated != null)
      ref
          .read(createWorkoutControllerProvider.notifier)
          .updateExercise(updated);
  }

  Future<void> _addSection() async {
    final name = await showWorkoutSectionNameSheet(context);
    if (name?.isNotEmpty == true)
      ref.read(createWorkoutControllerProvider.notifier).addSection(name);
  }

  Future<void> _commit() async {
    final workout = await ref
        .read(createWorkoutControllerProvider.notifier)
        .commit();
    if (!mounted || workout == null) return;
    HapticFeedback.mediumImpact();
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
  void _showStructureInfo() => CoachlyInfoSheet.show(
    context,
    title: context.tr('workout.builder.organize_title'),
    sections: [
      CoachlyInfoSection(
        context.tr('workout.builder.section'),
        context.tr('workout.builder.section_info'),
      ),
    ],
    primaryActionLabel: context.tr('common.got_it'),
    secondaryActionLabel: context.tr('common.learn_more'),
  );
}

class _BuilderActions extends StatelessWidget {
  final VoidCallback onAddExercise, onAddSection;
  const _BuilderActions({
    required this.onAddExercise,
    required this.onAddSection,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionChip(
          avatar: const Icon(Icons.add, size: 18),
          label: Text(context.tr('workout.builder.exercise')),
          onPressed: onAddExercise,
        ),
        ActionChip(
          avatar: const Icon(Icons.view_agenda_outlined, size: 18),
          label: Text(context.tr('workout.builder.section')),
          onPressed: onAddSection,
        ),
      ],
    ),
  );
}

class _BottomAction extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;
  const _BottomAction({
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.loading = false,
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
    child: SizedBox(
      height: CoachlyAthleteTheme.touchTarget,
      child: FilledButton(
        onPressed: enabled && !loading ? onPressed : null,
        child: loading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    ),
  );
}

String _localId() => 'entry_${DateTime.now().microsecondsSinceEpoch}';
