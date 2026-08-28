import 'package:coachly/design_system/components/product/muscle_anatomy_view.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/coachly_concept_guide_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/widgets/exercise_detail_widgets.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_detail_view_provider.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MuscleViewMode { visual, table }

class ExerciseMusclesPage extends ConsumerWidget {
  final String exerciseId;

  const ExerciseMusclesPage({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(exerciseDetailViewProvider(exerciseId));
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: asyncData.when(
        loading: () => const ExerciseLoadingView(),
        error: (_, _) => ExerciseErrorView(
          onRetry: () => ref.invalidate(exerciseDetailViewProvider(exerciseId)),
        ),
        data: (data) => ExerciseMusclesContent(data: data),
      ),
    );
  }
}

class ExerciseMusclesContent extends StatefulWidget {
  final ExerciseDetailViewData data;

  const ExerciseMusclesContent({super.key, required this.data});

  @override
  State<ExerciseMusclesContent> createState() => _ExerciseMusclesContentState();
}

class _ExerciseMusclesContentState extends State<ExerciseMusclesContent> {
  MuscleViewMode _mode = MuscleViewMode.visual;
  bool _backView = true;
  String? _selectedMuscleId;

  MuscleViewData? get _selectedMuscle {
    final selectedId = _selectedMuscleId;
    if (selectedId == null) return widget.data.muscles.firstOrNull;
    return widget.data.muscles
            .where((muscle) => muscle.id == selectedId)
            .firstOrNull ??
        widget.data.muscles.firstOrNull;
  }

