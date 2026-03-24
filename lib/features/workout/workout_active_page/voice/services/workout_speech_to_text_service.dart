import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

final workoutSpeechToTextServiceProvider =
    Provider<WorkoutSpeechToTextService>((ref) {
      return WorkoutSpeechToTextService();
    });

class WorkoutSpeechToTextService {
  WorkoutSpeechToTextService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;
  bool _explicitStop = false;
  String _lastTranscript = '';

  void Function()? _onError;
  void Function()? _onListeningStopped;

  bool get isListening => _speech.isListening;

  Future<bool> startListening({
    required String localeId,
    required void Function(String partial) onPartialResult,
    void Function(double level)? onSoundLevelChange,
    void Function()? onError,
    void Function()? onListeningStopped,
  }) async {
    _onError = onError;
    _onListeningStopped = onListeningStopped;

    if (!_initialized) {
      _initialized = await _speech.initialize(
        onError: (_) => _onError?.call(),
        onStatus: (status) {
          if (status == 'notListening' && !_explicitStop) {
            _onListeningStopped?.call();
          }
        },
      );
    }

    if (!_initialized) {
      _onError?.call();
      return false;
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    _explicitStop = false;
    _lastTranscript = '';
    final resolvedLocaleId = await _resolveLocaleId(localeId);

    await _speech.listen(
      localeId: resolvedLocaleId,
      pauseFor: const Duration(seconds: 30),
      listenFor: const Duration(minutes: 5),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
      onSoundLevelChange: (level) {
        onSoundLevelChange?.call(level);
      },
      onResult: (result) {
        final words = result.recognizedWords.trim();
        if (words.isEmpty) {
          return;
        }

        _lastTranscript = words;
        onPartialResult(words);
      },
    );

    return _speech.isListening;
  }

  Future<String?> stopListening() async {
    _explicitStop = true;
    if (_speech.isListening) {
      await _speech.stop();
    }

    final transcript = _lastTranscript.trim();
    return transcript.isEmpty ? null : transcript;
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
      // Keep preferred locale.
    }

    return preferredLocaleId;
  }
}
