import 'package:coachly/core/utils/debouncer.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/providers/exercise_list_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FilterOption {
  final String id;
  final String label;

  const _FilterOption({
    required this.id,
    required this.label,
  });
}

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

class _ExercisePickerSheetState extends ConsumerState<ExercisePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 500),
  );
  bool _showFilters = false;
  String? _selectedMuscleId;
  String? _selectedDifficulty;

  ExerciseFilterModel _currentFilter = const ExerciseFilterModel();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      _performSearch();
    });
  }

  void _performSearch() {
    final locale = ref.read(languageProvider);
    final langFilter = '${locale.languageCode}_${locale.countryCode}';

    setState(() {
      _currentFilter = _currentFilter.copyWith(
        textFilter:
            _searchController.text.length >= 3 || _searchController.text.isEmpty
            ? _searchController.text
            : null,
        langFilter: langFilter,
      );
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          if (_showFilters)
            Consumer(
              builder: (context, ref, child) {
                final exerciseListValue = ref.watch(
                  exerciseListProvider(filter: _currentFilter),
                );
                return exerciseListValue.when(
                  data: (exercises) {
                    final visibleExercises = _excludeAlreadySelected(exercises);
                    final locale = ref.read(languageProvider);
                    final muscleById = <String, _FilterOption>{};
                    for (final exercise in visibleExercises) {
                      for (final exerciseMuscle in exercise.muscles ?? const []) {
                        final muscle = exerciseMuscle.muscle;
                        final muscleId = muscle?.id;
                        if (muscleId == null || muscleId.isEmpty) {
                          continue;
                        }
                        muscleById[muscleId] = _FilterOption(
                          id: muscleId,
                          label: muscle?.nameI18n.fromI18n(locale) ?? muscleId,
                        );
                      }
                    }
                    final availableMuscles = muscleById.values.toList()
                      ..sort((a, b) => a.label.compareTo(b.label));
                    final availableDifficulties = visibleExercises
                        .map((e) => e.difficultyLevel)
                        .whereType<String>()
                        .toSet()
                        .toList()
                      ..sort();
                    return _buildFilters(
                      availableMuscles,
                      availableDifficulties,
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => const SizedBox.shrink(),
                );
              },
            ),
          Expanded(child: _buildExerciseList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF8E29EC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Aggiungi Esercizio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                  color: _showFilters ? const Color(0xFF2196F3) : Colors.white,
                ),
                onPressed: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Cerca esercizio...',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(
    List<_FilterOption> availableMuscles,
    List<String> availableDifficulties,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtri',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterChips<_FilterOption>(
            'Muscolo',
            availableMuscles,
            _selectedMuscleId,
            (option) => option.id,
            (option) => option.label,
            (value) {
              _debouncer.run(() {
                setState(() {
                  _selectedMuscleId = value;
                  _currentFilter = _currentFilter.copyWith(
                    muscleIds: value != null ? [value] : null,
                  );
                });
              });
            },
          ),
          const SizedBox(height: 12),
          _buildFilterChips<String>(
            'Difficolta',
            availableDifficulties,
            _selectedDifficulty,
            (value) => value,
            (value) => value,
            (value) {
              _debouncer.run(() {
                setState(() {
                  _selectedDifficulty = value;
                  _currentFilter = _currentFilter.copyWith(
                    difficultyLevel: value,
                  );
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips<T>(
    String label,
    List<T> options,
    String? selected,
    String Function(T option) getValue,
    String Function(T option) getLabel,
    Function(String?) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            GestureDetector(
              onTap: () => onSelected(null),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: selected == null
                      ? const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.04),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected == null
                        ? const Color(0xFF2196F3)
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  'Tutti',
                  style: TextStyle(
                    color: selected == null
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: selected == null
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
            ...options.map((option) {
              final optionValue = getValue(option);
              final isSelected = optionValue == selected;
              return GestureDetector(
                onTap: () => onSelected(optionValue),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.04),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2196F3)
                          : Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    getLabel(option),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    final exerciseListValue = ref.watch(
      exerciseListProvider(filter: _currentFilter),
    );

    return exerciseListValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'Error: ${err.toString()}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (exercises) {
        final visibleExercises = _excludeAlreadySelected(exercises);

        if (visibleExercises.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nessun esercizio trovato',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: visibleExercises.length,
          itemBuilder: (context, index) {
            return _buildExerciseCard(visibleExercises[index]);
          },
        );
      },
    );
  }

  List<ExerciseDetailModel> _excludeAlreadySelected(
    List<ExerciseDetailModel> exercises,
  ) {
    if (widget.excludedExerciseIds.isEmpty) {
      return exercises;
    }

    return exercises
        .where((exercise) => !widget.excludedExerciseIds.contains(exercise.id))
        .toList();
  }

  Widget _buildExerciseCard(ExerciseDetailModel exercise) {
    final locale = ref.watch(languageProvider);
    final accentColor = Color(int.parse('0xFF2196F3'));

    return GestureDetector(
      onTap: () {
        final editableExercise = EditableExerciseModel(
          id: 'ex_${DateTime.now().millisecondsSinceEpoch}_${exercise.id}',
          exerciseId: exercise.id ?? '',
          number: 0,
          name: exercise.nameI18n?.fromI18n(locale) ?? exercise.id ?? 'N/A',
          muscles: (exercise.muscles ?? const [])
              .map((m) => m.muscle?.nameI18n.fromI18n(locale) ?? 'N/A')
              .toList(),
          difficulty: exercise.difficultyLevel ?? 'N/A',
          sets: '3',
          rest: '60s',
          weight: '',
          progress: '0',
          notes: '',
          accentColorHex: '#2196F3',
          variants: exercise.variants ?? const [],
        );
        widget.onExerciseSelected(editableExercise);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2A2A3E).withValues(alpha: 0.6),
              const Color(0xFF1A1A2E).withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: accentColor.withValues(alpha: 0.5), blurRadius: 8),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.nameI18n?.fromI18n(locale) ?? exercise.id ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildSmallTag(
                        (exercise.muscles ?? const [])
                            .map(
                              (m) =>
                                  m.muscle?.nameI18n.fromI18n(locale) ?? 'N/A',
                            )
                            .join(', '),
                        accentColor,
                      ),
                      const SizedBox(width: 8),
                      _buildSmallTag(
                        exercise.difficultyLevel ?? 'N/A',
                        const Color(0xFFFF9800),
                      ),
                      if ((exercise.variants ?? const []).isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.swap_horiz,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline, color: accentColor, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
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
}