  @override
  void initState() {
    super.initState();
    _selectedMuscleId = widget.data.muscles.firstOrNull?.id;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return ExerciseDetailScaffold(
      title: context.tr('exercise.muscles.title'),
      exerciseName: widget.data.name,
      body: CustomScrollView(
        key: const Key('muscles-page-scroll'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            sliver: SliverList.list(
              children: [
                _ModeSelector(
                  mode: _mode,
                  onChanged: (mode) {
                    if (_mode == mode) return;
                    HapticFeedback.selectionClick();
                    setState(() => _mode = mode);
                  },
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  child: _mode == MuscleViewMode.visual
                      ? _buildVisual(colors)
                      : _MuscleTable(
                          key: const ValueKey('muscle-table'),
                          muscles: widget.data.muscles,
                          selectedId: _selectedMuscleId,
                          onSelected: _selectMuscle,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisual(CoachlyExerciseTheme colors) {
    final selected = _selectedMuscle;
    return Column(
      key: const ValueKey('muscle-visual'),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _ViewChip(
              label: context.tr('exercise.muscles.front'),
              selected: !_backView,
              onTap: () {
                if (!_backView) return;
                setState(() => _backView = false);
              },
            ),
            const SizedBox(width: 8),
            _ViewChip(
              label: context.tr('exercise.muscles.back'),
              selected: _backView,
              onTap: () {
                if (_backView) return;
                setState(() => _backView = true);
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 390,
          child: _OptionalMuscleDetailHero(
            tag: 'exercise-muscles-${widget.data.id}',
            child: MuscleAnatomyView(
              muscles: widget.data.muscles,
              selectedMuscleId: _selectedMuscleId,
              backView: _backView,
              onMuscleSelected: _selectMuscle,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const _MuscleLegend(),
        const SizedBox(height: 24),
        if (selected != null) _SelectedMusclePanel(muscle: selected),
      ],
    );
  }

  void _selectMuscle(String id) {
    if (_selectedMuscleId == id) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedMuscleId = id);
  }
}

class _OptionalMuscleDetailHero extends StatelessWidget {
  final String tag;
  final Widget child;

  const _OptionalMuscleDetailHero({required this.tag, required this.child});

  @override
  Widget build(BuildContext context) {
    final material = Material(color: Colors.transparent, child: child);
    if (MediaQuery.disableAnimationsOf(context)) return material;
    return Hero(tag: tag, child: material);
  }
}

class _ModeSelector extends StatelessWidget {
  final MuscleViewMode mode;
  final ValueChanged<MuscleViewMode> onChanged;

  const _ModeSelector({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Semantics(
      label: context.tr('exercise.muscles.view_mode'),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            for (final item in MuscleViewMode.values)
              Expanded(
                child: InkWell(
                  key: Key('muscle-mode-${item.name}'),
                  borderRadius: BorderRadius.circular(11),
                  onTap: () => onChanged(item),
                  child: AnimatedContainer(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(minHeight: 44),
                    decoration: BoxDecoration(
                      color: mode == item
                          ? colors.surfaceElevated
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      item == MuscleViewMode.visual ? 'Visuale' : 'Tabella',
                      style: TextStyle(
                        color: mode == item
                            ? colors.textPrimary
                            : colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ViewChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ViewChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        if (selected) return;
        HapticFeedback.selectionClick();
        onTap();
      },
      selectedColor: colors.primaryMuted,
      backgroundColor: colors.surface,
      side: BorderSide(color: colors.border),
      labelStyle: TextStyle(
        color: selected ? colors.textPrimary : colors.textSecondary,
      ),
    );
  }
}

class _MuscleLegend extends StatelessWidget {
  const _MuscleLegend();

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 8,
      children: [
        _LegendItem(
          color: colors.primary,
          label: context.tr('exercise.muscles.role_primary'),
        ),
        _LegendItem(
          color: context.exerciseTheme.primaryMuted,
          label: context.tr('exercise.muscles.role_secondary'),
        ),
        _LegendItem(
          color: colors.info,
          label: context.tr('exercise.muscles.role_stabilizer'),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: context.exerciseTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SelectedMusclePanel extends StatelessWidget {
  final MuscleViewData muscle;

  const _SelectedMusclePanel({required this.muscle});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            muscle.name,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            muscleRoleLabel(muscle.role),
            style: TextStyle(color: colors.primary, fontSize: 13),
          ),
          const SizedBox(height: 22),
          ExerciseSectionTitle(
            'Tensione nel ROM',
            onInfo: () => showCoachlyInfoSheet(
              context,
              title: 'Tensione nel ROM',
              description:
                  'Mostra qualitativamente dove il muscolo riceve tensione significativa durante il movimento.',
              whyItMatters:
                  'Aiuta a confrontare esercizi simili senza ridurre un movimento complesso a una percentuale.',
              guideTopic: CoachlyGuideTopic.tensionInRom,
              disclaimer:
                  'Non rappresenta una misura EMG né una percentuale di crescita.',
            ),
          ),
          const SizedBox(height: 12),
          _TensionRow(
            label: context.tr('exercise.muscles.lengthened'),
            level: muscle.tension.lengthened,
          ),
          _TensionRow(
            label: context.tr('exercise.muscles.midrange'),
            level: muscle.tension.midRange,
          ),
          _TensionRow(
            label: context.tr('exercise.muscles.shortened'),
            level: muscle.tension.shortened,
          ),
        ],
      ),
    );
  }
}

class _TensionRow extends StatelessWidget {
  final String label;
  final TensionLevel level;

  const _TensionRow({required this.label, required this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.exerciseTheme.textSecondary),
            ),
          ),
          TensionDots(level: level),
        ],
      ),
    );
  }
}

class _MuscleTable extends StatelessWidget {
  final List<MuscleViewData> muscles;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const _MuscleTable({
    super.key,
    required this.muscles,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      children: [
        for (final muscle in muscles) ...[
          InkWell(
            key: Key('muscle-row-${muscle.id}'),
            borderRadius: BorderRadius.circular(18),
            onTap: () => onSelected(muscle.id),
            child: AnimatedContainer(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: selectedId == muscle.id
                    ? colors.surfaceElevated
                    : colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selectedId == muscle.id
                      ? colors.primary.withValues(alpha: 0.28)
                      : colors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    muscle.name,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    muscleRoleLabel(muscle.role),
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  _TensionRow(
                    label: context.tr('exercise.muscles.lengthened'),
                    level: muscle.tension.lengthened,
                  ),
                  _TensionRow(
                    label: context.tr('exercise.muscles.mid'),
                    level: muscle.tension.midRange,
                  ),
                  _TensionRow(
                    label: context.tr('exercise.muscles.shortened'),
                    level: muscle.tension.shortened,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
