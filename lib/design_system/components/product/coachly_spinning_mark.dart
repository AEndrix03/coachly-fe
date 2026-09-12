// Il marchio che gira, per le attese lunghe.
//
// `27-loading.md` dice che l'illustrazione dell'attesa **respira** invece di
// ruotare, perche' una rotazione afferma «sto lavorando su qualcosa di lungo»
// e in una app local-first quasi sempre non e' vero. Quella regola resta, e
// resta il comportamento di ogni attesa di sezione: questo componente e'
// l'eccezione dichiarata per l'attesa a schermo intero, dove l'affermazione e'
// vera — l'avvio, la prima idratazione, una rotta che non ha ancora nulla.
//
// Non usarlo per un'attesa che puo' finire in pochi millisecondi: li' il
// marchio statico e' la risposta giusta, ed e' quella che i componenti di
// sezione continuano a dare.

import 'package:coachly/core/assets/app_assets.dart';
import 'package:flutter/material.dart';
// Il widget pubblico del pacchetto non espone il JS della pagina, e la sua API
// costringe a pilotare la camera un frame alla volta dal lato Dart: un
// round-trip sul platform channel per frame. Il widget interno accetta CSS e JS
// propri, cosi' il moto gira dentro la WebView senza traffico
// Flutter → WebView. Versione bloccata in pubspec.
// ignore: implementation_imports
import 'package:flutter_3d_controller/src/core/modules/model_viewer/model_viewer.dart';

/// Il marchio tridimensionale che oscilla mentre si aspetta.
///
/// Il moto e' un pendolo sull'asse verticale: parte lento, accelera fino al
/// passaggio centrale, rallenta, inverte e rifa' lo stesso dall'altra parte.
/// Non e' un giro a velocita' costante, che leggerebbe come un ingranaggio.
///
/// Prestazioni: la WebView e' una platform view. Non va spostata, scalata o
/// ricostruita da Flutter, o il lato nativo rifa' layout e composizione a ogni
/// frame. Qui e' costruita una volta e il moto vive dentro la pagina, in un
/// solo `requestAnimationFrame`.
///
/// Finche' il modello non e' pronto — e sempre, se la piattaforma non riesce a
/// disegnarlo — resta il marchio statico, che e' anche quello che copre
/// l'attesa nei primi istanti: un modello caricato quando serve arriverebbe
/// dopo l'attesa che doveva coprire.
class CoachlySpinningMark extends StatefulWidget {
  const CoachlySpinningMark({required this.size, super.key});

  /// Lato del riquadro in cui il marchio e' inscritto.
  final double size;

  @override
  State<CoachlySpinningMark> createState() => _CoachlySpinningMarkState();
}

class _CoachlySpinningMarkState extends State<CoachlySpinningMark> {
  static const String _viewerId = 'coachly-loading-mark';

  String? _pageJs;
  bool _isModelReady = false;
  bool _modelFailed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pageJs ??= _sweepJs(
      reduceMotion: MediaQuery.disableAnimationsOf(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isModelReady ? 0 : 1,
            duration: const Duration(milliseconds: 400),
            child: Image.asset(AppAssets.logo, width: widget.size * 0.72),
          ),
          if (!_modelFailed)
            Positioned.fill(
              child: RepaintBoundary(
                child: ModelViewer(
                  id: _viewerId,
                  src: AppAssets.logo3d,
                  debugLogging: false,
                  activeGestureInterceptor: false,
                  cameraControls: false,
                  disableTap: true,
                  disableZoom: true,
                  disablePan: true,
                  autoRotate: false,
                  autoPlay: false,
                  interactionPrompt: InteractionPrompt.none,
                  interpolationDecay: 25,
                  cameraOrbit: '0deg 92deg 130%',
                  // Il limite automatico del raggio si ferma prima della posa
                  // di riposo: senza questo la camera verrebbe riportata
                  // avanti e il marchio tornerebbe grande.
                  maxCameraOrbit: 'Infinity 180deg 1000%',
                  relatedCss: _pageCss,
                  relatedJs: _pageJs,
                  onLoad: (_) {
                    if (!mounted) return;
                    setState(() => _isModelReady = true);
                  },
                  onError: (_) {
                    if (!mounted) return;
                    setState(() => _modelFailed = true);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  static const String _pageCss = '''
model-viewer {
  opacity: 0;
  transition: opacity 400ms ease-out;
  --poster-color: transparent;
}
model-viewer.is-ready { opacity: 1; }
model-viewer::part(default-progress-bar),
model-viewer::part(default-progress-mask) { display: none; }
''';

  /// Il pendolo.
  ///
  /// L'angolo segue un seno: la velocita' e' massima al passaggio centrale e
  /// nulla agli estremi, che e' esattamente «lento, veloce, lento, inverte».
  /// L'ampiezza supera il mezzo giro, quindi a ogni passata il marchio mostra
  /// anche il retro.
  ///
  /// Con «riduci animazioni» il modello resta fermo nella posa frontale.
  static String _sweepJs({required bool reduceMotion}) =>
      '''
(function () {
  var mv = document.getElementById('$_viewerId');
  if (!mv) { return; }
  var reduce = ${reduceMotion ? 'true' : 'false'};

  function call(name, arg) {
    var bridge = window.flutter_inappwebview;
    if (bridge && bridge.callHandler) { bridge.callHandler(name, arg); }
  }

  var AMPLITUDE = 200;   // gradi per lato
  var PERIOD = 2600;     // ms di un'andata e ritorno completa
  var lastOrbit = '', running = false, start = null;

  function draw(theta) {
    var orbit = theta.toFixed(2) + 'deg 92deg 130%';
    if (orbit !== lastOrbit) { mv.setAttribute('camera-orbit', orbit); lastOrbit = orbit; }
  }

  function tick(now) {
    if (document.hidden) { running = false; return; }
    running = true;
    if (start === null) { start = now; }
    draw(AMPLITUDE * Math.sin((now - start) / PERIOD * 2 * Math.PI));
    requestAnimationFrame(tick);
  }

  mv.addEventListener('load', function () {
    call('onLoadChannel', '/model');
    mv.classList.add('is-ready');
    if (reduce) { draw(0); return; }
    requestAnimationFrame(tick);
  }, { once: true });

  mv.addEventListener('error', function (event) {
    var detail = event && event.detail ? event.detail.type : 'error';
    call('onErrorChannel', String(detail));
  });

  document.addEventListener('visibilitychange', function () {
    if (!document.hidden && !running && !reduce) {
      start = null;
      requestAnimationFrame(tick);
    }
  });
})();
''';
}
