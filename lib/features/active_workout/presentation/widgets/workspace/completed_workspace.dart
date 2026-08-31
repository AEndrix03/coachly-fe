import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:flutter/material.dart';

/// Lo stato a allenamento finito.
class CompletedWorkspace extends StatelessWidget {
  final VoidCallback onComplete;
  const CompletedWorkspace({super.key, required this.onComplete});
  @override
  Widget build(BuildContext context) => Center(
    child: FilledButton(
      onPressed: onComplete,
      child: Text(context.activeTr('completeWorkout')),
    ),
  );
}
