import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final String? exerciseLabel;
  final VoidCallback onAddSection;
  final VoidCallback onCreateBlock;

  const WorkoutStructureComposer({
    super.key,
    required this.onAddExercise,
    this.exerciseLabel,
    required this.onAddSection,
    required this.onCreateBlock,
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
          SizedBox(
            height: CoachlyAthleteTheme.primaryActionHeight,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: context.exerciseTheme.surfaceElevated,
                foregroundColor: context.exerciseTheme.textPrimary,
                side: BorderSide(color: context.exerciseTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CoachlyAthleteTheme.actionRadius,
                  ),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              icon: Icon(
                Icons.add_rounded,
                size: 22,
                color: context.exerciseTheme.primary,
              ),
              label: Text(
                exerciseLabel ?? context.tr('workout.builder.add_exercise'),
              ),
              onPressed: onAddExercise,
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _StructureActionCard(
                    icon: Icons.view_agenda_outlined,
                    title: context.tr('workout.builder.sections_hint_title'),
                    body: context.tr('workout.builder.sections_hint_body'),
                    actionLabel: context.tr('workout.builder.add_section'),
                    onTap: onAddSection,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
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
              ],
            ),
          ),
        ],
      ),
    ),
  );
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

  const WorkoutDraftStructure({
    super.key,
    required this.draft,
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
    required this.onAddExercise,
    required this.onAddSection,
    required this.onCreateBlock,
    this.onEditSection,
    this.onUpdateSection,
    this.onRemoveSection,
    this.editable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (draft.exerciseCount == 0 && draft.sections.isEmpty) {
      return const _WorkoutEmptyState();
    }
    return Column(
      children: draft.sections
          .map(
            (section) => Padding(
              padding: const EdgeInsets.only(
                bottom: CoachlyAthleteTheme.sectionGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (section.name != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Semantics(
                        header: true,
                        button: editable && onEditSection != null,
                        child: InkWell(
                          onTap: editable && onEditSection != null
                              ? () => onEditSection!(section)
                              : null,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 44),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    section.name!.toUpperCase(),
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
                                if (editable && onUpdateSection != null) ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () => _showItemActions(
                                      context,
                                      initialNotes: section.notes,
                                      onNotesChanged: (notes) =>
                                          onUpdateSection!(
                                            section.copyWith(notes: notes),
                                          ),
                                      onRemove: () =>
                                          onRemoveSection?.call(section.id),
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
                  if (section.items.isEmpty)
                    const _SectionEmpty()
                  else if (editable)
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: section.items.length,
                      onReorderStart: (_) => HapticFeedback.selectionClick(),
                      onReorderEnd: (_) => HapticFeedback.lightImpact(),
                      onReorder: (oldIndex, newIndex) =>
                          onReorder(section.id, oldIndex, newIndex),
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
                        editable: editable,
                        onEditExercise: onEditExercise,
                        onEditBlock: onEditBlock,
                        onUpdateExercise: onUpdateExercise,
                        onUpdateBlock: onUpdateBlock,
                        onOpenExercise: onOpenExercise,
                        onRemove: onRemove,
                        onRemoveExercise: onRemoveExercise,
                        onDuplicate: onDuplicate,
                        onMove: onMove,
                      ),
                    )
                  else
                    ...section.items.indexed.map(
                      (pair) => _DraftItem(
                        key: ValueKey(pair.$2.id),
                        item: pair.$2,
                        index: pair.$1,
                        editable: false,
                        onEditExercise: onEditExercise,
                        onEditBlock: onEditBlock,
                        onUpdateExercise: onUpdateExercise,
                        onUpdateBlock: onUpdateBlock,
                        onOpenExercise: onOpenExercise,
                        onRemove: onRemove,
                        onRemoveExercise: onRemoveExercise,
                        onDuplicate: onDuplicate,
                        onMove: onMove,
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
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
              ...group.exercises.indexed.map(
                (pair) => _ExerciseLine(
                  exercise: pair.$2,
                  prefix: 'A${pair.$1 + 1}',
                  onEdit: () => onEditExercise(pair.$2),
                  onOpen: () => onOpenExercise(pair.$2),
                  onActions: editable
                      ? () => _showItemActions(
                          context,
                          initialNotes: pair.$2.notes,
                          onNotesChanged: (notes) =>
                              onUpdateExercise(pair.$2.copyWith(notes: notes)),
                          onRemove: () => onRemoveExercise(pair.$2.localId),
                        )
                      : null,
                ),
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
  const _ExerciseLine({
    required this.exercise,
    required this.prefix,
    required this.onEdit,
    required this.onOpen,
    this.onActions,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onEdit,
    borderRadius: BorderRadius.circular(CoachlyAthleteTheme.compactRadius),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
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
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: value - step >= min
              ? () {
                  HapticFeedback.selectionClick();
                  onChanged(value - step);
                }
              : null,
          tooltip: context.tr(
            'workout.builder.decrease',
            params: {'label': label},
          ),
          icon: const Icon(Icons.remove),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44),
          child: Text(
            formatter?.call(value) ?? '$value',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: value + step <= max
              ? () {
                  HapticFeedback.selectionClick();
                  onChanged(value + step);
                }
              : null,
          tooltip: context.tr(
            'workout.builder.increase',
            params: {'label': label},
          ),
          icon: const Icon(Icons.add),
        ),
      ],
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
  late final TextEditingController notesController = TextEditingController(
    text: widget.initial?.notes,
  );
  String selectedType = 'main';
  late bool customizing = widget.initial != null;
  late bool showNotes = widget.initial?.notes?.isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    if (widget.initial?.name != null) controller.text = widget.initial!.name!;
  }

  @override
  void dispose() {
    controller.dispose();
    notesController.dispose();
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
            context.tr('workout.builder.new_section'),
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
                      (key) => ChoiceChip(
                        selected: selectedType == key,
                        label: Text(context.tr('workout.builder.section_$key')),
                        onSelected: (_) => setState(() {
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
              onPressed: () => setState(() => customizing = !customizing),
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
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      maxLength: 30,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: context.tr('workout.builder.custom_name'),
                        hintText: context.tr(
                          'workout.builder.custom_section_hint',
                        ),
                        filled: false,
                        border: const UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.exerciseTheme.border,
                          ),
                        ),
                      ),
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
              onPressed: () => setState(() => showNotes = !showNotes),
              icon: const Icon(Icons.notes_rounded),
              label: Text(context.tr('workout.builder.add_notes')),
            ),
          ),
          AnimatedSize(
            duration: CoachlyAthleteTheme.expandDuration,
            child: showNotes
                ? TextField(
                    controller: notesController,
                    minLines: 2,
                    maxLines: 4,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText: context.tr('workout.builder.notes_hint'),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: customizing && controller.text.trim().isEmpty
                ? null
                : _submit,
            child: Text(context.tr('workout.builder.add_section')),
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
  @override
  void dispose() {
    load.dispose();
    notes.dispose();
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 22),
              Text(
                context.tr('workout.builder.target_load_heading'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: CoachlyAthleteTheme.textSecondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: load,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: context.tr('workout.detail.target_load'),
                  hintText: context.tr('workout.builder.from_history'),
                  suffixText: widget.initial.loadUnit,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notes,
                minLines: 2,
                maxLines: 4,
                maxLength: 300,
                decoration: InputDecoration(
                  labelText: context.tr('workout.builder.add_notes'),
                  hintText: context.tr('workout.builder.notes_hint'),
                ),
              ),
              const SizedBox(height: 22),
              _ProgrammingFutureRow(
                label: context.tr('workout.builder.intensity'),
                value: context.tr('workout.builder.not_configured'),
              ),
              _ProgrammingFutureRow(
                label: context.tr('workout.builder.progression'),
                value: context.tr('workout.builder.manual'),
              ),
              _ProgrammingFutureRow(
                label: context.tr('workout.builder.advanced'),
                value: context.tr('workout.builder.advanced_summary'),
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

class _ProgrammingFutureRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProgrammingFutureRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(color: CoachlyAthleteTheme.textSecondary),
          ),
        ),
      ],
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

  @override
  void dispose() {
    notesController.dispose();
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: context.exerciseTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              ReorderableListView.builder(
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
                  leading: Text('A${index + 1}'),
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
              const SizedBox(height: 12),
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
