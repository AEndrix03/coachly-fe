import 'dart:async';

import 'package:coachly/features/ai_coach/data/repositories/ai_coach_repository_impl.dart';
import 'package:coachly/features/ai_coach/data/services/context_assembler_service.dart';
import 'package:coachly/features/ai_coach/data/services/gemma_inference_service.dart';
import 'package:coachly/features/ai_coach/data/services/stt_service.dart';
import 'package:coachly/features/ai_coach/domain/models/coach_message.dart';
import 'package:coachly/features/ai_coach/domain/models/local_ai_model.dart';
import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
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
    this.isModelInstalled = true,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.isLocalAiEnabled = true,
  });

  final List<CoachMessage> messages;
  final bool isGenerating;
  final bool isListening;
  final String voiceTranscript;
  final List<String> suggestions;
  /// True while checking installation or loading model into memory.
  final bool isModelLoading;
  /// False when the model file is not yet downloaded to the device.
  final bool isModelInstalled;
  final bool isDownloading;
  /// Download progress from 0.0 to 1.0.
  final double downloadProgress;
  /// False when the user has disabled local AI in settings.
  final bool isLocalAiEnabled;

  AiCoachState copyWith({
    List<CoachMessage>? messages,
    bool? isGenerating,
    bool? isListening,
    String? voiceTranscript,
    List<String>? suggestions,
    bool? isModelLoading,
    bool? isModelInstalled,
    bool? isDownloading,
    double? downloadProgress,
    bool? isLocalAiEnabled,
  }) {
    return AiCoachState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      isListening: isListening ?? this.isListening,
      voiceTranscript: voiceTranscript ?? this.voiceTranscript,
      suggestions: suggestions ?? this.suggestions,
      isModelLoading: isModelLoading ?? this.isModelLoading,
      isModelInstalled: isModelInstalled ?? this.isModelInstalled,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isLocalAiEnabled: isLocalAiEnabled ?? this.isLocalAiEnabled,
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
          text: _tr('ai.default_opening'),
          sender: MessageSender.ai,
          timestamp: DateTime.now(),
        ),
      ],
      isModelLoading: true,
    );
  }

  Future<void> _bootstrap() async {
    final aiSettings = ref.read(localAiSettingsProvider);

    if (!aiSettings.enabled) {
      state = AsyncData(
        _current.copyWith(
          isModelLoading: false,
          isLocalAiEnabled: false,
        ),
      );
      return;
    }

    // Configure the inference service with the selected model.
    final service = ref.read(gemmaInferenceServiceProvider);
    service.configure(LocalAiModelConfig.forModel(aiSettings.model));

    final repository = ref.read(aiCoachRepositoryProvider);

    final installed = await repository.isModelInstalled();
    if (!ref.mounted) return;

    if (!installed) {
      state = AsyncData(
        _current.copyWith(
          isModelLoading: false,
          isModelInstalled: false,
          isLocalAiEnabled: true,
        ),
      );
      return;
    }

    final ready = await repository.ensureModelReady();
    if (!ref.mounted) return;

    var updated = _current.copyWith(
      isModelLoading: false,
      isModelInstalled: true,
      isLocalAiEnabled: true,
    );
    if (!ready) {
      final warning = CoachMessage(
        id: _nextId('ai'),
        text: _tr('ai.model_unavailable'),
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
      updated = updated.copyWith(messages: [...updated.messages, warning]);
    }

    state = AsyncData(updated);
  }

  Future<void> startModelDownload() async {
    if (_current.isDownloading) return;

    state = AsyncData(
      _current.copyWith(isDownloading: true, downloadProgress: 0.0),
    );

    final repository = ref.read(aiCoachRepositoryProvider);

    try {
      await for (final progress in repository.downloadModel()) {
        if (!ref.mounted) return;
        state = AsyncData(_current.copyWith(downloadProgress: progress));
      }

      if (!ref.mounted) return;

      // Download complete — load model into memory.
      state = AsyncData(
        _current.copyWith(
          isDownloading: false,
          isModelInstalled: true,
          isModelLoading: true,
          downloadProgress: 1.0,
        ),
      );

      final ready = await repository.ensureModelReady();
      if (!ref.mounted) return;

      var updated = _current.copyWith(isModelLoading: false);
      if (!ready) {
        final warning = CoachMessage(
          id: _nextId('ai'),
          text: _tr('ai.model_unavailable'),
          sender: MessageSender.ai,
          timestamp: DateTime.now(),
        );
        updated = updated.copyWith(messages: [...updated.messages, warning]);
      }
      state = AsyncData(updated);
    } catch (_) {
      if (!ref.mounted) return;
      state = AsyncData(
        _current.copyWith(
          isDownloading: false,
          isModelInstalled: false,
          downloadProgress: 0.0,
        ),
      );
    }
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
        languageCode: _languageCode,
      )) {
        streamBuffer.write(token);
        // Do not update the bubble with raw JSON during streaming;
        // the typing indicator stays visible until parsing is complete.
      }

      final parsed = repository.parseAiMessage(
        raw: streamBuffer.toString(),
        id: aiPlaceholder.id,
        timestamp: DateTime.now(),
        languageCode: _languageCode,
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
        text: _tr('ai.retry_short'),
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
      localeId: _speechLocaleId,
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
        // Keep transcript in state; InputBar will consume it and populate
        // the text field, letting the user review before sending.
        state = AsyncData(
          _current.copyWith(isListening: false, voiceTranscript: finalText),
        );
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

  /// Called by the VoiceOverlay "Send" button: stops listening and leaves
  /// the transcript in state so InputBar can populate the text field.
  Future<void> sendVoiceTranscript() async {
    final stt = ref.read(sttServiceProvider);
    await stt.stopListening();
    if (!ref.mounted) return;
    state = AsyncData(_current.copyWith(isListening: false));
  }

  void clearVoiceTranscript() {
    state = AsyncData(_current.copyWith(voiceTranscript: ''));
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
    final italian = _isItalian;

    if (text.contains('fatica') ||
        text.contains('recupero') ||
        text.contains('fatigue') ||
        text.contains('recovery')) {
      return italian
          ? const [
              'Taglio 2.5 kg nel prossimo set?',
              'Quanto recupero mi consigli adesso?',
              'Meglio chiudere con back-off set?',
            ]
          : const [
              'Should I drop 2.5 kg in the next set?',
              'How much rest do you suggest now?',
              'Should I finish with a back-off set?',
            ];
    }

    if (text.contains('tecnica') ||
        text.contains('forma') ||
        text.contains('technique') ||
        text.contains('form')) {
      return italian
          ? const [
              'Dammi 3 cue tecnici rapidi',
              'Meglio rallentare eccentrica?',
              'Posso aumentare ROM in sicurezza?',
            ]
          : const [
              'Give me 3 quick technique cues',
              'Should I slow down the eccentric?',
              'Can I increase ROM safely?',
            ];
    }

    return italian
        ? [
            'Come ottimizzo il prossimo set di ${context.exerciseName}?',
            'Mostrami trend carichi ultime sessioni',
            'Indicami un target reps realistico ora',
          ]
        : [
            'How do I optimize the next set on ${context.exerciseName}?',
            'Show me the load trend from recent sessions',
            'Suggest a realistic reps target now',
          ];
  }

  String _templateFor(QuickActionType action, WorkoutContext context) {
    final italian = _isItalian;
    switch (action) {
      case QuickActionType.adjustWeight:
        return italian
            ? 'Devo aggiustare il peso nel set ${context.currentSet}/${context.totalSets}?'
            : 'Should I adjust the load on set ${context.currentSet}/${context.totalSets}?';
      case QuickActionType.showProgress:
        return italian
            ? 'Fammi un recap dei progressi su ${context.exerciseName}.'
            : 'Give me a quick progress recap on ${context.exerciseName}.';
      case QuickActionType.fatigueCheck:
        return italian
            ? 'Valuta la mia fatica adesso e suggerisci recupero.'
            : 'Assess my fatigue now and suggest recovery.';
      case QuickActionType.nextExercise:
        return italian
            ? 'Sono pronto al prossimo esercizio o faccio un altro set?'
            : 'Am I ready for the next exercise or should I do another set?';
      case QuickActionType.nutrition:
        return italian
            ? 'Consiglio nutrizione post workout rapido in base a questa sessione.'
            : 'Give me a quick post-workout nutrition tip based on this session.';
    }
  }

  String get _languageCode =>
      ref.read(languageProvider).languageCode.toLowerCase();
  bool get _isItalian => _languageCode == 'it';
  String get _speechLocaleId => _isItalian ? 'it_IT' : 'en_US';
  Locale get _locale => _isItalian ? const Locale('it') : const Locale('en');

  String _tr(String key, {Map<String, String> params = const {}}) {
    return AppStrings.translate(key, locale: _locale, params: params);
  }

  String _nextId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }
}
