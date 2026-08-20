import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_builder/providers/workout_builder_providers.dart';
import 'package:coachly/features/workout/workout_builder/widgets/workout_builder_widgets.dart';
import 'package:coachly/features/workout/workout_edit_page/widgets/exercise_picker_sheet.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
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
  final _titleFocus = FocusNode();
  final _noteFocus = FocusNode();
  _CreateStage stage = _CreateStage.identity;
  bool _showSessionNote = false;

  @override
  void dispose() {
    _title.dispose();
    _focus.dispose();
    _titleFocus.dispose();
    _noteFocus.dispose();
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
            _WorkoutUnderlineField(
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
            _GoalSection(
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
                  ? _WorkoutUnderlineField(
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
        },
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
            AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : CoachlyAthleteTheme.expandDuration,
              switchInCurve: CoachlyAthleteTheme.standardCurve,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, child: child),
              ),
              child: WorkoutDraftStructure(
                key: ValueKey(state.draft.exerciseCount == 0),
                draft: state.draft,
                onEditExercise: (exercise) => _editExercise(exercise, false),
                onEditBlock: _editBlock,
                onOpenExercise: _openExerciseDetail,
                onReorder: (section, oldIndex, newIndex) => ref
                    .read(createWorkoutControllerProvider.notifier)
                    .reorderInSection(section, oldIndex, newIndex),
                onRemove: ref
                    .read(createWorkoutControllerProvider.notifier)
                    .removeItem,
                onDuplicate: ref
                    .read(createWorkoutControllerProvider.notifier)
                    .duplicateItem,
                onMove: _moveItem,
                onAddExercise: _addExercise,
                onAddSection: _addSection,
                onCreateBlock: _createBlock,
                onEditSection: _editSection,
              ),
            ),
            WorkoutStructureComposer(
              onAddExercise: () => _addExercise(null),
              onAddSection: _addSection,
              onCreateBlock: _createBlock,
            ),
          ],
        ),
      ),
      _BottomAction(
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
              onOpenExercise: _openExerciseDetail,
              onReorder: (_, _, _) {},
              onRemove: (_) {},
              onDuplicate: (_) {},
              onMove: (_) {},
              onAddExercise: (_) {},
              onAddSection: () {},
              onCreateBlock: () {},
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

  Future<WorkoutExerciseDraft?> _addExercise(String? sectionId) async {
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
        .addExercise(configured, sectionId: sectionId);
    HapticFeedback.lightImpact();
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
    final name = await showWorkoutSectionNameSheet(context);
    if (name?.isNotEmpty == true) {
      ref.read(createWorkoutControllerProvider.notifier).addSection(name);
    }
  }

  Future<void> _editSection(WorkoutSectionDraft section) async {
    final name = await showWorkoutSectionNameSheet(context);
    if (name?.isNotEmpty != true || !mounted) return;
    ref
        .read(createWorkoutControllerProvider.notifier)
        .renameSection(section.id, name!);
  }

  Future<void> _createBlock() async {
    final draft = ref.read(createWorkoutControllerProvider).draft;
    final candidates = <_BlockCandidate>[];
    for (final section in draft.sections) {
      for (final item in section.items.whereType<WorkoutExerciseItemDraft>()) {
        candidates.add(_BlockCandidate(sectionId: section.id, item: item));
      }
    }
    if (candidates.isEmpty) {
      await _addExercise(null);
      return;
    }
    final selection = await showModalBottomSheet<_BlockSelection>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.exerciseTheme.surfaceElevated,
      builder: (_) => _CreateBlockSheet(
        candidates: candidates,
        onAddExercise: (sectionId) async {
          final exercise = await _addExercise(sectionId);
          if (exercise == null) return null;
          final state = ref.read(createWorkoutControllerProvider);
          final section = state.draft.sections.firstWhere(
            (entry) => entry.items.any((item) => item.id == exercise.localId),
          );
          return _BlockCandidate(
            sectionId: section.id,
            item: WorkoutExerciseItemDraft(exercise),
          );
        },
      ),
    );
    if (selection == null || !mounted) return;
    ref
        .read(createWorkoutControllerProvider.notifier)
        .createGroup(
          type: selection.type,
          itemIds: selection.itemIds,
          rounds: selection.rounds,
          restBetweenExercisesSeconds: selection.restBetweenExercisesSeconds,
          restAfterRoundSeconds: selection.restAfterRoundSeconds,
        );
    HapticFeedback.lightImpact();
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
      CoachlyInfoSection(
        context.tr('workout.builder.block'),
        context.tr('workout.builder.block_info'),
      ),
    ],
    primaryActionLabel: context.tr('common.got_it'),
    secondaryActionLabel: context.tr('common.learn_more'),
  );
}

