// L'attesa, come componente unico.
//
// Prima di questo file la app aveva tredici `CircularProgressIndicator`
// scritti a mano in tredici schermate, ciascuno con la sua dimensione, il suo
// colore e la sua idea di quando comparire. Non e' un problema estetico: e'
// che **nessuno di quei tredici sapeva di essere in una app local-first**.
//
// In Coachly la lettura normale viene da Drift e finisce in pochi
// millisecondi (`docs/development/04-data-layer.md`). Un indicatore che
// compare appena parte un `Future` lampeggia: appare e sparisce prima che
// l'occhio lo metta a fuoco, e un lampo non si legge come «sto caricando», si
// legge come «e' successo qualcosa». Il caricamento vero — la prima
// idratazione, un catalogo che non c'e' ancora — e' l'eccezione, ed e' lui a
// meritare un'immagine.
//
// Da qui le due soglie, che sono la parte importante di questo file:
//
// - **non comparire** per i primi `loadingDelay` (300 ms): sotto quella
//   soglia il dato e' gia' arrivato e l'indicatore sarebbe solo rumore;
// - **una volta comparso, restare** almeno `loadingMinimum` (450 ms): senza,
//   un'attesa di 310 ms mostrerebbe l'immagine per 10 ms, che e' lo stesso
//   lampo spostato piu' in la'.
//
// Vedi `docs/development/27-loading.md`.

import 'dart:async';

import 'package:coachly/core/assets/app_assets.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

/// Una delle illustrazioni condivise dell'attesa.
///
/// Sono poche e stanno in un elenco solo, per la ragione per cui esistono i
/// token: se ogni schermata sceglie la propria immagine, dopo sei mesi la app
/// ha sei attese che sembrano sei app.
@immutable
class CoachlyLoadingScene {
  const CoachlyLoadingScene({required this.asset, required this.width});

  /// Percorso da `AppAssets`, mai una stringa scritta a mano
  /// (`docs/development/16-media.md`).
  final String asset;

  /// Larghezza a cui l'illustrazione e' disegnata.
  final double width;
}

/// Il repertorio condiviso.
///
/// Oggi ha una voce sola — il marchio, che e' gia' quello che la schermata di
/// avvio mostra. Aggiungerne e' aggiungere righe qui, e **nient'altro**:
/// nessuna schermata nomina un asset, quindi nessuna schermata va toccata.
abstract final class CoachlyLoadingScenes {
  const CoachlyLoadingScenes._();

  static const List<CoachlyLoadingScene> all = <CoachlyLoadingScene>[
    CoachlyLoadingScene(asset: AppAssets.logoDark, width: 96),
  ];

  /// La scena per una certa attesa, scelta in modo **deterministico**.
  ///
  /// Deterministico e non casuale: un widget si ricostruisce molte volte
  /// durante la stessa attesa, e con una scelta casuale l'immagine cambierebbe
  /// a ogni frame. La stessa chiave da' sempre la stessa scena; chiavi diverse
  /// distribuiscono le scene sul repertorio.
  static CoachlyLoadingScene forKey(String key) {
    if (all.length == 1) return all.first;
    var hash = 0;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return all[hash % all.length];
  }

  /// Decodifica le illustrazioni prima che servano.
  ///
  /// Un'immagine caricata nel momento in cui si deve mostrare l'attesa arriva
  /// *dopo* l'attesa che doveva coprire. Va chiamata una volta all'avvio, con
  /// un context che ha gia' `Directionality` e `MediaQuery`.
  static Future<void> precache(BuildContext context) => Future.wait([
    for (final scene in all) precacheImage(AssetImage(scene.asset), context),
  ]);
}

/// L'attesa a schermo intero: avvio, o una rotta che non ha ancora niente da
/// disegnare.
class CoachlyLoadingScreen extends StatelessWidget {
  const CoachlyLoadingScreen({
    super.key,
    this.sceneKey = 'app',
    this.message,
    this.background,
    this.headline,
  });

  final String sceneKey;
  final String? message;

  /// Sfondo opzionale disegnato sotto la scena. Esiste per l'avvio, che ha
  /// una sua identita' visiva; le attese dentro la app non lo usano.
  final Widget? background;

  /// Riga opzionale fra la scena e il messaggio (il nome della app all'avvio).
  final Widget? headline;

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: Center(
        child: _LoadingBody(
          scene: CoachlyLoadingScenes.forKey(sceneKey),
          message: message,
          headline: headline,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: background == null
          ? body
          : Stack(fit: StackFit.expand, children: [background!, body]),
    );
  }
}

