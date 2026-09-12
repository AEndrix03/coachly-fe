import 'package:flutter/widgets.dart';

/// Scala di spazio, base 4.
///
/// I valori includono quelli **già in uso** nel codice (20 per il padding di
/// pagina, 28 per lo stacco fra sezioni): la migrazione ai token deve essere
/// visivamente neutra, non un ridisegno mascherato.
///
/// Vedi `docs/development/09-design-tokens.md`.
@immutable
class CoachlySpacing {
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  const CoachlySpacing({
    this.xxs = 4,
    this.xs = 8,
    this.sm = 12,
    this.md = 16,
    this.lg = 20,
    this.xl = 24,
    this.xxl = 32,
    this.xxxl = 48,
  });

  static const standard = CoachlySpacing();

  /// Margine orizzontale di pagina.
  double get pageHorizontal => lg;

  /// Stacco verticale fra sezioni di una pagina.
  double get section => 28;

  /// Padding interno di una card.
  double get card => md;

  EdgeInsets get pagePadding =>
      EdgeInsets.symmetric(horizontal: pageHorizontal);

  EdgeInsets get cardPadding => EdgeInsets.all(card);
}

/// Raggi di arrotondamento.
@immutable
class CoachlyRadii {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double pill;

  const CoachlyRadii({
    this.xs = 8,
    this.sm = 10,
    this.md = 12,
    this.lg = 16,
    this.xl = 18,
    this.xxl = 24,
    this.pill = 999,
  });

  static const standard = CoachlyRadii();

  /// Raggio di una card. Corrisponde a `CoachlyAthleteTheme.cardRadius`.
  double get card => xl;

  /// Raggio di un controllo compatto.
  double get compact => sm;

  /// Raggio di un'azione primaria.
  double get action => lg;

  /// Raggio delle azioni di accesso: piu' morbido dell'azione comune, perche'
  /// sono grandi e isolate sopra una fotografia.
  double get authAction => 20;

  BorderRadius get cardBorder => BorderRadius.circular(card);

  BorderRadius get actionBorder => BorderRadius.circular(action);

  BorderRadius get authActionBorder => BorderRadius.circular(authAction);
}

/// Dimensioni dei controlli.
///
/// `touchTarget` è il minimo di accessibilità (`docs/development/14-accessibility.md`);
/// `touchTargetWorkout` si applica ai controlli usati durante l'allenamento,
/// con le mani sudate e senza guardare.
@immutable
class CoachlySizes {
  final double touchTarget;
  final double touchTargetWorkout;
  final double primaryActionHeight;
  final double iconXs;
  final double iconSm;
  final double iconMd;
  final double iconLg;
  final double iconXl;

  /// Logo animato della schermata di accesso e spazio che gli serve intorno.
  ///
  /// `authLogo` è il diametro visivo del logo; `authLogoStage` è l'altezza
  /// del palco in cui salta e ruota; `authLogoGlow` è il diametro del bagliore
  /// che gli sta dietro.
  /// Altezza delle azioni di accesso: piu' alte di un'azione comune perche'
  /// sono il solo bersaglio della schermata.
  final double authAction;
  final double authLogo;
  final double authLogoStage;
  final double authLogoGlow;

  /// Quanto il marchio 3D scende rispetto al resto del blocco: il modello e'
  /// montato alto nel file, e questo lo riporta a fuoco ottico con il titolo.
  /// E' uno stacco sopra al palco, non una traslazione dentro il viewer: il
  /// viewer ritaglia tutto cio' che esce dal suo riquadro.
  final double authLogoDrop;

  /// Altezza del titolo illustrato sotto il logo (immagine con proporzione 3:1).
  final double authTitle;

  const CoachlySizes({
    this.touchTarget = 48,
    this.touchTargetWorkout = 56,
    this.primaryActionHeight = 56,
    this.iconXs = 16,
    this.iconSm = 20,
    this.iconMd = 24,
    this.iconLg = 32,
    this.iconXl = 48,
    this.authAction = 64,
    this.authLogo = 135,
    this.authLogoStage = 176,
    this.authLogoGlow = 104,
    this.authLogoDrop = 16,
    this.authTitle = 108,
  });

  static const standard = CoachlySizes();
}

/// Durate e curve.
///
/// Vedi `docs/development/11-motion.md`. L'uscita è sempre più rapida
/// dell'entrata: chiudere deve sembrare immediato.
@immutable
class CoachlyMotion {
  final Duration instant;
  final Duration quick;
  final Duration standard;
  final Duration slow;
  final Duration deliberate;
  final Duration confirmHold;

  /// Periodo di un respiro ambientale (bagliori, elementi decorativi a
  /// riposo). Lento abbastanza da non attirare l'occhio.
  final Duration ambient;

  /// Quanto si aspetta prima di ammettere che si sta caricando.
  ///
  /// Sotto questa soglia un indicatore fa piu' danno che informazione: appare
  /// e sparisce, e l'occhio legge il lampo come un errore. In una app
  /// local-first la maggior parte delle letture finisce prima
  /// (`docs/development/04-local-first.md`), quindi nel caso normale un
  /// indicatore non deve proprio comparire.
  final Duration loadingDelay;

  /// Quanto resta visibile, una volta comparso.
  ///
  /// Senza questo, un'attesa di 310 ms mostrerebbe l'indicatore per 10 ms:
  /// il lampo che `loadingDelay` serviva a evitare, spostato piu' in la'.
  final Duration loadingMinimum;

  final Curve enter;
  final Curve exit;
  final Curve standardCurve;
  final Curve emphasized;

  const CoachlyMotion({
    this.instant = const Duration(milliseconds: 90),
    this.quick = const Duration(milliseconds: 160),
    this.standard = const Duration(milliseconds: 200),
    this.slow = const Duration(milliseconds: 280),
    this.deliberate = const Duration(milliseconds: 500),
    this.confirmHold = const Duration(seconds: 2),
    this.ambient = const Duration(milliseconds: 2800),
    this.loadingDelay = const Duration(milliseconds: 300),
    this.loadingMinimum = const Duration(milliseconds: 450),
    this.enter = Curves.easeOutCubic,
    this.exit = Curves.easeInCubic,
    this.standardCurve = Curves.easeOutCubic,
    this.emphasized = Curves.easeOutBack,
  });

  static const defaults = CoachlyMotion();

  /// Durata effettiva, che rispetta la preferenza di sistema "riduci
  /// animazioni". Da usare **sempre** al posto della durata grezza.
  Duration resolve(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
