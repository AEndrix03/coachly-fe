import 'dart:async';

import 'package:coachly/features/ai_coach/data/repositories/ai_coach_repository_impl.dart';
import 'package:coachly/features/ai_coach/data/services/context_assembler_service.dart';
import 'package:coachly/features/ai_coach/data/services/stt_service.dart';
import 'package:coachly/features/ai_coach/domain/models/coach_message.dart';
import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_coach_notifier.g.dart';

enum QuickActionType {
  adjustWeight,
  showProgress,
  fatigueCheck,
  nextExercise,
  nutrition,
}

class AiCoachState {
  const AiCoachState({
    this.messages = const [],
    this.isGenerating = false,
    this.isListening = false,
    this.voiceTranscript = '',
    this.suggestions = const [],
    this.isModelLoading = true,
  });

  final List<CoachMessage> messages;
  final bool isGenerating;
  final bool isListening;
  final String voiceTranscript;
  final List<String> suggestions;
  final bool isModelLoading;

  AiCoachState copyWith({
    List<CoachMessage>? messages,
    bool? isGenerating,
    bool? isListening,
    String? voiceTranscript,
    List<String>? suggestions,
    bool? isModelLoading,
  }) {
    return AiCoachState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      isListening: isListening ?? this.isListening,
      voiceTranscript: voiceTranscript ?? this.voiceTranscript,
      suggestions: suggestions ?? this.suggestions,
      isModelLoading: isModelLoading ?? this.isModelLoading,
    );
  }
}

@riverpod
class AiCoachNotifier extends _$AiCoachNotifier {
  AiCoachState get _current => state.value ?? const AiCoachState();

  @override
  FutureOr<AiCoachState> build() {
    Future<void>.microtask(_bootstrap);
    return AiCoachState(
      messages: [
        CoachMessage(
          id: _nextId('ai'),
          text:
              'Sono pronto. Dimmi come ti senti in questo set e ti guido subito.',
          sender: MessageSender.ai,
          timestamp: DateTime.now(),
        ),
      ],
      isModelLoading: true,
    );
  }

