import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/workout/workout_page/data/models/workout_model.dart';
import '../domain/workout_controller.dart';

final workoutProvider = NotifierProvider<WorkoutController, List<Workout>>(
  WorkoutController.new,
);
