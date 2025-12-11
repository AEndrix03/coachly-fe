import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/features/workout/workout_edit_page/providers/workout_edit_provider/workout_edit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/editable_exercise_card.dart';
import 'widgets/exercise_picker_sheet.dart';
import 'widgets/workout_edit_header.dart';

class WorkoutEditPage extends ConsumerStatefulWidget {
  final String workoutId;

  const WorkoutEditPage({super.key, required this.workoutId});

  @override
  ConsumerState<WorkoutEditPage> createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends ConsumerState<WorkoutEditPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutEditPageProvider(widget.workoutId));

    return PopScope(
      canPop: !state.isDirty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && state.isDirty) {
          _showExitDialog();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        body: Stack(
          children: [
            Column(
              children: [
                WorkoutEditHeader(
                  title: state.title,
                  isDirty: state.isDirty,
                  isSaving: state.isLoading,
                  onBack: () => _handleBack(),
                  onSave: () => _handleSave(),
                  onTitleChanged: (value) => ref
                      .read(workoutEditPageProvider(widget.workoutId).notifier)
                      .updateTitle(value),
                ),
                Expanded(child: _buildBody(state)),
              ],
            ),
            if (state.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  Widget _buildBody(WorkoutEditState state) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildInfoCards(state),
          const SizedBox(height: 16),
          _buildDescriptionCard(state),
          const SizedBox(height: 24),
          // Conditionally show exercise section or a message if empty
          state.exercises.isEmpty
              ? _buildEmptyExerciseState()
              : _buildExerciseSection(state),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(WorkoutEditState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1A2E).withOpacity(0.95),
              const Color(0xFF16213E).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            width: 1,
          ),
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
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF8E29EC)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Descrizione',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: state.description)
                ..selection = TextSelection.collapsed(
                  offset: state.description.length,
                ),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                height: 1.6,
                letterSpacing: 0.2,
              ),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Aggiungi una descrizione...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => ref
                  .read(workoutEditPageProvider(widget.workoutId).notifier)
                  .updateDescription(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(WorkoutEditState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              Icons.fitness_center,
              state.exercises.length.toString(),
              'Esercizi',
              const Color(0xFF2196F3),
              null, // readonly
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              Icons.timer_outlined,
              state.duration,
              'Durata',
              const Color(0xFF9C27B0),
              (value) => ref
                  .read(workoutEditPageProvider(widget.workoutId).notifier)
                  .updateDuration(value),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              Icons.local_fire_department,
              state.type,
              'Tipo',
              const Color(0xFFFF9800),
              (value) => ref
                  .read(workoutEditPageProvider(widget.workoutId).notifier)
                  .updateType(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
    Function(String)? onChanged, // nullable per readonly
  ) {
    final isReadonly = onChanged == null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1A2E).withOpacity(0.95),
              const Color(0xFF16213E).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                ),
                border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            if (isReadonly)
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              )
            else
              TextField(
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.collapsed(offset: value.length),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true, // Reduce vertical space
                ),
                onChanged: onChanged,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSection(WorkoutEditState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF8E29EC)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Esercizi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${state.exercises.length} esercizi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.exercises.length,
            onReorder: (oldIndex, newIndex) {
              ref
                  .read(workoutEditPageProvider(widget.workoutId).notifier)
                  .reorderExercises(oldIndex, newIndex);
            },
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.scale(scale: 1.02, child: child);
                },
                child: child,
              );
            },
            itemBuilder: (context, index) {
              final exercise = state.exercises[index];
              return EditableExerciseCard(
                key: ValueKey(exercise.id),
                exercise: exercise,
                onRemove: () => _handleRemoveExercise(exercise.id),
                onFindVariant: () => _handleFindVariant(exercise),
                onUpdate: (updated) => ref
                    .read(workoutEditPageProvider(widget.workoutId).notifier)
                    .updateExercise(exercise.id, updated),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2196F3).withOpacity(0.2),
                  const Color(0xFF8E29EC).withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nessun esercizio',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aggiungi il primo esercizio per iniziare',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _handleAddExercise,
      backgroundColor: const Color(0xFF2196F3),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Aggiungi Esercizio',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildEmptyExerciseState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2196F3).withOpacity(0.2),
                  const Color(0xFF8E29EC).withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nessun esercizio',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aggiungi il primo esercizio per iniziare',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExercisePickerSheet(
        onExerciseSelected: (exercise) {
          final state = ref.read(workoutEditPageProvider(widget.workoutId));
          // Assegna numero progressivo basato sulla lunghezza attuale
          final newNumber = state.exercises.length + 1;

          final newExercise = exercise.copyWith(
            id: 'exercise_${DateTime.now().millisecondsSinceEpoch}',
            number: newNumber,
          );

          ref
              .read(workoutEditPageProvider(widget.workoutId).notifier)
              .addExercise(newExercise);
        },
      ),
    );
  }

  void _handleRemoveExercise(String exerciseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Rimuovi esercizio',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Sei sicuro di voler rimuovere questo esercizio?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(workoutEditPageProvider(widget.workoutId).notifier)
                  .removeExercise(exerciseId);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF5252),
            ),
            child: const Text('Rimuovi'),
          ),
        ],
      ),
    );
  }

  void _handleFindVariant(EditableExerciseModel exercise) {
    // TODO: Show variant picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cerca variante per: ${exercise.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSave() async {
    final success = await ref
        .read(workoutEditPageProvider(widget.workoutId).notifier)
        .save();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scheda salvata con successo'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      context.pop();
    } else if (mounted) {
      final state = ref.read(workoutEditPageProvider(widget.workoutId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error ?? 'Errore durante il salvataggio'),
          backgroundColor: const Color(0xFFFF5252),
        ),
      );
    }
  }

  void _handleBack() {
    // Rely on PopScope for dirty state dialog
    context.pop();
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Modifiche non salvate',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Hai modifiche non salvate. Vuoi uscire senza salvare?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF5252),
            ),
            child: const Text('Esci'),
          ),
        ],
      ),
    );
  }
}
