import 'package:coachly/core/utils/debouncer.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditableExerciseCard extends StatefulWidget {
  final EditableExerciseModel exercise;
  final VoidCallback onRemove;
  final VoidCallback onFindVariant;
  final VoidCallback onPreview;
  final Function(EditableExerciseModel) onUpdate;
  final bool isDragging;
  final bool initiallyExpanded;

  const EditableExerciseCard({
    super.key,
    required this.exercise,
    required this.onRemove,
    required this.onFindVariant,
    required this.onPreview,
    required this.onUpdate,
    this.isDragging = false,
    this.initiallyExpanded = false,
  });

  @override
  State<EditableExerciseCard> createState() => _EditableExerciseCardState();
}

class _EditableExerciseCardState extends State<EditableExerciseCard> {
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _restController;
  late TextEditingController _weightController;
  late TextEditingController _notesController;

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _initializeControllers();

    _setsController.addListener(() => _debouncer.run(_updateExercise));
    _repsController.addListener(() => _debouncer.run(_updateExercise));
    _restController.addListener(() => _debouncer.run(_updateExercise));
    _weightController.addListener(() => _debouncer.run(_updateExercise));
    _notesController.addListener(() => _debouncer.run(_updateExercise));
  }

  @override
  void didUpdateWidget(covariant EditableExerciseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exercise != oldWidget.exercise) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final parts = _extractSetParts(widget.exercise.sets);
    final restValue = widget.exercise.rest.replaceAll(RegExp(r'[^0-9]'), '');
    final weightValue = widget.exercise.weight.replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );

    _setsController = TextEditingController(text: parts.$1);
    _repsController = TextEditingController(text: parts.$2);
    _restController = TextEditingController(text: restValue);
    _weightController = TextEditingController(text: weightValue);
    _notesController = TextEditingController(text: widget.exercise.notes);
  }

  void _updateControllers() {
    final parts = _extractSetParts(widget.exercise.sets);

    _setsController.text = parts.$1;
    _repsController.text = parts.$2;
    _restController.text = widget.exercise.rest.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    _weightController.text = widget.exercise.weight.replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );
    _notesController.text = widget.exercise.notes;
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  (String, String) _extractSetParts(String rawSets) {
    final matches = RegExp(
      r'\d+',
    ).allMatches(rawSets).map((m) => m.group(0)!).toList();
    if (matches.length >= 2) {
      return (matches[0], matches[1]);
    }
    if (matches.length == 1) {
      return (matches[0], '');
    }
    return ('', '');
  }

  void _updateExercise() {
    final sets = '${_setsController.text} x ${_repsController.text}';
    final rest = '${_restController.text}s';
    final weight = '${_weightController.text}kg';

    widget.onUpdate(
      widget.exercise.copyWith(
        sets: sets,
        rest: rest,
        weight: weight,
        notes: _notesController.text,
      ),
    );
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
            const Color(
              0xFF2A2A3E,
            ).withValues(alpha: widget.isDragging ? 0.8 : 0.6),
            const Color(
              0xFF1A1A2E,
            ).withValues(alpha: widget.isDragging ? 0.95 : 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          width: widget.isDragging ? 2 : 1.5,
          color: widget.isDragging
              ? widget.exercise.accentColor.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isDragging
                ? widget.exercise.accentColor.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.3),
            blurRadius: widget.isDragging ? 25 : 20,
            offset: Offset(0, widget.isDragging ? 12 : 8),
            spreadRadius: widget.isDragging ? 2 : -4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMainContent(),
          // Summary bar: visible only when collapsed (non-redundant)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                _buildSummaryBar(),
              ],
            ),
          ),
          // Editable fields: visible only when expanded
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildEditableFields(),
          ),
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag(
                      widget.exercise.muscles.isNotEmpty
                          ? widget.exercise.muscles.first
                          : 'N/A',
                      widget.exercise.accentColor,
                      Icons.fitness_center,
                    ),
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
          border: Border.all(
            width: 2,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.exercise.number.toString(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
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
        _buildIconButton(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          Colors.white,
          _toggleExpanded,
        ),
        const SizedBox(height: 8),
        _buildIconButton(
          LucideIcons.eye,
          const Color(0xFF2196F3),
          widget.onPreview,
        ),
        const SizedBox(height: 8),
        if (widget.exercise.variants.isNotEmpty) ...[
          _buildIconButton(
            Icons.swap_horiz,
            widget.exercise.accentColor,
            widget.onFindVariant,
          ),
          const SizedBox(height: 8),
        ],
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
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.1),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildSummaryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(19),
          bottomRight: _isExpanded ? Radius.zero : const Radius.circular(19),
        ),
      ),
      child: Row(
        children: [
          _buildSummaryChip(Icons.repeat, widget.exercise.sets),
          const SizedBox(width: 10),
          _buildSummaryChip(Icons.timer_outlined, widget.exercise.rest),
          const Spacer(),
          _buildSummaryChip(Icons.fitness_center, widget.exercise.weight),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableFields() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(19),
          bottomRight: Radius.circular(19),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildNumericField(
                  label: 'Serie',
                  controller: _setsController,
                  hint: '4',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumericField(
                  label: 'Rep',
                  controller: _repsController,
                  hint: '10',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumericField(
                  label: 'Carico',
                  controller: _weightController,
                  suffix: 'kg',
                  hint: '80',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNumericField(
            label: 'Rest',
            controller: _restController,
            suffix: 'seconds',
            hint: '90',
          ),
          const SizedBox(height: 12),
          _buildNotesField(),
        ],
      ),
    );
  }

  Widget _buildNumericField({
    required String label,
    required TextEditingController controller,
    String? suffix,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
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
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  dragStartBehavior: DragStartBehavior.down,
                ),
              ),
              if (suffix != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    suffix,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
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
            color: Colors.white.withValues(alpha: 0.6),
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
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _notesController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 2,
            dragStartBehavior: DragStartBehavior.down,
            decoration: InputDecoration(
              hintText: 'Aggiungi note...',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
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
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
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

  void _toggleExpanded() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
