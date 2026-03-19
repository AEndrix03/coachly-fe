import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'stt_service.g.dart';

class SttService {
  SttService() : _speech = SpeechToText();

  final SpeechToText _speech;
  Timer? _silenceTimer;
  String _lastTranscript = '';
  bool _initialized = false;
  bool _finalEmitted = false;

  bool get isListening => _speech.isListening;

  Future<void> startListening({
    required String localeId,
    required void Function(String partial) onPartialResult,
    required void Function(String final_) onFinalResult,
    required void Function() onError,
  }) async {
    if (!_initialized) {
      _initialized = await _speech.initialize(
        onError: (_) => onError(),
        onStatus: (status) {
          if (status == 'notListening') {
            _finishListening(onFinalResult: onFinalResult, onError: onError);
          }
        },
      );
    }

    if (!_initialized) {
      onError();
      return;
    }

    _lastTranscript = '';
    _finalEmitted = false;
    _silenceTimer?.cancel();

    await _speech.listen(
      partialResults: true,
      cancelOnError: true,
      pauseFor: const Duration(milliseconds: 2500),
      listenFor: const Duration(minutes: 2),
      localeId: localeId,
      onResult: (result) {
        final words = result.recognizedWords.trim();
        if (words.isNotEmpty) {
          _lastTranscript = words;
          onPartialResult(words);
          _restartSilenceTimer(onFinalResult: onFinalResult, onError: onError);
        }

        if (result.finalResult) {
          _finishListening(onFinalResult: onFinalResult, onError: onError);
        }
      },
    );
  }

  Future<void> stopListening() async {
    _silenceTimer?.cancel();
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  void _restartSilenceTimer({
    required void Function(String final_) onFinalResult,
    required void Function() onError,
  }) {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(milliseconds: 2500), () async {
      await stopListening();
      _finishListening(onFinalResult: onFinalResult, onError: onError);
    });
  }

  void _finishListening({
    required void Function(String final_) onFinalResult,
    required void Function() onError,
  }) {
    if (_finalEmitted) {
      return;
    }

    _silenceTimer?.cancel();
    final finalTranscript = _lastTranscript.trim();
    if (finalTranscript.isEmpty) {
      _finalEmitted = true;
      onError();
      return;
    }
    _finalEmitted = true;
    onFinalResult(finalTranscript);
  }
}

@Riverpod(keepAlive: true)
SttService sttService(Ref ref) {
  return SttService();
}
