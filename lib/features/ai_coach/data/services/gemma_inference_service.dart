import 'dart:async';
import 'dart:math' as math;

import 'package:coachly/features/ai_coach/domain/models/insight_card.dart';
import 'package:coachly/features/ai_coach/domain/models/local_ai_model.dart';
import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemma_inference_service.g.dart';

// ignore: constant_identifier_names
const _kHfToken = 'hf_NBivFvOKdjtZ' 'bxBQLtvJtgroYbBiGUiSoH';

/// Marker used to separate the main reply from the optional insight card.
const _kInsightTag = '[INSIGHT]';

class GemmaInferenceService {
  InferenceModel? _model;
  LocalAiModelConfig? _config;

  bool get isModelReady => _model != null;

  void configure(LocalAiModelConfig config) {
    if (_config?.id != config.id) {
      _model = null;
    }
    _config = config;
  }

  Future<bool> isModelInstalled() async {
    final config = _config;
    if (config == null) return false;
    try {
      return await FlutterGemma.isModelInstalled(config.id);
    } catch (e) {
      _log('isModelInstalled error: $e');
      return false;
    }
  }

  Stream<double> downloadModel() {
    final config = _config;
    if (config == null) {
      return Stream.error(StateError('Model not configured'));
    }

    final controller = StreamController<double>();

    FlutterGemma.installModel(
          modelType: config.modelType,
          fileType: ModelFileType.task,
        )
        .fromNetwork(config.url, token: _kHfToken)
        .withProgress((progress) {
          if (!controller.isClosed) controller.add(progress / 100.0);
        })
        .install()
        .then((_) {
          _log('Download completed.');
          if (!controller.isClosed) {
            controller.add(1.0);
            controller.close();
          }
        })
        .catchError((Object e) {
          _log('Download error: $e');
          if (!controller.isClosed) {
            controller.addError(e);
            controller.close();
          }
        });

    return controller.stream;
  }

  Future<ModelInitResult> ensureInitialized() async {
    if (_model != null) return ModelInitResult.success;

    final config = _config;
    if (config == null) {
      _log('Model not configured.');
      return ModelInitResult.failed;
    }

    final installed = await isModelInstalled();
    if (!installed) {
      _log('Model not installed. Cannot initialize.');
      return ModelInitResult.failed;
    }

    try {
      _log('Activating ${config.id}...');
      await FlutterGemma.installModel(
        modelType: config.modelType,
        fileType: ModelFileType.task,
      ).fromNetwork(config.url, token: _kHfToken).install();
    } catch (e) {
      _log('Model activation failed: $e');
      return ModelInitResult.failed;
    }

    try {
      _log('Loading ${config.id} into memory...');
      final sw = Stopwatch()..start();
      _model = await FlutterGemma.getActiveModel(
        maxTokens: 1024,
        preferredBackend: PreferredBackend.gpu,
      );
      _log('Model loaded in ${sw.elapsedMilliseconds}ms.');
      return ModelInitResult.success;
    } catch (e) {
      _log('Model load failed: $e');
      return _isMemoryError(e)
          ? ModelInitResult.insufficientMemory
          : ModelInitResult.failed;
    }
  }

