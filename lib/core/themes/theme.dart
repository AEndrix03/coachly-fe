import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/design_system/tokens/coachly_palette.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppThemeScheme {
  static const FlexSchemeColor customScheme = FlexSchemeColor(
    primary: CoachlyPalette.teal400,
    primaryContainer: CoachlyPalette.teal900,
    secondary: CoachlyPalette.blue300,
    secondaryContainer: CoachlyPalette.blue900,
    tertiary: CoachlyPalette.amber400,
    tertiaryContainer: CoachlyPalette.amber900,
    appBarColor: CoachlyPalette.ink900,
    error: CoachlyPalette.red400,
  );

  static ThemeData lightTheme = FlexThemeData.light(
    colors: customScheme,
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
    blendLevel: 12,
    appBarStyle: FlexAppBarStyle.primary,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: true,
      defaultRadius: 12,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  ).copyWith(extensions: const [CoachlyThemeData.dark]);

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: customScheme,
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
    blendLevel: 20,
    appBarStyle: FlexAppBarStyle.primary,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendOnColors: true,
      defaultRadius: 12,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  ).copyWith(extensions: const [CoachlyThemeData.dark]);
}
