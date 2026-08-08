import 'package:flutter/material.dart';

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
    background: Color(0xFF07100F),
    surface: Color(0xFF0D1717),
    surfaceElevated: Color(0xFF12201F),
    primary: Color(0xFF20D3B0),
    primaryMuted: Color(0xFF284C47),
    textPrimary: Color(0xFFF4F8F7),
    textSecondary: Color(0xFFA6B6B3),
    border: Color(0x17FFFFFF),
    warning: Color(0xFFE6B75C),
    info: Color(0xFF77A9C9),
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
    scaffoldBackgroundColor: CoachlyExerciseTheme.dark.background,
    // Keep this list concretely typed. Some Flutter/Dart combinations infer
    // the recursively bounded ThemeExtension<dynamic> spread incorrectly.
    extensions: const [CoachlyExerciseTheme.dark],
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF20D3B0),
    ),
  );
}