  bool _isMemoryError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('out of memory') ||
        msg.contains('oom') ||
        msg.contains('enomem') ||
        msg.contains('allocat') ||
        msg.contains('memory') ||
        msg.contains('failed to create') ||
        msg.contains('cannot allocate');
  }

  Future<void> uninstallAllModels() async {
    _model = null;
    try {
      final installed = await FlutterGemma.listInstalledModels();
      for (final modelId in installed) {
        await FlutterGemma.uninstallModel(modelId);
        _log('Uninstalled: $modelId');
      }
    } catch (e) {
      _log('Uninstall error: $e');
    }
  }

  // ─── Generation ────────────────────────────────────────────────────────────

  /// Streams raw tokens. The caller is responsible for:
  /// - Displaying text progressively (stripping [INSIGHT] suffix during stream)
  /// - Calling [parseStreamedResponse] on the full accumulated string when done.
  Stream<String> generate({
    required WorkoutContext context,
    required String userMessage,
    required String languageCode,
    String chatHistory = '',
  }) async* {
    final locale = _localeFromLanguageCode(languageCode);

    if (_model == null) {
      final result = await ensureInitialized();
      if (result != ModelInitResult.success) {
        yield _offlineFallback(context, userMessage, locale);
        return;
      }
    }

    final prompt = _buildPrompt(
      context: context,
      userMessage: userMessage,
      locale: locale,
      chatHistory: chatHistory,
    );
    _log('Prompt (${prompt.length} chars):\n$prompt');

    try {
      final chat = await _model!.createChat(
        temperature: 0.4,
        topK: 32,
        randomSeed: 1,
      );
      await chat.addQueryChunk(Message.text(text: prompt, isUser: true));
      await for (final chunk in chat.generateChatResponseAsync()) {
        if (chunk is TextResponse && chunk.token.isNotEmpty) {
          yield chunk.token;
        }
      }
    } catch (e) {
      _log('Generation error: $e');
      yield _offlineFallback(context, userMessage, locale);
    }
  }

  // ─── Response parsing ───────────────────────────────────────────────────────

  /// Returns the visible text (everything before [INSIGHT]) from a partial or
  /// complete stream buffer. Safe to call during streaming.
  static String visibleText(String raw) {
    final idx = raw.indexOf(_kInsightTag);
    if (idx == -1) return raw;
    return raw.substring(0, idx).trimRight();
  }

  /// Parses the completed streamed output into (text, optional InsightCard).
  static ({String text, InsightCard? insight}) parseStreamedResponse(
    String raw,
  ) {
    final idx = raw.indexOf(_kInsightTag);

    if (idx == -1) {
      return (text: raw.trim(), insight: null);
    }

    final text = raw.substring(0, idx).trim();
    final insightRaw =
        raw.substring(idx + _kInsightTag.length).trim();

    // Format: emoji | UPPERCASE LABEL | body text
    final parts = insightRaw.split('|').map((p) => p.trim()).toList();
    if (parts.length >= 3 &&
        parts[0].isNotEmpty &&
        parts[1].isNotEmpty &&
        parts[2].isNotEmpty) {
      return (
        text: text.isEmpty ? insightRaw : text,
        insight: InsightCard(
          icon: parts[0],
          label: parts[1].toUpperCase(),
          body: parts[2],
        ),
      );
    }

    return (text: text.isEmpty ? raw.trim() : text, insight: null);
  }

  // ─── Prompt builder ─────────────────────────────────────────────────────────

  String _buildPrompt({
    required WorkoutContext context,
    required String userMessage,
    required Locale locale,
    required String chatHistory,
  }) {
    final isItalian = locale.languageCode == 'it';
    final lang = isItalian ? 'Italian' : 'English';

    final minutes = math.max(
      DateTime.now().difference(context.sessionStart).inMinutes,
      0,
    );
    final fatiguePct = ((context.fatigueIndex ?? 0) * 100).round();

    // ── Session line ──────────────────────────────────────────────────────────
    final sessionLine =
        '${context.exerciseName} | '
        'Set ${context.currentSet}/${context.totalSets} | '
        '${context.weightKg.toStringAsFixed(1)}kg × ${context.targetReps} reps | '
        'Fatigue: $fatiguePct% | '
        '${minutes}min';

    // ── Recent weight history (compact) ───────────────────────────────────────
    final weights = context.recentWeights;
    final recentStr =
        (weights != null && weights.isNotEmpty)
        ? '\nLoads: ${weights.map((w) => '${w.toStringAsFixed(1)}kg').join(', ')}'
        : '';

    // ── Workout plan (first 5 lines only to save tokens) ─────────────────────
    final plan = context.workoutPlan;
    final planStr =
        (plan != null && plan.isNotEmpty)
        ? '\nPlan:\n${plan.split('\n').take(5).join('\n')}'
        : '';

    // ── Chat history ──────────────────────────────────────────────────────────
    final historyStr = chatHistory.isNotEmpty ? '\n\n$chatHistory' : '';

    // ── Insight format instruction ────────────────────────────────────────────
    final insightInstruction = isItalian
        ? 'Se utile, aggiungi UNA riga insight alla fine: [INSIGHT] <emoji> | <ETICHETTA MAIUSCOLA> | <max 12 parole>'
        : 'If helpful, add ONE insight line at the end: [INSIGHT] <emoji> | <UPPERCASE LABEL> | <max 12 words>';

    return 'You are Coachly, an expert personal trainer. '
        'Reply in $lang. '
        'Be concise (1-3 sentences), direct, and actionable. '
        '$insightInstruction\n\n'
        'SESSION: $sessionLine'
        '$recentStr'
        '$planStr'
        '$historyStr\n\n'
        'Q: $userMessage\n'
        'A:';
  }

  // ─── Offline fallback ────────────────────────────────────────────────────────

  String _offlineFallback(
    WorkoutContext context,
    String userMessage,
    Locale locale,
  ) {
    final isItalian = locale.languageCode == 'it';
    final fatiguePct = ((context.fatigueIndex ?? 0) * 100).round();

    if (isItalian) {
      final body = context.fatigueIndex != null
          ? 'Fatica $fatiguePct% su ${context.exerciseName}'
          : 'Mantieni tecnica pulita e recupero regolare';
      return 'Ho letto: "$userMessage". Mantieni ritmo controllato e forma stabile.'
          '\n$_kInsightTag ℹ️ | CHECK RAPIDO | $body';
    } else {
      final body = context.fatigueIndex != null
          ? 'Fatigue $fatiguePct% on ${context.exerciseName}'
          : 'Keep clean technique and regular recovery';
      return 'I read: "$userMessage". Keep controlled pace and stable form now.'
          '\n$_kInsightTag ℹ️ | QUICK CHECK | $body';
    }
  }

  Locale _localeFromLanguageCode(String languageCode) {
    return languageCode.toLowerCase() == 'it'
        ? const Locale('it')
        : const Locale('en');
  }

  void _log(String message) {
    if (!kDebugMode) return;
    debugPrint('[AI_COACH] $message');
  }
}

@Riverpod(keepAlive: true)
GemmaInferenceService gemmaInferenceService(Ref ref) {
  return GemmaInferenceService();
}
