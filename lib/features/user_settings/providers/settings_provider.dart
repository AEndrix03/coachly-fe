import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/ai_coach/domain/models/local_ai_model.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class Language extends _$Language {
  @override
  Locale build() {
    final db = LocalDatabaseService();
    final storedLanguage = db.settings.get('language') as String?;
    final parsedStoredLocale = _parseLocale(storedLanguage);
    if (parsedStoredLocale != null) {
      return parsedStoredLocale;
    }
    return AppStrings.defaultLocale;
  }

  Future<void> setLanguage(Locale locale) async {
    final normalizedLocale = AppStrings.normalizeLocale(locale);
    final db = LocalDatabaseService();
    await db.settings.put('language', normalizedLocale.languageCode);
    state = normalizedLocale;
  }

  Locale? _parseLocale(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    final normalizedRaw = rawValue.trim().toLowerCase().replaceAll('-', '_');
    final languageCode = normalizedRaw.split('_').first;
    if (languageCode == 'it') {
      return const Locale('it');
    }
    if (languageCode == 'en') {
      return const Locale('en');
    }
    return null;
  }
}

// ─── Local AI Settings ───────────────────────────────────────────────────────

class LocalAiSettings {
  const LocalAiSettings({
    this.enabled = false,
    this.model = LocalAiModel.good,
    this.hfToken,
  });

  final bool enabled;
  final LocalAiModel model;
  final String? hfToken;

  LocalAiSettings copyWith({
    bool? enabled,
    LocalAiModel? model,
    String? hfToken,
    bool clearHfToken = false,
  }) {
    return LocalAiSettings(
      enabled: enabled ?? this.enabled,
      model: model ?? this.model,
      hfToken: clearHfToken ? null : (hfToken ?? this.hfToken),
    );
  }
}

class LocalAiSettingsNotifier extends Notifier<LocalAiSettings> {
  @override
  LocalAiSettings build() {
    final db = LocalDatabaseService();
    final enabled =
        db.settings.get('local_ai_enabled', defaultValue: false) as bool;
    final modelStr = db.settings.get('local_ai_model') as String?;
    final hfToken = db.settings.get('local_ai_hf_token') as String?;
    final model = modelStr != null
        ? LocalAiModel.values.firstWhere(
            (e) => e.name == modelStr,
            orElse: () => LocalAiModel.good,
          )
        : LocalAiModel.good;
    return LocalAiSettings(enabled: enabled, model: model, hfToken: hfToken);
  }

  Future<void> setEnabled(bool v) async {
    await LocalDatabaseService().settings.put('local_ai_enabled', v);
    state = state.copyWith(enabled: v);
  }

  Future<void> setModel(LocalAiModel m) async {
    await LocalDatabaseService().settings.put('local_ai_model', m.name);
    state = state.copyWith(model: m);
  }

  Future<void> setHfToken(String? token) async {
    final trimmed = token?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      await LocalDatabaseService().settings.delete('local_ai_hf_token');
      state = state.copyWith(clearHfToken: true);
    } else {
      await LocalDatabaseService().settings.put('local_ai_hf_token', trimmed);
      state = state.copyWith(hfToken: trimmed);
    }
  }
}

final localAiSettingsProvider =
    NotifierProvider<LocalAiSettingsNotifier, LocalAiSettings>(
  LocalAiSettingsNotifier.new,
);
