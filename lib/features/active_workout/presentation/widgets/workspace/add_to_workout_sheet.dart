import 'dart:async';
import 'package:coachly/core/assets/app_assets.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_callbacks.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

/// Aggiungere un esercizio o un blocco durante l'allenamento.
///
/// Il rack occupato e' un fatto, non un'eccezione: la struttura si
/// cambia mentre si sta allenando.
class AddToWorkoutSheet extends StatefulWidget {
  final VoidCallback onAddSet;
  final VoidCallback onAddExercise;
  final List<({String id, String name})> exercises;
  final String? initiallySelectedId;
  final BlockExerciseAdd onAddBlockExercise;
  final BlockCreate onCreateGroup;

  const AddToWorkoutSheet({
    super.key,
    required this.onAddSet,
    required this.onAddExercise,
    required this.exercises,
    required this.initiallySelectedId,
    required this.onAddBlockExercise,
    required this.onCreateGroup,
  });

  @override
  State<AddToWorkoutSheet> createState() => AddToWorkoutSheetState();
}

class AddToWorkoutSheetState extends State<AddToWorkoutSheet> {
  ExerciseGroupType? _blockType;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.sizeOf(context).height -
            MediaQuery.paddingOf(context).top -
            context.spacing.xxl,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spacing.lg,
          0,
          context.spacing.lg,
          context.spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_blockType != null)
                  IconButton(
                    onPressed: () => setState(() => _blockType = null),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: motion.resolve(context, motion.standard),
                    child: Text(
                      _blockType == null
                          ? context.l10n.workoutActiveAddTitle
                          : blockTitle(_blockType!),
                      key: ValueKey(_blockType),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            SizedBox(height: context.spacing.sm),
            Flexible(
              child: AnimatedSwitcher(
                duration: motion.resolve(context, motion.standard),
                switchInCurve: motion.enter,
                switchOutCurve: motion.exit,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: child,
                  ),
                ),
                child: _blockType == null
                    ? AddToWorkoutOverview(
                        key: const ValueKey('add-overview'),
                        onAddSet: widget.onAddSet,
                        onAddExercise: widget.onAddExercise,
                        onBlock: (type) => setState(() => _blockType = type),
                      )
                    : InlineBlockBuilder(
                        key: ValueKey(_blockType),
                        type: _blockType!,
                        exercises: widget.exercises,
                        initiallySelectedId: widget.initiallySelectedId,
                        onAddExercise: widget.onAddBlockExercise,
                        onCreate: (ids) =>
                            widget.onCreateGroup(ids, _blockType!),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddToWorkoutOverview extends StatelessWidget {
  final VoidCallback onAddSet;
  final VoidCallback onAddExercise;
  final ValueChanged<ExerciseGroupType> onBlock;

  const AddToWorkoutOverview({
    super.key,
    required this.onAddSet,
    required this.onAddExercise,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.workoutActiveAddSubtitle,
            style: context.text.bodyM.copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: context.spacing.md),
          AddActionRow(
            icon: Icons.add_rounded,
            title: context.l10n.workoutActiveAddSet,
            subtitle: context.l10n.workoutActiveAddSetHint,
            onTap: onAddSet,
          ),
          SizedBox(height: context.spacing.xs),
          AddActionRow(
            icon: Icons.fitness_center_rounded,
            title: context.l10n.workoutActiveAddExercise,
            subtitle: context.l10n.workoutActiveAddMovement,
            onTap: onAddExercise,
          ),
          SizedBox(height: context.spacing.lg),
          Text(context.l10n.workoutActiveBlocks, style: labelStyle),
          SizedBox(height: context.spacing.xxs),
          Text(
            context.l10n.workoutActiveCombineHint,
            style: context.text.bodyS.copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: context.spacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - context.spacing.xs) / 2;
              return Wrap(
                spacing: context.spacing.xs,
                runSpacing: context.spacing.xs,
                children: [
                  for (final type in const [
                    ExerciseGroupType.superset,
                    ExerciseGroupType.triset,
                    ExerciseGroupType.giantSet,
                    ExerciseGroupType.circuit,
                  ])
                    SizedBox(
                      width: tileWidth,
                      child: BlockTypeTile(
                        type: type,
                        onTap: () => onBlock(type),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class AddActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AddActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radii.lg),
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.sizes.touchTargetWorkout,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(context.radii.lg),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: context.sizes.touchTarget,
              height: context.sizes.touchTarget,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(context.radii.md),
              ),
              child: Icon(
                icon,
                size: context.sizes.iconSm,
                color: scheme.primary,
              ),
            ),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: context.spacing.xxs),
                  Text(
                    subtitle,
                    style: context.text.bodyS.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class BlockTypeTile extends StatelessWidget {
  final ExerciseGroupType type;
  final VoidCallback onTap;

  const BlockTypeTile({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radii.lg),
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.sizes.touchTargetWorkout,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.xs,
          vertical: context.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(context.radii.lg),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlockGlyph(type: type),
            SizedBox(height: context.spacing.xs),
            Text(
              blockTitle(type),
              textAlign: TextAlign.center,
              style: context.text.labelStrong,
            ),
            SizedBox(height: context.spacing.xxs),
            Text(
              blockSubtitle(type),
              textAlign: TextAlign.center,
              style: context.text.bodyS.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockGlyph extends StatelessWidget {
  final ExerciseGroupType type;
  const BlockGlyph({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final extent = context.sizes.iconXl + context.spacing.md;
    final cacheExtent = (extent * MediaQuery.devicePixelRatioOf(context))
        .round();
    return SizedBox(
      width: extent,
      height: extent,
      child: Image.asset(
        switch (type) {
          ExerciseGroupType.superset => AppAssets.setTypeSuperset,
          ExerciseGroupType.triset => AppAssets.setTypeTriset,
          ExerciseGroupType.giantSet => AppAssets.setTypeGiantSet,
          ExerciseGroupType.circuit => AppAssets.setTypeCircuit,
          ExerciseGroupType.preparation || ExerciseGroupType.mobility =>
            throw StateError('Unsupported block type: $type'),
        },
        fit: BoxFit.contain,
        alignment: Alignment.center,
        cacheWidth: cacheExtent,
        cacheHeight: cacheExtent,
        excludeFromSemantics: true,
      ),
    );
  }
}

class InlineBlockBuilder extends StatefulWidget {
  final ExerciseGroupType type;
  final List<({String id, String name})> exercises;
  final String? initiallySelectedId;
  final BlockExerciseAdd onAddExercise;
  final ValueChanged<List<String>> onCreate;

  const InlineBlockBuilder({
    super.key,
    required this.type,
    required this.exercises,
    required this.initiallySelectedId,
    required this.onAddExercise,
    required this.onCreate,
  });

  @override
  State<InlineBlockBuilder> createState() => InlineBlockBuilderState();
}

class InlineBlockBuilderState extends State<InlineBlockBuilder> {
  late final List<({String id, String name})> _exercises;
  late final Set<String> _selected;
  bool _addingExercise = false;

  int get _minimum => switch (widget.type) {
    ExerciseGroupType.superset => 2,
    ExerciseGroupType.triset => 3,
    ExerciseGroupType.giantSet => 4,
    ExerciseGroupType.circuit => 2,
    _ => 2,
  };

  int? get _maximum => switch (widget.type) {
    ExerciseGroupType.superset => 2,
    ExerciseGroupType.triset => 3,
    _ => null,
  };

  @override
  void initState() {
    super.initState();
    _exercises = [...widget.exercises];
    _selected = {
      if (widget.initiallySelectedId != null) widget.initiallySelectedId!,
    };
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_maximum == null || _selected.length < _maximum!) {
        _selected.add(id);
      }
    });
  }

  Future<void> _addExercise() async {
    if (_addingExercise) return;
    setState(() => _addingExercise = true);
    final exercise = await widget.onAddExercise();
    if (!mounted) return;
    setState(() {
      _addingExercise = false;
      if (exercise != null) {
        _exercises.add(exercise);
        if (_maximum == null || _selected.length < _maximum!) {
          _selected.add(exercise.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final valid = _selected.length >= _minimum;
    return Column(
      key: ValueKey(widget.type),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlockGlyph(type: widget.type),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(
                blockBuilderInstruction(widget.type),
                style: context.text.bodyM.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing.md),
        Row(
          children: [
            Text(context.l10n.workoutActiveExercises, style: labelStyle),
            const Spacer(),
            Text(
              '${_selected.length}${_maximum == null ? ' / $_minimum+' : ' / $_maximum'}',
              style: TextStyle(
                color: valid ? scheme.primary : scheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing.xs),
        Expanded(
          child: ListView.separated(
            itemCount: _exercises.length,
            separatorBuilder: (_, __) => SizedBox(height: context.spacing.xxs),
            itemBuilder: (context, index) {
              final exercise = _exercises[index];
              final selected = _selected.contains(exercise.id);
              final disabled =
                  !selected &&
                  _maximum != null &&
                  _selected.length >= _maximum!;
              return BlockExerciseChoice(
                index: index + 1,
                name: exercise.name,
                selected: selected,
                enabled: !disabled,
                onTap: () => _toggle(exercise.id),
              );
            },
          ),
        ),
        SizedBox(height: context.spacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addingExercise ? null : _addExercise,
            icon: _addingExercise
                ? SizedBox.square(
                    dimension: context.sizes.iconXs,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_rounded),
            label: Text(context.l10n.workoutActiveAddExercise),
          ),
        ),
        SizedBox(height: context.spacing.xs),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: valid ? () => widget.onCreate(_selected.toList()) : null,
            child: Text(
              context.l10n.workoutBuilderCreateSelectedBlock(
                blockTitle(widget.type),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BlockExerciseChoice extends StatelessWidget {
  final int index;
  final String name;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const BlockExerciseChoice({
    super.key,
    required this.index,
    required this.name,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    return AnimatedOpacity(
      duration: motion.resolve(context, motion.quick),
      opacity: enabled || selected ? 1 : .42,
      child: InkWell(
        onTap: enabled || selected ? onTap : null,
        borderRadius: BorderRadius.circular(context.radii.md),
        child: AnimatedContainer(
          duration: motion.resolve(context, motion.quick),
          constraints: BoxConstraints(
            minHeight: context.sizes.touchTargetWorkout,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.sm,
            vertical: context.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: .1)
                : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(context.radii.md),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: context.sizes.iconMd,
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              AnimatedSwitcher(
                duration: motion.resolve(context, motion.quick),
                child: selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('selected'),
                        color: scheme.primary,
                      )
                    : Icon(
                        Icons.add_circle_outline_rounded,
                        key: const ValueKey('available'),
                        color: scheme.onSurfaceVariant,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
