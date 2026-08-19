import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_detail_view_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_detail_view_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseDetailViewServiceProvider = Provider<ExerciseDetailViewService>(
  (ref) => ApiExerciseDetailViewService(ref.watch(apiClientProvider)),
);

final exerciseDetailViewRepositoryProvider =
    Provider<ExerciseDetailViewRepository>((ref) {
      return ExerciseDetailViewRepositoryImpl(
        ref.watch(exerciseDetailViewServiceProvider),
      );
    });

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
