import 'package:coachly/core/utils/debouncer.dart';
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
  final _scrollController = ScrollController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _typeController = TextEditingController();

  // Debouncer per ritardare l'aggiornamento dello stato durante la digitazione
  final _debouncer = Debouncer(delay: Duration(milliseconds: 300));

  @override
  void initState() {
    super.initState();
    // Aggiungi listener per aggiornare il provider quando l'utente digita
    _descriptionController.addListener(_onDescriptionChanged);
    _durationController.addListener(_onDurationChanged);
    _typeController.addListener(_onTypeChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() {
    _debouncer.run(() {
      ref
          .read(workoutEditPageProvider(widget.workoutId).notifier)
          .updateDescription(_descriptionController.text);
    });
  }

  void _onDurationChanged() {
    _debouncer.run(() {
      ref
          .read(workoutEditPageProvider(widget.workoutId).notifier)
          .updateDuration(_durationController.text);
    });
  }

  void _onTypeChanged() {
    _debouncer.run(() {
      ref
          .read(workoutEditPageProvider(widget.workoutId).notifier)
          .updateType(_typeController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutEditPageProvider(widget.workoutId));

    ref.listen(workoutEditPageProvider(widget.workoutId), (previous, next) {
      if (_descriptionController.text != next.description) {
        _descriptionController.text = next.description;
      }
      if (_durationController.text != next.duration) {
        _durationController.text = next.duration;
      }
      if (_typeController.text != next.type) {
        _typeController.text = next.type;
      }
    });

    return PopScope(
      canPop: !state.isDirty,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _showExitDialog();
        if (shouldPop ?? false) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: WorkoutEditHeader(
                    title: state.title,
                    isDirty: state.isDirty,
                    isSaving: state.isLoading,
                    onBack: () => context.pop(),
                    onSave: _handleSave,
                    onTitleChanged: (value) => ref
                        .read(
                          workoutEditPageProvider(widget.workoutId).notifier,
                        )
                        .updateTitle(value),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildInfoCards(state),
                      const SizedBox(height: 16),
                      _buildDescriptionCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                if (state.exercises.isEmpty && !state.isLoading)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyExerciseState(),
                  )
                else
                  _buildExerciseSliverList(state),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100), // FAB space
                ),
              ],
            ),
            if (state.isLoading && state.exercises.isEmpty)
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

  Widget _buildDescriptionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descrizione',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Aggiungi una descrizione...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
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
              null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              Icons.timer_outlined,
              state.duration,
              'Durata (min)',
              const Color(0xFF9C27B0),
              _durationController,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              Icons.local_fire_department,
              state.type,
              'Tipo',
              const Color(0xFFFF9800),
              _typeController,
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
    TextEditingController? controller,
  ) {
    final isReadonly = controller == null;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1A1A2E),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          if (isReadonly)
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            SizedBox(
              height: 20,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSliverList(WorkoutEditState state) {
    return SliverReorderableList(
      itemCount: state.exercises.length,
      onReorder: (oldIndex, newIndex) {
        ref
            .read(workoutEditPageProvider(widget.workoutId).notifier)
            .reorderExercises(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final exercise = state.exercises[index];
        return Padding(
          key: ValueKey(exercise.id),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: EditableExerciseCard(
            exercise: exercise,
            onRemove: () => _handleRemoveExercise(exercise.id),
            onFindVariant: () => _handleFindVariant(exercise),
            onUpdate: (updated) => ref
                .read(workoutEditPageProvider(widget.workoutId).notifier)
                .updateExercise(exercise.id, updated),
          ),
        );
      },
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
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scheda salvata con successo'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      context.pop();
    } else {
      final error = ref.read(workoutEditPageProvider(widget.workoutId)).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Errore durante il salvataggio'),
          backgroundColor: const Color(0xFFFF5252),
        ),
      );
    }
  }

  Future<bool?> _showExitDialog() async {
    return showDialog<bool>(
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
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(workoutEditPageProvider(widget.workoutId).notifier)
                  .resetDirty();
              Navigator.of(context).pop(true);
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
