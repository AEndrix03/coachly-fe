import 'dart:async';

import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/providers/exercise_list_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/providers/workout_edit_draft_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_programming_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _CatalogScope { all, verified, mine }

class AddExercisePage extends ConsumerStatefulWidget {
  final String workoutId;

  const AddExercisePage({super.key, required this.workoutId});

  @override
  ConsumerState<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends ConsumerState<AddExercisePage> {
  final TextEditingController _search = TextEditingController();
  Timer? _debounce;
  String _query = '';
  _CatalogScope _scope = _CatalogScope.all;
  String? _muscleId;
  String? _equipmentId;
  String? _movement;
  bool? _bodyweight;
  String? _justAddedId;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final catalog = ref.watch(exerciseListProvider());
    return Scaffold(
      backgroundColor: CoachlyAthleteTheme.background,
      appBar: AppBar(
        backgroundColor: CoachlyAthleteTheme.background,
        surfaceTintColor: Colors.transparent,
        title: Text(context.tr('workout.add_exercise.title')),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.tr('workout.detail.done')),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: catalog.when(
        loading: () => const _CatalogSkeleton(),
        error: (_, _) =>
            _CatalogError(onRetry: () => ref.invalidate(exerciseListProvider)),
        data: (allExercises) {
          final results = _filter(allExercises, locale);
          final initial = _query.isEmpty && !_hasFilters;
          final displayed = initial ? _recent(allExercises) : results;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _searchAndFilters(context, allExercises, locale),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Text(
                    context.tr(
                      initial
                          ? 'workout.add_exercise.recent'
                          : 'workout.add_exercise.results',
                    ),
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              if (displayed.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(context.tr('workout.add_exercise.no_results')),
                  ),
                )
              else
                SliverList.separated(
                  itemCount: displayed.length,
                  itemBuilder: (context, index) {
                    final exercise = displayed[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _ExerciseResultTile(
                        exercise: exercise,
                        locale: locale,
                        added: _justAddedId == exercise.id,
                        onOpen: () => context.push('/exercises/${exercise.id}'),
                        onAdd: () => _quickAdd(exercise),
                      ),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 9),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/exercises/create'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      foregroundColor: CoachlyAthleteTheme.textPrimary,
                      side: const BorderSide(color: CoachlyAthleteTheme.border),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      context.tr('workout.add_exercise.create_personal'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _searchAndFilters(
    BuildContext context,
    List<ExerciseDetailModel> exercises,
    Locale locale,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _search,
            onChanged: (value) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 275), () {
                if (mounted) {
                  setState(() => _query = value.trim().toLowerCase());
                }
              });
            },
            style: const TextStyle(color: CoachlyAthleteTheme.textPrimary),
            decoration: InputDecoration(
              hintText: context.tr('workout.add_exercise.search_hint'),
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: CoachlyAthleteTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CoachlyAthleteTheme.border),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<_CatalogScope>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: _CatalogScope.all,
                label: Text(context.tr('workout.add_exercise.all')),
              ),
              ButtonSegment(
                value: _CatalogScope.verified,
                label: Text(context.tr('workout.add_exercise.verified')),
              ),
              ButtonSegment(
                value: _CatalogScope.mine,
                label: Text(context.tr('workout.add_exercise.mine')),
              ),
            ],
            selected: {_scope},
            onSelectionChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _scope = value.single);
            },
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: context.tr('workout.add_exercise.muscle'),
                  active: _muscleId != null,
                  onTap: () => _chooseValue(
                    title: context.tr('workout.add_exercise.muscle'),
                    values: {
                      for (final muscle in exercises.expand(
                        (e) => e.muscles ?? const [],
                      ))
                        if (muscle.muscle != null)
                          muscle.muscle!.id:
                              muscle.muscle!.nameI18n.fromI18n(locale) ??
                              muscle.muscle!.code,
                    },
                    selected: _muscleId,
                    onSelected: (value) => setState(() => _muscleId = value),
                  ),
                ),
                _FilterChip(
                  label: context.tr('workout.add_exercise.movement'),
                  active: _movement != null,
                  onTap: () => _chooseValue(
                    title: context.tr('workout.add_exercise.movement'),
                    values: {
                      for (final value
                          in exercises
                              .map((e) => e.mechanicsType)
                              .whereType<String>())
                        value: value,
                    },
                    selected: _movement,
                    onSelected: (value) => setState(() => _movement = value),
                  ),
                ),
                _FilterChip(
                  label: context.tr('workout.add_exercise.equipment'),
                  active: _equipmentId != null,
                  onTap: () => _chooseValue(
                    title: context.tr('workout.add_exercise.equipment'),
                    values: {
                      for (final equipment in exercises.expand(
                        (e) => e.equipments ?? const [],
                      ))
                        equipment.equipment.id:
                            equipment.equipment.nameI18n.fromI18n(locale) ??
                            equipment.equipment.code,
                    },
                    selected: _equipmentId,
                    onSelected: (value) => setState(() => _equipmentId = value),
                  ),
                ),
                _FilterChip(
                  label: context.tr('workout.add_exercise.tracking'),
                  active: _bodyweight != null,
                  onTap: () => setState(
                    () => _bodyweight = _bodyweight == null ? true : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasFilters =>
      _scope != _CatalogScope.all ||
      _muscleId != null ||
      _equipmentId != null ||
      _movement != null ||
      _bodyweight != null;

  List<ExerciseDetailModel> _filter(
    List<ExerciseDetailModel> all,
    Locale locale,
  ) {
    return all.where((exercise) {
      final name = exercise.nameI18n?.fromI18n(locale).toLowerCase() ?? '';
      final muscles = exercise.muscles ?? const [];
      final equipment = exercise.equipments ?? const [];
      final searchable = [
        name,
        ...muscles.expand((m) => m.muscle?.nameI18n.values ?? const []),
        ...equipment.expand((e) => e.equipment.nameI18n.values),
      ].join(' ').toLowerCase();
      if (_query.isNotEmpty && !searchable.contains(_query)) return false;
      if (_scope == _CatalogScope.mine && !exercise.isPersonal) return false;
      if (_scope == _CatalogScope.verified && exercise.isPersonal) return false;
      if (_muscleId != null && !muscles.any((m) => m.muscle?.id == _muscleId)) {
        return false;
      }
      if (_equipmentId != null &&
          !equipment.any((e) => e.equipment.id == _equipmentId)) {
        return false;
      }
      if (_movement != null && exercise.mechanicsType != _movement) {
        return false;
      }
      if (_bodyweight != null && exercise.isBodyweight != _bodyweight) {
        return false;
      }
      return exercise.id != null;
    }).toList();
  }

  List<ExerciseDetailModel> _recent(List<ExerciseDetailModel> all) {
    final workouts = ref.watch(workoutListProvider).value ?? const [];
    final ids = <String>[];
    final ordered = [...workouts]
      ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    for (final workout in ordered) {
      for (final exercise in workout.workoutExercises) {
        final id = exercise.exercise.id;
        if (id != null && !ids.contains(id)) ids.add(id);
      }
    }
    final byId = {for (final exercise in all) exercise.id: exercise};
    final recent = ids
        .take(6)
        .map((id) => byId[id])
        .whereType<ExerciseDetailModel>()
        .toList();
    return recent.isEmpty ? all.take(6).toList() : recent;
  }

  Future<void> _chooseValue({
    required String title,
    required Map<String, String> values,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) async {
    final value = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: CoachlyAthleteTheme.surfaceElevated,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (selected != null)
              ListTile(
                title: Text(context.tr('workout.add_exercise.clear_filter')),
                onTap: () => Navigator.pop(context, ''),
              ),
            ...values.entries.map(
              (entry) => ListTile(
                title: Text(entry.value),
                trailing: selected == entry.key
                    ? const Icon(
                        Icons.check_rounded,
                        color: CoachlyAthleteTheme.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, entry.key),
              ),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    onSelected(value == '' ? null : value);
  }

  Future<void> _quickAdd(ExerciseDetailModel exercise) async {
    final last = ref.read(lastExercisePrescriptionProvider(exercise.id ?? ''));
    await ExerciseQuickAddSheet.show(
      context,
      exercise: exercise,
      workoutId: widget.workoutId,
      initial: last,
      onAdd: (sets, sectionId) {
        ref
            .read(workoutEditDraftProvider(widget.workoutId).notifier)
            .addExercise(exercise: exercise, sets: sets, sectionId: sectionId);
        setState(() => _justAddedId = exercise.id);
        Timer(const Duration(milliseconds: 1300), () {
          if (mounted && _justAddedId == exercise.id) {
            setState(() => _justAddedId = null);
          }
        });
      },
    );
  }
}

class _ExerciseResultTile extends StatelessWidget {
  final ExerciseDetailModel exercise;
  final Locale locale;
  final bool added;
  final VoidCallback onOpen;
  final VoidCallback onAdd;

  const _ExerciseResultTile({
    required this.exercise,
    required this.locale,
    required this.added,
    required this.onOpen,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final name =
        exercise.nameI18n?.fromI18n(locale) ??
        context.tr('exercise.fallback_name');
    final equipment = exercise.equipments?.firstOrNull?.equipment.nameI18n
        .fromI18n(locale);
    final muscles = exercise.muscles
        ?.take(2)
        .map((m) => m.muscle?.nameI18n.fromI18n(locale))
        .whereType<String>()
        .join(' · ');
    final thumbnail = exercise.media
        ?.where((media) => media.thumbnailUrl.isNotEmpty)
        .firstOrNull
        ?.thumbnailUrl;
    return CoachlySurface(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: thumbnail == null
                    ? Container(
                        width: 56,
                        height: 56,
                        color: CoachlyAthleteTheme.surfaceElevated,
                        child: const Icon(Icons.fitness_center_rounded),
                      )
                    : Image.network(
                        thumbnail,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        cacheWidth: 112,
                        errorBuilder: (_, _, _) =>
                            const SizedBox(width: 56, height: 56),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 2,
                            style: const TextStyle(
                              color: CoachlyAthleteTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!exercise.isPersonal) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified_rounded,
                            size: 15,
                            color: CoachlyAthleteTheme.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        exercise.mechanicsType,
                        equipment,
                        muscles,
                      ].whereType<String>().join(' · '),
                      maxLines: 2,
                      style: const TextStyle(
                        color: CoachlyAthleteTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: CoachlyAthleteTheme.expandDuration,
                child: added
                    ? const SizedBox(
                        key: ValueKey('added'),
                        width: 48,
                        height: 48,
                        child: Icon(
                          Icons.check_rounded,
                          color: CoachlyAthleteTheme.primary,
                        ),
                      )
                    : IconButton(
                        key: const ValueKey('add'),
                        onPressed: onAdd,
                        tooltip: context.tr('workout.detail.add_exercise'),
                        icon: const Icon(Icons.add_rounded),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: FilterChip(
      selected: active,
      onSelected: (_) {
        HapticFeedback.selectionClick();
        onTap();
      },
      label: Text(label),
    ),
  );
}

class ExerciseQuickAddSheet extends StatefulWidget {
  final ExerciseDetailModel exercise;
  final String workoutId;
  final WorkoutProgrammingEntryModel? initial;
  final void Function(List<WorkoutProgrammingSetModel>, String? sectionId)
  onAdd;

  const ExerciseQuickAddSheet({
    super.key,
    required this.exercise,
    required this.workoutId,
    required this.initial,
    required this.onAdd,
  });

  static Future<void> show(
    BuildContext context, {
    required ExerciseDetailModel exercise,
    required String workoutId,
    required WorkoutProgrammingEntryModel? initial,
    required void Function(List<WorkoutProgrammingSetModel>, String? sectionId)
    onAdd,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: CoachlyAthleteTheme.surfaceElevated,
    builder: (_) => ExerciseQuickAddSheet(
      exercise: exercise,
      workoutId: workoutId,
      initial: initial,
      onAdd: onAdd,
    ),
  );

  @override
  State<ExerciseQuickAddSheet> createState() => _ExerciseQuickAddSheetState();
}

class _ExerciseQuickAddSheetState extends State<ExerciseQuickAddSheet> {
  late int setCount;
  late final TextEditingController repsMin;
  late final TextEditingController repsMax;
  late final TextEditingController rest;
  String intensityType = 'rir';
  late final TextEditingController intensity;
  String? sectionId;

  @override
  void initState() {
    super.initState();
    final first = widget.initial?.sets.firstOrNull;
    setCount = widget.initial?.sets.length ?? 3;
    repsMin = TextEditingController(
      text: '${first?.repsMin ?? first?.reps ?? 8}',
    );
    repsMax = TextEditingController(
      text: '${first?.repsMax ?? first?.reps ?? 12}',
    );
    rest = TextEditingController(text: '${first?.restSeconds ?? 120}');
    intensityType = first?.intensityType ?? 'rir';
    intensity = TextEditingController(text: '${first?.intensityMin ?? 2}');
  }

  @override
  void dispose() {
    repsMin.dispose();
    repsMax.dispose();
    rest.dispose();
    intensity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.readLanguageFallback;
    return Consumer(
      builder: (context, ref, _) {
        final draft = ref.watch(workoutEditDraftProvider(widget.workoutId));
        final sections = {
          for (final block in draft.blocks)
            if (block.sectionId != null && block.sectionTitle != null)
              block.sectionId!: block.sectionTitle!,
        };
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.exercise.nameI18n?.fromI18n(locale) ??
                      context.tr('exercise.fallback_name'),
                  style: const TextStyle(
                    color: CoachlyAthleteTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (widget.initial != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      context.tr('workout.add_exercise.last_configuration'),
                      style: const TextStyle(
                        color: CoachlyAthleteTheme.primary,
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                _InlineNumberStepper(
                  label: context.tr('workout.sets'),
                  value: setCount,
                  onChanged: (value) =>
                      setState(() => setCount = value.clamp(1, 20)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        context.tr('workout.add_exercise.reps_min'),
                        repsMin,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        context.tr('workout.add_exercise.reps_max'),
                        repsMax,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _field('RIR', intensity, decimal: true)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        '${context.tr('workout.detail.rest')} (s)',
                        rest,
                      ),
                    ),
                  ],
                ),
                if (sections.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: sectionId,
                    decoration: InputDecoration(
                      labelText: context.tr('workout.add_exercise.add_to'),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          context.tr('workout.add_exercise.no_section'),
                        ),
                      ),
                      ...sections.entries.map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => sectionId = value),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    final min = int.tryParse(repsMin.text);
                    final max = int.tryParse(repsMax.text);
                    final restSeconds = int.tryParse(rest.text) ?? 0;
                    final intensityValue = double.tryParse(
                      intensity.text.replaceAll(',', '.'),
                    );
                    final sets = List.generate(
                      setCount,
                      (index) => WorkoutProgrammingSetModel(
                        position: index,
                        repsMin: min,
                        repsMax: max,
                        intensityType: intensityType,
                        intensityMin: intensityValue,
                        intensityMax: intensityValue,
                        restSeconds: restSeconds,
                      ),
                    );
                    widget.onAdd(sets, sectionId);
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor: CoachlyAthleteTheme.primary,
                    foregroundColor: CoachlyAthleteTheme.background,
                  ),
                  child: Text(context.tr('workout.detail.add_exercise')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool decimal = false,
  }) => TextField(
    controller: controller,
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    style: const TextStyle(color: CoachlyAthleteTheme.textPrimary),
    decoration: InputDecoration(labelText: label),
  );
}

class _InlineNumberStepper extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  const _InlineNumberStepper({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label)),
      IconButton(
        onPressed: value > 1 ? () => onChanged(value - 1) : null,
        icon: const Icon(Icons.remove),
      ),
      SizedBox(
        width: 42,
        child: Text(
          '$value',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      IconButton(
        onPressed: () => onChanged(value + 1),
        icon: const Icon(Icons.add),
      ),
    ],
  );
}

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton();
  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(20),
    itemCount: 6,
    itemBuilder: (_, _) => Container(
      height: 78,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: CoachlyAthleteTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

class _CatalogError extends StatelessWidget {
  final VoidCallback onRetry;
  const _CatalogError({required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.tr('workout.add_exercise.load_error')),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: onRetry,
          child: Text(context.tr('exercise.retry')),
        ),
      ],
    ),
  );
}

extension on BuildContext {
  Locale get readLanguageFallback => Localizations.localeOf(this);
}
