import 'package:coachly/features/workout/shared/widgets/workout_exercise_view_card.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

class WorkoutDetailExerciseListSection extends StatelessWidget {
  final List<WorkoutExerciseModel> exercises;
  final String? workoutId;

  const WorkoutDetailExerciseListSection({
    super.key,
    required this.exercises,
    this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.tr('common.exercises'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  context.tr(
                    'workout.organize.exercises_count',
                    params: {'count': '${exercises.length}'},
                  ),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...exercises.asMap().entries.map(
            (entry) => WorkoutExerciseViewCard(
              workoutExercise: entry.value,
              workoutId: workoutId ?? '',
              exerciseNumber: entry.key + 1,
            ),
          ),
        ],
      ),
    );
  }
}
