import 'package:coachly/design_system/tokens/coachly_colors.dart';
import 'package:coachly/design_system/tokens/coachly_metrics.dart';
import 'package:coachly/design_system/tokens/coachly_typography.dart';
import 'package:flutter/material.dart';

/// I token Coachly agganciati a `ThemeData`.
///
/// Unico punto di accesso dal codice di prodotto:
///
/// ```dart
/// context.colors.textPrimary
/// context.spacing.md
/// context.radii.card
/// context.text.titleM
/// context.motion.standard
/// ```
///
/// Vedi `docs/development/09-design-tokens.md`.
@immutable
class CoachlyThemeData extends ThemeExtension<CoachlyThemeData> {
  final CoachlyColors colors;
  final CoachlySpacing spacing;
  final CoachlyRadii radii;
  final CoachlySizes sizes;
  final CoachlyMotion motion;
  final CoachlyTypography typography;

  const CoachlyThemeData({
    required this.colors,
    required this.spacing,
    required this.radii,
    required this.sizes,
    required this.motion,
    required this.typography,
  });

  static const dark = CoachlyThemeData(
    colors: CoachlyColors.dark,
    spacing: CoachlySpacing.standard,
    radii: CoachlyRadii.standard,
    sizes: CoachlySizes.standard,
    motion: CoachlyMotion.defaults,
    typography: CoachlyTypography.standard,
  );

  @override
  CoachlyThemeData copyWith({
    CoachlyColors? colors,
    CoachlySpacing? spacing,
    CoachlyRadii? radii,
    CoachlySizes? sizes,
    CoachlyMotion? motion,
    CoachlyTypography? typography,
  }) {
    return CoachlyThemeData(
      colors: colors ?? this.colors,
      spacing: spacing ?? this.spacing,
      radii: radii ?? this.radii,
      sizes: sizes ?? this.sizes,
      motion: motion ?? this.motion,
      typography: typography ?? this.typography,
    );
  }

  @override
  CoachlyThemeData lerp(
    covariant ThemeExtension<CoachlyThemeData>? other,
    double t,
  ) {
    if (other is! CoachlyThemeData) return this;
    return CoachlyThemeData(
      colors: colors.lerp(other.colors, t),
      // Spazi, raggi e dimensioni non si interpolano: un layout che cambia
      // misura durante una transizione di tema produce solo scatti.
      spacing: other.spacing,
      radii: other.radii,
      sizes: other.sizes,
      motion: other.motion,
      typography: typography.lerp(other.typography, t),
    );
  }
}

extension CoachlyThemeContext on BuildContext {
  CoachlyThemeData get coachly =>
      Theme.of(this).extension<CoachlyThemeData>() ?? CoachlyThemeData.dark;

  CoachlyColors get colors => coachly.colors;

  CoachlySpacing get spacing => coachly.spacing;

  CoachlyRadii get radii => coachly.radii;

  CoachlySizes get sizes => coachly.sizes;

  CoachlyMotion get motion => coachly.motion;

  CoachlyTypography get text => coachly.typography;
}
