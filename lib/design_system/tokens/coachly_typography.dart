import 'package:flutter/widgets.dart';

/// Scala tipografica per **ruolo semantico**, non per dimensione.
///
/// Vedi `docs/development/09-design-tokens.md`.
///
/// `displayL` e `displayM` esistono per un requisito di prodotto, non estetico:
/// durante un allenamento carico e timer devono essere leggibili a un metro di
/// distanza.
///
/// Gli stili **non portano colore**: quello lo mette chi li usa, con un token
/// di `CoachlyColors`. Così lo stesso stile funziona su fondali diversi.
@immutable
class CoachlyTypography {
  final TextStyle displayL;
  final TextStyle displayM;
  final TextStyle titleL;
  final TextStyle titleM;
  final TextStyle titleS;
  final TextStyle bodyL;
  final TextStyle bodyM;
  final TextStyle bodyS;
  final TextStyle label;
  final TextStyle labelStrong;
  final TextStyle mono;

  const CoachlyTypography({
    required this.displayL,
    required this.displayM,
    required this.titleL,
    required this.titleM,
    required this.titleS,
    required this.bodyL,
    required this.bodyM,
    required this.bodyS,
    required this.label,
    required this.labelStrong,
    required this.mono,
  });

  static const standard = CoachlyTypography(
    displayL: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, height: 1.05),
    displayM: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, height: 1.1),
    titleL: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.2),
    titleM: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.25),
    titleS: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
    bodyL: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.45),
    bodyM: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.45),
    bodyS: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
    label: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2),
    labelStrong: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.2,
      letterSpacing: 0.4,
    ),
    mono: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  CoachlyTypography lerp(CoachlyTypography other, double t) {
    return CoachlyTypography(
      displayL: TextStyle.lerp(displayL, other.displayL, t)!,
      displayM: TextStyle.lerp(displayM, other.displayM, t)!,
      titleL: TextStyle.lerp(titleL, other.titleL, t)!,
      titleM: TextStyle.lerp(titleM, other.titleM, t)!,
      titleS: TextStyle.lerp(titleS, other.titleS, t)!,
      bodyL: TextStyle.lerp(bodyL, other.bodyL, t)!,
      bodyM: TextStyle.lerp(bodyM, other.bodyM, t)!,
      bodyS: TextStyle.lerp(bodyS, other.bodyS, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      labelStrong: TextStyle.lerp(labelStrong, other.labelStrong, t)!,
      mono: TextStyle.lerp(mono, other.mono, t)!,
    );
  }
}