  Future<void> _bootstrap() async {
    final repository = ref.read(aiCoachRepositoryProvider);
    final ready = await repository.ensureModelReady();
    if (!ref.mounted) {
      return;
    }

    var updated = _current.copyWith(isModelLoading: false);
    if (!ready) {
      final warning = CoachMessage(
        id: _nextId('ai'),
        text:
            'Modello non disponibile ora. Uso risposte locali semplificate offline.',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
      updated = updated.copyWith(messages: [...updated.messages, warning]);
    }

    state = AsyncData(updated);
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _current.isGenerating) {
      return;
    }

    final repository = ref.read(aiCoachRepositoryProvider);
    final context = ref.read(currentWorkoutContextProvider);
    final userMessage = CoachMessage(
      id: _nextId('user'),
      text: trimmed,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final aiPlaceholder = CoachMessage(
      id: _nextId('ai'),
      text: '',
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );

    state = AsyncData(
      _current.copyWith(
        messages: [..._current.messages, userMessage, aiPlaceholder],
        isGenerating: true,
        suggestions: const [],
      ),
    );

    final streamBuffer = StringBuffer();

    try {
      await for (final token in repository.streamResponse(
        context: context,
        userMessage: trimmed,
      )) {
        streamBuffer.write(token);
        _replaceMessageText(aiPlaceholder.id, streamBuffer.toString());
      }

      final parsed = repository.parseAiMessage(
        raw: streamBuffer.toString(),
        id: aiPlaceholder.id,
        timestamp: DateTime.now(),
      );

      final messages = _current.messages
          .map((message) => message.id == aiPlaceholder.id ? parsed : message)
          .toList(growable: false);

      state = AsyncData(
        _current.copyWith(
          messages: messages,
          isGenerating: false,
          suggestions: _buildSuggestions(parsed, context),
        ),
      );
      await HapticFeedback.lightImpact();
    } catch (_) {
      final fallback = CoachMessage(
        id: aiPlaceholder.id,
        text:
            'Non ho completato la risposta. Riprova con una richiesta piu breve.',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );

      final messages = _current.messages
          .map((message) => message.id == aiPlaceholder.id ? fallback : message)
          .toList(growable: false);

      state = AsyncData(
        _current.copyWith(
          messages: messages,
          isGenerating: false,
          suggestions: _buildSuggestions(fallback, context),
        ),
      );
    }
  }

  Future<void> startVoiceInput() async {
    if (_current.isListening) {
      return;
    }

    await HapticFeedback.lightImpact();

    state = AsyncData(
      _current.copyWith(isListening: true, voiceTranscript: ''),
    );

    final stt = ref.read(sttServiceProvider);

    await stt.startListening(
      onPartialResult: (partial) {
        if (!ref.mounted) {
          return;
        }
        state = AsyncData(_current.copyWith(voiceTranscript: partial));
      },
      onFinalResult: (finalText) {
        if (!ref.mounted) {
          return;
        }
        state = AsyncData(
          _current.copyWith(isListening: false, voiceTranscript: finalText),
        );
        unawaited(sendVoiceTranscript());
      },
      onError: () {
        if (!ref.mounted) {
          return;
        }
        state = AsyncData(
          _current.copyWith(isListening: false, voiceTranscript: ''),
        );
      },
    );
  }

  Future<void> stopVoiceInput() async {
    final stt = ref.read(sttServiceProvider);
    await stt.stopListening();
    if (!ref.mounted) {
      return;
    }

    state = AsyncData(_current.copyWith(isListening: false));
  }

  Future<void> sendVoiceTranscript() async {
    final transcript = _current.voiceTranscript.trim();
    if (transcript.isEmpty) {
      return;
    }

    state = AsyncData(
      _current.copyWith(voiceTranscript: '', isListening: false),
    );
    await sendMessage(transcript);
  }

  void tapQuickAction(QuickActionType action) {
    final context = ref.read(currentWorkoutContextProvider);
    final prompt = _templateFor(action, context);
    unawaited(sendMessage(prompt));
  }

  void clearSuggestions() {
    state = AsyncData(_current.copyWith(suggestions: const []));
  }

  void _replaceMessageText(String messageId, String text) {
    if (!ref.mounted) {
      return;
    }

    final messages = _current.messages
        .map(
          (message) =>
              message.id == messageId ? message.copyWith(text: text) : message,
        )
        .toList(growable: false);

    state = AsyncData(
      _current.copyWith(messages: messages, isGenerating: true),
    );
  }

  List<String> _buildSuggestions(CoachMessage message, WorkoutContext context) {
    final text = message.text.toLowerCase();

    if (text.contains('fatica') || text.contains('recupero')) {
      return const [
        'Taglio 2.5 kg nel prossimo set?',
        'Quanto recupero mi consigli adesso?',
        'Meglio chiudere con back-off set?',
      ];
    }

    if (text.contains('tecnica') || text.contains('forma')) {
      return const [
        'Dammi 3 cue tecnici rapidi',
        'Meglio rallentare eccentrica?',
        'Posso aumentare ROM in sicurezza?',
      ];
    }

    return [
      'Come ottimizzo il prossimo set di ${context.exerciseName}?',
      'Mostrami trend carichi ultime sessioni',
      'Indicami un target reps realistico ora',
    ];
  }

  String _templateFor(QuickActionType action, WorkoutContext context) {
    switch (action) {
      case QuickActionType.adjustWeight:
        return 'Devo aggiustare il peso nel set ${context.currentSet}/${context.totalSets}?';
      case QuickActionType.showProgress:
        return 'Fammi un recap dei progressi su ${context.exerciseName}.';
      case QuickActionType.fatigueCheck:
        return 'Valuta la mia fatica adesso e suggerisci recupero.';
      case QuickActionType.nextExercise:
        return 'Sono pronto al prossimo esercizio o faccio un altro set?';
      case QuickActionType.nutrition:
        return 'Consiglio nutrizione post workout rapido in base a questa sessione.';
    }
  }

  String _nextId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }
}
