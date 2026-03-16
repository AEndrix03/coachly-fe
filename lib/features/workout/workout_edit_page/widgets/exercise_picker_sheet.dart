import 'package:coachly/core/utils/debouncer.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/providers/exercise_list_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  bool _showAdvanced = false;

  // active filters
  String? _categoryId;
  String? _muscleId;
  String? _difficulty;
  String? _mechanics;
  String? _forceType;
  bool? _bodyweight;
  bool? _unilateral;

  ExerciseFilterModel _filter = const ExerciseFilterModel();

  // ── lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  // ── filter logic ──────────────────────────────────────────────────────────

  void _onSearch() {
    _debouncer.run(_applyFilters);
  }

  void _applyFilters() {
    final locale = ref.read(languageProvider);
    final lang = '${locale.languageCode}_${locale.countryCode}';
    final text = _searchCtrl.text;
    setState(() {
      _filter = ExerciseFilterModel(
        textFilter: text.length >= 2 || text.isEmpty ? text : null,
        langFilter: lang,
        difficultyLevel: _difficulty,
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
      _difficulty = null;
      _mechanics = null;
      _forceType = null;
      _bodyweight = null;
      _unilateral = null;
    });
    _applyFilters();
  }

  int get _activeCount => [
    _categoryId,
    _muscleId,
    _difficulty,
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
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          _buildSearchBar(),
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
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Aggiungi Esercizio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          // filter button with badge
          GestureDetector(
            onTap: () => setState(() => _showAdvanced = !_showAdvanced),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _showAdvanced || _activeCount > 0
                    ? const LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.04),
                        ],
                      ),
                border: Border.all(
                  color: _showAdvanced || _activeCount > 0
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: _showAdvanced || _activeCount > 0
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.6),
                  ),
                  if (_activeCount > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '$_activeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (_activeCount > 0) ...[
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: _clearFilters,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
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
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Cerca esercizio...',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 15,
            ),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.4), size: 20),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? GestureDetector(
                    onTap: () { _searchCtrl.clear(); _applyFilters(); },
                    child: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.4), size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  // ── filter options source ─────────────────────────────────────────────────

  /// Uses a base filter (text + lang only) to build available filter options
  /// so options don't disappear when categorical filters are applied.
  Widget _buildOptionsSource() {
    final locale = ref.read(languageProvider);
    final lang = '${locale.languageCode}_${locale.countryCode}';
    final text = _searchCtrl.text;
    final baseFilter = ExerciseFilterModel(
      langFilter: lang,
      textFilter: text.length >= 2 || text.isEmpty ? text : null,
    );

    return Consumer(
      builder: (context, ref, _) {
        final all = ref.watch(exerciseListProvider(filter: baseFilter));
        return all.maybeWhen(
          data: (exercises) => _buildFilterPanel(exercises),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

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
            label: cat.nameI18n?.fromI18n(locale) ?? id,
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
          () => _Option(id: id, label: em.muscle?.nameI18n.fromI18n(locale) ?? id),
        );
      }
    }
    final muscles = muscleById.values.toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    // Extract mechanics
    final mechanics = exercises
        .map((e) => e.mechanicsType)
        .whereType<String>()
        .toSet()
        .toList()..sort();

    // Extract force types
    final forceTypes = exercises
        .map((e) => e.forceType)
        .whereType<String>()
        .toSet()
        .toList()..sort();

    // Extract difficulties
    final difficulties = exercises
        .map((e) => e.difficultyLevel)
        .whereType<String>()
        .toSet()
        .toList()..sort();

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
              ? _buildAdvancedFilters(muscles, mechanics, forceTypes, difficulties)
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ],
    );
  }

  Widget _buildAdvancedFilters(
    List<_Option> muscles,
    List<String> mechanics,
    List<String> forceTypes,
    List<String> difficulties,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (muscles.isNotEmpty) ...[
            _buildFilterLabel('Muscolo'),
            _buildHorizontalChips<_Option>(
              items: muscles,
              selected: _muscleId,
              getLabel: (o) => o.label,
              getId: (o) => o.id,
              color: const Color(0xFF9C27B0),
              onTap: (id) {
                setState(() => _muscleId = _muscleId == id ? null : id);
                _applyFilters();
              },
            ),
          ],
          if (mechanics.isNotEmpty) ...[
            _buildFilterLabel('Meccanica'),
            _buildHorizontalChips<String>(
              items: mechanics,
              selected: _mechanics,
              getLabel: (s) => _mechanicsLabel(s),
              getId: (s) => s,
              color: const Color(0xFF00BCD4),
              onTap: (id) {
                setState(() => _mechanics = _mechanics == id ? null : id);
                _applyFilters();
              },
            ),
          ],
          if (forceTypes.isNotEmpty) ...[
            _buildFilterLabel('Tipo di forza'),
            _buildHorizontalChips<String>(
              items: forceTypes,
              selected: _forceType,
              getLabel: (s) => _forceLabel(s),
              getId: (s) => s,
              color: const Color(0xFFFF9800),
              onTap: (id) {
                setState(() => _forceType = _forceType == id ? null : id);
                _applyFilters();
              },
            ),
          ],
          if (difficulties.isNotEmpty) ...[
            _buildFilterLabel('Difficoltà'),
            _buildHorizontalChips<String>(
              items: difficulties,
              selected: _difficulty,
              getLabel: (s) => _difficultyLabel(s),
              getId: (s) => s,
              color: const Color(0xFFFF5252),
              onTap: (id) {
                setState(() => _difficulty = _difficulty == id ? null : id);
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
                  label: 'Solo corpo libero',
                  icon: Icons.self_improvement_rounded,
                  active: _bodyweight == true,
                  color: const Color(0xFF4CAF50),
                  onTap: () {
                    setState(() => _bodyweight = _bodyweight == true ? null : true);
                    _applyFilters();
                  },
                ),
                _buildToggleChip(
                  label: 'Con attrezzi',
                  icon: Icons.fitness_center_rounded,
                  active: _bodyweight == false,
                  color: const Color(0xFF2196F3),
                  onTap: () {
                    setState(() => _bodyweight = _bodyweight == false ? null : false);
                    _applyFilters();
                  },
                ),
                _buildToggleChip(
                  label: 'Unilaterale',
                  icon: Icons.swap_horiz_rounded,
                  active: _unilateral == true,
                  color: const Color(0xFF7B4BC1),
                  onTap: () {
                    setState(() => _unilateral = _unilateral == true ? null : true);
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
          color: Colors.white.withValues(alpha: 0.45),
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
    Color color = const Color(0xFF2196F3),
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
                gradient: isActive
                    ? LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.07),
                          Colors.white.withValues(alpha: 0.04),
                        ],
                      ),
                border: Border.all(
                  color: isActive ? color : Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 10,
                          spreadRadius: -3,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                getLabel(item),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: active
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)])
              : LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.07),
                    Colors.white.withValues(alpha: 0.04),
                  ],
                ),
          border: Border.all(
            color: active ? color : Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: active ? Colors.white : Colors.white.withValues(alpha: 0.5)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white.withValues(alpha: 0.6),
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
        final value = ref.watch(exerciseListProvider(filter: _filter));
        return value.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF2196F3)),
              strokeWidth: 2,
            ),
          ),
          error: (err, _) => Center(
            child: Text(err.toString(), style: const TextStyle(color: Colors.red)),
          ),
          data: (exercises) {
            final visible = _excludeSelected(exercises);
            if (visible.isEmpty) return _buildEmptyList();
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: visible.length,
              itemBuilder: (_, i) => _buildCard(visible[i]),
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
          Icon(Icons.search_off_rounded, size: 56, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            'Nessun esercizio trovato',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 15),
          ),
          if (_activeCount > 0) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _clearFilters,
              child: const Text(
                'Rimuovi filtri',
                style: TextStyle(
                  color: Color(0xFF2196F3),
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

  Widget _buildCard(ExerciseDetailModel exercise) {
    final locale = ref.watch(languageProvider);
    final name = exercise.nameI18n?.fromI18n(locale) ?? exercise.id ?? 'N/A';
    final muscles = (exercise.muscles ?? const [])
        .map((m) => m.muscle?.nameI18n.fromI18n(locale) ?? '')
        .where((s) => s.isNotEmpty)
        .take(2)
        .join(', ');
    final difficulty = exercise.difficultyLevel;
    final mechanics = exercise.mechanicsType;
    final isBodyweight = exercise.isBodyweight ?? false;

    return GestureDetector(
      onTap: () {
        widget.onExerciseSelected(EditableExerciseModel(
          id: 'ex_${DateTime.now().millisecondsSinceEpoch}_${exercise.id}',
          exerciseId: exercise.id ?? '',
          number: 0,
          name: name,
          muscles: (exercise.muscles ?? const [])
              .map((m) => m.muscle?.nameI18n.fromI18n(locale) ?? 'N/A')
              .toList(),
          difficulty: difficulty ?? 'N/A',
          sets: '3',
          rest: '60s',
          weight: '',
          progress: '0',
          notes: '',
          accentColorHex: '#2196F3',
          variants: exercise.variants ?? const [],
        ));
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07), width: 1),
        ),
        child: Row(
          children: [
            // Accent dot
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2196F3).withValues(alpha: 0.25),
                    const Color(0xFF7B4BC1).withValues(alpha: 0.15),
                  ],
                ),
              ),
              child: Icon(
                isBodyweight ? Icons.self_improvement_rounded : Icons.fitness_center_rounded,
                color: const Color(0xFF2196F3),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Name + tags
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (muscles.isNotEmpty)
                        _cardTag(muscles, const Color(0xFF2196F3)),
                      if (difficulty != null)
                        _cardTag(_difficultyLabel(difficulty), _difficultyColor(difficulty)),
                      if (mechanics != null)
                        _cardTag(_mechanicsLabel(mechanics), const Color(0xFF00BCD4)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Add icon
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withValues(alpha: 0.35),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  List<ExerciseDetailModel> _excludeSelected(List<ExerciseDetailModel> list) {
    if (widget.excludedExerciseIds.isEmpty) return list;
    return list.where((e) => !widget.excludedExerciseIds.contains(e.id)).toList();
  }

  String _difficultyLabel(String raw) => switch (raw.toLowerCase()) {
        'beginner' => 'Principiante',
        'intermediate' => 'Intermedio',
        'advanced' => 'Avanzato',
        _ => raw,
      };

  Color _difficultyColor(String raw) => switch (raw.toLowerCase()) {
        'beginner' => const Color(0xFF4CAF50),
        'intermediate' => const Color(0xFFFF9800),
        'advanced' => const Color(0xFFFF5252),
        _ => Colors.white54,
      };

  String _mechanicsLabel(String raw) => switch (raw.toLowerCase()) {
        'compound' => 'Composto',
        'isolation' => 'Isolamento',
        _ => raw,
      };

  String _forceLabel(String raw) => switch (raw.toLowerCase()) {
        'push' => 'Spinta',
        'pull' => 'Trazione',
        'legs' => 'Gambe',
        'core' => 'Core',
        'static' => 'Statico',
        _ => raw,
      };
}

// ─────────────────────────── data class ──────────────────────────────────────

class _Option {
  final String id;
  final String label;
  final bool isPrimary;

  const _Option({required this.id, required this.label, this.isPrimary = false});
}
