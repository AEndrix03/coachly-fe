import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/core/text_filter/polite_text_input_formatter.dart';
import 'package:coachly/core/utils/debouncer.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercise/providers/exercise_list_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────── public widget ───────────────────────────────────

class ExercisePickerSheet extends ConsumerStatefulWidget {
  final Function(EditableExerciseModel) onExerciseSelected;
  final Set<String> excludedExerciseIds;

  const ExercisePickerSheet({
    super.key,
    required this.onExerciseSelected,
    this.excludedExerciseIds = const {},
  });

  @override
  ConsumerState<ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

// ─────────────────────────── state ───────────────────────────────────────────

class _ExercisePickerSheetState extends ConsumerState<ExercisePickerSheet> {
  final _searchCtrl = TextEditingController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 350));
  final _listScrollController = ScrollController();

  final bool _showAdvanced = false;
  bool _showScrollToTop = false;
  String _scope = 'community';

  // active filters
  String? _categoryId;
  String? _muscleId;
  String? _mechanics;
  String? _forceType;
  bool? _bodyweight;
  bool? _unilateral;

  ExerciseFilterModel _filter = const ExerciseFilterModel(scope: 'community');

  // ── lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
    _listScrollController.addListener(_onListScroll);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    _debouncer.dispose();
    _listScrollController.removeListener(_onListScroll);
    _listScrollController.dispose();
    super.dispose();
  }

  // ── filter logic ──────────────────────────────────────────────────────────

  void _onSearch() {
    _debouncer.run(_applyFilters);
  }

  void _onListScroll() {
    final shouldShow = _listScrollController.offset > 320;
    if (shouldShow != _showScrollToTop) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  void _scrollToTop() {
    _listScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _applyFilters() {
    final locale = ref.read(languageProvider);
    final lang = locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
    final text = _searchCtrl.text;
    setState(() {
      _filter = ExerciseFilterModel(
        scope: _scope,
        textFilter: text.length >= 2 || text.isEmpty ? text : null,
        langFilter: lang,
        mechanicsType: _mechanics,
        forceType: _forceType,
        isUnilateral: _unilateral,
        isBodyweight: _bodyweight,
        categoryIds: _categoryId != null ? [_categoryId!] : null,
        muscleIds: _muscleId != null ? [_muscleId!] : null,
      );
    });
  }

  void _clearFilters() {
    setState(() {
      _categoryId = null;
      _muscleId = null;
      _mechanics = null;
      _forceType = null;
      _bodyweight = null;
      _unilateral = null;
    });
    _applyFilters();
  }

  Future<void> _showCreateExerciseDialog() async {
    final created = await context.push<ExerciseDetailModel>(
      '/exercises/create',
    );
    if (created == null || !mounted) return;
    final locale = ref.read(languageProvider);
    final name =
        created.nameI18n?.fromI18n(locale) ?? created.id ?? 'Esercizio';
    widget.onExerciseSelected(
      EditableExerciseModel(
        id: 'ex_${DateTime.now().millisecondsSinceEpoch}_${created.id}',
        exerciseId: created.id ?? '',
        number: 0,
        name: name,
        muscles: const [],
        difficulty: '',
        sets: '3x10',
        rest: '60s',
        weight: '-',
        progress: '0',
        notes: '',
        accentColorHex: '#20D3B0',
        variants: const [],
      ),
    );
    if (mounted) Navigator.pop(context);
    return;

    /*
    final locale = ref.read(languageProvider);
    final lang = locale.languageCode;
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151524),
          title: Text(
            context.tr('exercise.personal.create'),
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                maxLength: 80,
                inputFormatters: [PoliteTextInputFormatter()],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: context.tr('exercise.personal.name'),
                  labelStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                maxLength: 160,
                inputFormatters: [PoliteTextInputFormatter()],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: context.tr('exercise.personal.description'),
                  labelStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.tr('common.cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.tr('common.confirm')),
            ),
          ],
        );
      },
    );

    if (result != true) {
      return;
    }

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final repository = ref.read(exerciseInfoPageRepositoryProvider);
    final response = await repository.createPersonalExercise(
      nameI18n: {lang: name},
      descriptionI18n: description.isNotEmpty ? {lang: description} : null,
      tipsI18n: const {},
      difficultyLevel: 'beginner',
      mechanicsType: 'compound',
      isBodyweight: true,
      isUnilateral: false,
    );

    if (!mounted) {
      return;
    }

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? context.tr('common.error'))),
      );
      return;
    }

    setState(() => _scope = 'mine');
    _applyFilters();
    ref.invalidate(exerciseListProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('exercise.personal.created'))),
    );
    */
  }

  int get _activeCount => [
    _categoryId,
    _muscleId,
    _mechanics,
    _forceType,
    _bodyweight,
    _unilateral,
  ].where((v) => v != null).length;

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: context.exerciseTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          _buildSearchBar(),
          _buildSourceSelector(),
          _buildOptionsSource(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  // ── handle ────────────────────────────────────────────────────────────────

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.exerciseTheme.textSecondary.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('workout.edit.add_exercise'),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.exerciseTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.tr('workout.builder.exercise_library_hint'),
                      style: TextStyle(
                        color: context.exerciseTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          CoachlyPressable(
            onTap: _showCreateExerciseDialog,
            semanticLabel: context.tr('exercise.personal.create'),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: context.exerciseTheme.surface,
                borderRadius: BorderRadius.circular(
                  CoachlyAthleteTheme.compactRadius,
                ),
                border: Border.all(color: context.exerciseTheme.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: context.exerciseTheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.tr('exercise.personal.create'),
                      style: TextStyle(
                        color: context.exerciseTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: context.exerciseTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── search ────────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: context.exerciseTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.exerciseTheme.border),
        ),
        child: TextField(
          controller: _searchCtrl,
          inputFormatters: [PoliteTextInputFormatter()],
          style: TextStyle(
            color: context.exerciseTheme.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: context.tr('workout.search_exercise_hint'),
            hintStyle: TextStyle(
              color: context.exerciseTheme.textSecondary,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: context.exerciseTheme.textSecondary,
              size: 20,
            ),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      _applyFilters();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: context.exerciseTheme.textSecondary,
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _sourceChip(
              label: context.tr('exercise.scope.community'),
              value: 'community',
            ),
            const SizedBox(width: 8),
            _sourceChip(
              label: context.tr('exercise.scope.default'),
              value: 'default',
            ),
            const SizedBox(width: 8),
            _sourceChip(
              label: context.tr('exercise.scope.mine'),
              value: 'mine',
            ),
          ],
        ),
      ),
    );
  }

  Widget _sourceChip({required String label, required String value}) {
    final isActive = _scope == value;
    return CoachlyPressable(
      onTap: () {
        setState(() => _scope = value);
        _applyFilters();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive
              ? context.exerciseTheme.primaryMuted.withValues(alpha: .58)
              : context.exerciseTheme.surface,
          border: Border.all(
            color: isActive
                ? context.exerciseTheme.primary.withValues(alpha: .55)
                : context.exerciseTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? context.exerciseTheme.textPrimary
                : context.exerciseTheme.textSecondary,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── filter options source ─────────────────────────────────────────────────

  /// The picker intentionally indexes just names. Advanced catalogue filters
  /// would require loading every exercise detail and are therefore omitted.
  Widget _buildOptionsSource() => const SizedBox.shrink();

  // ignore: unused_element
  bool get _hasAdvancedFilters =>
      _categoryId != null ||
      _muscleId != null ||
      _mechanics != null ||
      _forceType != null ||
      _bodyweight != null ||
      _unilateral != null;

  // ignore: unused_element
  Widget _buildFilterPanel(List<ExerciseDetailModel> exercises) {
    final locale = ref.read(languageProvider);

    // Extract unique categories (primary first)
    final catById = <String, _Option>{};
    for (final ex in exercises) {
      for (final cat in ex.categories ?? const []) {
        final id = cat.id;
        if (id == null || id.isEmpty) continue;
        catById.putIfAbsent(
          id,
          () => _Option(
            id: id,
            label:
                (cat.nameI18n as Map<String, String>?)?.fromI18n(locale) ?? id,
            isPrimary: cat.isPrimary ?? false,
          ),
        );
      }
    }
    final categories = catById.values.toList()
      ..sort((a, b) {
        if (a.isPrimary != b.isPrimary) return a.isPrimary ? -1 : 1;
        return a.label.compareTo(b.label);
      });

    // Extract muscles
    final muscleById = <String, _Option>{};
    for (final ex in exercises) {
      for (final em in ex.muscles ?? const []) {
        final id = em.muscle?.id;
        if (id == null || id.isEmpty) continue;
        muscleById.putIfAbsent(
          id,
          () => _Option(
            id: id,
            label:
                (em.muscle?.nameI18n as Map<String, String>?)?.fromI18n(
                  locale,
                ) ??
                id,
          ),
        );
      }
    }
    final muscles = muscleById.values.toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    // Extract mechanics
    final mechanics =
        exercises
            .map((e) => e.mechanicsType)
            .whereType<String>()
            .toSet()
            .toList()
          ..sort();

    // Extract force types
    final forceTypes =
        exercises.map((e) => e.forceType).whereType<String>().toSet().toList()
          ..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category chips — always visible
        if (categories.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildHorizontalChips<_Option>(
            items: categories,
            selected: _categoryId,
            getLabel: (o) => o.label,
            getId: (o) => o.id,
            onTap: (id) {
              setState(() => _categoryId = _categoryId == id ? null : id);
              _applyFilters();
            },
          ),
        ],
        // Advanced filters
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _showAdvanced
              ? _buildAdvancedFilters(muscles, mechanics, forceTypes)
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          color: context.colors.textPrimary.withValues(alpha: 0.07),
        ),
      ],
    );
  }

  Widget _buildAdvancedFilters(
    List<_Option> muscles,
    List<String> mechanics,
    List<String> forceTypes,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (muscles.isNotEmpty) ...[
            _buildFilterLabel(context.tr('exercise.muscle')),
            _buildHorizontalChips<_Option>(
              items: muscles,
              selected: _muscleId,
              getLabel: (o) => o.label,
              getId: (o) => o.id,
              onTap: (id) {
                setState(() => _muscleId = _muscleId == id ? null : id);
                _applyFilters();
              },
            ),
          ],
          if (mechanics.isNotEmpty) ...[
            _buildFilterLabel(context.tr('exercise.mechanics')),
            _buildHorizontalChips<String>(
              items: mechanics,
              selected: _mechanics,
              getLabel: (s) => _mechanicsLabel(s),
              getId: (s) => s,
              onTap: (id) {
                setState(() => _mechanics = _mechanics == id ? null : id);
                _applyFilters();
              },
            ),
          ],
          if (forceTypes.isNotEmpty) ...[
            _buildFilterLabel(context.tr('exercise.force_type')),
            _buildHorizontalChips<String>(
              items: forceTypes,
              selected: _forceType,
              getLabel: (s) => _forceLabel(s),
              getId: (s) => s,
              onTap: (id) {
                setState(() => _forceType = _forceType == id ? null : id);
                _applyFilters();
              },
            ),
          ],
          // Bool toggles
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildToggleChip(
                  label: context.tr('exercise.bodyweight_only'),
                  icon: Icons.self_improvement_rounded,
                  active: _bodyweight == true,
                  onTap: () {
                    setState(
                      () => _bodyweight = _bodyweight == true ? null : true,
                    );
                    _applyFilters();
                  },
                ),
                _buildToggleChip(
                  label: context.tr('exercise.with_equipment'),
                  icon: Icons.fitness_center_rounded,
                  active: _bodyweight == false,
                  onTap: () {
                    setState(
                      () => _bodyweight = _bodyweight == false ? null : false,
                    );
                    _applyFilters();
                  },
                ),
                _buildToggleChip(
                  label: context.tr('exercise.unilateral'),
                  icon: Icons.swap_horiz_rounded,
                  active: _unilateral == true,
                  onTap: () {
                    setState(
                      () => _unilateral = _unilateral == true ? null : true,
                    );
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Text(
        label,
        style: TextStyle(
          color: context.colors.textPrimary.withValues(alpha: 0.45),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildHorizontalChips<T>({
    required List<T> items,
    required String? selected,
    required String Function(T) getLabel,
    required String Function(T) getId,
    required void Function(String) onTap,
  }) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: items.map((item) {
          final id = getId(item);
          final isActive = id == selected;
          return GestureDetector(
            onTap: () => onTap(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isActive
                    ? context.exerciseTheme.primaryMuted
                    : context.exerciseTheme.surface,
                border: Border.all(
                  color: isActive
                      ? context.exerciseTheme.primary.withValues(alpha: .55)
                      : context.exerciseTheme.border,
                  width: 1,
                ),
              ),
              child: Text(
                getLabel(item),
                style: TextStyle(
                  color: isActive
                      ? context.exerciseTheme.textPrimary
                      : context.exerciseTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleChip({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: active
              ? context.exerciseTheme.primaryMuted
              : context.exerciseTheme.surface,
          border: Border.all(
            color: active
                ? context.exerciseTheme.primary.withValues(alpha: .55)
                : context.exerciseTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: active
                  ? context.exerciseTheme.primary
                  : context.exerciseTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? context.exerciseTheme.textPrimary
                    : context.exerciseTheme.textSecondary,
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── exercise list ─────────────────────────────────────────────────────────

  Widget _buildList() {
    return Consumer(
      builder: (context, ref, _) {
        final value = ref.watch(exerciseListProvider);
        return value.when(
          loading: () => Center(
            child: CircularProgressIndicator(
              color: context.exerciseTheme.primary,
              strokeWidth: 2,
            ),
          ),
          error: (err, _) => Center(
            child: Text(
              err.toString(),
              style: TextStyle(color: context.exerciseTheme.warning),
            ),
          ),
          data: (exercises) {
            final visible = _filterAndExclude(exercises);
            if (visible.isEmpty) return _buildEmptyList();
            return Stack(
              children: [
                ListView.builder(
                  controller: _listScrollController,
                  // Keep only a short viewport ahead of the user. Together
                  // with ListView.builder this keeps the catalogue virtualized
                  // without mounting the full exercise list.
                  cacheExtent: 300,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  // 78px card + 14px gap keeps the catalogue compact while
                  // preserving a clearly separated tap target per exercise.
                  itemExtent: 92,
                  // Reserve space for the rail, so its thumb never sits on
                  // top of the exercise cards.
                  padding: const EdgeInsets.fromLTRB(16, 8, 52, 24),
                  itemCount: visible.length,
                  itemBuilder: (_, i) => _buildCard(visible[i]),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  width: 36,
                  child: _ExerciseListScrollRail(
                    controller: _listScrollController,
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: IgnorePointer(
                    ignoring: !_showScrollToTop,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: _showScrollToTop ? 1 : 0,
                      child: Tooltip(
                        message: context.tr('common.back_to_top'),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _scrollToTop,
                            borderRadius: BorderRadius.circular(16),
                            child: Ink(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                              child: Icon(
                                Icons.vertical_align_top_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: context.exerciseTheme.textSecondary.withValues(alpha: .35),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('workout.no_exercise_found'),
            style: TextStyle(
              color: context.exerciseTheme.textSecondary,
              fontSize: 15,
            ),
          ),
          if (_activeCount > 0) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _clearFilters,
              child: Text(
                context.tr('exercise.clear_filters'),
                style: TextStyle(
                  color: context.exerciseTheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── exercise card ─────────────────────────────────────────────────────────

  Widget _buildCard(ExerciseModel exercise) {
    final locale = ref.watch(languageProvider);
    final na = context.tr('common.na');
    final name = exercise.nameI18n?.fromI18n(locale) ?? exercise.id ?? na;
    final isBodyweight = exercise.isBodyweight ?? false;

    Future<void> openDetail() async {
      final selectedExercise = await context.push<ExerciseDetailModel>(
        '/exercises/${exercise.id}',
      );
      if (!mounted) return;
      if (selectedExercise == null) return;
      final selectedName =
          selectedExercise.nameI18n?.fromI18n(locale) ??
          selectedExercise.id ??
          na;
      _addExercise(selectedExercise, selectedName, locale, na);
    }

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 78,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: context.exerciseTheme.surface,
            border: Border.all(color: context.exerciseTheme.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: openDetail,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: context.exerciseTheme.primaryMuted
                                    .withValues(alpha: .55),
                              ),
                              child: Icon(
                                isBodyweight
                                    ? Icons.self_improvement_rounded
                                    : Icons.fitness_center_rounded,
                                color: context.exerciseTheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.exerciseTheme.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Semantics(
                  button: true,
                  label: context.tr('workout.edit.add_exercise'),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: context.tr('workout.edit.add_exercise'),
                        onPressed: () =>
                            _addExerciseFromSummary(exercise, name, locale, na),
                        padding: EdgeInsets.zero,
                        icon: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.exerciseTheme.primary,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: context.exerciseTheme.background,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addExerciseFromSummary(
    ExerciseModel exercise,
    String name,
    Locale locale,
    String notAvailable,
  ) async {
    final id = exercise.id;
    if (id == null || id.isEmpty) return;
    final repository = ref.read(exerciseInfoPageRepositoryProvider);
    final response = await repository.getExerciseDetail(id);
    if (!mounted) return;
    if (!response.success || response.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? context.tr('common.error'))),
      );
      return;
    }
    _addExercise(response.data!, name, locale, notAvailable);
  }

  void _addExercise(
    ExerciseDetailModel exercise,
    String name,
    Locale locale,
    String notAvailable,
  ) {
    final defaults = _lastSessionDefaults(exercise.id ?? '');
    widget.onExerciseSelected(
      EditableExerciseModel(
        id: 'ex_${DateTime.now().millisecondsSinceEpoch}_${exercise.id}',
        exerciseId: exercise.id ?? '',
        number: 0,
        name: name,
        muscles: (exercise.muscles ?? const [])
            .map((m) => m.muscle?.nameI18n.fromI18n(locale) ?? notAvailable)
            .toList(),
        // Kept only for the existing workout payload; it is not exposed in the UI.
        difficulty: '',
        sets: defaults.sets,
        rest: '60s',
        weight: defaults.weight,
        progress: '0',
        notes: '',
        accentColorHex: '#20D3B0',
        variants: exercise.variants ?? const [],
      ),
    );
    Navigator.pop(context);
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  /// Reads the last recorded session entry for [exerciseId] from Hive and
  /// returns pre-filled defaults for Serie x Ripetizioni and Carico.
  /// Falls back to generic defaults if no session data is found.
  ({String sets, String weight}) _lastSessionDefaults(String exerciseId) {
    try {
      final db = ref.read(localDatabaseServiceProvider);
      LocalWorkoutSessionEntry? bestEntry;
      DateTime? bestDate;

      for (final raw in db.workoutSessions.values) {
        final session = LocalWorkoutSession.fromJson(
          raw.map((k, v) => MapEntry(k.toString(), v)),
        );
        final date = session.completedAt ?? session.updatedAt;
        for (final entry in session.entries) {
          if (entry.exerciseId != exerciseId) continue;
          if (bestDate == null || date.isAfter(bestDate)) {
            bestDate = date;
            bestEntry = entry;
          }
        }
      }

      if (bestEntry == null || bestEntry.sets.isEmpty) {
        // TODO: no previous session data found for this exercise
        return (sets: '3', weight: '');
      }

      final setsCount = bestEntry.sets.length;
      final reps = bestEntry.sets.first.reps ?? 0;
      final load = bestEntry.sets.first.load;
      final setsStr = '$setsCount x $reps';
      final weightStr = (load != null && load > 0) ? '$load' : '';
      return (sets: setsStr, weight: weightStr);
    } catch (_) {
      // TODO: failed to read Hive session data for exercise $exerciseId
      return (sets: '3', weight: '');
    }
  }

  List<ExerciseModel> _filterAndExclude(List<ExerciseModel> list) {
    final text = _filter.textFilter?.trim().toLowerCase();
    return list
        .where((exercise) {
          if (widget.excludedExerciseIds.contains(exercise.id)) return false;
          if (_scope == 'mine' && !exercise.isPersonal) return false;
          if (_scope == 'default' && exercise.isPersonal) return false;
          if (text == null || text.isEmpty) return true;
          return exercise.nameI18n?.values.any(
                (name) => name.toLowerCase().contains(text),
              ) ??
              false;
        })
        .toList(growable: false);
  }

  String _mechanicsLabel(String raw) => switch (raw.toLowerCase()) {
    'compound' => context.tr('exercise.mechanics.compound'),
    'isolation' => context.tr('exercise.mechanics.isolation'),
    _ => raw,
  };

  String _forceLabel(String raw) => switch (raw.toLowerCase()) {
    'push' => context.tr('exercise.force.push'),
    'pull' => context.tr('exercise.force.pull'),
    'legs' => context.tr('exercise.force.legs'),
    'core' => context.tr('exercise.force.core'),
    'static' => context.tr('exercise.force.static'),
    _ => raw,
  };
}

// ─────────────────────────── data class ──────────────────────────────────────

/// A wide touch target with a lightweight, app-styled scroll thumb.
///
/// [RawScrollbar]'s hit area is only as wide as its thumb, which is difficult
/// to grab in a long exercise catalogue. This rail maps a drag directly to the
/// list offset and rebuilds only itself while the list scrolls.
class _ExerciseListScrollRail extends StatefulWidget {
  static const _minThumbLength = 52.0;

  final ScrollController controller;

  const _ExerciseListScrollRail({required this.controller});

  @override
  State<_ExerciseListScrollRail> createState() =>
      _ExerciseListScrollRailState();
}

class _ExerciseListScrollRailState extends State<_ExerciseListScrollRail> {
  double? _pendingOffset;
  bool _scrollScheduled = false;
  ScrollPosition? _scrollPosition;
  bool _isScrolling = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _attachScrollState());
  }

  @override
  void didUpdateWidget(covariant _ExerciseListScrollRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detachScrollState();
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => _attachScrollState(),
      );
    }
  }

  @override
  void dispose() {
    _detachScrollState();
    super.dispose();
  }

  void _attachScrollState() {
    if (!mounted || !widget.controller.hasClients) return;
    _scrollPosition = widget.controller.position;
    _scrollPosition!.isScrollingNotifier.addListener(_onScrollStateChanged);
    _onScrollStateChanged();
  }

  void _detachScrollState() {
    _scrollPosition?.isScrollingNotifier.removeListener(_onScrollStateChanged);
    _scrollPosition = null;
  }

  void _onScrollStateChanged() {
    final isScrolling = _scrollPosition?.isScrollingNotifier.value ?? false;
    if (mounted && isScrolling != _isScrolling) {
      setState(() => _isScrolling = isScrolling);
    }
  }

  void _setDragging(bool value) {
    if (_isDragging != value) setState(() => _isDragging = value);
  }

  void _moveTo(double localY, double trackHeight, {required bool immediately}) {
    if (!widget.controller.hasClients) return;
    final position = widget.controller.position;
    final maxScroll = position.maxScrollExtent;
    if (maxScroll <= 0 || trackHeight <= 0) return;

    final contentHeight = maxScroll + position.viewportDimension;
    final thumbHeight = (trackHeight * trackHeight / contentHeight)
        .clamp(_ExerciseListScrollRail._minThumbLength, trackHeight)
        .toDouble();
    final travel = trackHeight - thumbHeight;
    if (travel <= 0) return;

    final thumbTop = (localY - thumbHeight / 2).clamp(0.0, travel).toDouble();
    final targetOffset = thumbTop / travel * maxScroll;
    if (immediately) {
      widget.controller.jumpTo(targetOffset);
      return;
    }

    // Pointer events can arrive faster than Flutter can paint. Coalescing
    // drag updates to a frame prevents the rail from flooding the scrollable
    // with jumpTo calls while preserving direct thumb tracking.
    _pendingOffset = targetOffset;
    if (_scrollScheduled) return;
    _scrollScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollScheduled = false;
      final offset = _pendingOffset;
      _pendingOffset = null;
      if (!mounted || offset == null || !widget.controller.hasClients) return;
      final position = widget.controller.position;
      widget.controller.jumpTo(offset.clamp(0.0, position.maxScrollExtent));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackHeight = constraints.maxHeight;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              _moveTo(details.localPosition.dy, trackHeight, immediately: true),
          onPanStart: (details) {
            _setDragging(true);
            _moveTo(details.localPosition.dy, trackHeight, immediately: true);
          },
          onPanUpdate: (details) => _moveTo(
            details.localPosition.dy,
            trackHeight,
            immediately: false,
          ),
          onPanEnd: (_) => _setDragging(false),
          onPanCancel: () => _setDragging(false),
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              if (!widget.controller.hasClients) return const SizedBox.expand();
              final position = widget.controller.position;
              final maxScroll = position.maxScrollExtent;
              if (maxScroll <= 0 || trackHeight <= 0) {
                return const SizedBox.expand();
              }

              final contentHeight = maxScroll + position.viewportDimension;
              final thumbHeight = (trackHeight * trackHeight / contentHeight)
                  .clamp(_ExerciseListScrollRail._minThumbLength, trackHeight)
                  .toDouble();
              final travel = trackHeight - thumbHeight;
              final thumbTop = travel <= 0
                  ? 0.0
                  : (position.pixels / maxScroll * travel)
                        .clamp(0.0, travel)
                        .toDouble();

              return Stack(
                children: [
                  Center(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: MediaQuery.of(context).disableAnimations
                        ? Duration.zero
                        : const Duration(milliseconds: 90),
                    curve: Curves.easeOutCubic,
                    top: thumbTop,
                    left: 10,
                    right: 10,
                    height: thumbHeight,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: _isScrolling ? 1 : 0.62,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 120),
                        scale: _isDragging ? 1.12 : 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                Theme.of(context).colorScheme.surfaceContainer,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.surface.withValues(alpha: 0.55),
                                blurRadius: _isDragging ? 8 : 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _Option {
  final String id;
  final String label;
  final bool isPrimary;

  const _Option({
    required this.id,
    required this.label,
    this.isPrimary = false,
  });
}
