import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// I flag di build della app.
///
/// `docs/development/17-config-and-flags.md`. Un flag qui è una **decisione
/// di build**, non una preferenza dell'utente: le preferenze vivono in
/// `SharedPreferencesAsync` e cambiano a runtime.
///
/// Regola che questo file esiste per rendere possibile: nessuna feature legge
/// `String.fromEnvironment` per conto proprio. Un flag letto in due punti è un
/// flag che prima o poi vale due cose diverse.
enum FeatureFlag {
  /// Sottosistema vocale dell'allenamento attivo (`23-voice.md`).
  voiceLogging('VOICE_LOGGING', defaultValue: true),

  /// Schermata diagnostica interna (`18-observability.md`).
  ///
  /// In debug è sempre accesa: in un'app local-first i bug vivono nel
  /// database e nella coda sul telefono, dove nessun crash reporter arriva.
  debugScreen('DEBUG_SCREEN', defaultValue: kDebugMode),

  /// Tour guidato al primo avvio.
  guidedTour('GUIDED_TOUR', defaultValue: true);

  const FeatureFlag(this.wireName, {required this.defaultValue});

  /// Nome accettato da `--dart-define=<wireName>=true|false`.
  final String wireName;

  final bool defaultValue;
}

/// Risoluzione dei flag.
///
/// `const` non ammette una lettura dinamica di `bool.fromEnvironment`, quindi
/// i valori sono dichiarati una volta qui e la mappa li indicizza. È verboso
/// di proposito: il compilatore deve poterli eliminare a tree-shaking.
abstract final class FeatureFlags {
  static const _voiceLogging = bool.fromEnvironment(
    'VOICE_LOGGING',
    defaultValue: true,
  );
  static const _debugScreen = bool.fromEnvironment(
    'DEBUG_SCREEN',
    defaultValue: kDebugMode,
  );
  static const _guidedTour = bool.fromEnvironment(
    'GUIDED_TOUR',
    defaultValue: true,
  );

  static bool isEnabled(FeatureFlag flag) => switch (flag) {
    FeatureFlag.voiceLogging => _voiceLogging,
    FeatureFlag.debugScreen => _debugScreen,
    FeatureFlag.guidedTour => _guidedTour,
  };

  /// Stato di tutti i flag, per la debug screen.
  static Map<String, bool> get snapshot => {
    for (final flag in FeatureFlag.values) flag.wireName: isEnabled(flag),
  };
}

/// `keepAlive`: i flag sono costanti di build, non hanno ciclo di vita.
final featureFlagsProvider = Provider<bool Function(FeatureFlag)>(
  (ref) => FeatureFlags.isEnabled,
);