class _WorkoutUnderlineField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final String? helper;
  final int maxLength;
  final int? minLines;
  final int maxLines;
  final bool autofocus;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;

  const _WorkoutUnderlineField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.maxLength,
    required this.textInputAction,
    required this.onChanged,
    this.helper,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
  });

  @override
  State<_WorkoutUnderlineField> createState() => _WorkoutUnderlineFieldState();
}

class _WorkoutUnderlineFieldState extends State<_WorkoutUnderlineField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_refresh);
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_refresh);
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final focused = widget.focusNode.hasFocus;
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: focused ? colors.primary : colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (widget.helper != null)
              Text(
                widget.helper!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          maxLength: widget.maxLength,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: colors.textSecondary),
            counterText: focused
                ? '${widget.controller.text.characters.length}/${widget.maxLength}'
                : '',
            counterStyle: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            contentPadding: const EdgeInsets.only(bottom: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalSection extends StatelessWidget {
  final String? selectedGoal;
  final ValueChanged<String> onSelected;
  final VoidCallback onInfo;

  const _GoalSection({
    required this.selectedGoal,
    required this.onSelected,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            context.tr('workout.builder.goal_label'),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.exerciseTheme.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            onPressed: onInfo,
            tooltip: context.tr('workout.builder.goal_info_tooltip'),
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.help_outline, size: 18),
            color: context.exerciseTheme.textSecondary,
          ),
        ],
      ),
      const SizedBox(height: 4),
      _GoalOption(
        goal: 'hypertrophy',
        icon: Icons.fitness_center_outlined,
        selected: selectedGoal == 'hypertrophy',
        onTap: onSelected,
      ),
      const SizedBox(height: 9),
      _GoalOption(
        goal: 'strength',
        icon: Icons.bolt_outlined,
        selected: selectedGoal == 'strength',
        onTap: onSelected,
      ),
      const SizedBox(height: 9),
      _GoalOption(
        goal: 'general',
        icon: Icons.track_changes_outlined,
        selected: selectedGoal == 'general',
        onTap: onSelected,
      ),
    ],
  );
}

class _GoalOption extends StatelessWidget {
  final String goal;
  final IconData icon;
  final bool selected;
  final ValueChanged<String> onTap;

  const _GoalOption({
    required this.goal,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final title = context.tr('workout.builder.goal_$goal');
    final description = context.tr('workout.builder.goal_${goal}_description');
    return Semantics(
      selected: selected,
      button: true,
      label: '$title. $description',
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : CoachlyAthleteTheme.expandDuration,
        curve: CoachlyAthleteTheme.standardCurve,
        decoration: BoxDecoration(
          color: selected
              ? colors.primaryMuted.withValues(alpha: .45)
              : colors.surface,
          borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => onTap(goal),
          borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 23,
                    color: selected ? colors.primary : colors.textSecondary,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.check_circle_outline,
                      color: colors.primary,
                      size: 21,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BlockCandidate {
  final String sectionId;
  final WorkoutExerciseItemDraft item;
  const _BlockCandidate({required this.sectionId, required this.item});
}

class _BlockSelection {
  final WorkoutGroupType type;
  final List<String> itemIds;
  final int rounds;
  final int restBetweenExercisesSeconds;
  final int restAfterRoundSeconds;
  const _BlockSelection({
    required this.type,
    required this.itemIds,
    required this.rounds,
    required this.restBetweenExercisesSeconds,
    required this.restAfterRoundSeconds,
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
                style: TextStyle(
                  color: context.exerciseTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
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
              HapticFeedback.selectionClick();
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
                    HapticFeedback.selectionClick();
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

class _BlockStepper extends StatelessWidget {
  final int currentStep;
  const _BlockStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(3, (index) {
      final labels = [
        context.tr('workout.builder.step_type'),
        context.tr('workout.builder.step_exercises'),
        context.tr('workout.builder.step_setup'),
      ];
      final active = index <= currentStep;
      return Expanded(
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? CoachlyAthleteTheme.primary
                    : context.exerciseTheme.surface,
              ),
              child: Text('${index + 1}'),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                labels[index],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? context.exerciseTheme.textPrimary
                      : context.exerciseTheme.textSecondary,
                ),
              ),
            ),
            if (index < 2) const Expanded(child: Divider()),
          ],
        ),
      );
    }),
  );
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
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    minVerticalPadding: 10,
    onTap: onTap,
    title: Text(
      _groupTypeLabel(context, type),
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
    subtitle: Text(context.tr('workout.builder.block_type_${type.name}')),
    trailing: selected
        ? const Icon(Icons.check_circle, color: CoachlyAthleteTheme.primary)
        : const Icon(Icons.circle_outlined),
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
