import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/workout_controller.dart';
import '../data/workout_model.dart';

final workoutProvider =
NotifierProvider<WorkoutController, List<Workout>>(WorkoutController.new);
