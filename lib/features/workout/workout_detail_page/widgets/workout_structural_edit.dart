import 'dart:math';

import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/providers/workout_edit_draft_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_programming_model.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutStructuralEdit extends ConsumerWidget {
  final String workoutId;
  final WorkoutDetailViewData viewData;
  final VoidCallback onAddExercise;

  const WorkoutStructuralEdit({
    super.key,
    required this.workoutId,
    required this.viewData,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutEditDraftProvider(workoutId));
    final notifier = ref.read(workoutEditDraftProvider(workoutId).notifier);
    final exercises = {
      for (final exercise in _allExercises(viewData))
        exercise.instanceId: exercise,
    };
    return Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.error != null) ...[
            Text(
              state.error!,
              style: const TextStyle(color: CoachlyAthleteTheme.danger),
            ),
            const SizedBox(height: 12),
          ],
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: state.blocks.length,
            onReorder: (oldIndex, newIndex) {
              HapticFeedback.lightImpact();
              notifier.moveBlock(
                oldIndex,
                newIndex > oldIndex ? newIndex - 1 : newIndex,
              );
            },
            itemBuilder: (context, index) {
              final block = state.blocks[index];
              return Padding(
                key: ValueKey(block.id),
                padding: const EdgeInsets.only(bottom: 10),
                child: _EditableBlock(
                  index: index,
                  block: block,
                  exercises: exercises,
                  dragHandle: ReorderableDragStartListener(
                    index: index,
                    child: const SizedBox(
                      width: 44,
                      height: 48,
                      child: Icon(
                        Icons.drag_handle_rounded,
                        color: CoachlyAthleteTheme.textSecondary,
                      ),
                    ),
                  ),
                  onEdit: block.entries.length == 1
                      ? () => WorkoutExerciseQuickEditSheet.show(
                          context,
                          exercise: exercises[block.entries.single.id],
                          entry: block.entries.single,
                          onSave:
                              ({
                                required sets,
                                required repsMin,
                                required repsMax,
                                required restSeconds,
                                required intensityType,
                                intensityMin,
                                intensityMax,
                              }) => notifier.updatePrescription(
                                instanceId: block.entries.single.id,
                                sets: sets,
                                repsMin: repsMin,
                                repsMax: repsMax,
                                restSeconds: restSeconds,
                                intensityType: intensityType,
                                intensityMin: intensityMin,
                                intensityMax: intensityMax,
                              ),
                        )
                      : null,
                  onDuplicate: () =>
                      notifier.duplicateExercise(block.entries.first.id),
                  onRemove: () {
                    final beforeRemoval = [...state.blocks];
                    final removed = block.entries.first.id;
                    notifier.removeExercise(removed);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.tr('workout.detail.exercise_removed'),
                        ),
                        action: SnackBarAction(
                          label: context.tr('common.undo'),
                          onPressed: () => notifier.restoreBlocks(beforeRemoval),
                        ),
                      ),
                    );
                  },
                  onUngroup: block.entries.length > 1
                      ? () => notifier.ungroup(block.id)
                      : null,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onAddExercise,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: CoachlyAthleteTheme.primary,
              foregroundColor: CoachlyAthleteTheme.background,
            ),
            icon: const Icon(Icons.add_rounded),
            label: Text(context.tr('workout.detail.add_exercise')),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: state.blocks.isEmpty
                ? null
                : () => _addSection(context, notifier),
            style: _secondaryStyle(),
            icon: const Icon(Icons.view_agenda_outlined),
            label: Text(context.tr('workout.detail.add_section')),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: state.blocks.length < 2
                ? null
                : () => _createGroup(context, state, notifier, exercises),
            style: _secondaryStyle(),
            icon: const Icon(Icons.link_rounded),
            label: Text(context.tr('workout.detail.create_group')),
          ),
        ],
      ),
    );
  }

  ButtonStyle _secondaryStyle() => OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(50),
    foregroundColor: CoachlyAthleteTheme.textPrimary,
    side: const BorderSide(color: CoachlyAthleteTheme.border),
  );

  Future<void> _addSection(
    BuildContext context,
    WorkoutEditDraft notifier,
  ) async {
    final controller = TextEditingController();
    var kind = 'main';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CoachlyAthleteTheme.surfaceElevated,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
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
                context.tr('workout.detail.add_section'),
                style: const TextStyle(
                  color: CoachlyAthleteTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: ['preparation', 'main', 'accessory', 'custom'].map((
                  value,
                ) {
                  return ChoiceChip(
                    selected: kind == value,
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setSheetState(() => kind = value);
                    },
                    label: Text(context.tr('workout.detail.section_$value')),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: CoachlyAthleteTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: context.tr('workout.detail.section_name'),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  notifier.addSection(title: controller.text, kind: kind);
                  Navigator.pop(sheetContext);
                },
                child: Text(context.tr('common.confirm')),
              ),
            ],
          ),
        ),
      ),
    );
    controller.dispose();
  }

  Future<void> _createGroup(
    BuildContext context,
    WorkoutEditDraftState state,
    WorkoutEditDraft notifier,
    Map<String, WorkoutExerciseViewData> exercises,
  ) async {
    final selected = <String>{};
    var type = 'superset';
    var rounds = 3;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CoachlyAthleteTheme.surfaceElevated,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.tr('workout.detail.create_group'),
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'superset',
                      label: Text(context.tr('workout.detail.superset')),
                    ),
                    ButtonSegment(
                      value: 'circuit',
                      label: Text(context.tr('workout.detail.circuit')),
                    ),
                  ],
                  selected: {type},
                  onSelectionChanged: (value) =>
                      setSheetState(() => type = value.single),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: state.blocks.expand((block) => block.entries).map(
                      (entry) {
                        return CheckboxListTile(
                          value: selected.contains(entry.id),
                          title: Text(
                            exercises[entry.id]?.name ?? entry.exerciseId,
                            style: const TextStyle(
                              color: CoachlyAthleteTheme.textPrimary,
                            ),
                          ),
                          onChanged: (value) => setSheetState(() {
                            value == true
                                ? selected.add(entry.id)
                                : selected.remove(entry.id);
                          }),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Row(
                  children: [
                    Text(context.tr('workout.detail.rounds')),
                    const Spacer(),
                    IconButton(
                      onPressed: rounds > 1
                          ? () => setSheetState(() => rounds--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$rounds'),
                    IconButton(
                      onPressed: () => setSheetState(() => rounds++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: selected.length < 2
                      ? null
                      : () {
                          notifier.createGroup(
                            type: type,
                            instanceIds: selected.toList(),
                            rounds: rounds,
                          );
                          Navigator.pop(sheetContext);
                        },
                  child: Text(context.tr('common.confirm')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditableBlock extends StatelessWidget {
  final int index;
  final WorkoutProgrammingBlockModel block;
  final Map<String, WorkoutExerciseViewData> exercises;
  final Widget dragHandle;
  final VoidCallback? onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onRemove;
  final VoidCallback? onUngroup;

  const _EditableBlock({
    required this.index,
    required this.block,
    required this.exercises,
    required this.dragHandle,
    required this.onEdit,
    required this.onDuplicate,
    required this.onRemove,
    required this.onUngroup,
  });

  @override
  Widget build(BuildContext context) {
    final names = block.entries
        .map((entry) => exercises[entry.id]?.name ?? entry.exerciseId)
        .join(' · ');
    final group = block.groupType == 'superset' || block.groupType == 'circuit';
    return CoachlySurface(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      child: Row(
        children: [
          dragHandle,
          SizedBox(
            width: 30,
            child: Text(
              group
                  ? String.fromCharCode(65 + index.clamp(0, 25))
                  : '${index + 1}',
              style: const TextStyle(
                color: CoachlyAthleteTheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (group)
                  Text(
                    '${block.groupType!.toUpperCase()} · ${block.rounds ?? 1} round',
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                Text(
                  names,
                  maxLines: 2,
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            constraints: const BoxConstraints(minWidth: 180),
            color: CoachlyAthleteTheme.surfaceElevated,
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit?.call();
                case 'duplicate':
                  onDuplicate();
                case 'ungroup':
                  onUngroup?.call();
                case 'remove':
                  onRemove();
              }
            },
            itemBuilder: (_) => [
              if (onEdit != null)
                PopupMenuItem(
                  value: 'edit',
                  child: Text(context.tr('common.edit')),
                ),
              PopupMenuItem(
                value: 'duplicate',
                child: Text(context.tr('common.duplicate')),
              ),
              if (onUngroup != null)
                PopupMenuItem(
                  value: 'ungroup',
                  child: Text(context.tr('workout.detail.ungroup')),
                ),
              PopupMenuItem(
                value: 'remove',
                child: Text(
                  context.tr('common.delete'),
                  style: const TextStyle(color: CoachlyAthleteTheme.danger),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

typedef PrescriptionSave =
    void Function({
      required int sets,
      required int? repsMin,
      required int? repsMax,
      required int restSeconds,
      required String intensityType,
      double? intensityMin,
      double? intensityMax,
    });

class WorkoutExerciseQuickEditSheet extends StatefulWidget {
  final WorkoutExerciseViewData? exercise;
  final WorkoutProgrammingEntryModel entry;
  final PrescriptionSave onSave;

  const WorkoutExerciseQuickEditSheet({
    super.key,
    required this.exercise,
    required this.entry,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required WorkoutExerciseViewData? exercise,
    required WorkoutProgrammingEntryModel entry,
    required PrescriptionSave onSave,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: CoachlyAthleteTheme.surfaceElevated,
    builder: (_) => WorkoutExerciseQuickEditSheet(
      exercise: exercise,
      entry: entry,
      onSave: onSave,
    ),
  );

  @override
  State<WorkoutExerciseQuickEditSheet> createState() =>
      _WorkoutExerciseQuickEditSheetState();
}

class _WorkoutExerciseQuickEditSheetState
    extends State<WorkoutExerciseQuickEditSheet>
    with SingleTickerProviderStateMixin {
  late final TabController tabs;
  late int sets;
  late final TextEditingController repsMin;
  late final TextEditingController repsMax;
  late final TextEditingController rest;
  late final TextEditingController intensity;
  String intensityType = 'none';

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 3, vsync: this);
    final first = widget.entry.sets.firstOrNull;
    sets = widget.entry.sets.isEmpty ? 1 : widget.entry.sets.length;
    repsMin = TextEditingController(
      text: '${first?.repsMin ?? first?.reps ?? ''}',
    );
    repsMax = TextEditingController(
      text: '${first?.repsMax ?? first?.reps ?? ''}',
    );
    rest = TextEditingController(text: '${first?.restSeconds ?? 120}');
    intensityType = first?.intensityType ?? 'none';
    intensity = TextEditingController(text: '${first?.intensityMin ?? ''}');
  }

  @override
  void dispose() {
    tabs.dispose();
    repsMin.dispose();
    repsMax.dispose();
    rest.dispose();
    intensity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: min(MediaQuery.sizeOf(context).height * .78, 650),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('workout.detail.edit_exercise'),
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    widget.exercise?.name ?? widget.entry.exerciseId,
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: tabs,
              tabs: [
                Tab(text: context.tr('workout.detail.base')),
                Tab(text: context.tr('workout.detail.intensity')),
                Tab(text: context.tr('workout.detail.advanced')),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabs,
                children: [
                  _baseTab(context),
                  _intensityTab(context),
                  Center(
                    child: Text(
                      context.tr('workout.detail.advanced_progressive'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.tr('common.cancel')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        widget.onSave(
                          sets: sets,
                          repsMin: int.tryParse(repsMin.text),
                          repsMax: int.tryParse(repsMax.text),
                          restSeconds: int.tryParse(rest.text) ?? 0,
                          intensityType: intensityType,
                          intensityMin: double.tryParse(
                            intensity.text.replaceAll(',', '.'),
                          ),
                          intensityMax: double.tryParse(
                            intensity.text.replaceAll(',', '.'),
                          ),
                        );
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                      },
                      child: Text(context.tr('common.confirm')),
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

  Widget _baseTab(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      _EditorLabel(context.tr('workout.sets')),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: sets > 1 ? () => setState(() => sets--) : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 64,
            child: Center(
              child: Text(
                '$sets',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => sets++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      _EditorLabel(context.tr('workout.reps')),
      Row(
        children: [
          Expanded(child: _numberField(repsMin)),
          const Padding(padding: EdgeInsets.all(12), child: Text('—')),
          Expanded(child: _numberField(repsMax)),
        ],
      ),
      const SizedBox(height: 18),
      _EditorLabel(
        '${context.tr('workout.detail.rest')} (${context.tr('common.seconds')})',
      ),
      _numberField(rest),
    ],
  );

  Widget _intensityTab(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Wrap(
        spacing: 8,
        children: ['none', 'rir', 'rpe', 'percentage_1rm'].map((type) {
          return ChoiceChip(
            selected: intensityType == type,
            label: Text(
              type == 'none'
                  ? context.tr('workout.detail.none')
                  : type.replaceAll('_', '').toUpperCase(),
            ),
            onSelected: (_) {
              HapticFeedback.selectionClick();
              setState(() => intensityType = type);
            },
          );
        }).toList(),
      ),
      if (intensityType != 'none') ...[
        const SizedBox(height: 24),
        _EditorLabel(intensityType.replaceAll('_', '').toUpperCase()),
        _numberField(intensity, decimal: true),
      ],
    ],
  );

  Widget _numberField(
    TextEditingController controller, {
    bool decimal = false,
  }) => TextField(
    controller: controller,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    style: const TextStyle(
      color: CoachlyAthleteTheme.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _EditorLabel extends StatelessWidget {
  final String text;
  const _EditorLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: CoachlyAthleteTheme.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

Iterable<WorkoutExerciseViewData> _allExercises(
  WorkoutDetailViewData workout,
) sync* {
  for (final block in workout.sections.expand((section) => section.blocks)) {
    switch (block) {
      case WorkoutExerciseBlockViewData():
        yield block.exercise;
      case WorkoutGroupBlockViewData():
        yield* block.exercises;
    }
  }
}
