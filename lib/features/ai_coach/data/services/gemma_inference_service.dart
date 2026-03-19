import 'dart:math' as math;

import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemma_inference_service.g.dart';

class GemmaInferenceService {
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
    required String languageCode,
  }) async* {
    final locale = _localeFromLanguageCode(languageCode);
    final prompt = _buildPrompt(
      context: context,
      userMessage: userMessage,
      locale: locale,
    );
    final ready = await ensureInitialized();

    if (!ready || _model == null) {
      yield _offlineFallback(context, userMessage, locale);
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
      yield _offlineFallback(context, userMessage, locale);
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
    required Locale locale,
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

    final systemPrompt = AppStrings.translate(
      'ai.prompt.system.en',
      locale: locale,
    );
    final contextTitle = AppStrings.translate(
      'ai.prompt.context_title',
      locale: locale,
    );
    final userTitle = AppStrings.translate(
      'ai.prompt.user_title',
      locale: locale,
    );
    final exerciseLine = AppStrings.translate(
      'ai.prompt.exercise_line',
      locale: locale,
      params: {
        'name': context.exerciseName,
        'current': '${context.currentSet}',
        'total': '${context.totalSets}',
      },
    );
    final weightLine = AppStrings.translate(
      'ai.prompt.weight_line',
      locale: locale,
      params: {
        'weight': context.weightKg.toStringAsFixed(1),
        'reps': '${context.targetReps}',
      },
    );
    final fatigueLine = AppStrings.translate(
      'ai.prompt.fatigue_line',
      locale: locale,
      params: {'value': fatigue},
    );
    final recentWeightsLine = AppStrings.translate(
      'ai.prompt.recent_weights_line',
      locale: locale,
      params: {'value': recentWeights},
    );
    final minutesLine = AppStrings.translate(
      'ai.prompt.minutes_line',
      locale: locale,
      params: {'value': '$minutesSinceStart'},
    );

    return '$systemPrompt\n\n'
        '$contextTitle\n'
        '$exerciseLine\n'
        '$weightLine\n'
        '$fatigueLine\n'
        '$recentWeightsLine\n'
        '$minutesLine\n\n'
        '$userTitle\n'
        '$userMessage';
  }

  String _offlineFallback(
    WorkoutContext context,
    String userMessage,
    Locale locale,
  ) {
    final body = context.fatigueIndex != null
        ? AppStrings.translate(
            'ai.offline.body',
            locale: locale,
            params: {
              'value': '${((context.fatigueIndex ?? 0) * 100).round()}',
              'exercise': context.exerciseName,
            },
          )
        : AppStrings.translate('ai.offline.body_default', locale: locale);

    final escapedMessage = userMessage.replaceAll('"', '\\"');
    final message = AppStrings.translate(
      'ai.offline.message',
      locale: locale,
      params: {'message': escapedMessage},
    ).replaceAll('"', '\\"');
    final label = AppStrings.translate('ai.offline.label', locale: locale);

    return '{'
        '"message":"$message",'
        '"insight_card":{"icon":"info","label":"$label","body":"$body"}'
        '}';
  }

  Locale _localeFromLanguageCode(String languageCode) {
    if (languageCode.toLowerCase() == 'it') {
      return const Locale('it');
    }
    return const Locale('en');
  }
}

@Riverpod(keepAlive: true)
GemmaInferenceService gemmaInferenceService(Ref ref) {
  return GemmaInferenceService();
}
