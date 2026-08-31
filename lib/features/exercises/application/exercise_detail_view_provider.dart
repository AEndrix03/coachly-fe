import 'dart:ui' show Locale;

import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercises/data/models/exercise_detail_api_dto.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_detail_view_repository.dart';
import 'package:coachly/features/exercises/data/services/exercise_detail_view_service.dart';
import 'package:coachly/features/exercises/domain/exercise_detail_view_data.dart';
import 'package:coachly/features/user_settings/application/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseDetailViewRepositoryProvider =
    Provider<ExerciseDetailViewRepository>((ref) {
      return LocalFirstExerciseDetailViewRepository(
        ref.watch(exerciseInfoPageRepositoryProvider),
      );
    });

class LocalFirstExerciseDetailViewRepository
    implements ExerciseDetailViewRepository {
  const LocalFirstExerciseDetailViewRepository(this._repository);

  final IExerciseInfoPageRepository _repository;

  @override
  Future<ExerciseDetailViewData> getExercise(
    String exerciseId,
    Locale locale,
  ) async {
    final result = await _repository.getExerciseDetailResult(exerciseId);
    return switch (result) {
      Ok(:final value) => _toViewData(value, exerciseId, locale),
      Err(:final failure) => throw StateError(failure.message),
    };
  }

  @override
  Future<List<ExerciseDetailViewData>> getExercises(Locale locale) async {
    final details = await _repository.getDownloadedDetails();
    return [
      for (final detail in details)
        if (detail.id case final String id) _toViewData(detail, id, locale),
    ];
  }

  ExerciseDetailViewData _toViewData(
    ExerciseDetailModel model,
    String id,
    Locale locale,
  ) {
    return ApiExerciseDetailViewService.toViewData(
      ExerciseDetailApiDto.fromJson(model.toJson()),
      id,
      locale,
    );
  }
}

final exerciseDetailCatalogProvider =
    FutureProvider<List<ExerciseDetailViewData>>((ref) {
      final locale = ref.watch(languageProvider);
      return ref
          .watch(exerciseDetailViewRepositoryProvider)
          .getExercises(locale);
    });

final exerciseDetailViewProvider = FutureProvider.autoDispose
    .family<ExerciseDetailViewData, String>((ref, exerciseId) async {
      final locale = ref.watch(languageProvider);
      return ref
          .watch(exerciseDetailViewRepositoryProvider)
          .getExercise(exerciseId, locale);
    });
