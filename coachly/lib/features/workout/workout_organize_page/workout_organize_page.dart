import 'package:coachly/features/workout/workout_organize_page/widgets/organize_workout_card.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
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

class _WorkoutOrganizePageState extends ConsumerState<WorkoutOrganizePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(workoutListProvider.notifier).loadWorkouts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final workoutState = ref.watch(workoutListProvider);

    final activeWorkouts =
        workoutState.workouts.where((w) => w.active).toList();
    final inactiveWorkouts =
        workoutState.workouts.where((w) => !w.active).toList();

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
              bottom: false,
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Text(
                      'Organizza gli Allenamenti',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Schede Attive'),
              Tab(text: 'Schede Non Attive'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWorkoutList(context, workoutState, activeWorkouts, scheme),
                _buildWorkoutList(
                    context, workoutState, inactiveWorkouts, scheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList(
    BuildContext context,
    WorkoutListState workoutState,
    List<WorkoutModel> workouts,
    ColorScheme scheme,
  ) {
    if (workoutState.hasError) {
      return Center(
        child: ShadAlert(
          title: const Text('Errore'),
          description: Text(workoutState.errorMessage ?? 'Errore sconosciuto'),
        ),
      );
    }
    if (workoutState.isLoading && workouts.isEmpty) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: scheme.surface,
          highlightColor: scheme.primary.withOpacity(0.2),
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (workouts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Nessuna scheda in questa categoria',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
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
            context.push('/workouts/workout/${workout.id}/edit');
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
