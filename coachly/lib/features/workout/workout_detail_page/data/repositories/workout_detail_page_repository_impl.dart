import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_detail_page/data/repositories/workout_detail_page_repository.dart';
import 'package:coachly/features/workout/workout_detail_page/data/services/workout_detail_page_service.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';

class WorkoutDetailPageRepositoryImpl implements IWorkoutDetailPageRepository {
  final WorkoutDetailPageService _service;

  const WorkoutDetailPageRepositoryImpl(this._service);

  @override
  Future<ApiResponse<WorkoutModel>> getWorkout(String workoutId) async {
    return await _service.fetchWorkout(workoutId);
  }
}
