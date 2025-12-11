import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:flutter/material.dart';

class EditableExerciseCard extends StatefulWidget {
  final EditableExerciseModel exercise;
  final VoidCallback onRemove;
  final VoidCallback onFindVariant;
  final Function(EditableExerciseModel) onUpdate;
  final bool isDragging;

  const EditableExerciseCard({
    super.key,
    required this.exercise,
    required this.onRemove,
    required this.onFindVariant,
    required this.onUpdate,
    this.isDragging = false,
  });

  @override
  State<EditableExerciseCard> createState() => _EditableExerciseCardState();
}

class _EditableExerciseCardState extends State<EditableExerciseCard> {
  late TextEditingController _setsController;
  late TextEditingController _restController;
  late TextEditingController _weightController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(text: widget.exercise.sets);
    _restController = TextEditingController(text: widget.exercise.rest);
    _weightController = TextEditingController(text: widget.exercise.weight);
    _notesController = TextEditingController(text: widget.exercise.notes);
  }

  @override
  void dispose() {
    _setsController.dispose();
    _restController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateExercise() {
    /*widget.onUpdate(
      widget.exercise.updateEditable(
        sets: _setsController.text,
        rest: _restController.text,
        weight: _weightController.text,
        notes: _notesController.text,
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(
        bottom: 16,
        left: widget.isDragging ? 8 : 0,
        right: widget.isDragging ? 8 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A2A3E).withOpacity(widget.isDragging ? 0.8 : 0.6),
            const Color(0xFF1A1A2E).withOpacity(widget.isDragging ? 0.95 : 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          width: widget.isDragging ? 2 : 1.5,
          color: widget.isDragging
              ? widget.exercise.accentColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isDragging
                ? widget.exercise.accentColor.withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
            blurRadius: widget.isDragging ? 25 : 20,
            offset: Offset(0, widget.isDragging ? 12 : 8),
            spreadRadius: widget.isDragging ? 2 : -4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMainContent(),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          _buildEditableFields(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _buildDragHandle(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.exercise.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildTag(
                      widget.exercise.muscle,
                      widget.exercise.accentColor,
                      Icons.fitbit,
                    ),
                    const SizedBox(width: 8),
                    _buildTag(
                      widget.exercise.difficulty,
                      const Color(0xFFFF9800),
                      Icons.whatshot,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return ReorderableDragStartListener(
      index: widget.exercise.number - 1,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A4A5E), Color(0xFF2A2A3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 2, color: Colors.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.exercise.number.toString(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.exercise.hasVariants)
          _buildIconButton(
            Icons.swap_horiz,
            widget.exercise.accentColor,
            widget.onFindVariant,
          ),
        const SizedBox(height: 8),
        _buildIconButton(
          Icons.delete_outline,
          const Color(0xFFFF5252),
          widget.onRemove,
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildEditableFields() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(19),
          bottomRight: Radius.circular(19),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  'Serie × Reps',
                  _setsController,
                  '3 × 10',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('Rest', _restController, '60s')),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField('Peso', _weightController, '80kg'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNotesField(),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
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
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: (_) => _updateExercise(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: TextField(
            controller: _notesController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Aggiungi note...',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (_) => _updateExercise(),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.35), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
