import 'package:coachly/features/exercises/domain/exercise_detail_view_data.dart';
// `Locale` vive in `dart:ui`: il data layer non dipende da Flutter
// (`docs/development/01-principles.md`, dependency rule D2).
import 'dart:ui' show Locale;

abstract interface class ExerciseDetailViewRepository {
  Future<ExerciseDetailViewData> getExercise(String exerciseId, Locale locale);

  Future<List<ExerciseDetailViewData>> getExercises(Locale locale);
}
