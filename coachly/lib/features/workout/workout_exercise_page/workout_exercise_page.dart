import 'package:coachly/features/workout/workout_exercise_page/widgets/exercise_tabs_section.dart';
import 'package:flutter/material.dart';

import 'widgets/exercise_header.dart';
import 'widgets/exercise_stats_cards.dart';
import 'widgets/exercise_video_section.dart';

class ExercisePage extends StatelessWidget {
  final String id;

  const ExercisePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from BLoC/Provider
    return Scaffold(
      body: Container(
        color: const Color(0xFF0F0F1E),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ExerciseHeader(
                onBack: () => Navigator.of(context).pop(),
                onShare: () {},
                onSave: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20),
                  ExerciseVideoSection(
                    videoUrl: '',
                    exerciseName: 'Panca Piana con Bilanciere',
                    tags: ['Intermedio', 'Compound', 'Push'],
                  ),
                  SizedBox(height: 24),
                  ExerciseStatsCards(
                    difficulty: 'Intermedio',
                    mechanics: 'Compound',
                    type: 'Push',
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: ExerciseTabsSection(),
            ),
          ],
        ),
      ),
    );
  }
}
