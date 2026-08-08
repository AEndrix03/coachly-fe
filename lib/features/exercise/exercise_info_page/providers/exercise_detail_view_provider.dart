import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_detail_view_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_detail_view_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const useExerciseDetailMocks = bool.fromEnvironment(
  'USE_EXERCISE_DETAIL_MOCKS',
  defaultValue: true,
);

final exerciseDetailViewServiceProvider = Provider<ExerciseDetailViewService>((
  ref,
) {
  if (useExerciseDetailMocks) {
    return const MockExerciseDetailViewService();
  }
  return ApiExerciseDetailViewService(
    ref.watch(exerciseInfoPageRepositoryProvider),
  );
});

final exerciseDetailViewRepositoryProvider =
    Provider<ExerciseDetailViewRepository>((ref) {
      return ExerciseDetailViewRepositoryImpl(
        ref.watch(exerciseDetailViewServiceProvider),
      );
    });

final exerciseDetailViewProvider =
    FutureProvider.family<ExerciseDetailViewData, String>((ref, exerciseId) {
      final locale = ref.watch(languageProvider);
      return ref
          .watch(exerciseDetailViewRepositoryProvider)
          .getExercise(exerciseId, locale);
    });
