import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/core/utils/debouncer.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_edit_page/data/models/editable_exercise_model/editable_exercise_model.dart';
import 'package:coachly/features/workout/workout_edit_page/providers/workout_edit_provider/workout_edit_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/editable_exercise_card.dart';
import 'widgets/exercise_picker_sheet.dart';
import 'widgets/workout_edit_header.dart';

class WorkoutEditPage extends ConsumerStatefulWidget {
  final String workoutId;
  final WorkoutModel? workout;

  const WorkoutEditPage({super.key, required this.workoutId, this.workout});

  @override
  ConsumerState<WorkoutEditPage> createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends ConsumerState<WorkoutEditPage> {
  final _scrollController = ScrollController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _typeController = TextEditingController();

  // IDs of exercises just added in this session — open expanded by default
  final Set<String> _justAddedIds = {};

  // Debouncer per ritardare l'aggiornamento dello stato durante la digitazione
  final _debouncer = Debouncer(delay: Duration(milliseconds: 300));

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      final locale = ref.read(languageProvider);
      Future.microtask(() {
        ref
            .read(workoutEditPageProvider(widget.workoutId).notifier)
            .setInitialWorkout(widget.workout!, locale);
      });
    } else {
      final locale = ref.read(languageProvider);
      Future.microtask(() {
        ref
            .read(workoutEditPageProvider(widget.workoutId).notifier)
            .loadWorkout(widget.workoutId, locale);
      });
    }
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
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitDialog();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                color: Colors.black.withValues(alpha: 0.5),
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
            color: const Color(0xFF2196F3).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('workout.edit.description'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
              maxLines: null,
              decoration: InputDecoration(
                hintText: context.tr('workout.edit.description'),
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
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
              context.tr('common.exercises'),
              const Color(0xFF2196F3),
              null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              Icons.timer_outlined,
              state.duration,
              context.tr('workout.duration_minutes'),
              const Color(0xFF9C27B0),
              _durationController,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              Icons.local_fire_department,
              state.type,
              context.tr('workout.type'),
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
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
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
              color: Colors.white.withValues(alpha: 0.6),
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
            onPreview: () => context.push(
              '/workouts/workout/${widget.workoutId}/workout_exercise_page/${exercise.exerciseId}',
            ),
            onUpdate: (updated) => ref
                .read(workoutEditPageProvider(widget.workoutId).notifier)
                .updateExercise(exercise.id, updated),
            initiallyExpanded: _justAddedIds.contains(exercise.id),
          ),
        );
      },
    );
  }

  Widget _buildFAB() {
    return _buildFABContent();
  }

  Widget _buildFABContent() {
    return GestureDetector(
      onTap: _handleAddExercise,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              context.tr('workout.edit.add_exercise'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
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
                  const Color(0xFF2196F3).withValues(alpha: 0.2),
                  const Color(0xFF8E29EC).withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center,
              size: 64,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.tr('workout.edit.no_exercise'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('workout.edit.add_first_exercise'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddExercise() {
    final selectedExerciseIds = ref
        .read(workoutEditPageProvider(widget.workoutId))
        .exercises
        .map((exercise) => exercise.exerciseId)
        .where((id) => id.isNotEmpty)
        .toSet();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExercisePickerSheet(
        excludedExerciseIds: selectedExerciseIds,
        onExerciseSelected: (exercise) {
          final state = ref.read(workoutEditPageProvider(widget.workoutId));
          final newNumber = state.exercises.length + 1;
          final newId = 'exercise_${DateTime.now().millisecondsSinceEpoch}';
          final newExercise = exercise.copyWith(id: newId, number: newNumber);
          setState(() => _justAddedIds.add(newId));
          ref
              .read(workoutEditPageProvider(widget.workoutId).notifier)
              .addExercise(newExercise);
        },
      ),
    );
  }

  Future<void> _handleRemoveExercise(String exerciseId) async {
    final shouldRemove = await showAppConfirmationDialog(
      context,
      title: context.tr('workout.edit.remove_title'),
      content: context.tr('workout.edit.remove_content'),
      confirmLabel: context.tr('workout.edit.remove_confirm'),
      destructive: true,
      icon: Icons.remove_circle_outline_rounded,
    );
    if (!shouldRemove) {
      return;
    }

    ref
        .read(workoutEditPageProvider(widget.workoutId).notifier)
        .removeExercise(exerciseId);
  }

  void _handleFindVariant(EditableExerciseModel exercise) {
    ref
        .read(appToastServiceProvider)
        .showInfo(
          context,
          'Cerca variante per: ${exercise.name}',
          title: context.tr('workout.edit.variant_title'),
          duration: const Duration(seconds: 2),
        );
  }

  Future<void> _handleSave() async {
    final success = await ref
        .read(workoutEditPageProvider(widget.workoutId).notifier)
        .save();
    if (!mounted) return;
    if (success) {
      ref
          .read(appToastServiceProvider)
          .showSuccess(
            context,
            context.tr('workout.edit.saved'),
            title: context.tr('workout.edit.save_completed'),
          );
      context.pop();
    } else {
      final error = ref.read(workoutEditPageProvider(widget.workoutId)).error;
      ref
          .read(appToastServiceProvider)
          .showError(
            context,
            error ?? context.tr('workout.save_error'),
            title: context.tr('workout.edit.save_failed'),
          );
    }
  }

  Future<bool> _showExitDialog() async {
    final shouldExit = await showAppConfirmationDialog(
      context,
      title: context.tr('workout.edit.unsaved_title'),
      content: context.tr('workout.edit.unsaved_content'),
      confirmLabel: context.tr('workout.edit.exit'),
      destructive: true,
      icon: Icons.warning_amber_rounded,
    );
    if (shouldExit) {
      ref.read(workoutEditPageProvider(widget.workoutId).notifier).resetDirty();
    }
    return shouldExit;
  }
}
