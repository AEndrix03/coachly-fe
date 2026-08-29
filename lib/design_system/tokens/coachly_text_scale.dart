import 'package:flutter/widgets.dart';

/// La scala tipografica **che la app ha davvero**, ricavata dai suoi 186
/// `TextStyle` letterali.
///
/// ## Perché esiste, accanto a `CoachlyTypography`
///
/// `CoachlyTypography` descrive la scala per ruolo semantico che
/// `docs/development/09-design-tokens.md` vuole. È la destinazione. Ma non può
/// assorbire il codice esistente senza spostare pixel, e il motivo è
/// misurabile:
///
/// - l'**87%** dei letterali non imposta `height`, mentre ogni token semantico
///   lo impone: adottarli cambierebbe l'interlinea di quasi ogni riga;
/// - il **31%** non imposta nemmeno `fontWeight` — eredita quello del
///   contesto — mentre ogni token semantico lo fissa.
///
/// Questa scala è l'altra metà. È organizzata su due livelli, e la divisione
/// è il punto di tutto il file:
///
/// - **8 ruoli principali** — `micro` 10, `caption` 12, `body` 15,
///   `subtitle` 17, `title` 19, `headline` 22, `display` 24, `displayL` 29.
///   Sono le mode dei gruppi, non numeri scelti: `caption` è 12 perché 88
///   occorrenze su 186 stanno fra 11 e 13, e 12 è la più frequente.
/// - **12 gradini intermedi** — le altre dimensioni realmente in uso, ognuna
///   con il suo valore esatto.
///
/// Perché due livelli invece di otto ruoli e basta: perché fondere 11, 12 e 13
/// in un solo `caption` **sposta** 46 testi di 1px. È stato misurato, non
/// stimato: la variante fusa fa fallire i quattro golden di workout detail dal
/// 2,7% al 17,9% di pixel diversi. La variante a due livelli li lascia
/// identici byte per byte.
///
/// Un pixel-diff non è un degrado — è quasi tutto riflusso verticale — ma è
/// comunque una decisione di design, e una decisione di design non la prende
/// un codemod mentre fa pulizia.
///
/// Così i due lavori restano separati: togliere i letterali è meccanico e
/// gratuito, stringere la scala è deliberato e misurabile.
///
/// ## Il peso è un modificatore, non un ruolo
///
/// La stessa dimensione compare con quattro pesi diversi. Nominarli tutti
/// darebbe 30 token; qui il peso si compone:
///
/// ```dart
/// context.scale.caption              // 12, peso ereditato
/// context.scale.caption.semibold     // 12 / w600
/// context.scale.body.bold            // 15 / w700
/// ```
///
/// Un ruolo senza modificatore **non fissa il peso**: è il comportamento dei
/// 58 letterali che oggi scrivono solo `fontSize`, e cambiarlo li muoverebbe.
///
/// ## Quando questo file va cancellato
///
/// Quando la scala semantica di `CoachlyTypography` sarà adottata davvero,
/// schermata per schermata. Questo è il livello di alias previsto dalla fase
/// 5.1 del piano di migrazione, e la 5.10 lo rimuove. Non è una seconda
/// tecnologia per la stessa responsabilità: è la stessa scala, misurata
/// invece che desiderata, e ha una condizione di uscita scritta.
@immutable
class CoachlyTextScale {
  const CoachlyTextScale({
    required this.micro,
    required this.caption,
    required this.body,
    required this.subtitle,
    required this.title,
    required this.headline,
    required this.display,
    required this.displayL,
    required this.microTight,
    required this.captionTight,
    required this.captionLoose,
    required this.bodyTight,
    required this.bodyLoose,
    required this.subtitleLoose,
    required this.titleLoose,
    required this.headlineTight,
    required this.displayLoose,
    required this.displayLTight,
    required this.displayLLoose,
    required this.hero,
  });

  /// 10 — etichette minime, badge, unità di misura.
  final TextStyle micro;

  /// 12 — la dimensione più usata della app: label, metadati, didascalie.
  final TextStyle caption;

  /// 15 — testo di lettura.
  final TextStyle body;

  /// 17 — titoli di sezione dentro una schermata.
  final TextStyle subtitle;

  /// 19 — titoli di schermata.
  final TextStyle title;

  /// 22 — titoli di apertura.
  final TextStyle headline;

  /// 24 — numeri e titoli che devono leggersi da lontano.
  final TextStyle display;

  /// 29 — la cifra grande di una sessione attiva.
  final TextStyle displayL;