/// L'attesa di una porzione di schermata, quando il resto della pagina esiste
/// gia' ed e' utile.
class CoachlyLoadingSection extends StatelessWidget {
  const CoachlyLoadingSection({
    super.key,
    this.sceneKey = 'section',
    this.message,
    this.minHeight = 160,
  });

  final String sceneKey;
  final String? message;
  final double minHeight;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(minHeight: minHeight),
    child: Center(
      child: _LoadingBody(
        scene: CoachlyLoadingScenes.forKey(sceneKey),
        message: message,
        compact: true,
      ),
    ),
  );
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({
    required this.scene,
    this.message,
    this.headline,
    this.compact = false,
  });

  final CoachlyLoadingScene scene;
  final String? message;
  final Widget? headline;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = message ?? context.l10n.commonLoading;
    return Semantics(
      // `liveRegion`: il lettore di schermo annuncia l'attesa quando compare,
      // senza che l'utente debba andarla a cercare
      // (`docs/development/14-accessibility.md`).
      liveRegion: true,
      label: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: _BreathingScene(scene: scene, compact: compact),
          ),
          if (headline != null) ...[
            SizedBox(height: context.spacing.md),
            ExcludeSemantics(child: headline!),
          ],
          SizedBox(height: context.spacing.md),
          ExcludeSemantics(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

/// L'illustrazione che respira.
///
/// Un'opacita' che pulsa lentamente, non una rotazione: la rotazione dice
/// «sto lavorando su qualcosa di lungo», che qui e' quasi sempre falso.
/// Con «riduci animazioni» attivo l'immagine sta ferma e piena, e resta
/// leggibile: l'animazione e' un ornamento, l'informazione e' l'immagine.
class _BreathingScene extends StatefulWidget {
  const _BreathingScene({required this.scene, required this.compact});

  final CoachlyLoadingScene scene;
  final bool compact;

  @override
  State<_BreathingScene> createState() => _BreathingSceneState();
}

class _BreathingSceneState extends State<_BreathingScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.compact ? widget.scene.width * .6 : widget.scene.width;
    return FadeTransition(
      opacity: Tween<double>(
        begin: .45,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Image.asset(widget.scene.asset, width: width),
    );
  }
}

/// Il cancello che decide **se** l'attesa si vede.
///
/// Avvolge il contenuto: finche' [isLoading] e' vero da meno di
/// `loadingDelay` non mostra niente e lascia [child] al suo posto; quando
/// scatta mostra [loading] e lo tiene per almeno `loadingMinimum`.
///
/// Non e' una comodita': e' il punto in cui la regola vive una volta sola. Le
/// stesse due soglie replicate in tredici schermate divergono al primo che ha
/// fretta.
class CoachlyLoadingGate extends StatefulWidget {
  const CoachlyLoadingGate({
    super.key,
    required this.isLoading,
    required this.loading,
    required this.child,
  });

  final bool isLoading;

  /// Cosa mostrare quando l'attesa ha superato la soglia.
  final Widget loading;

  /// Cosa mostrare altrimenti — di norma il contenuto vero, o il contenuto
  /// precedente ancora valido.
  final Widget child;

  @override
  State<CoachlyLoadingGate> createState() => _CoachlyLoadingGateState();
}

class _CoachlyLoadingGateState extends State<CoachlyLoadingGate> {
  bool _visible = false;
  bool _holding = false;
  Timer? _appear;
  Timer? _hold;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isLoading && !_visible && _appear == null) _scheduleAppear();
  }

  @override
  void didUpdateWidget(CoachlyLoadingGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading == oldWidget.isLoading) return;
    if (widget.isLoading) {
      _scheduleAppear();
      return;
    }
    _appear?.cancel();
    _appear = null;
    // Se la permanenza minima e' ancora in corso, sparisce alla sua fine.
    if (_visible && !_holding) setState(() => _visible = false);
  }

  void _scheduleAppear() {
    _appear?.cancel();
    _appear = Timer(context.motion.loadingDelay, () {
      if (!mounted || !widget.isLoading) return;
      setState(() {
        _visible = true;
        _holding = true;
      });
      _hold = Timer(context.motion.loadingMinimum, () {
        if (!mounted) return;
        _holding = false;
        if (!widget.isLoading) setState(() => _visible = false);
      });
    });
  }

  @override
  void dispose() {
    _appear?.cancel();
    _hold?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _visible ? widget.loading : widget.child;
}
