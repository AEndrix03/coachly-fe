import 'package:coachly/design_system/tokens/coachly_palette.dart';
import 'package:flutter/material.dart';

/// **Deprecato.** Usare i token via `context.colors` (`lib/design_system/`).
///
/// Resta come alias durante la migrazione (ADR-001): i valori **delegano alla
/// palette**, quindi la sorgente di verità sui colori è una sola. Verrà rimosso
/// quando i 21 file che lo usano saranno migrati.
@immutable
class CoachlyExerciseTheme extends ThemeExtension<CoachlyExerciseTheme> {
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color primary;
  final Color primaryMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color warning;
  final Color info;

  const CoachlyExerciseTheme({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.primary,
    required this.primaryMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.warning,
    required this.info,
  });

  static const dark = CoachlyExerciseTheme(
    background: CoachlyPalette.ink900,
    surface: CoachlyPalette.ink800,
    surfaceElevated: CoachlyPalette.ink700,
    primary: CoachlyPalette.teal400,
    primaryMuted: CoachlyPalette.teal900,
    textPrimary: CoachlyPalette.bone50,
    textSecondary: CoachlyPalette.sage400,
    border: CoachlyPalette.whiteAlpha09,
    warning: CoachlyPalette.amber400,
    info: CoachlyPalette.blue300,
  );

  @override
  CoachlyExerciseTheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? primary,
    Color? primaryMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? warning,
    Color? info,
  }) {
    return CoachlyExerciseTheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      primary: primary ?? this.primary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  CoachlyExerciseTheme lerp(
    covariant ThemeExtension<CoachlyExerciseTheme>? other,
    double t,
  ) {
    if (other is! CoachlyExerciseTheme) return this;
    return CoachlyExerciseTheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

extension ExerciseThemeContext on BuildContext {
  CoachlyExerciseTheme get exerciseTheme =>
      Theme.of(this).extension<CoachlyExerciseTheme>() ??
      CoachlyExerciseTheme.dark;
}

ThemeData exerciseDetailTheme(ThemeData base) {
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: CoachlyExerciseTheme.dark.primary,
      onPrimary: CoachlyExerciseTheme.dark.background,
      surface: CoachlyExerciseTheme.dark.surface,
      onSurface: CoachlyExerciseTheme.dark.textPrimary,
      outline: CoachlyExerciseTheme.dark.border,
      error: CoachlyExerciseTheme.dark.warning,
    ),
    scaffoldBackgroundColor: CoachlyExerciseTheme.dark.background,
    // Keep this list concretely typed. Some Flutter/Dart combinations infer
    // the recursively bounded ThemeExtension<dynamic> spread incorrectly.
    extensions: const [CoachlyExerciseTheme.dark],
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: CoachlyPalette.teal400,
    ),
  );
}
