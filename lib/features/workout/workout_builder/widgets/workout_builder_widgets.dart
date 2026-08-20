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

class WorkoutStructureHints extends StatelessWidget {
  final VoidCallback? onCreateBlock;

  const WorkoutStructureHints({super.key, this.onCreateBlock});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: _StructureHint(
          icon: Icons.view_agenda_outlined,
          title: context.tr('workout.builder.sections_hint_title'),
          body: context.tr('workout.builder.sections_hint_body'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _StructureHint(
          icon: Icons.link_rounded,
          title: context.tr('workout.builder.blocks_hint_title'),
          body: context.tr('workout.builder.blocks_hint_body'),
          actionLabel: onCreateBlock == null
              ? null
              : context.tr('workout.builder.create_superset_short'),
          onAction: onCreateBlock,
        ),
      ),
    ],
  );
}

class _StructureHint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StructureHint({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: CoachlyAthleteTheme.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textSecondary,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 3),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 44),
                alignment: Alignment.centerLeft,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    ),
  );
}

class WorkoutDraftStructure extends StatelessWidget {
  final WorkoutDraft draft;
  final ValueChanged<WorkoutExerciseDraft> onEditExercise;
  final ValueChanged<WorkoutExerciseGroupDraft> onEditBlock;
  final ValueChanged<WorkoutExerciseDraft> onOpenExercise;
  final void Function(String sectionId, int oldIndex, int newIndex) onReorder;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onDuplicate;
  final ValueChanged<String> onMove;
  final ValueChanged<String?> onAddExercise;
  final VoidCallback onAddSection;
  final VoidCallback onCreateBlock;
  final bool editable;

  const WorkoutDraftStructure({
    super.key,
    required this.draft,
    required this.onEditExercise,
    required this.onEditBlock,
    required this.onOpenExercise,
    required this.onReorder,
    required this.onRemove,
    required this.onDuplicate,
    required this.onMove,
    required this.onAddExercise,
    required this.onAddSection,
    required this.onCreateBlock,
    this.editable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (draft.exerciseCount == 0 && draft.sections.isEmpty) {
      return _WorkoutEmptyState(
        onAddExercise: () => onAddExercise(null),
        onAddSection: onAddSection,
      );
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
                          ],
                        ),
                      ),
                    ),
                  if (section.items.isEmpty)
                    _SectionEmpty(onAdd: () => onAddExercise(section.id))
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
                        onOpenExercise: onOpenExercise,
                        onRemove: onRemove,
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
                        onOpenExercise: onOpenExercise,
                        onRemove: onRemove,
                        onDuplicate: onDuplicate,
                        onMove: onMove,
                      ),
                    ),
                  if (editable && section.items.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => onAddExercise(section.id),
                        icon: const Icon(Icons.add),
                        label: Text(
                          context.tr(
                            'workout.builder.add_exercise_to_section',
                            params: {
                              'section':
                                  section.name ??
                                  context.tr('workout.builder.main_section'),
                            },
                          ),
                        ),
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
  final VoidCallback onAdd;
  const _SectionEmpty({required this.onAdd});
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onAdd,
    icon: const Icon(Icons.add),
    label: Text(context.tr('workout.builder.section_empty')),
  );
}

class _WorkoutEmptyState extends StatelessWidget {
  final VoidCallback onAddExercise;
  final VoidCallback onAddSection;

  const _WorkoutEmptyState({
    required this.onAddExercise,
    required this.onAddSection,
  });

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
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAddExercise,
            icon: const Icon(Icons.add),
            label: Text(context.tr('workout.builder.add_first_exercise')),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onAddSection,
            child: Text(context.tr('workout.builder.add_section')),
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
  final ValueChanged<WorkoutExerciseDraft> onOpenExercise;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onDuplicate;
  final ValueChanged<String> onMove;
  const _DraftItem({
    super.key,
    required this.item,
    required this.index,
    required this.editable,
    required this.onEditExercise,
    required this.onEditBlock,
    required this.onOpenExercise,
    required this.onRemove,
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
                        onEdit: () => onEditBlock(group),
                        onDuplicate: () => onDuplicate(group.id),
                        onMove: () => onMove(group.id),
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
                      const SizedBox(
                        width: CoachlyAthleteTheme.touchTarget,
                        height: CoachlyAthleteTheme.touchTarget,
                        child: Icon(Icons.chevron_right),
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
                  onEdit: () => onEditExercise(exercise),
                  onDuplicate: () => onDuplicate(item.id),
                  onMove: () => onMove(item.id),
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
  const _ExerciseLine({
    required this.exercise,
    required this.prefix,
    required this.onEdit,
    required this.onOpen,
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
                          const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: CoachlyAthleteTheme.textSecondary,
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

enum _ItemAction { edit, duplicate, move, remove }

Future<void> _showItemActions(
  BuildContext context, {
  required VoidCallback onEdit,
  required VoidCallback onDuplicate,
  required VoidCallback onMove,
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
            icon: Icons.tune_rounded,
            label: context.tr('common.edit'),
            action: _ItemAction.edit,
          ),
          _ActionTile(
            icon: Icons.copy_rounded,
            label: context.tr('common.duplicate'),
            action: _ItemAction.duplicate,
          ),
          _ActionTile(
            icon: Icons.drive_file_move_outline,
            label: context.tr('workout.builder.move'),
            action: _ItemAction.move,
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
    case _ItemAction.edit:
      onEdit();
    case _ItemAction.duplicate:
      onDuplicate();
    case _ItemAction.move:
      onMove();
    case _ItemAction.remove:
      onRemove();
    case null:
      break;
  }
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

Future<String?> showWorkoutSectionNameSheet(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.exerciseTheme.surfaceElevated,
      builder: (_) => const _WorkoutSectionNameSheet(),
    );

class _WorkoutSectionNameSheet extends StatefulWidget {
  const _WorkoutSectionNameSheet();

  @override
  State<_WorkoutSectionNameSheet> createState() =>
      _WorkoutSectionNameSheetState();
}

class _WorkoutSectionNameSheetState extends State<_WorkoutSectionNameSheet> {
  final controller = TextEditingController();
  String selectedType = 'main';
  bool customizing = false;

  @override
  void dispose() {
    controller.dispose();
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
    Navigator.pop(context, _sectionName);
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
  @override
  void dispose() {
    load.dispose();
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
