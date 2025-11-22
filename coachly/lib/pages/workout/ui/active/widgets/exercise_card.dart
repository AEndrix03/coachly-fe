import 'package:coachly/widgets/common/exercise_info_widget.dart';
import 'package:flutter/material.dart';

import 'set_row.dart';

class ExerciseCard extends StatefulWidget {
  final int exerciseNumber;
  final String title;
  final String setsRange;
  final String repsRange;
  final List<Map<String, dynamic>> sets;
  final bool isExpanded;
  final int restSeconds;
  final VoidCallback? onSetCompleted;

  const ExerciseCard({
    super.key,
    required this.exerciseNumber,
    required this.title,
    required this.setsRange,
    required this.repsRange,
    required this.sets,
    this.isExpanded = false,
    this.restSeconds = 90,
    this.onSetCompleted,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
    );
    if (_isExpanded) {
      _expandController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedSets = widget.sets
        .where((set) => set['completed'] == true)
        .length;
    final totalSets = widget.sets.length;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E2A), Color(0xFF14141F)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(16),
            child: _buildHeader(completedSets, totalSets),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(
                  color: Color(0xFF2A2A3A),
                  height: 1,
                  thickness: 1,
                ),
                _buildSetsSection(),
                _buildAddSetButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int completedSets, int totalSets) {
    return Padding(
      padding: const EdgeInsets.all(14), // RIDOTTO da 16 a 14
      child: Row(
        children: [
          // Exercise number badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF3A3A4A), width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.exerciseNumber}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Exercise info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Progress indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: completedSets == totalSets
                            ? const Color(0xFF10B981).withOpacity(0.2)
                            : const Color(0xFF2A2A3A),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: completedSets == totalSets
                              ? const Color(0xFF10B981)
                              : const Color(0xFF3A3A4A),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '$completedSets/$totalSets',
                        style: TextStyle(
                          color: completedSets == totalSets
                              ? const Color(0xFF10B981)
                              : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${widget.repsRange}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Info button
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.white.withOpacity(0.6),
              size: 22,
            ),
            onPressed: () => _showExerciseInfo(context),
          ),

          // Menu button
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white.withOpacity(0.6),
              size: 22,
            ),
            color: const Color(0xFF2A2A3A),
            offset: const Offset(0, 40),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF3A3A4A), width: 1),
            ),
            onSelected: (value) {
              switch (value) {
                case 'notes':
                  // TODO: Note esercizio
                  break;
                case 'add_set':
                  _addSet();
                  break;
                case 'replace':
                  // TODO: Sostituisci esercizio
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'notes',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Note esercizio',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'add_set',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Aggiungi serie',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),
              PopupMenuItem(
                value: 'replace',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: Colors.white70, size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'Sostituisci',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetsSection() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      // RIDOTTO
      itemCount: widget.sets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final set = widget.sets[index];
        return SetRow(
          type: set['type'],
          weight: set['weight'].toDouble(),
          reps: set['reps'],
          completed: set['completed'],
          onCompleteToggle: (completed) {
            setState(() {
              widget.sets[index]['completed'] = completed;

              final allCompleted = widget.sets.every(
                (set) => set['completed'] == true,
              );

              if (allCompleted && _isExpanded) {
                Future.microtask(() {
                  if (mounted) {
                    _toggleExpanded();
                  }
                });
              }
            });

            // Triggera timer riposo se set completato
            if (completed && widget.onSetCompleted != null) {
              widget.onSetCompleted!();
            }
          },
          onWeightChanged: (weight) {
            setState(() {
              widget.sets[index]['weight'] = weight;
            });
          },
          onRepsChanged: (reps) {
            setState(() {
              widget.sets[index]['reps'] = reps;
            });
          },
          onTypeChanged: (type) {
            setState(() {
              widget.sets[index]['type'] = type;
            });
          },
          onDelete: () {
            setState(() {
              widget.sets.removeAt(index);
            });
          },
          onDuplicate: () {
            setState(() {
              widget.sets.insert(index + 1, Map<String, dynamic>.from(set));
            });
          },
        );
      },
    );
  }

  Widget _buildAddSetButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), // RIDOTTO
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _addSet,
          icon: const Icon(Icons.add, size: 20),
          label: const Text(
            'Serie',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Color(0xFF3A3A4A), width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  void _addSet() {
    setState(() {
      // Add new set with default values
      final lastSet = widget.sets.isNotEmpty
          ? widget.sets.last
          : {'type': 'Normale', 'weight': 0.0, 'reps': 0, 'completed': false};

      widget.sets.add({
        'type': lastSet['type'],
        'weight': lastSet['weight'],
        'reps': lastSet['reps'],
        'completed': false,
      });

      if (!_isExpanded) {
        _isExpanded = true;
        _expandController.forward();
      }
    });
  }

  void _showExerciseInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseInfoWidget(
        exerciseName: widget.title,
        onClose: () => Navigator.pop(context),
      ),
    );
  }
}
