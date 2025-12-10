import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/exercise_technique_model/exercise_technique_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/exercise_variant_model/exercise_variant_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/muscle_model/muscle_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_info_page_service.dart';

class ExerciseInfoPageRepositoryImpl implements IExerciseInfoPageRepository {
  final ExerciseInfoPageService _service;
  final bool useMockData;

  const ExerciseInfoPageRepositoryImpl(
    this._service, {
    this.useMockData = true,
  });

  @override
  Future<ApiResponse<ExerciseModel>> getExerciseDetail(
    String exerciseId,
  ) async {
    if (useMockData) {
      return _getMockExerciseDetail(exerciseId);
    }
    return await _service.fetchExerciseDetails(exerciseId);
  }

  @override
  Future<ApiResponse<List<ExerciseModel>>> getAllExercises() async {
    if (useMockData) {
      return _getMockExercises();
    }
    return await _service.fetchAllExercises();
  }

  ApiResponse<ExerciseModel> _getMockExerciseDetail(String exerciseId) {
    // Mock di esempio, puoi personalizzare i dati
    return ApiResponse.success(
      data: ExerciseModel(
        id: exerciseId,
        name: 'Panca Piana con Bilanciere',
        videoUrl: '',
        tags: ['Intermedio', 'Compound', 'Push'],
        difficulty: 'Intermedio',
        mechanics: 'Compound',
        type: 'Push',
        description:
            'Esercizio base per lo sviluppo del petto e dei tricipiti.',
        primaryMuscles: [
          MuscleModel(name: 'Pettorale', activation: 5, color: 0xFFFF5252),
          MuscleModel(
            name: 'Tricipite Brachiale',
            activation: 4,
            color: 0xFFFF5252,
          ),
        ],
        secondaryMuscles: [
          MuscleModel(
            name: 'Deltoide Anteriore',
            activation: 3,
            color: 0xFFFF9800,
          ),
          MuscleModel(
            name: 'Dentato Anteriore',
            activation: 2,
            color: 0xFFFF9800,
          ),
        ],
        techniqueSteps: [
          ExerciseTechniqueModel(
            title: 'Setup Iniziale',
            description:
                'Sdraiati sulla panca con piedi ben piantati a terra. Scapole retratte e petto in fuori. Afferra il bilanciere con presa poco più larga delle spalle.',
            iconCodePoint: 0xe2f6,
            iconGradient: [0xFFFF4081, 0xFFF50057],
          ),
          ExerciseTechniqueModel(
            title: 'Fase Eccentrica',
            description:
                'Abbassa il bilanciere in modo controllato verso lo sterno. I gomiti formano un angolo di 45° con il corpo. Mantieni tensione continua.',
            iconCodePoint: 0xe5db,
            iconGradient: [0xFF2196F3, 0xFF1976D2],
          ),
        ],
        variants: [
          ExerciseVariantModel(
            title: 'Panca Inclinata 30°',
            subtitle: 'Intermedio',
            emphasis: 'Petto Alto',
            iconCodePoint: 0xf1db,
          ),
          ExerciseVariantModel(
            title: 'Panca Declinata',
            subtitle: 'Intermedio',
            emphasis: 'Petto Basso',
            iconCodePoint: 0xf1db,
          ),
        ],
      ),
    );
  }

  ApiResponse<List<ExerciseModel>> _getMockExercises() {
    // Mock di esempio, puoi aggiungere altri esercizi
    return ApiResponse.success(
      data: [
        ExerciseModel(
          id: '1',
          name: 'Panca Piana con Bilanciere',
          videoUrl: '',
          tags: ['Intermedio', 'Compound', 'Push'],
          difficulty: 'Intermedio',
          mechanics: 'Compound',
          type: 'Push',
          description:
              'Esercizio base per lo sviluppo del petto e dei tricipiti.',
          primaryMuscles: [
            MuscleModel(name: 'Pettorale', activation: 5, color: 0xFFFF5252),
            MuscleModel(
              name: 'Tricipite Brachiale',
              activation: 4,
              color: 0xFFFF5252,
            ),
          ],
          secondaryMuscles: [
            MuscleModel(
              name: 'Deltoide Anteriore',
              activation: 3,
              color: 0xFFFF9800,
            ),
            MuscleModel(
              name: 'Dentato Anteriore',
              activation: 2,
              color: 0xFFFF9800,
            ),
          ],
          techniqueSteps: [
            ExerciseTechniqueModel(
              title: 'Setup Iniziale',
              description:
                  'Sdraiati sulla panca con piedi ben piantati a terra. Scapole retratte e petto in fuori. Afferra il bilanciere con presa poco più larga delle spalle.',
              iconCodePoint: 0xe2f6,
              iconGradient: [0xFFFF4081, 0xFFF50057],
            ),
          ],
          variants: [
            ExerciseVariantModel(
              title: 'Panca Inclinata 30°',
              subtitle: 'Intermedio',
              emphasis: 'Petto Alto',
              iconCodePoint: 0xf1db,
            ),
          ],
        ),
      ],
    );
  }
}
