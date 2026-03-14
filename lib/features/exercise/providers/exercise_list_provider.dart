import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_list_provider.g.dart';

@riverpod
Future<List<ExerciseDetailModel>> exerciseList(
  Ref ref, {
  ExerciseFilterModel? filter,
}) async {
  final repository = ref.watch(exerciseInfoPageRepositoryProvider);
  final actualFilter = filter ?? const ExerciseFilterModel();
  final response = await repository.getFilteredExercises(actualFilter);

  if (response.success) {
    return response.data ?? [];
  } else {
    throw Exception(response.message ?? 'Failed to fetch exercises');
  }
}