  // --- Gradini intermedi -----------------------------------------------
  //
  // La app usa 20 dimensioni distinte; gli 8 ruoli sopra ne coprono 8. Questi
  // alias coprono le altre 12, ognuno **con la dimensione esatta che il
  // codice ha oggi**, cosi' che la conversione dei letterali non sposti
  // nemmeno un pixel.
  //
  // Sono il manico della migrazione: unire due gradini non significa toccare
  // i call site, significa cambiare una riga qui. Per esempio
  //
  //     captionTight: TextStyle(fontSize: 11),   // oggi
  //     captionTight: caption,                   // dopo la fusione
  //
  // e i golden dicono subito quanto e' costato. E' la ragione per cui la
  // decisione di design resta separata dalla rimozione dei letterali.

  /// 9 — usata 3 volte. Candidata a fondersi in [micro].
  final TextStyle microTight;

  /// 11 — usata 19 volte. Candidata a fondersi in [caption].
  final TextStyle captionTight;

  /// 13 — usata 27 volte. Candidata a fondersi in [caption].
  final TextStyle captionLoose;

  /// 14 — usata 15 volte. Candidata a fondersi in [body].
  final TextStyle bodyTight;

  /// 16 — usata 12 volte. Candidata a fondersi in [body].
  final TextStyle bodyLoose;

  /// 18 — usata 3 volte. Candidata a fondersi in [subtitle].
  final TextStyle subtitleLoose;

  /// 20 — usata 6 volte. Candidata a fondersi in [title].
  final TextStyle titleLoose;

  /// 21 — usata 1 volta. Candidata a fondersi in [headline].
  final TextStyle headlineTight;

  /// 26 — usata 1 volta.
  final TextStyle displayLoose;

  /// 28 — usata 1 volta. Candidata a fondersi in [displayL].
  final TextStyle displayLTight;

  /// 30 — usata 1 volta. Candidata a fondersi in [displayL].
  final TextStyle displayLLoose;

  /// 32 — la cifra piu' grande della app, in un punto solo.
  final TextStyle hero;

  static const standard = CoachlyTextScale(
    micro: TextStyle(fontSize: 10),
    caption: TextStyle(fontSize: 12),
    body: TextStyle(fontSize: 15),
    subtitle: TextStyle(fontSize: 17),
    title: TextStyle(fontSize: 19),
    headline: TextStyle(fontSize: 22),
    display: TextStyle(fontSize: 24),
    displayL: TextStyle(fontSize: 29),
    microTight: TextStyle(fontSize: 9),
    captionTight: TextStyle(fontSize: 11),
    captionLoose: TextStyle(fontSize: 13),
    bodyTight: TextStyle(fontSize: 14),
    bodyLoose: TextStyle(fontSize: 16),
    subtitleLoose: TextStyle(fontSize: 18),
    titleLoose: TextStyle(fontSize: 20),
    headlineTight: TextStyle(fontSize: 21),
    displayLoose: TextStyle(fontSize: 26),
    displayLTight: TextStyle(fontSize: 28),
    displayLLoose: TextStyle(fontSize: 30),
    hero: TextStyle(fontSize: 32),
  );

  CoachlyTextScale lerp(CoachlyTextScale other, double t) => CoachlyTextScale(
    micro: TextStyle.lerp(micro, other.micro, t)!,
    caption: TextStyle.lerp(caption, other.caption, t)!,
    body: TextStyle.lerp(body, other.body, t)!,
    subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
    title: TextStyle.lerp(title, other.title, t)!,
    headline: TextStyle.lerp(headline, other.headline, t)!,
    display: TextStyle.lerp(display, other.display, t)!,
    displayL: TextStyle.lerp(displayL, other.displayL, t)!,
    microTight: TextStyle.lerp(microTight, other.microTight, t)!,
    captionTight: TextStyle.lerp(captionTight, other.captionTight, t)!,
    captionLoose: TextStyle.lerp(captionLoose, other.captionLoose, t)!,
    bodyTight: TextStyle.lerp(bodyTight, other.bodyTight, t)!,
    bodyLoose: TextStyle.lerp(bodyLoose, other.bodyLoose, t)!,
    subtitleLoose: TextStyle.lerp(subtitleLoose, other.subtitleLoose, t)!,
    titleLoose: TextStyle.lerp(titleLoose, other.titleLoose, t)!,
    headlineTight: TextStyle.lerp(headlineTight, other.headlineTight, t)!,
    displayLoose: TextStyle.lerp(displayLoose, other.displayLoose, t)!,
    displayLTight: TextStyle.lerp(displayLTight, other.displayLTight, t)!,
    displayLLoose: TextStyle.lerp(displayLLoose, other.displayLLoose, t)!,
    hero: TextStyle.lerp(hero, other.hero, t)!,
  );
}

/// I pesi come modificatori componibili.
///
/// Nomi, non numeri: `w600` non dice niente sul perché, `semibold` almeno dice
/// che è un grado di enfasi.
extension CoachlyTextWeight on TextStyle {
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  TextStyle get heavy => copyWith(fontWeight: FontWeight.w800);

  TextStyle get black => copyWith(fontWeight: FontWeight.w900);
}
