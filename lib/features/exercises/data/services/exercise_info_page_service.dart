import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/exercises/domain/models/exercise_model.dart';

class ExerciseInfoPageService {
  final ApiClient _apiClient;

  ExerciseInfoPageService(this._apiClient);

  /// Fetch exercise details by id
  Future<ApiResponse<ExerciseDetailModel>> fetchExerciseDetails(
    String exerciseId,
  ) async {
    return await _apiClient.get<ExerciseDetailModel>(
      '/exercises/$exerciseId/details',
      fromJson: (json) => ExerciseDetailModel.fromJson(json),
    );
  }

  /// Fetch all exercises (if needed)
  Future<ApiResponse<List<ExerciseModel>>> fetchAllExercises() async {
    return await _apiClient.get<List<ExerciseModel>>(
      '/exercises',
      fromJson: (data) {
        // Un payload che non e' una lista era un catalogo vuoto: e da li'
        // `upsertSummaries` cancellava l'intero catalogo locale. Una risposta
        // che non si capisce e' un errore di parsing, non zero esercizi.
        if (data is! List) {
          throw FormatException(
            'Expected a list of exercises, got ${data.runtimeType}',
          );
        }
        return data.map((json) => ExerciseModel.fromJson(json)).toList();
      },
    );
  }

  Future<ApiResponse<List<ExerciseModel>>> fetchMyExercises() async {
    return await _apiClient.get<List<ExerciseModel>>(
      '/exercises/mine',
      fromJson: (data) {
        // Una risposta che non si sa leggere e' un errore di parsing, non un
        // elenco vuoto: confonderli fa sparire dalla UI dati che esistono.
        if (data is! List) {
          throw FormatException(
            'Expected a list of exercises, got ${data.runtimeType}',
          );
        }
        return data.map((json) => ExerciseModel.fromJson(json)).toList();
      },
    );
  }

  Future<ApiResponse<ExerciseDetailModel>> createPersonalExercise(
    Map<String, dynamic> body,
  ) async {
    return await _apiClient.post<ExerciseDetailModel>(
      '/exercises',
      body: body,
      fromJson: (json) => ExerciseDetailModel.fromJson(json),
    );
  }

  Future<ApiResponse<ExerciseDetailModel>> updatePersonalExercise(
    String exerciseId,
    Map<String, dynamic> body,
  ) async {
    return await _apiClient.put<ExerciseDetailModel>(
      '/exercises/$exerciseId',
      body: body,
      fromJson: (json) => ExerciseDetailModel.fromJson(json),
    );
  }

  Future<ApiResponse<void>> deletePersonalExercise(String exerciseId) async {
    return await _apiClient.delete<void>('/exercises/$exerciseId');
  }

  Future<ApiResponse<void>> createPersonalExercisePayload(
    Map<String, dynamic> body,
  ) => _apiClient.post<void>('/exercises', body: body, fromJson: (_) {});

  Future<ApiResponse<void>> updatePersonalExercisePayload(
    String exerciseId,
    Map<String, dynamic> body,
  ) => _apiClient.put<void>(
    '/exercises/$exerciseId',
    body: body,
    fromJson: (_) {},
  );
}
