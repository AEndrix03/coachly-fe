import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_detail_page/data/models/exercise_info_model/exercise_info_model.dart';
import 'package:coachly/features/workout/workout_detail_page/data/models/workout_detail_model/workout_detail_model.dart';
import 'package:coachly/features/workout/workout_detail_page/data/repositories/workout_detail_page_repository.dart';
import 'package:coachly/features/workout/workout_detail_page/data/services/workout_detail_page_service.dart';

class WorkoutDetailPageRepositoryImpl implements IWorkoutDetailPageRepository {
  final WorkoutDetailPageService _service;
  final bool useMockData;

  const WorkoutDetailPageRepositoryImpl(
    this._service, {
    this.useMockData = true,
  });

  @override
  Future<ApiResponse<WorkoutDetailModel>> getWorkoutDetail(
    String workoutId,
  ) async {
    if (useMockData) {
      return this._getMockWorkouts();
    }
    return await this._service.fetchWorkoutDetails(workoutId);
  }

  @override
  Future<ApiResponse<List<ExerciseInfoModel>>> getWorkoutExercises(
    String workoutId,
  ) async {
    if (useMockData) {
      return this._getMockWorkoutExercises();
    }
    return await this._service.fetchAllWorkoutExercises(workoutId);
  }

  ApiResponse<WorkoutDetailModel> _getMockWorkouts() {
    return ApiResponse.success(
      data: WorkoutDetailModel(
        title: 'PETTO & TRICIPITI',
        coachName: 'Coach Luca Bianchi',
        muscleTags: const ['Petto', 'Tricipiti', 'Deltoidi Anteriori'],
        progress: 0.8,
        sessionsCount: 12,
        lastSessionDays: 2,
      ),
    );
  }

  ApiResponse<List<ExerciseInfoModel>> _getMockWorkoutExercises() {
    return ApiResponse.success(
      data: [
        ExerciseInfoModel(
          number: 1,
          name: 'Panca Piana con Bilanciere',
          muscle: 'Petto',
          difficulty: 'Intermedio',
          sets: '4 × 8-10',
          rest: '120s',
          weight: '85 kg',
          progress: '+5%',
          accentColorHex: '#2196F3',
        ),
        ExerciseInfoModel(
          number: 2,
          name: 'Panca Inclinata Manubri',
          muscle: 'Petto Alto',
          difficulty: 'Intermedio',
          sets: '4 × 10-12',
          rest: '90s',
          weight: '32 kg',
          progress: '+3%',
          accentColorHex: '#2196F3',
        ),
        ExerciseInfoModel(
          number: 3,
          name: 'Croci ai Cavi',
          muscle: 'Petto',
          difficulty: 'Base',
          sets: '3 × 12-15',
          rest: '60s',
          weight: '20 kg',
          progress: '',
          accentColorHex: '#2196F3',
        ),
        ExerciseInfoModel(
          number: 4,
          name: 'Panca Stretta',
          muscle: 'Tricipiti',
          difficulty: 'Intermedio',
          sets: '4 × 8-10',
          rest: '90s',
          weight: '70 kg',
          progress: '+7%',
          accentColorHex: '#9C27B0',
        ),
        ExerciseInfoModel(
          number: 5,
          name: 'French Press',
          muscle: 'Tricipiti',
          difficulty: 'Base',
          sets: '3 × 10-12',
          rest: '75s',
          weight: '30 kg',
          progress: '',
          accentColorHex: '#9C27B0',
        ),
        ExerciseInfoModel(
          number: 6,
          name: 'Push Down Cavi',
          muscle: 'Tricipiti',
          difficulty: 'Base',
          sets: '3 × 12-15',
          rest: '60s',
          weight: '35 kg',
          progress: '+2%',
          accentColorHex: '#9C27B0',
        ),
      ],
    );
  }
}
