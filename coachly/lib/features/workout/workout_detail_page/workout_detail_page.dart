import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/providers/workout_detail_provider/workout_detail_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_exercise_list_section.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_header.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_stats_cards.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart'; // Import for fromI18n
import 'package:coachly/shared/widgets/cards/border_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutDetailPage extends ConsumerStatefulWidget {
  final String id;

  const WorkoutDetailPage({super.key, required this.id});

  @override
  ConsumerState<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends ConsumerState<WorkoutDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(workoutDetailPageProvider.notifier).loadWorkoutDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutDetailPageProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        color: const Color(0xFF0F0F1E),
        child: _buildBody(context, state, scheme),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WorkoutDetailPageState state,
    ColorScheme scheme,
  ) {
    final locale = ref.watch(languageProvider); // Use languageProvider
    // Error State
    if (state.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShadAlert(
                title: const Text('Errore'),
                description: Text(state.error ?? 'Errore sconosciuto'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(workoutDetailPageProvider.notifier)
                    .refresh(widget.id),
                icon: const Icon(Icons.refresh),
                label: const Text('Riprova'),
              ),
            ],
          ),
        ),
      );
    }

    // Loading State
    if (state.isLoading && !state.hasData) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: const Color(0xFF1A1A2E),
          highlightColor: const Color(0xFF2196F3).withOpacity(0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Caricamento...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    // Empty State
    if (state.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Nessun workout trovato',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Content State
    final workout = state.workout!;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(workoutDetailPageProvider.notifier).refresh(widget.id),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WorkoutDetailHeader(
              title: workout.titleI18n.fromI18n(locale),
              coachName: workout.coachName ?? '',
              muscleTags: workout.muscleTags,
              progress: workout.progress,
              sessionsCount: workout.sessionsCount,
              lastSessionDays: workout.lastSessionDays,
              onBack: () => Navigator.of(context).pop(),
              onShare: () => _showShareSnackbar(context),
              onEdit: () => context.push('/workouts/workout/${widget.id}/edit'),
            ),
            const SizedBox(height: 20),
            WorkoutDetailStatsCards(
              exercisesCount: workout.workoutExercises.length,
              duration: workout.durationMinutes.toString(),
              focus: workout.type,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BorderCard(
                title: 'Descrizione',
                text: workout.descriptionI18n.fromI18n(locale),
                borderColor: const Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 20),
            _buildStartButton(context),
            const SizedBox(height: 20),
            WorkoutDetailExerciseListSection(
              exercises: workout.workoutExercises,
              workoutId: widget.id,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => context.go('/workouts/workout/${widget.id}/active'),
          icon: const Icon(Icons.play_arrow, size: 22),
          label: const Text(
            'Inizia Allenamento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  void _showShareSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Condividi workout'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showEditSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modifica workout'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
