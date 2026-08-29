import 'package:coachly/design_system/tokens/coachly_palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Ruoli semantici di colore. **È l'unico vocabolario ammesso nel codice di
/// prodotto.**
///
/// Vedi `docs/development/09-design-tokens.md`. Ogni superficie dichiara
/// insieme il proprio contenuto in contrasto, così chi usa un token non deve
/// scegliere la coppia.
@immutable
class CoachlyColors {
  // ── Superfici ─────────────────────────────────────────────────────────────
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceSunken;
  final Color surfaceOverlay;
  final Color surfaceAccent;
  final Color surfaceAccentMuted;

  // ── Contenuto ─────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color textOnAccent;

  // ── Bordi ─────────────────────────────────────────────────────────────────
  final Color border;
  final Color borderSubtle;

  // ── Feedback ──────────────────────────────────────────────────────────────
  final Color feedbackSuccess;
  final Color feedbackWarning;
  final Color feedbackDanger;
  final Color feedbackInfo;

  const CoachlyColors({
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceSunken,
    required this.surfaceOverlay,
    required this.surfaceAccent,
    required this.surfaceAccentMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnAccent,
    required this.border,
    required this.borderSubtle,
    required this.feedbackSuccess,
    required this.feedbackWarning,
    required this.feedbackDanger,
    required this.feedbackInfo,
  });

  /// Coachly è dark-first: è l'unico schema completo.
  /// Il tema chiaro si aggiunge quando i ruoli sono stabili (ADR-001).
  static const dark = CoachlyColors(
    surface: CoachlyPalette.ink900,
    surfaceElevated: CoachlyPalette.ink800,
    surfaceSunken: CoachlyPalette.ink700,
    surfaceOverlay: CoachlyPalette.ink800,
    surfaceAccent: CoachlyPalette.teal400,
    surfaceAccentMuted: CoachlyPalette.teal900,
    textPrimary: CoachlyPalette.bone50,
    textSecondary: CoachlyPalette.sage400,
    textDisabled: CoachlyPalette.sage600,
    textOnAccent: CoachlyPalette.ink900,
    border: CoachlyPalette.whiteAlpha09,
    borderSubtle: CoachlyPalette.whiteAlpha04,
    feedbackSuccess: CoachlyPalette.green400,
    feedbackWarning: CoachlyPalette.amber400,
    feedbackDanger: CoachlyPalette.red400,
    feedbackInfo: CoachlyPalette.blue300,
  );

  // ── Token di dominio ──────────────────────────────────────────────────────
  //
  // Concetti di prodotto Coachly. Sono la parte di valore del design system:
  // garantiscono che una serie di riscaldamento abbia lo stesso colore nel
  // logger, nel builder e nello storico.

  /// Serie di lavoro.
  Color get setWorking => surfaceAccent;

  /// Serie di riscaldamento.
  Color get setWarmup => feedbackInfo;

  /// Drop set.
  Color get setDrop => feedbackWarning;

  /// Serie portata a cedimento.
  Color get setFailure => feedbackDanger;

  /// Muscolo agonista.
  Color get musclePrimary => surfaceAccent;

  /// Muscolo sinergico.
  Color get muscleSecondary => surfaceAccentMuted;

  /// Muscolo stabilizzatore.
  Color get muscleStabilizer => textSecondary;

  Color get intensityLow => feedbackInfo;

  Color get intensityMid => feedbackWarning;

  Color get intensityHigh => feedbackDanger;

  /// Allenamento registrato ma non ancora inviato al backend.
  Color get syncPending => feedbackWarning;

  Color get syncSynced => feedbackSuccess;

  Color get syncOffline => textSecondary;

  /// Gradiente del completamento protetto: a riposo resta nel linguaggio
  /// acqua/smeraldo; l'ambra compare solo mentre il gesto è in corso.
  LinearGradient completeWorkoutGradient({
    required double phase,
    required bool active,
  }) => LinearGradient(
    begin: Alignment(-1.6 + phase * 1.8, -1),
    end: Alignment(.4 + phase * 1.8, 1),
    colors: active
        ? [surfaceAccent, feedbackSuccess, feedbackWarning, feedbackSuccess]
        : [surfaceAccent, feedbackSuccess, surfaceAccent],
    stops: active ? const [0, .34, .68, 1] : const [0, .52, 1],
  );

  CoachlyColors copyWith({
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceSunken,
    Color? surfaceOverlay,
    Color? surfaceAccent,
    Color? surfaceAccentMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? textOnAccent,
    Color? border,
    Color? borderSubtle,
    Color? feedbackSuccess,
    Color? feedbackWarning,
    Color? feedbackDanger,
    Color? feedbackInfo,
  }) {
    return CoachlyColors(
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      surfaceAccent: surfaceAccent ?? this.surfaceAccent,
      surfaceAccentMuted: surfaceAccentMuted ?? this.surfaceAccentMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      feedbackSuccess: feedbackSuccess ?? this.feedbackSuccess,
      feedbackWarning: feedbackWarning ?? this.feedbackWarning,
      feedbackDanger: feedbackDanger ?? this.feedbackDanger,
      feedbackInfo: feedbackInfo ?? this.feedbackInfo,
    );
  }

  CoachlyColors lerp(CoachlyColors other, double t) {
    return CoachlyColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      surfaceOverlay: Color.lerp(surfaceOverlay, other.surfaceOverlay, t)!,
      surfaceAccent: Color.lerp(surfaceAccent, other.surfaceAccent, t)!,
      surfaceAccentMuted: Color.lerp(
        surfaceAccentMuted,
        other.surfaceAccentMuted,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      feedbackSuccess: Color.lerp(feedbackSuccess, other.feedbackSuccess, t)!,
      feedbackWarning: Color.lerp(feedbackWarning, other.feedbackWarning, t)!,
      feedbackDanger: Color.lerp(feedbackDanger, other.feedbackDanger, t)!,
      feedbackInfo: Color.lerp(feedbackInfo, other.feedbackInfo, t)!,
    );
  }
}
