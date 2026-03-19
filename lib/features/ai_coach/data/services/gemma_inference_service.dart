import 'dart:async';
import 'dart:math' as math;

import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemma_inference_service.g.dart';

class GemmaInferenceService {
  final FlutterGemmaPlugin _gemma = FlutterGemmaPlugin.instance;
  bool _isModelReady = false;
  Future<bool>? _warmupFuture;
  static const int _warmupSteps = 5;

  bool get isModelReady => _isModelReady;
  bool get isWarmingUp => _warmupFuture != null && !_isModelReady;

  Future<bool> ensureInitialized() async {
    if (_isModelReady) {
      _log('Warmup skipped: model already ready.');
      return true;
    }

    if (_warmupFuture != null) {
      _log('Warmup already in progress, joining existing future.');
      return _warmupFuture!;
    }

    _warmupFuture = _runWarmup();
    try {
      return await _warmupFuture!;
    } finally {
      _warmupFuture = null;
    }
  }

  Stream<String> generate({
    required WorkoutContext context,
    required String userMessage,
    required String languageCode,
  }) async* {
    final locale = _localeFromLanguageCode(languageCode);
    if (isWarmingUp && !_isModelReady) {
      _log('Generation requested while warmup in progress.');
      yield _modelLoadingFallback(locale);
      return;
    }

    final prompt = _buildPrompt(
      context: context,
      userMessage: userMessage,
      locale: locale,
    );
    final ready = await ensureInitialized().timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        _log('Warmup timeout reached for generation request.');
        return false;
      },
    );

    if (!ready) {
      _log(
        'Generation fallback: model not ready in time, returning loading notice.',
      );
      yield _modelLoadingFallback(locale);
      return;
    }

    try {
      await for (final token in _gemma.getResponseAsync(prompt: prompt)) {
        if (token is String && token.isNotEmpty) {
          yield token;
        }
      }
    } catch (_) {
      _log('Generation error: using offline fallback response.');
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

  Future<bool> _runWarmup() async {
    final stopwatch = Stopwatch()..start();
    _log('Warmup start.');

    Timer? heartbeat;
    try {
      heartbeat = Timer.periodic(const Duration(seconds: 1), (_) {
        _log(
          'Warmup in progress... ${stopwatch.elapsedMilliseconds}ms elapsed.',
        );
      });

      _log('Step 1/$_warmupSteps: reading plugin init status.');
      final alreadyInitialized = await _gemma.isInitialized;
      _log(
        'Step 1/$_warmupSteps done: alreadyInitialized=$alreadyInitialized.',
      );

      _log('Step 2/$_warmupSteps: checking local model availability.');
      final isLoaded = await _gemma.isLoaded;
      _log('Step 2/$_warmupSteps done: isLoaded=$isLoaded.');

      if (!isLoaded) {
        _log('Step 3/$_warmupSteps aborted: model not loaded on device.');
        _isModelReady = false;
        return false;
      }

      _log('Step 3/$_warmupSteps: init check.');
      if (!alreadyInitialized) {
        _log('Step 4/$_warmupSteps: initializing Gemma runtime...');
        await _gemma.init(
          maxTokens: 384,
          temperature: 0.35,
          topK: 24,
          randomSeed: 1,
        );
        _log('Step 4/$_warmupSteps done: runtime init completed.');
      } else {
        _log('Step 4/$_warmupSteps skipped: runtime already initialized.');
      }

      _log('Step 5/$_warmupSteps: final readiness verification.');
      _isModelReady = await _gemma.isInitialized;
      _log(
        'Step 5/$_warmupSteps done: isModelReady=$_isModelReady (total ${stopwatch.elapsedMilliseconds}ms).',
      );
      return _isModelReady;
    } catch (e) {
      _isModelReady = false;
      _log('Warmup failed after ${stopwatch.elapsedMilliseconds}ms: $e');
      return false;
    } finally {
      heartbeat?.cancel();
      stopwatch.stop();
    }
  }

  String _modelLoadingFallback(Locale locale) {
    final message = AppStrings.translate(
      'ai.model_loading_retry',
      locale: locale,
    ).replaceAll('"', '\\"');

    return '{'
        '"message":"$message",'
        '"insight_card":null'
        '}';
  }

  Locale _localeFromLanguageCode(String languageCode) {
    if (languageCode.toLowerCase() == 'it') {
      return const Locale('it');
    }
    return const Locale('en');
  }

  void _log(String message) {
    if (!kDebugMode) {
      return;
    }
    debugPrint('[AI_WARMUP] $message');
  }
}

@Riverpod(keepAlive: true)
GemmaInferenceService gemmaInferenceService(Ref ref) {
  return GemmaInferenceService();
}

final aiCoachModelWarmupProvider = FutureProvider<bool>((ref) async {
  final stopwatch = Stopwatch()..start();
  if (kDebugMode) {
    debugPrint('[AI_WARMUP] Provider warmup requested.');
  }
  final service = ref.watch(gemmaInferenceServiceProvider);
  final ready = await service.ensureInitialized();
  if (kDebugMode) {
    debugPrint(
      '[AI_WARMUP] Provider warmup completed: ready=$ready in ${stopwatch.elapsedMilliseconds}ms.',
    );
  }
  return ready;
});
