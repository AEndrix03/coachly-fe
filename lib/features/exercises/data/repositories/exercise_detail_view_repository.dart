import 'package:coachly/features/exercises/data/services/exercise_detail_view_service.dart';
import 'package:coachly/features/exercises/domain/exercise_detail_view_data.dart';
// `Locale` vive in `dart:ui`: il data layer non dipende da Flutter
// (`docs/development/01-principles.md`, dependency rule D2).
import 'dart:ui' show Locale;

abstract interface class ExerciseDetailViewRepository {
  Future<ExerciseDetailViewData> getExercise(String exerciseId, Locale locale);

  Future<List<ExerciseDetailViewData>> getExercises(Locale locale);
}

class ExerciseDetailViewRepositoryImpl implements ExerciseDetailViewRepository {
  final ExerciseDetailViewService _service;

  const ExerciseDetailViewRepositoryImpl(this._service);

  @override
  Future<ExerciseDetailViewData> getExercise(String exerciseId, Locale locale) {
    return _service.fetch(exerciseId, locale);
  }

  @override
  Future<List<ExerciseDetailViewData>> getExercises(Locale locale) {
    return _service.fetchAll(locale);
  }
}
