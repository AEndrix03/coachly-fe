import 'package:coachly/design_system/tokens/coachly_palette.dart';
import 'package:flutter/material.dart';

/// **Deprecato.** Usare i token via `context.colors`, `context.spacing`,
/// `context.radii`, `context.motion` (`lib/design_system/`).
///
/// Resta come alias durante la migrazione (ADR-001, fase 5.1 di
/// `docs/development/26-migration-plan.md`): i valori **delegano alla palette**,
/// quindi non esiste più una seconda sorgente di verità sui colori. Verrà
/// rimosso quando i 18 file che lo usano saranno migrati.
abstract final class CoachlyAthleteTheme {
  static const background = CoachlyPalette.ink900;
  static const surface = CoachlyPalette.ink800;
  static const surfaceElevated = CoachlyPalette.ink700;
  static const primary = CoachlyPalette.teal400;
  static const textPrimary = CoachlyPalette.bone50;
  static const textSecondary = CoachlyPalette.sage400;
  static const danger = CoachlyPalette.red400;
  static const border = CoachlyPalette.whiteAlpha09;

  // Metriche: allineate a CoachlySpacing / CoachlyRadii / CoachlySizes.
  // Non possono delegare (i getter di istanza non sono espressioni costanti),
  // quindi i valori sono duplicati **volutamente identici**.
  static const pagePadding = EdgeInsets.symmetric(horizontal: 20);
  static const sectionGap = 28.0;
  static const cardRadius = 18.0;
  static const compactRadius = 10.0;
  static const actionRadius = 16.0;
  static const touchTarget = 48.0;
  static const primaryActionHeight = 56.0;
  static const cardPadding = 16.0;

  static const expandDuration = Duration(milliseconds: 200);
  static const pageDuration = Duration(milliseconds: 280);
  static const standardCurve = Curves.easeOutCubic;
}
