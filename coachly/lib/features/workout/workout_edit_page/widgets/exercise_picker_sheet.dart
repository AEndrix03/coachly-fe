import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:flutter/material.dart';

class ExercisePickerSheet extends StatefulWidget {
  final Function(EditableExerciseModel) onExerciseSelected;

  const ExercisePickerSheet({super.key, required this.onExerciseSelected});

  @override
  State<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<ExercisePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  String _selectedMuscle = 'Tutti';
  String _selectedDifficulty = 'Tutti';

  final List<String> _muscles = [
    'Tutti',
    'Petto',
    'Dorsali',
    'Spalle',
    'Bicipiti',
    'Tricipiti',
    'Gambe',
    'Addominali',
  ];

  final List<String> _difficulties = [
    'Tutti',
    'Base',
    'Intermedio',
    'Avanzato',
  ];

  final List<EditableExerciseModel> _allExercises = const [
    EditableExerciseModel(
      id: 'new_1',
      exerciseId: 'ex_3',
      number: 0,
      name: 'Panca Declinata',
      muscle: 'Petto Basso',
      difficulty: 'Intermedio',
      sets: '3 × 10',
      rest: '90s',
      weight: '',
      progress: '',
      notes: '',
      accentColorHex: '#2196F3',
      hasVariants: true,
    ),
    EditableExerciseModel(
      id: 'new_2',
      exerciseId: 'ex_4',
      number: 0,
      name: 'Croci Manubri',
      muscle: 'Petto',
      difficulty: 'Base',
      sets: '3 × 12-15',
      rest: '60s',
      weight: '',
      progress: '',
      notes: '',
      accentColorHex: '#2196F3',
      hasVariants: true,
    ),
    EditableExerciseModel(
      id: 'new_3',
      exerciseId: 'ex_5',
      number: 0,
      name: 'Dips',
      muscle: 'Petto Basso',
      difficulty: 'Avanzato',
      sets: '4 × 8',
      rest: '120s',
      weight: '',
      progress: '',
      notes: '',
      accentColorHex: '#2196F3',
      hasVariants: false,
    ),
    EditableExerciseModel(
      id: 'new_4',
      exerciseId: 'ex_6',
      number: 0,
      name: 'Lat Machine',
      muscle: 'Dorsali',
      difficulty: 'Base',
      sets: '3 × 12',
      rest: '75s',
      weight: '',
      progress: '',
      notes: '',
      accentColorHex: '#4CAF50',
      hasVariants: true,
    ),
    EditableExerciseModel(
      id: 'new_5',
      exerciseId: 'ex_7',
      number: 0,
      name: 'Rematore Bilanciere',
      muscle: 'Dorsali',
      difficulty: 'Intermedio',
      sets: '4 × 8-10',
      rest: '90s',
      weight: '',
      progress: '',
      notes: '',
      accentColorHex: '#4CAF50',
      hasVariants: true,
    ),
  ];

  List<EditableExerciseModel> get _filteredExercises {
    return _allExercises.where((exercise) {
      final searchMatch = exercise.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final muscleMatch =
          _selectedMuscle == 'Tutti' ||
          exercise.muscle.contains(_selectedMuscle);
      final difficultyMatch =
          _selectedDifficulty == 'Tutti' ||
          exercise.difficulty == _selectedDifficulty;

      return searchMatch && muscleMatch && difficultyMatch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
          if (_showFilters) _buildFilters(),
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
              color: Colors.white.withOpacity(0.3),
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
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Cerca esercizio...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.5),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtri',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterChips('Muscolo', _muscles, _selectedMuscle, (value) {
            setState(() => _selectedMuscle = value);
          }),
          const SizedBox(height: 12),
          _buildFilterChips('Difficoltà', _difficulties, _selectedDifficulty, (
            value,
          ) {
            setState(() => _selectedDifficulty = value);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    String label,
    List<String> options,
    String selected,
    Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return GestureDetector(
              onTap: () => onSelected(option),
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
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.04),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2196F3)
                        : Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    final exercises = _filteredExercises;

    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Nessun esercizio trovato',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return _buildExerciseCard(exercises[index]);
      },
    );
  }

  Widget _buildExerciseCard(EditableExerciseModel exercise) {
    return GestureDetector(
      onTap: () {
        widget.onExerciseSelected(exercise);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2A2A3E).withOpacity(0.6),
              const Color(0xFF1A1A2E).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: exercise.accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: exercise.accentColor.withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
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
                      _buildSmallTag(exercise.muscle, exercise.accentColor),
                      const SizedBox(width: 8),
                      _buildSmallTag(
                        exercise.difficulty,
                        const Color(0xFFFF9800),
                      ),
                      if (exercise.hasVariants) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.swap_horiz,
                          size: 14,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline,
              color: exercise.accentColor,
              size: 24,
            ),
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
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
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
