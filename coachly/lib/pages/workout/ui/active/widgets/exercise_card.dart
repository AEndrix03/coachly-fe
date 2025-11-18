import 'package:flutter/material.dart';

import 'set_row.dart';

class ExerciseCard extends StatefulWidget {
  final int exerciseNumber;
  final String title;
  final String setsRange;
  final String repsRange;
  final List<Map<String, dynamic>> sets;
  final bool isExpanded;

  const ExerciseCard({
    super.key,
    required this.exerciseNumber,
    required this.title,
    required this.setsRange,
    required this.repsRange,
    required this.sets,
    this.isExpanded = false,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E2A), Color(0xFF14141F)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3A), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_isExpanded) ...[
            const Divider(color: Color(0xFF2A2A3A), height: 1),
            _buildSetsSection(),
            _buildAddSetButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.exerciseNumber}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.setsRange} • ${widget.repsRange}',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white70,
              size: 20,
            ),
            onPressed: () {
              // TODO: Mostra exercise_detail_page in dialog
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
            color: const Color(0xFF2A2A3A),
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
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
              const PopupMenuItem(
                value: 'notes',
                child: Row(
                  children: [
                    Icon(Icons.note_outlined, color: Colors.white70, size: 18),
                    SizedBox(width: 12),
                    Text(
                      'Note esercizio',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'add_set',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white70, size: 18),
                    SizedBox(width: 12),
                    Text(
                      'Aggiungi serie',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'replace',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: Colors.white70, size: 18),
                    SizedBox(width: 12),
                    Text('Sostituisci', style: TextStyle(color: Colors.white)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            // TODO: Update set completion
          },
          onWeightChanged: (weight) {
            // TODO: Update weight
          },
          onRepsChanged: (reps) {
            // TODO: Update reps
          },
          onTypeChanged: (type) {
            // TODO: Update type
          },
          onDelete: () {
            // TODO: Delete set
          },
          onDuplicate: () {
            // TODO: Duplicate set
          },
        );
      },
    );
  }

  Widget _buildAddSetButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _addSet,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Serie'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Color(0xFF2A2A3A)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  void _addSet() {
    // TODO: Add new set
    setState(() {});
  }
}
