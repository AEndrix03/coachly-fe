import 'package:coachly/features/workout/workout_organize_page/widgets/organize_workout_card.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/widgets/buttons/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutOrganizePage extends ConsumerStatefulWidget {
  const WorkoutOrganizePage({super.key});

  @override
  ConsumerState<WorkoutOrganizePage> createState() =>
      _WorkoutOrganizePageState();
}

class _WorkoutOrganizePageState extends ConsumerState<WorkoutOrganizePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(workoutListProvider.notifier).loadWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final workoutState = ref.watch(workoutListProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2196F3),
                  Color(0xFF1976D2),
                  Color(0xFF7B4BC1),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlassIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () {
                            context.pop();
                          },
                          iconColor: Colors.white,
                          size: 20,
                          marginRight: 0,
                        ),
                        // "Allenamenti" chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.onPrimary.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: scheme.onPrimary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fitness_center,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Allenamenti',
                                style: TextStyle(
                                  color: scheme.onPrimary.withOpacity(0.95),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GlassIconButton(
                          icon: Icons.save,
                          onPressed: () {
                            // TODO: Implement save functionality
                          },
                          iconColor: Colors.white,
                          size: 20,
                          marginRight: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Organizza gli Allenamenti',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildBody(context, workoutState, scheme)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WorkoutListState workoutState,
    ColorScheme scheme,
  ) {
    if (workoutState.hasError) {
      return Center(
        child: ShadAlert(
          title: Text('Errore'),
          description: Text(workoutState.errorMessage ?? 'Errore sconosciuto'),
        ),
      );
    }
    if (workoutState.isLoading && workoutState.workouts.isEmpty) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: scheme.surface,
          highlightColor: scheme.primary.withOpacity(0.2),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    if (workoutState.workouts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Nessuna scheda disponibile da organizzare',
            style: TextStyle(color: Color(0x80000000)),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: workoutState.workouts.length,
      itemBuilder: (context, index) {
        final workout = workoutState.workouts[index];
        return OrganizeWorkoutCard(
          workout: workout,
          onDelete: () async {
            final confirmed = await _showConfirmationDialog(
              context,
              'Conferma Eliminazione',
              'Sei sicuro di voler eliminare la scheda "${workout.title}"?',
            );
            if (confirmed) {
              ref.read(workoutListProvider.notifier).deleteWorkout(workout.id);
            }
          },
          onToggleActive: (isActive) async {
            final action = isActive ? 'attivare' : 'disattivare';
            final confirmed = await _showConfirmationDialog(
              context,
              'Conferma Modifica Stato',
              'Sei sicuro di voler $action la scheda "${workout.title}"?',
            );
            if (confirmed) {
              ref
                  .read(workoutListProvider.notifier)
                  .updateWorkoutActiveStatus(workout.id, isActive);
            }
          },
          onEdit: () {
            context.go('/workouts/workout/${workout.id}/edit');
          },
        );
      },
    );
  }
}

Future<bool> _showConfirmationDialog(
  BuildContext context,
  String title,
  String content,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annulla'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Conferma'),
              ),
            ],
          );
        },
      ) ??
      false;
}
