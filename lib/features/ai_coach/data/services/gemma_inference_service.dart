import 'dart:math' as math;

import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemma_inference_service.g.dart';

class GemmaInferenceService {
  static const String _systemPrompt =
      'Sei AI Coach di Coachly, un assistente fitness on-device.\n'
      'Hai accesso al contesto del workout in tempo reale dell\'utente.\n'
      'Rispondi SEMPRE in JSON con questa struttura esatta:\n'
      '{\n'
      '  "message": "<risposta conversazionale in italiano, max 3 frasi>",\n'
      '  "insight_card": {\n'
      '    "icon": "<emoji>",\n'
      '    "label": "<LABEL IN UPPERCASE, max 3 parole>",\n'
      '    "body": "<dato strutturato, max 12 parole>"\n'
      '  } | null\n'
      '}\n'
      'Non aggiungere nulla fuori dal JSON. Non usare markdown.\n'
      'Sei conciso, diretto, motivante. Non sei un chatbot generico.';

  dynamic _model;
  bool _isModelReady = false;
  bool _isInitializing = false;

  bool get isModelReady => _isModelReady;

  Future<bool> ensureInitialized() async {
    if (_isModelReady && _model != null) {
      return true;
    }

    if (_isInitializing) {
      while (_isInitializing) {
        await Future<void>.delayed(const Duration(milliseconds: 120));
      }
      return _isModelReady;
    }

    _isInitializing = true;
    try {
      _model = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt,
        preferredBackend: PreferredBackend.cpu,
        maxTokens: 768,
      );
      _isModelReady = true;
    } catch (_) {
      _model = null;
      _isModelReady = false;
    } finally {
      _isInitializing = false;
    }

    return _isModelReady;
  }

  Stream<String> generate({
    required WorkoutContext context,
    required String userMessage,
  }) async* {
    final prompt = _buildPrompt(context: context, userMessage: userMessage);
    final ready = await ensureInitialized();

    if (!ready || _model == null) {
      yield _offlineFallback(context, userMessage);
      return;
    }

    dynamic session;
    try {
      session = await _model.createSession(temperature: 0.45, topK: 40);

      await session.addQueryChunk(Message.text(text: prompt, isUser: true));

      await for (final token in session.getResponseAsync()) {
        if (token is String && token.isNotEmpty) {
          yield token;
        }
      }
    } catch (_) {
      yield _offlineFallback(context, userMessage);
    } finally {
      try {
        await session?.close();
      } catch (_) {
        // No-op.
      }
    }
  }

  String _buildPrompt({
    required WorkoutContext context,
    required String userMessage,
  }) {
    final minutesSinceStart = math.max(
      DateTime.now().difference(context.sessionStart).inMinutes,
      0,
    );

    final fatigue = context.fatigueIndex?.toStringAsFixed(2) ?? 'n/d';
    final recentWeights =
        context.recentWeights == null || context.recentWeights!.isEmpty
        ? '[]'
        : context.recentWeights!
              .map((value) => value.toStringAsFixed(1))
              .join(', ');

    return '$_systemPrompt\n\n'
        '[CONTESTO WORKOUT]\n'
        'Esercizio: ${context.exerciseName} | Set: ${context.currentSet}/${context.totalSets}\n'
        'Peso: ${context.weightKg.toStringAsFixed(1)}kg x ${context.targetReps} reps target\n'
        'Indice fatica: $fatigue\n'
        'Storico pesi recenti: $recentWeights\n'
        'Minuti sessione: $minutesSinceStart\n\n'
        '[MESSAGGIO UTENTE]\n'
        '$userMessage';
  }

  String _offlineFallback(WorkoutContext context, String userMessage) {
    final body = context.fatigueIndex != null
        ? 'Fatica ${((context.fatigueIndex ?? 0) * 100).round()}% su ${context.exerciseName}'
        : 'Mantieni tecnica pulita e recupero regolare';

    final escapedMessage = userMessage.replaceAll('"', '\\"');

    return '{'
        '"message":"Ho letto: $escapedMessage. Ora mantieni ritmo controllato e forma stabile.",'
        '"insight_card":{"icon":"info","label":"CHECK RAPIDO","body":"$body"}'
        '}';
  }
}

@Riverpod(keepAlive: true)
GemmaInferenceService gemmaInferenceService(Ref ref) {
  return GemmaInferenceService();
}
