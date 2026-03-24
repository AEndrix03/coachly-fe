import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

final workoutSpeechToTextServiceProvider = Provider<WorkoutSpeechToTextService>((ref) {
  return WorkoutSpeechToTextService();
});

class WorkoutSpeechToTextService {
  WorkoutSpeechToTextService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;

  Future<String?> transcribe({
    required String localeId,
    Duration maxDuration = const Duration(seconds: 20),
  }) async {
    if (!_initialized) {
      _initialized = await _speech.initialize();
    }

    if (!_initialized) {
      return null;
    }

    final completer = Completer<String?>();
    var transcript = '';
    var hasRecognizedText = false;
    Timer? silenceTimer;

    Future<void> complete() async {
      if (completer.isCompleted) {
        return;
      }

      silenceTimer?.cancel();
      if (_speech.isListening) {
        await _speech.stop();
      }

      final finalTranscript = transcript.trim();
      completer.complete(finalTranscript.isEmpty ? null : finalTranscript);
    }

    final resolvedLocaleId = await _resolveLocaleId(localeId);
    Future<void> startListening() async {
      await _speech.listen(
        localeId: resolvedLocaleId,
        pauseFor: const Duration(milliseconds: 2500),
        listenFor: const Duration(minutes: 2),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
        ),
        onResult: (result) {
          final words = result.recognizedWords.trim();
          if (words.isNotEmpty) {
            hasRecognizedText = true;
            transcript = words;
            silenceTimer?.cancel();
            silenceTimer = Timer(const Duration(milliseconds: 2500), () async {
              await complete();
            });
          }

          // Some engines can emit finalResult with empty text immediately.
          // Only close when we actually captured speech.
          if (result.finalResult && words.isNotEmpty) {
            unawaited(complete());
          }
        },
      );
    }

    if (_speech.isListening) {
      await _speech.stop();
    }
    await startListening();

    // Retry once if recognition did not effectively start.
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!_speech.isListening && !hasRecognizedText) {
      await startListening();
    }

    return completer.future.timeout(
      maxDuration,
      onTimeout: () async {
        await complete();
        return transcript.trim().isEmpty ? null : transcript.trim();
      },
    );
  }

  Future<String> _resolveLocaleId(String preferredLocaleId) async {
    try {
      final locales = await _speech.locales();
      for (final locale in locales) {
        if (locale.localeId.toLowerCase() == preferredLocaleId.toLowerCase()) {
          return locale.localeId;
        }
      }

      final languageCode = preferredLocaleId
          .split(RegExp(r'[-_]'))
          .first
          .toLowerCase();
      for (final locale in locales) {
        if (locale.localeId.toLowerCase().startsWith(languageCode)) {
          return locale.localeId;
        }
      }
    } catch (_) {
      // Fallback to preferred locale.
    }

    return preferredLocaleId;
  }
}
