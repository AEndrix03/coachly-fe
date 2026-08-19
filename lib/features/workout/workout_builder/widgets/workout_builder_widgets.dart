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
          if (draft.trainingGoal?.isNotEmpty == true) draft.trainingGoal!,
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

class WorkoutDraftStructure extends StatelessWidget {
  final WorkoutDraft draft;
  final ValueChanged<WorkoutExerciseDraft> onEditExercise;
  final void Function(String sectionId, int oldIndex, int newIndex) onReorder;
  final ValueChanged<String> onRemove;
  final ValueChanged<String?> onAddExercise;
  final bool editable;

  const WorkoutDraftStructure({
    super.key,
    required this.draft,
    required this.onEditExercise,
    required this.onReorder,
    required this.onRemove,
    required this.onAddExercise,
    this.editable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (draft.exerciseCount == 0 && draft.sections.isEmpty) {
      return CoachlySurface(
        child: Column(
          children: [
            const Icon(
              Icons.fitness_center_rounded,
              color: CoachlyAthleteTheme.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('workout.builder.empty'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CoachlyAthleteTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => onAddExercise(null),
              icon: const Icon(Icons.add),
              label: Text(context.tr('workout.builder.add_first_exercise')),
            ),
          ],
        ),
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
                      child: Text(
                        section.name!.toUpperCase(),
                        style: const TextStyle(
                          color: CoachlyAthleteTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .75,
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
                          scale: 1 + animation.value * .025,
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
                        onRemove: onRemove,
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
                        onRemove: onRemove,
                      ),
                    ),
                  if (editable && section.items.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => onAddExercise(section.id),
                        icon: const Icon(Icons.add),
                        label: Text(context.tr('workout.builder.add')),
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

class _DraftItem extends StatelessWidget {
  final WorkoutStructureItemDraft item;
  final int index;
  final bool editable;
  final ValueChanged<WorkoutExerciseDraft> onEditExercise;
  final ValueChanged<String> onRemove;
  const _DraftItem({
    super.key,
    required this.item,
    required this.index,
    required this.editable,
    required this.onEditExercise,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (item is WorkoutExerciseGroupDraft) {
      final group = item as WorkoutExerciseGroupDraft;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CoachlySurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                    _RemoveButton(onRemove: () => onRemove(group.id)),
                ],
              ),
              ...group.exercises.indexed.map(
                (pair) => _ExerciseLine(
                  exercise: pair.$2,
                  prefix: '${String.fromCharCode(65 + index)}${pair.$1 + 1}',
                  onTap: () => onEditExercise(pair.$2),
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
        child: CoachlySurface(
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
                  onTap: () => onEditExercise(exercise),
                ),
              ),
              if (editable) _RemoveButton(onRemove: () => onRemove(item.id)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseLine extends StatelessWidget {
  final WorkoutExerciseDraft exercise;
  final String prefix;
  final VoidCallback onTap;
  const _ExerciseLine({
    required this.exercise,
    required this.prefix,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
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
                Text(
                  exercise.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercise.sets} × ${exercise.repTarget.compactLabel} · ${formatDuration(exercise.recoverySeconds)}',
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

class _RemoveButton extends StatelessWidget {
  final VoidCallback onRemove;
  const _RemoveButton({required this.onRemove});
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onRemove,
    tooltip: context.tr('common.delete'),
    icon: const Icon(Icons.close, color: CoachlyAthleteTheme.textSecondary),
  );
}

class NumericStepper extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  const NumericStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$label. $value',
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
          onPressed: value > min
              ? () {
                  HapticFeedback.selectionClick();
                  onChanged(value - 1);
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
            '$value',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: value < max
              ? () {
                  HapticFeedback.selectionClick();
                  onChanged(value + 1);
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
    builder: (_) => _PrescriptionEditor(initial: initial, adding: adding),
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
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['preparation', 'main', 'accessories', 'finisher']
                .map(
                  (key) => ActionChip(
                    label: Text(context.tr('workout.builder.section_$key')),
                    onPressed: () => Navigator.pop(
                      context,
                      context.tr('workout.builder.section_$key'),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: context.tr('workout.builder.custom_name'),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _submit,
            child: Text(context.tr('workout.builder.add_section')),
          ),
        ],
      ),
    ),
  );

  void _submit() {
    final value = controller.text.trim();
    if (value.isNotEmpty) Navigator.pop(context, value);
  }
}

class _PrescriptionEditor extends StatefulWidget {
  final WorkoutExerciseDraft initial;
  final bool adding;
  const _PrescriptionEditor({required this.initial, required this.adding});
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
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      12,
      20,
      20 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CoachlyAthleteTheme.textSecondary.withValues(alpha: .45),
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
            style: const TextStyle(color: CoachlyAthleteTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          NumericStepper(
            label: context.tr('workout.sets'),
            value: sets,
            min: 1,
            onChanged: (v) => setState(() => sets = v),
          ),
          NumericStepper(
            label: context.tr('workout.builder.reps_min'),
            value: min,
            min: 1,
            onChanged: (v) => setState(() {
              min = v;
              if (max < min) max = min;
            }),
          ),
          NumericStepper(
            label: context.tr('workout.builder.reps_max'),
            value: max,
            min: min,
            onChanged: (v) => setState(() => max = v),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('workout.detail.recovery'),
            style: const TextStyle(
              color: CoachlyAthleteTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [30, 60, 90, 120, 180]
                .map(
                  (seconds) => ChoiceChip(
                    selected: recovery == seconds,
                    label: Text(formatDuration(seconds)),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => recovery = seconds);
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: load,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: InputDecoration(
              labelText: context.tr('workout.detail.target_load'),
              suffixText: widget.initial.loadUnit,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: CoachlyAthleteTheme.touchTarget,
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
        ],
      ),
    ),
  );
}

String formatDuration(int seconds) =>
    '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
String _groupLabel(BuildContext context, WorkoutGroupType type) =>
    context.tr(switch (type) {
      WorkoutGroupType.superset => 'workout.detail.superset',
      WorkoutGroupType.triset => 'workout.detail.triset',
      WorkoutGroupType.giantSet => 'workout.detail.giant_set',
      WorkoutGroupType.circuit => 'workout.detail.circuit',
    });
