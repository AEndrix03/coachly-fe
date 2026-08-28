import 'package:flutter/painting.dart';

/// Primitivi di colore. **Non si usano mai fuori da `design_system/tokens/`.**
///
/// Una feature che scrive `_CoachlyPalette.teal400` viola questo documento
/// tanto quanto una che scrive `Color(0xFF20D3B0)`: nel codice di prodotto
/// esistono solo i ruoli semantici di `coachly_colors.dart`.
///
/// Vedi `docs/development/09-design-tokens.md`.
///
/// I valori sono derivati da `CoachlyAthleteTheme` e `CoachlyExerciseTheme`:
/// la migrazione ai token è **visivamente neutra** per costruzione.
abstract final class CoachlyPalette {
  // Fondali — verde-nero desaturato
  static const ink900 = Color(0xFF07100F);
  static const ink800 = Color(0xFF0D1717);
  static const ink700 = Color(0xFF12201F);

  // Accento di brand
  static const teal400 = Color(0xFF20D3B0);
  static const teal900 = Color(0xFF284C47);

  // Contenuto
  static const bone50 = Color(0xFFF4F8F7);
  static const sage400 = Color(0xFFA6B6B3);
  static const sage600 = Color(0xFF6B7C79);

  // Feedback
  static const green400 = Color(0xFF41D17E);
  static const amber400 = Color(0xFFE6B75C);
  static const red400 = Color(0xFFFF6B6B);
  static const blue300 = Color(0xFF77A9C9);
  static const blue900 = Color(0xFF1C3D4A);
  static const amber900 = Color(0xFF4B3A18);

  // Separatori: bianco a bassissima opacità, funziona su tutti i fondali
  static const whiteAlpha09 = Color(0x17FFFFFF);
  static const whiteAlpha04 = Color(0x0AFFFFFF);

  static const transparent = Color(0x00000000);
}
