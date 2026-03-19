import 'package:coachly/features/ai_coach/domain/models/coach_message.dart';
import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';

abstract class AiCoachRepository {
  Future<bool> isModelInstalled();

  Stream<double> downloadModel();

  Future<bool> ensureModelReady();

  Stream<String> streamResponse({
    required WorkoutContext context,
    required String userMessage,
    required String languageCode,
  });

  CoachMessage parseAiMessage({
    required String raw,
    required String id,
    required DateTime timestamp,
    required String languageCode,
  });
}
