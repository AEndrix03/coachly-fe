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

    try {
      final dynamic parsed = jsonDecode(sanitized);
      if (parsed is Map<String, dynamic>) {
        return parsed;
      }
    } catch (_) {
      // Try extracting the first valid JSON object.
    }

    final match = RegExp(r'\{[\s\S]*\}', multiLine: true).firstMatch(sanitized);
    if (match == null) {
      return null;
    }

    try {
      final dynamic parsed = jsonDecode(match.group(0)!);
      return parsed is Map<String, dynamic> ? parsed : null;
    } catch (_) {
      return null;
    }
  }
}

@riverpod
AiCoachRepository aiCoachRepository(Ref ref) {
  final gemmaService = ref.watch(gemmaInferenceServiceProvider);
  return AiCoachRepositoryImpl(gemmaService);
}
