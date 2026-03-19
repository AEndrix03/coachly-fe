import 'dart:convert';

import 'package:coachly/features/ai_coach/data/services/gemma_inference_service.dart';
import 'package:coachly/features/ai_coach/domain/models/coach_message.dart';
import 'package:coachly/features/ai_coach/domain/models/insight_card.dart';
import 'package:coachly/features/ai_coach/domain/models/workout_context.dart';
import 'package:coachly/features/ai_coach/domain/repositories/ai_coach_repository.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_coach_repository_impl.g.dart';

class AiCoachRepositoryImpl implements AiCoachRepository {
  AiCoachRepositoryImpl(this._gemmaService);

  final GemmaInferenceService _gemmaService;

  @override
  Future<bool> isModelInstalled() {
    return _gemmaService.isModelInstalled();
  }

  @override
  Stream<double> downloadModel() {
    return _gemmaService.downloadModel();
  }

  @override
  Future<bool> ensureModelReady() {
    return _gemmaService.ensureInitialized();
  }

  @override
  Stream<String> streamResponse({
    required WorkoutContext context,
    required String userMessage,
    required String languageCode,
  }) {
    return _gemmaService.generate(
      context: context,
      userMessage: userMessage,
      languageCode: languageCode,
    );
  }

  @override
  CoachMessage parseAiMessage({
    required String raw,
    required String id,
    required DateTime timestamp,
    required String languageCode,
  }) {
    final locale = languageCode.toLowerCase() == 'it'
        ? const Locale('it')
        : const Locale('en');
    final decoded = _decodeJson(raw);
    if (decoded == null) {
      return CoachMessage(
        id: id,
        text: raw.trim().isEmpty
            ? AppStrings.translate('ai.json_fallback', locale: locale)
            : raw.trim(),
        sender: MessageSender.ai,
        timestamp: timestamp,
      );
    }

    final message = (decoded['message'] as String?)?.trim();
    final insightRaw = decoded['insight_card'];
    InsightCard? insight;

    if (insightRaw is Map<String, dynamic>) {
      final icon = (insightRaw['icon'] as String?)?.trim();
      final label = (insightRaw['label'] as String?)?.trim();
      final body = (insightRaw['body'] as String?)?.trim();

      if ((icon ?? '').isNotEmpty &&
          (label ?? '').isNotEmpty &&
          (body ?? '').isNotEmpty) {
        insight = InsightCard(
          icon: icon!,
          label: label!.toUpperCase(),
          body: body!,
        );
      }
    }

    return CoachMessage(
      id: id,
      text: message?.isNotEmpty == true
          ? message!
          : AppStrings.translate('ai.message_fallback', locale: locale),
      sender: MessageSender.ai,
      timestamp: timestamp,
      insightCard: insight,
    );
  }

  Map<String, dynamic>? _decodeJson(String raw) {
    final sanitized = raw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    // 1. Direct parse (happy path).
    var result = _tryDecode(sanitized);
    if (result != null) return result;

    // 2. Extract the first {...} block and try again.
    final blockMatch =
        RegExp(r'\{[\s\S]*\}', multiLine: true).firstMatch(sanitized);
    if (blockMatch != null) {
      final block = blockMatch.group(0)!;

      result = _tryDecode(block);
      if (result != null) return result;

      // 3. Fix unquoted keys (e.g. {message: "..."} → {"message": "..."}).
      result = _tryDecode(_fixUnquotedKeys(block));
      if (result != null) return result;

      // 4. Truncated JSON: close any unclosed objects and try once more.
      result = _tryDecode(_closeJson(block));
      if (result != null) return result;
    }

    // 5. Last resort: pull the message value directly via regex so the
    //    user at least sees a response even when the JSON is mangled.
    final msgMatch =
        RegExp(r'"message"\s*:\s*"((?:[^"\\]|\\.)*)"').firstMatch(sanitized);
    if (msgMatch != null) {
      return {'message': msgMatch.group(1)!, 'insight_card': null};
    }

    return null;
  }

  Map<String, dynamic>? _tryDecode(String json) {
    try {
      final dynamic parsed = jsonDecode(json);
      return parsed is Map<String, dynamic> ? parsed : null;
    } catch (_) {
      return null;
    }
  }

  /// Adds double-quotes around bareword JSON keys.
  String _fixUnquotedKeys(String json) {
    return json.replaceAllMapped(
      RegExp(r'([\{,])\s*([A-Za-z_][A-Za-z0-9_]*)\s*:'),
      (m) => '${m.group(1)}"${m.group(2)}":',
    );
  }

  /// Attempts to close truncated JSON by counting braces.
  String _closeJson(String json) {
    var open = 0;
    for (final ch in json.runes) {
      if (ch == 0x7B) open++; // '{'
      if (ch == 0x7D) open--; // '}'
    }
    if (open <= 0) return json;
    final buf = StringBuffer(json);
    // Close any open string first (model may have been cut mid-value).
    if (!json.trimRight().endsWith('"') &&
        !json.trimRight().endsWith('}') &&
        !json.trimRight().endsWith('null')) {
      buf.write('"');
    }
    for (var i = 0; i < open; i++) {
      buf.write('}');
    }
    return buf.toString();
  }
}

@riverpod
AiCoachRepository aiCoachRepository(Ref ref) {
  final gemmaService = ref.watch(gemmaInferenceServiceProvider);
  return AiCoachRepositoryImpl(gemmaService);
}
