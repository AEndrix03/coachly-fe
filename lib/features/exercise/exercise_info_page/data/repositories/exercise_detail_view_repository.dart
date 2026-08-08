import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_detail_view_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:flutter/material.dart';

abstract interface class ExerciseDetailViewRepository {
  Future<ExerciseDetailViewData> getExercise(String exerciseId, Locale locale);
}

class ExerciseDetailViewRepositoryImpl implements ExerciseDetailViewRepository {
  final ExerciseDetailViewService _service;

  const ExerciseDetailViewRepositoryImpl(this._service);

  @override
  Future<ExerciseDetailViewData> getExercise(String exerciseId, Locale locale) {
    return _service.fetch(exerciseId, locale);
  }
}
