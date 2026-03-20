import 'dart:async';
import 'dart:math' as math;

import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemma_inference_service.g.dart';

const _kModelUrl =
    'https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv4096.litertlm';
const _kModelId =
    'Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv4096.litertlm';

class GemmaInferenceService {
  InferenceModel? _model;

  bool get isModelReady => _model != null;

  Future<bool> isModelInstalled() async {
    try {
      return await FlutterGemma.isModelInstalled(_kModelId);
    } catch (e) {
      _log('isModelInstalled error: $e');
      return false;
    }
  }

  /// Streams download progress as values from 0.0 to 1.0.
  Stream<double> downloadModel() {
    final controller = StreamController<double>();

    FlutterGemma.installModel(
      modelType: ModelType.qwen,
      fileType: ModelFileType.task,
    )
        .fromNetwork(_kModelUrl)
        .withProgress((progress) {
          if (!controller.isClosed) {
            controller.add(progress / 100.0);
          }
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

  Future<bool> ensureInitialized() async {
    if (_model != null) return true;

    final installed = await isModelInstalled();
    if (!installed) {
      _log('Model not installed. Cannot initialize.');
      return false;
    }

    try {
      _log('Activating $_kModelId...');
      // fromNetwork + install() is idempotent: if the file already exists on
      // device flutter_gemma skips the download and just sets the active model.
      await FlutterGemma.installModel(
        modelType: ModelType.qwen,
        fileType: ModelFileType.task,
      ).fromNetwork(_kModelUrl).install();
    } catch (e) {
      _log('Model activation failed: $e');
      return false;
    }

    try {
      _log('Loading $_kModelId into memory...');
      final stopwatch = Stopwatch()..start();
      _model = await FlutterGemma.getActiveModel(
        maxTokens: 1024,
        preferredBackend: PreferredBackend.gpu,
      );
      _log('Model loaded in ${stopwatch.elapsedMilliseconds}ms.');
      return true;
    } catch (e) {
      _log('Model load failed: $e');
      return false;
    }
  }

  Stream<String> generate({
    required WorkoutContext context,
    required String userMessage,
    required String languageCode,
  }) async* {
    final locale = _localeFromLanguageCode(languageCode);

    if (_model == null) {
      final ready = await ensureInitialized();
      if (!ready) {
        yield _offlineFallback(context, userMessage, locale);
        return;
      }
    }

    final prompt = _buildPrompt(
      context: context,
      userMessage: userMessage,
      locale: locale,
    );

    try {
      final chat = await _model!.createChat(
        temperature: 0.35,
        topK: 24,
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

    final workoutPlanSection =
        context.workoutPlan != null && context.workoutPlan!.isNotEmpty
        ? '\n\n[WORKOUT PLAN]\n${context.workoutPlan}'
        : '';

    return '$systemPrompt\n\n'
        '$contextTitle\n'
        '$exerciseLine\n'
        '$weightLine\n'
        '$fatigueLine\n'
        '$recentWeightsLine\n'
        '$minutesLine'
        '$workoutPlanSection\n\n'
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

  void _log(String message) {
    if (!kDebugMode) return;
    debugPrint('[AI_COACH] $message');
  }
}

@Riverpod(keepAlive: true)
GemmaInferenceService gemmaInferenceService(Ref ref) {
  return GemmaInferenceService();
}
