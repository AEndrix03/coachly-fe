import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_exercise_list_section.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_header.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_stats_cards.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/widgets/cards/border_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutDetailPage extends ConsumerWidget {
  final WorkoutModel workout;

  const WorkoutDetailPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        color: const Color(0xFF0F0F1E),
        child: _buildBody(context, ref, workout, scheme),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    WorkoutModel workout,
    ColorScheme scheme,
  ) {
    final locale = ref.watch(languageProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(workoutListProvider);
        // We might need to pop and let the workout page rebuild, or find a way
        // to get the updated workout model here. For now, just invalidating.
      },
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
              onEdit: () => context.push(
                '/workouts/workout/${workout.id}/edit',
                extra: workout,
              ),
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
            _buildStartButton(context, workout.id),
            const SizedBox(height: 20),
            WorkoutDetailExerciseListSection(
              exercises: workout.workoutExercises,
              workoutId: workout.id,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, String workoutId) {
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
          onPressed: () => context.go('/workouts/workout/$workoutId/active'),
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
}
