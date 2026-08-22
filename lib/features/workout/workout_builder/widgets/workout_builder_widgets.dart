import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_builder/tour/builder_tour_controller.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/guided_tour/coachly_guided_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutBuilderUnderlineField extends StatefulWidget {
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
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffixText;
  final ValueChanged<String> onChanged;

  const WorkoutBuilderUnderlineField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.maxLength,
    required this.textInputAction,
    required this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.suffixText,
    this.helper,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
  });

  @override
  State<WorkoutBuilderUnderlineField> createState() =>
      _WorkoutBuilderUnderlineFieldState();
}

class _WorkoutBuilderUnderlineFieldState
    extends State<WorkoutBuilderUnderlineField> {
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
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixText: widget.suffixText,
            suffixStyle: TextStyle(color: colors.textSecondary),
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

class WorkoutBuilderSummary extends StatelessWidget {
  final WorkoutDraft draft;
  final bool compact;
  const WorkoutBuilderSummary({
    super.key,
    required this.draft,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        draft.title.isEmpty
            ? context.tr('workout.builder.untitled')
            : draft.title,
        style: TextStyle(
          color: CoachlyAthleteTheme.textPrimary,
          fontSize: compact ? 22 : 30,
          fontWeight: FontWeight.w800,
          height: 1.15,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        [
          if (draft.trainingGoal?.isNotEmpty == true)
            context.tr('workout.builder.goal_${draft.trainingGoal}'),
          context.tr(
            draft.exerciseCount == 1
                ? 'workout.detail.exercise_count_one'
                : 'workout.detail.exercise_count_other',
            params: {'count': '${draft.exerciseCount}'},
          ),
          context.tr(
            'workout.detail.estimated_minutes',
            params: {'count': '${draft.estimatedDurationMinutes}'},
          ),
        ].join(' · '),
        style: const TextStyle(
          color: CoachlyAthleteTheme.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class WorkoutStructureComposer extends StatelessWidget {
  final VoidCallback onAddExercise;
  final VoidCallback onAddSection;
  final VoidCallback onCreateBlock;
  final CoachlyTourTargetRegistry? tourRegistry;

  const WorkoutStructureComposer({
    super.key,
    required this.onAddExercise,
    required this.onAddSection,
    required this.onCreateBlock,
    this.tourRegistry,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: context.tr('workout.builder.structure_actions'),
    child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OptionalTourTarget(
            id: BuilderTourTarget.addExercise,
            registry: tourRegistry,
            child: CoachlyPressable(
              onTap: onAddExercise,
              semanticLabel: context.tr('workout.builder.add_exercise'),
              child: Container(
                constraints: const BoxConstraints(minHeight: 72),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: context.exerciseTheme.surface,
                  borderRadius: BorderRadius.circular(
                    CoachlyAthleteTheme.cardRadius,
                  ),
                  border: Border.all(color: context.exerciseTheme.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.exerciseTheme.primaryMuted.withValues(
                          alpha: .55,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 23,
                        color: context.exerciseTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('workout.builder.add_exercise'),
                            style: TextStyle(
                              color: context.exerciseTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            context.tr('workout.builder.add_exercise_hint'),
                            style: TextStyle(
                              color: context.exerciseTheme.textSecondary,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: context.exerciseTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _OptionalTourTarget(
                    id: BuilderTourTarget.sectionsAction,
                    registry: tourRegistry,
                    child: _StructureActionCard(
                      icon: Icons.view_agenda_outlined,
                      title: context.tr('workout.builder.sections_hint_title'),
                      body: context.tr('workout.builder.sections_hint_body'),
                      actionLabel: context.tr('workout.builder.add_section'),
                      onTap: onAddSection,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OptionalTourTarget(
                    id: BuilderTourTarget.blocksAction,
                    registry: tourRegistry,
                    child: _StructureActionCard(
                      icon: Icons.link_rounded,
                      title: context.tr('workout.builder.blocks_hint_title'),
                      body: context.tr('workout.builder.blocks_hint_body'),
                      actionLabel: context.tr(
                        'workout.builder.create_block_short',
                      ),
                      onTap: onCreateBlock,
                    ),
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

class _OptionalTourTarget extends StatelessWidget {
  final Object id;
  final CoachlyTourTargetRegistry? registry;
  final Widget child;

  const _OptionalTourTarget({
    required this.id,
    required this.registry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => registry == null
      ? child
      : CoachlyTourTarget(id: id, registry: registry!, child: child);
}

class _StructureActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onTap;

  const _StructureActionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => CoachlyPressable(
    onTap: onTap,
    semanticLabel: '$actionLabel. $body',
    borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.exerciseTheme.surface,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        border: Border.all(color: context.exerciseTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.exerciseTheme.primaryMuted.withValues(alpha: .48),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 19, color: context.exerciseTheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: context.exerciseTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: TextStyle(
              color: context.exerciseTheme.textSecondary,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    color: context.exerciseTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: context.exerciseTheme.primary,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class WorkoutDraftStructure extends StatelessWidget {
  final WorkoutDraft draft;
  final ValueChanged<WorkoutExerciseDraft> onEditExercise;
  final ValueChanged<WorkoutExerciseGroupDraft> onEditBlock;
  final ValueChanged<WorkoutExerciseDraft> onUpdateExercise;
  final ValueChanged<WorkoutExerciseGroupDraft> onUpdateBlock;
  final ValueChanged<WorkoutExerciseDraft> onOpenExercise;
  final void Function(String sectionId, int oldIndex, int newIndex) onReorder;
  final void Function(int oldIndex, int newIndex) onReorderSections;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRemoveExercise;
  final ValueChanged<String> onDuplicate;
  final ValueChanged<String> onMove;
  final ValueChanged<String?> onAddExercise;
  final VoidCallback onAddSection;
  final VoidCallback onCreateBlock;
  final ValueChanged<WorkoutSectionDraft>? onEditSection;
  final ValueChanged<WorkoutSectionDraft>? onUpdateSection;
  final ValueChanged<String>? onRemoveSection;
  final bool editable;
  final CoachlyTourTargetRegistry? tourRegistry;

  const WorkoutDraftStructure({
    super.key,
    required this.draft,
    required this.onEditExercise,
    required this.onEditBlock,
    required this.onUpdateExercise,
    required this.onUpdateBlock,
    required this.onOpenExercise,
    required this.onReorder,
    required this.onReorderSections,
    required this.onRemove,
    required this.onRemoveExercise,
    required this.onDuplicate,
    required this.onMove,
    required this.onAddExercise,
    required this.onAddSection,
    required this.onCreateBlock,
    this.onEditSection,
    this.onUpdateSection,
    this.onRemoveSection,
    this.editable = true,
    this.tourRegistry,
  });

  @override
  Widget build(BuildContext context) {
    if (draft.exerciseCount == 0 && draft.sections.isEmpty) {
      return const _WorkoutEmptyState();
    }
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: draft.sections.length,
      onReorderStart: (_) => HapticFeedback.selectionClick(),
      onReorderEnd: (_) => HapticFeedback.lightImpact(),
      onReorder: onReorderSections,
      itemBuilder: (context, sectionIndex) {
        final section = draft.sections[sectionIndex];
        return _CollapsibleDraftSection(
          key: ValueKey(section.id),
          section: section,
          sectionIndex: sectionIndex,
          editable: editable,
          onEditExercise: onEditExercise,
          onEditBlock: onEditBlock,
          onUpdateExercise: onUpdateExercise,
          onUpdateBlock: onUpdateBlock,
          onOpenExercise: onOpenExercise,
          onReorder: onReorder,
          onRemove: onRemove,
          onRemoveExercise: onRemoveExercise,
          onDuplicate: onDuplicate,
          onMove: onMove,
          onEditSection: onEditSection,
          onUpdateSection: onUpdateSection,
          onRemoveSection: onRemoveSection,
          tourRegistry: tourRegistry,
        );
      },
    );
  }
}

class _CollapsibleDraftSection extends StatefulWidget {
  final WorkoutSectionDraft section;
  final int sectionIndex;
  final bool editable;
  final ValueChanged<WorkoutExerciseDraft> onEditExercise;
  final ValueChanged<WorkoutExerciseGroupDraft> onEditBlock;
  final ValueChanged<WorkoutExerciseDraft> onUpdateExercise;
  final ValueChanged<WorkoutExerciseGroupDraft> onUpdateBlock;
  final ValueChanged<WorkoutExerciseDraft> onOpenExercise;
  final void Function(String sectionId, int oldIndex, int newIndex) onReorder;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRemoveExercise;
  final ValueChanged<String> onDuplicate;
  final ValueChanged<String> onMove;
  final ValueChanged<WorkoutSectionDraft>? onEditSection;
  final ValueChanged<WorkoutSectionDraft>? onUpdateSection;
  final ValueChanged<String>? onRemoveSection;
  final CoachlyTourTargetRegistry? tourRegistry;

  const _CollapsibleDraftSection({
    super.key,
    required this.section,
    required this.sectionIndex,
    required this.editable,
    required this.onEditExercise,
    required this.onEditBlock,
    required this.onUpdateExercise,
    required this.onUpdateBlock,
    required this.onOpenExercise,
    required this.onReorder,
    required this.onRemove,
    required this.onRemoveExercise,
    required this.onDuplicate,
    required this.onMove,
    this.onEditSection,
    this.onUpdateSection,
    this.onRemoveSection,
    this.tourRegistry,
  });

  @override
  State<_CollapsibleDraftSection> createState() =>
      _CollapsibleDraftSectionState();
}

class _CollapsibleDraftSectionState extends State<_CollapsibleDraftSection> {
  bool collapsed = false;

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    return Padding(
      padding: const EdgeInsets.only(bottom: CoachlyAthleteTheme.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OptionalTourTarget(
            id: section.kind == WorkoutSectionKind.main
                ? BuilderTourTarget.mainSectionHeader
                : 'section-${section.id}',
            registry: section.kind == WorkoutSectionKind.main
                ? widget.tourRegistry
                : null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Semantics(
                header: true,
                button: widget.editable && widget.onEditSection != null,
                child: InkWell(
                  onTap: widget.editable && widget.onEditSection != null
                      ? () => widget.onEditSection!(section)
                      : null,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Row(
                      children: [
                        if (widget.editable)
                          ReorderableDragStartListener(
                            index: widget.sectionIndex,
                            child: const _DragHandle(),
                          ),
                        Flexible(
                          child: Text(
                            workoutSectionLabel(context, section).toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CoachlyAthleteTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: Divider()),
                        IconButton(
                          onPressed: () =>
                              setState(() => collapsed = !collapsed),
                          tooltip: context.tr(
                            collapsed
                                ? 'workout.builder.expand_section'
                                : 'workout.builder.collapse_section',
                          ),
                          icon: Icon(
                            collapsed
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: context.exerciseTheme.textSecondary,
                          ),
                        ),
                        if (widget.editable &&
                            widget.onUpdateSection != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _showItemActions(
                              context,
                              initialNotes: section.notes,
                              onNotesChanged: (notes) =>
                                  widget.onUpdateSection!(
                                    section.copyWith(notes: notes),
                                  ),
                              onRemove: () =>
                                  widget.onRemoveSection?.call(section.id),
                            ),
                            tooltip: context.tr(
                              'workout.builder.section_actions',
                            ),
                            icon: const Icon(Icons.more_horiz_rounded),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (collapsed)
            const SizedBox.shrink()
          else if (section.items.isEmpty)
            const _SectionEmpty()
          else if (widget.editable)
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: section.items.length,
              onReorderStart: (_) => HapticFeedback.selectionClick(),
              onReorderEnd: (_) => HapticFeedback.lightImpact(),
              onReorder: (oldIndex, newIndex) =>
                  widget.onReorder(section.id, oldIndex, newIndex),
              proxyDecorator: (child, _, animation) => AnimatedBuilder(
                animation: animation,
                builder: (_, child) => Transform.scale(
                  scale: 1 + animation.value * .015,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 8,
                    child: child,
                  ),
                ),
                child: child,
              ),
              itemBuilder: (context, index) => _DraftItem(
                key: ValueKey(section.items[index].id),
                item: section.items[index],
                index: index,
                editable: widget.editable,
                onEditExercise: widget.onEditExercise,
                onEditBlock: widget.onEditBlock,
                onUpdateExercise: widget.onUpdateExercise,
                onUpdateBlock: widget.onUpdateBlock,
                onOpenExercise: widget.onOpenExercise,
                onRemove: widget.onRemove,
                onRemoveExercise: widget.onRemoveExercise,
                onDuplicate: widget.onDuplicate,
                onMove: widget.onMove,
              ),
            )
          else
            ...section.items.indexed.map(
              (pair) => _DraftItem(
                key: ValueKey(pair.$2.id),
                item: pair.$2,
                index: pair.$1,
                editable: false,
                onEditExercise: widget.onEditExercise,
                onEditBlock: widget.onEditBlock,
                onUpdateExercise: widget.onUpdateExercise,
                onUpdateBlock: widget.onUpdateBlock,
                onOpenExercise: widget.onOpenExercise,
                onRemove: widget.onRemove,
                onRemoveExercise: widget.onRemoveExercise,
                onDuplicate: widget.onDuplicate,
                onMove: widget.onMove,
              ),
            ),
        ],
      ),
    );
  }
}

String workoutSectionLabel(BuildContext context, WorkoutSectionDraft section) =>
    section.name?.trim().isNotEmpty == true
    ? section.name!.trim()
    : context.tr('workout.builder.section_main');

Future<String?> showWorkoutSectionPicker(
  BuildContext context,
  List<WorkoutSectionDraft> sections,
) {
  if (sections.isEmpty) return Future.value();
  if (sections.length == 1) return Future.value(sections.single.id);
  final main = sections.firstWhere(
    (section) => section.kind == WorkoutSectionKind.main,
    orElse: () => sections.first,
  );
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    backgroundColor: context.exerciseTheme.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr('workout.builder.choose_destination'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: context.exerciseTheme.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.tr('workout.builder.choose_destination_hint'),
            style: TextStyle(color: context.exerciseTheme.textSecondary),
          ),
          const SizedBox(height: 14),
          ...sections.map((section) {
            final isDefault = section.id == main.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CoachlyPressable(
                onTap: () => Navigator.pop(sheetContext, section.id),
                semanticLabel: workoutSectionLabel(context, section),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 56),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: context.exerciseTheme.surface,
                    borderRadius: BorderRadius.circular(
                      CoachlyAthleteTheme.compactRadius,
                    ),
                    border: Border.all(color: context.exerciseTheme.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workoutSectionLabel(context, section),
                              style: TextStyle(
                                color: context.exerciseTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (isDefault) ...[
                              const SizedBox(height: 2),
                              Text(
                                context.tr('workout.builder.default_section'),
                                style: TextStyle(
                                  color: context.exerciseTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        isDefault
                            ? Icons.check_circle_rounded
                            : Icons.chevron_right_rounded,
                        color: isDefault
                            ? context.exerciseTheme.primary
                            : context.exerciseTheme.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}

class _SectionEmpty extends StatelessWidget {
  const _SectionEmpty();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      context.tr('workout.builder.section_empty_hint'),
      style: TextStyle(
        color: context.exerciseTheme.textSecondary,
        fontSize: 13,
      ),
    ),
  );
}

class _WorkoutEmptyState extends StatelessWidget {
  const _WorkoutEmptyState();

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : CoachlyAthleteTheme.expandDuration,
    child: Padding(
      key: const ValueKey('workout-empty'),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('workout.builder.empty_title'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: context.exerciseTheme.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('workout.builder.empty_body'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.exerciseTheme.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    ),
  );
}

class _DraftItem extends StatelessWidget {
  final WorkoutStructureItemDraft item;
  final int index;
  final bool editable;
  final ValueChanged<WorkoutExerciseDraft> onEditExercise;
  final ValueChanged<WorkoutExerciseGroupDraft> onEditBlock;
  final ValueChanged<WorkoutExerciseDraft> onUpdateExercise;
  final ValueChanged<WorkoutExerciseGroupDraft> onUpdateBlock;
  final ValueChanged<WorkoutExerciseDraft> onOpenExercise;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRemoveExercise;
  final ValueChanged<String> onDuplicate;
  final ValueChanged<String> onMove;
  const _DraftItem({
    super.key,
    required this.item,
    required this.index,
    required this.editable,
    required this.onEditExercise,
    required this.onEditBlock,
    required this.onUpdateExercise,
    required this.onUpdateBlock,
    required this.onOpenExercise,
    required this.onRemove,
    required this.onRemoveExercise,
    required this.onDuplicate,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    if (item is WorkoutExerciseGroupDraft) {
      final group = item as WorkoutExerciseGroupDraft;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CoachlySurface(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: editable ? () => onEditBlock(group) : null,
                onLongPress: editable
                    ? () => _showItemActions(
                        context,
                        initialNotes: group.notes,
                        onNotesChanged: (notes) =>
                            onUpdateBlock(group.copyWith(notes: notes)),
                        onRemove: () => onRemove(group.id),
                      )
                    : null,
                borderRadius: BorderRadius.circular(
                  CoachlyAthleteTheme.compactRadius,
                ),
                child: Row(
                  children: [
                    if (editable)
                      ReorderableDragStartListener(
                        index: index,
                        child: const _DragHandle(),
                      ),
                    Expanded(
                      child: Text(
                        '${_groupLabel(context, group.type)} · ${context.tr(group.rounds == 1 ? 'workout.detail.round_count_one' : 'workout.detail.round_count_other', params: {'count': '${group.rounds}'})}',
                        style: const TextStyle(
                          color: CoachlyAthleteTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (editable)
                      IconButton(
                        onPressed: () => _showItemActions(
                          context,
                          initialNotes: group.notes,
                          onNotesChanged: (notes) =>
                              onUpdateBlock(group.copyWith(notes: notes)),
                          onRemove: () => onRemove(group.id),
                        ),
                        tooltip: context.tr('workout.builder.item_actions'),
                        icon: const Icon(Icons.more_horiz_rounded),
                      ),
                  ],
                ),
              ),
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: group.exercises.length,
                onReorderStart: (_) => HapticFeedback.selectionClick(),
                onReorderEnd: (_) => HapticFeedback.lightImpact(),
                onReorder: editable
                    ? (oldIndex, newIndex) {
                        final exercises = [...group.exercises];
                        if (newIndex > oldIndex) newIndex -= 1;
                        final exercise = exercises.removeAt(oldIndex);
                        exercises.insert(
                          newIndex.clamp(0, exercises.length),
                          exercise,
                        );
                        onUpdateBlock(group.copyWith(exercises: exercises));
                      }
                    : (_, _) {},
                itemBuilder: (context, exerciseIndex) {
                  final exercise = group.exercises[exerciseIndex];
                  return _ExerciseLine(
                    key: ValueKey(exercise.localId),
                    exercise: exercise,
                    prefix: 'A${exerciseIndex + 1}',
                    leading: editable
                        ? ReorderableDragStartListener(
                            index: exerciseIndex,
                            child: const _DragHandle(),
                          )
                        : null,
                    onEdit: () => onEditExercise(exercise),
                    onOpen: () => onOpenExercise(exercise),
                    onActions: editable
                        ? () => _showItemActions(
                            context,
                            initialNotes: exercise.notes,
                            onNotesChanged: (notes) => onUpdateExercise(
                              exercise.copyWith(notes: notes),
                            ),
                            onRemove: () => onRemoveExercise(exercise.localId),
                          )
                        : null,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 6),
                child: Text(
                  context.tr(
                    'workout.builder.rest_after_round',
                    params: {
                      'duration': formatDuration(group.roundRestSeconds),
                    },
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.exerciseTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final exercise = (item as WorkoutExerciseItemDraft).exercise;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        label:
            '${exercise.name}, ${context.tr('workout.builder.position', params: {'position': '${index + 1}'})}',
        child: InkWell(
          onLongPress: editable
              ? () => _showItemActions(
                  context,
                  initialNotes: exercise.notes,
                  onNotesChanged: (notes) =>
                      onUpdateExercise(exercise.copyWith(notes: notes)),
                  onRemove: () => onRemove(item.id),
                )
              : null,
          borderRadius: BorderRadius.circular(
            CoachlyAthleteTheme.compactRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                if (editable)
                  ReorderableDragStartListener(
                    index: index,
                    child: const _DragHandle(),
                  ),
                Expanded(
                  child: _ExerciseLine(
                    exercise: exercise,
                    prefix: '${index + 1}'.padLeft(2, '0'),
                    onEdit: () => onEditExercise(exercise),
                    onOpen: () => onOpenExercise(exercise),
                    onActions: editable
                        ? () => _showItemActions(
                            context,
                            initialNotes: exercise.notes,
                            onNotesChanged: (notes) => onUpdateExercise(
                              exercise.copyWith(notes: notes),
                            ),
                            onRemove: () => onRemove(item.id),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseLine extends StatelessWidget {
  final WorkoutExerciseDraft exercise;
  final String prefix;
  final VoidCallback onEdit;
  final VoidCallback onOpen;
  final VoidCallback? onActions;
  final Widget? leading;
  const _ExerciseLine({
    super.key,
    required this.exercise,
    required this.prefix,
    required this.onEdit,
    required this.onOpen,
    this.onActions,
    this.leading,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onEdit,
    borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (leading != null) leading!,
          SizedBox(
            width: 32,
            child: Text(
              prefix,
              style: const TextStyle(
                color: CoachlyAthleteTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  button: true,
                  label: context.tr(
                    'workout.builder.open_exercise_details',
                    params: {'name': exercise.name},
                  ),
                  child: InkWell(
                    onTap: onOpen,
                    borderRadius: BorderRadius.circular(
                      CoachlyAthleteTheme.compactRadius,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: CoachlyAthleteTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatPrescription(exercise),
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (onActions != null)
            SizedBox(
              width: CoachlyAthleteTheme.touchTarget,
              height: CoachlyAthleteTheme.touchTarget,
              child: IconButton(
                onPressed: onActions,
                tooltip: context.tr('workout.builder.item_actions'),
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            ),
          Semantics(
            button: true,
            label: context.tr(
              'workout.builder.open_exercise_details',
              params: {'name': exercise.name},
            ),
            child: InkWell(
              onTap: onOpen,
              borderRadius: BorderRadius.circular(
                CoachlyAthleteTheme.compactRadius,
              ),
              child: const SizedBox(
                width: 36,
                height: CoachlyAthleteTheme.touchTarget,
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: CoachlyAthleteTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: CoachlyAthleteTheme.touchTarget,
    height: CoachlyAthleteTheme.touchTarget,
    child: Icon(
      Icons.drag_indicator_rounded,
      color: CoachlyAthleteTheme.textSecondary,
    ),
  );
}

enum _ItemAction { addNotes, remove }

Future<void> _showItemActions(
  BuildContext context, {
  required String? initialNotes,
  required ValueChanged<String?> onNotesChanged,
  required VoidCallback onRemove,
}) async {
  HapticFeedback.mediumImpact();
  final action = await showModalBottomSheet<_ItemAction>(
    context: context,
    useSafeArea: true,
    backgroundColor: context.exerciseTheme.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionTile(
            icon: Icons.notes_rounded,
            label: context.tr('workout.builder.add_notes'),
            action: _ItemAction.addNotes,
          ),
          _ActionTile(
            icon: Icons.delete_outline_rounded,
            label: context.tr('common.delete'),
            action: _ItemAction.remove,
            destructive: true,
          ),
        ],
      ),
    ),
  );
  switch (action) {
    case _ItemAction.addNotes:
      if (!context.mounted) return;
      final notes = await showWorkoutNotesSheet(
        context,
        initialValue: initialNotes,
      );
      if (notes != null) onNotesChanged(notes.isEmpty ? null : notes);
    case _ItemAction.remove:
      onRemove();
    case null:
      break;
  }
}

Future<String?> showWorkoutNotesSheet(
  BuildContext context, {
  String? initialValue,
}) => showModalBottomSheet<String>(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: context.exerciseTheme.surfaceElevated,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (_) => _WorkoutNotesSheet(initialValue: initialValue),
);

class _WorkoutNotesSheet extends StatefulWidget {
  final String? initialValue;
  const _WorkoutNotesSheet({this.initialValue});

  @override
  State<_WorkoutNotesSheet> createState() => _WorkoutNotesSheetState();
}

class _WorkoutNotesSheetState extends State<_WorkoutNotesSheet> {
  late final TextEditingController controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedPadding(
    duration: CoachlyAthleteTheme.expandDuration,
    padding: EdgeInsets.fromLTRB(
      20,
      20,
      20,
      20 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr('workout.builder.notes_title'),
          style: const TextStyle(
            color: CoachlyAthleteTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          autofocus: true,
          minLines: 3,
          maxLines: 6,
          maxLength: 300,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: context.tr('workout.builder.notes_hint'),
          ),
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: Text(context.tr('workout.builder.save_notes')),
        ),
      ],
    ),
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final _ItemAction action;
  final bool destructive;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.action,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(
      icon,
      color: destructive ? Theme.of(context).colorScheme.error : null,
    ),
    title: Text(
      label,
      style: destructive
          ? TextStyle(color: Theme.of(context).colorScheme.error)
          : null,
    ),
    onTap: () => Navigator.pop(context, action),
  );
}

class NumericStepper extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final String Function(int value)? formatter;
  const NumericStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    this.formatter,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$label. ${formatter?.call(value) ?? value}',
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        decoration: BoxDecoration(
          color: context.exerciseTheme.surface,
          borderRadius: BorderRadius.circular(
            CoachlyAthleteTheme.compactRadius,
          ),
          border: Border.all(color: context.exerciseTheme.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: context.exerciseTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _StepperButton(
              icon: Icons.remove_rounded,
              tooltip: context.tr(
                'workout.builder.decrease',
                params: {'label': label},
              ),
              onPressed: value - step >= min
                  ? () {
                      HapticFeedback.selectionClick();
                      onChanged(value - step);
                    }
                  : null,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 56),
              child: Text(
                formatter?.call(value) ?? '$value',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.exerciseTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _StepperButton(
              icon: Icons.add_rounded,
              tooltip: context.tr(
                'workout.builder.increase',
                params: {'label': label},
              ),
              onPressed: value + step <= max
                  ? () {
                      HapticFeedback.selectionClick();
                      onChanged(value + step);
                    }
                  : null,
            ),
          ],
        ),
      ),
    ),
  );
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: CoachlyAthleteTheme.touchTarget,
    height: CoachlyAthleteTheme.touchTarget,
    child: IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: context.exerciseTheme.surfaceElevated,
        disabledBackgroundColor: context.exerciseTheme.surfaceElevated
            .withValues(alpha: .45),
        foregroundColor: context.exerciseTheme.primary,
        disabledForegroundColor: context.exerciseTheme.textSecondary.withValues(
          alpha: .45,
        ),
      ),
      icon: Icon(icon, size: 19),
    ),
  );
}

class RepRangeControl extends StatelessWidget {
  final String label;
  final int min;
  final int max;
  final void Function(int min, int max) onChanged;

  const RepRangeControl({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => NumericStepper(
    label: label,
    value: min,
    min: 1,
    max: 99,
    formatter: (_) => min == max ? '$min' : '$min–$max',
    onChanged: (value) {
      final delta = value - min;
      onChanged(value, (max + delta).clamp(value, 99));
    },
  );
}

class DurationStepper extends StatelessWidget {
  final String label;
  final int seconds;
  final ValueChanged<int> onChanged;

  const DurationStepper({
    super.key,
    required this.label,
    required this.seconds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => NumericStepper(
    label: label,
    value: seconds,
    min: 0,
    max: 900,
    step: 30,
    formatter: formatDuration,
    onChanged: onChanged,
  );
}

Future<WorkoutExerciseDraft?> showPrescriptionEditor(
  BuildContext context,
  WorkoutExerciseDraft initial, {
  required bool adding,
}) {
  return showModalBottomSheet<WorkoutExerciseDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.exerciseTheme.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .78,
      minChildSize: .55,
      maxChildSize: .94,
      builder: (context, scrollController) => _PrescriptionEditor(
        initial: initial,
        adding: adding,
        scrollController: scrollController,
      ),
    ),
  );
}

Future<({String name, String? notes})?> showWorkoutSectionNameSheet(
  BuildContext context, {
  WorkoutSectionDraft? initial,
}) => showModalBottomSheet<({String name, String? notes})>(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: context.exerciseTheme.surfaceElevated,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (_) => _WorkoutSectionNameSheet(initial: initial),
);

class _WorkoutSectionNameSheet extends StatefulWidget {
  final WorkoutSectionDraft? initial;
  const _WorkoutSectionNameSheet({this.initial});

  @override
  State<_WorkoutSectionNameSheet> createState() =>
      _WorkoutSectionNameSheetState();
}

class _WorkoutSectionNameSheetState extends State<_WorkoutSectionNameSheet> {
  final controller = TextEditingController();
  final nameFocus = FocusNode();
  final notesFocus = FocusNode();
  late final TextEditingController notesController = TextEditingController(
    text: widget.initial?.notes,
  );
  String selectedType = 'main';
  late bool customizing = widget.initial?.kind == WorkoutSectionKind.custom;
  late bool showNotes = widget.initial?.notes?.isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial == null) return;
    selectedType = initial.kind.name;
    if (customizing && initial.name != null) controller.text = initial.name!;
  }

  @override
  void dispose() {
    controller.dispose();
    notesController.dispose();
    nameFocus.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedPadding(
    duration: CoachlyAthleteTheme.expandDuration,
    curve: CoachlyAthleteTheme.standardCurve,
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
            context.tr(
              widget.initial == null
                  ? 'workout.builder.new_section'
                  : 'workout.builder.edit_section',
            ),
            style: TextStyle(
              color: context.exerciseTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.tr('workout.builder.section_explanation'),
            style: const TextStyle(
              color: CoachlyAthleteTheme.textSecondary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                ['preparation', 'main', 'accessories', 'finisher', 'cooldown']
                    .map(
                      (key) => _SectionPreset(
                        label: context.tr('workout.builder.section_$key'),
                        selected: selectedType == key && !customizing,
                        onTap: () => setState(() {
                          selectedType = key;
                          customizing = false;
                          controller.clear();
                        }),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: context.exerciseTheme.primary,
              ),
              onPressed: () {
                setState(() => customizing = !customizing);
                if (customizing) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => nameFocus.requestFocus(),
                  );
                }
              },
              child: Text(context.tr('workout.builder.customize')),
            ),
          ),
          AnimatedSize(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : CoachlyAthleteTheme.expandDuration,
            curve: CoachlyAthleteTheme.standardCurve,
            alignment: Alignment.topCenter,
            child: customizing
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: WorkoutBuilderUnderlineField(
                      controller: controller,
                      focusNode: nameFocus,
                      label: context.tr('workout.builder.custom_name'),
                      hint: context.tr('workout.builder.custom_section_hint'),
                      helper: context.tr('workout.builder.optional'),
                      autofocus: true,
                      maxLength: 30,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Text(
            context.tr('workout.builder.preview'),
            style: const TextStyle(
              color: CoachlyAthleteTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  _sectionName.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Divider()),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: context.exerciseTheme.primary,
              ),
              onPressed: () {
                setState(() => showNotes = !showNotes);
                if (showNotes) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => notesFocus.requestFocus(),
                  );
                }
              },
              icon: const Icon(Icons.notes_rounded),
              label: Text(context.tr('workout.builder.add_notes')),
            ),
          ),
          AnimatedSize(
            duration: CoachlyAthleteTheme.expandDuration,
            child: showNotes
                ? WorkoutBuilderUnderlineField(
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
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 22),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.exerciseTheme.primary,
              foregroundColor: context.exerciseTheme.background,
            ),
            onPressed: customizing && controller.text.trim().isEmpty
                ? null
                : _submit,
            child: Text(
              context.tr(
                widget.initial == null
                    ? 'workout.builder.add_section'
                    : 'workout.builder.save_changes',
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _submit() {
    if (customizing && controller.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    final notes = notesController.text.trim();
    Navigator.pop(context, (
      name: _sectionName,
      notes: notes.isEmpty ? null : notes,
    ));
  }

  String get _sectionName => customizing && controller.text.trim().isNotEmpty
      ? controller.text.trim()
      : context.tr('workout.builder.section_$selectedType');
}

class _SectionPreset extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SectionPreset({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => CoachlyPressable(
    onTap: onTap,
    semanticLabel: label,
    child: AnimatedContainer(
      duration: CoachlyAthleteTheme.expandDuration,
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? context.exerciseTheme.surface
            : context.exerciseTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.actionRadius),
        border: Border.all(
          color: selected
              ? context.exerciseTheme.textSecondary
              : context.exerciseTheme.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...[
            Icon(
              Icons.check_rounded,
              size: 16,
              color: context.exerciseTheme.primary,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: context.exerciseTheme.textPrimary,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class _PrescriptionEditor extends StatefulWidget {
  final WorkoutExerciseDraft initial;
  final bool adding;
  final ScrollController scrollController;
  const _PrescriptionEditor({
    required this.initial,
    required this.adding,
    required this.scrollController,
  });
  @override
  State<_PrescriptionEditor> createState() => _PrescriptionEditorState();
}

class _PrescriptionEditorState extends State<_PrescriptionEditor> {
  late int sets = widget.initial.sets;
  late int min = widget.initial.repTarget.min;
  late int max = widget.initial.repTarget.max;
  late int recovery = widget.initial.recoverySeconds;
  late final TextEditingController load = TextEditingController(
    text: widget.initial.targetLoad?.toString() ?? '',
  );
  late final TextEditingController notes = TextEditingController(
    text: widget.initial.notes,
  );
  final loadFocus = FocusNode();
  final notesFocus = FocusNode();
  @override
  void dispose() {
    load.dispose();
    notes.dispose();
    loadFocus.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          controller: widget.scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CoachlyAthleteTheme.textSecondary.withValues(
                      alpha: .45,
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                widget.initial.name,
                style: const TextStyle(
                  color: CoachlyAthleteTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr('workout.builder.programming'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: CoachlyAthleteTheme.textSecondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
              const SizedBox(height: 12),
              NumericStepper(
                label: context.tr('workout.sets'),
                value: sets,
                min: 1,
                onChanged: (v) => setState(() => sets = v),
              ),
              RepRangeControl(
                label: context.tr('workout.builder.rep_range'),
                min: min,
                max: max,
                onChanged: (newMin, newMax) => setState(() {
                  min = newMin;
                  max = newMax;
                }),
              ),
              DurationStepper(
                label: context.tr('workout.builder.rest'),
                seconds: recovery,
                onChanged: (value) => setState(() => recovery = value),
              ),
              const SizedBox(height: 18),
              _SheetSectionLabel(
                context.tr('workout.builder.target_load_heading'),
              ),
              const SizedBox(height: 10),
              WorkoutBuilderUnderlineField(
                controller: load,
                focusNode: loadFocus,
                label: context.tr('workout.detail.target_load'),
                hint: context.tr('workout.builder.from_history'),
                helper: context.tr('workout.builder.optional'),
                maxLength: 8,
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                suffixText: widget.initial.loadUnit,
                onChanged: (_) {},
              ),
              const SizedBox(height: 22),
              _SheetSectionLabel(context.tr('workout.builder.notes_title')),
              const SizedBox(height: 10),
              WorkoutBuilderUnderlineField(
                controller: notes,
                focusNode: notesFocus,
                label: context.tr('workout.builder.add_notes'),
                hint: context.tr('workout.builder.notes_hint'),
                helper: context.tr('workout.builder.optional'),
                minLines: 2,
                maxLines: 4,
                maxLength: 300,
                textInputAction: TextInputAction.done,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
      AnimatedPadding(
        duration: CoachlyAthleteTheme.expandDuration,
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          12 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          width: double.infinity,
          height: CoachlyAthleteTheme.primaryActionHeight,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.exerciseTheme.primary,
              foregroundColor: context.exerciseTheme.background,
            ),
            onPressed: () => Navigator.pop(
              context,
              widget.initial.copyWith(
                sets: sets,
                repTarget: min == max
                    ? RepTarget.fixed(min)
                    : RepTarget.range(min: min, max: max),
                recoverySeconds: recovery,
                targetLoad: double.tryParse(load.text.replaceAll(',', '.')),
                notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
              ),
            ),
            child: Text(
              context.tr(
                widget.adding
                    ? 'workout.builder.add_exercise'
                    : 'workout.builder.save_changes',
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _SheetSectionLabel extends StatelessWidget {
  final String label;
  const _SheetSectionLabel(this.label);

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(
      color: context.exerciseTheme.textSecondary,
      fontWeight: FontWeight.w800,
      letterSpacing: .8,
    ),
  );
}

Future<WorkoutExerciseGroupDraft?> showWorkoutBlockEditor(
  BuildContext context,
  WorkoutExerciseGroupDraft initial,
) => showModalBottomSheet<WorkoutExerciseGroupDraft>(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: context.exerciseTheme.surfaceElevated,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (_) => _WorkoutBlockEditor(initial: initial),
);

class _WorkoutBlockEditor extends StatefulWidget {
  final WorkoutExerciseGroupDraft initial;

  const _WorkoutBlockEditor({required this.initial});

  @override
  State<_WorkoutBlockEditor> createState() => _WorkoutBlockEditorState();
}

class _WorkoutBlockEditorState extends State<_WorkoutBlockEditor> {
  late int rounds = widget.initial.rounds;
  late int between = widget.initial.intraExerciseRestSeconds;
  late int afterRound = widget.initial.roundRestSeconds;
  late List<WorkoutExerciseDraft> exercises = [...widget.initial.exercises];
  late final TextEditingController notesController = TextEditingController(
    text: widget.initial.notes,
  );
  final notesFocus = FocusNode();

  @override
  void dispose() {
    notesController.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: .72,
    minChildSize: .5,
    maxChildSize: .92,
    builder: (context, scrollController) => Column(
      children: [
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            children: [
              Text(
                context.tr('workout.builder.configure_block'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.exerciseTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr('workout.builder.block_edit_explanation'),
                style: TextStyle(
                  color: context.exerciseTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              _SheetSectionLabel(context.tr('workout.builder.step_exercises')),
              const SizedBox(height: 10),
              CoachlySurface(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: exercises.length,
                  onReorder: (oldIndex, newIndex) => setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final exercise = exercises.removeAt(oldIndex);
                    exercises.insert(newIndex, exercise);
                  }),
                  itemBuilder: (context, index) => ListTile(
                    key: ValueKey(exercises[index].localId),
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      'A${index + 1}',
                      style: TextStyle(
                        color: context.exerciseTheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    title: Text(exercises[index].name),
                    subtitle: Text(
                      formatPrescription(exercises[index]),
                      style: TextStyle(
                        color: context.exerciseTheme.textSecondary,
                      ),
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: const SizedBox(
                        width: CoachlyAthleteTheme.touchTarget,
                        height: CoachlyAthleteTheme.touchTarget,
                        child: Icon(Icons.drag_indicator_rounded),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SheetSectionLabel(context.tr('workout.builder.step_setup')),
              const SizedBox(height: 6),
              NumericStepper(
                label: context.tr('workout.detail.rounds'),
                value: rounds,
                min: 1,
                onChanged: (value) => setState(() => rounds = value),
              ),
              DurationStepper(
                label: context.tr('workout.builder.between_exercises'),
                seconds: between,
                onChanged: (value) => setState(() => between = value),
              ),
              DurationStepper(
                label: context.tr('workout.builder.after_each_round'),
                seconds: afterRound,
                onChanged: (value) => setState(() => afterRound = value),
              ),
              const SizedBox(height: 18),
              WorkoutBuilderUnderlineField(
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
            ],
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: CoachlyAthleteTheme.primaryActionHeight,
            child: FilledButton(
              onPressed: () => Navigator.pop(
                context,
                widget.initial.copyWith(
                  exercises: exercises,
                  rounds: rounds,
                  intraExerciseRestSeconds: between,
                  roundRestSeconds: afterRound,
                  notes: notesController.text.trim().isEmpty
                      ? null
                      : notesController.text.trim(),
                ),
              ),
              child: Text(context.tr('workout.builder.save_changes')),
            ),
          ),
        ),
      ],
    ),
  );
}

String formatDuration(int seconds) =>
    '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
String formatPrescription(WorkoutExerciseDraft exercise) =>
    '${exercise.sets} × ${exercise.repTarget.compactLabel} · ${formatDuration(exercise.recoverySeconds)}';
String _groupLabel(BuildContext context, WorkoutGroupType type) =>
    context.tr(switch (type) {
      WorkoutGroupType.superset => 'workout.detail.superset',
      WorkoutGroupType.triset => 'workout.detail.triset',
      WorkoutGroupType.giantSet => 'workout.detail.giant_set',
      WorkoutGroupType.circuit => 'workout.detail.circuit',
    });
