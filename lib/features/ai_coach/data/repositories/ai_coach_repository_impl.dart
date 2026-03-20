import 'package:coachly/features/ai_coach/data/services/gemma_inference_service.dart';
import 'package:coachly/features/ai_coach/domain/models/local_ai_model.dart';
import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/features/ai_coach/domain/repositories/ai_coach_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_coach_repository_impl.g.dart';

class AiCoachRepositoryImpl implements AiCoachRepository {
  AiCoachRepositoryImpl(this._gemmaService);

  final GemmaInferenceService _gemmaService;

  @override
  Future<bool> isModelInstalled() {
    return _gemmaService.isModelInstalled();
  }

  @override
  Stream<double> downloadModel() {
    return _gemmaService.downloadModel();
  }

  @override
  Future<ModelInitResult> ensureModelReady() {
    return _gemmaService.ensureInitialized();
  }

  @override
  Stream<String> streamResponse({
    required WorkoutContext context,
    required String userMessage,
    required String languageCode,
    String chatHistory = '',
  }) {
    return _gemmaService.generate(
      context: context,
      userMessage: userMessage,
      languageCode: languageCode,
      chatHistory: chatHistory,
    );
  }
}

@riverpod
AiCoachRepository aiCoachRepository(Ref ref) {
  final gemmaService = ref.watch(gemmaInferenceServiceProvider);
  return AiCoachRepositoryImpl(gemmaService);
}
