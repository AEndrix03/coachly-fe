import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppThemeScheme {
  static const FlexSchemeColor customScheme = FlexSchemeColor(
    primary: Color(0xFF2196F3),
    primaryContainer: Color(0xFF1976D2),
    secondary: Color(0xFF9C27B0),
    secondaryContainer: Color(0xFF7B4BC1),
    tertiary: Color(0xFFFF9800),
    tertiaryContainer: Color(0xFFFF5722),
    appBarColor: Color(0xFF0F0F1E),
    error: Color(0xFFFF5252),
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
  );

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
  );
}
