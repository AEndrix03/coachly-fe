import 'dart:async';

import 'package:coachly/core/assets/app_assets.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';
// `Flutter3DViewer` non espone né `interpolationDecay` né il JS della pagina,
// e la sua API pubblica costringe a pilotare la camera un frame alla volta dal
// lato Dart (un round-trip sul platform channel per frame). Il widget interno
// `ModelViewer` accetta CSS e JS propri: la coreografia gira dentro la WebView
// a 60 fps senza traffico Flutter → WebView. Versione bloccata in pubspec.
// ignore: implementation_imports
import 'package:flutter_3d_controller/src/core/modules/model_viewer/model_viewer.dart';

/// Animated brand hero used by the login screen.
///
/// Performance model, in order of importance:
///
/// 1. The WebView is a platform view. Moving, scaling or rebuilding it from
///    Flutter forces the native side to relayout and recomposite every frame,
///    which is what produced the stutter and the `NativeAlloc` GC churn. The
///    viewer is therefore built once, never wrapped in an animated builder and
///    never transformed from Dart.
/// 2. All motion of the 3D model happens inside the page, driven by a single
///    `requestAnimationFrame` loop: camera orbit for the rotations, a CSS
///    transform for hops and squash. The only message that crosses the
///    platform channel after `load` is the [busy] flag.
/// 3. The glow behind the model lives in its own `RepaintBoundary` and is
///    faded with a `FadeTransition`, so its raster is painted once and only
///    its alpha changes.
///
/// Behaviour: at rest the logo is almost still, with a slow breath. A tap
/// gives a small nod, a drag rotates it under the finger to reveal the volume,
/// a fling spins it and lets it settle back. While [busy] is true it eases
/// into a steady, unhurried spin on the vertical axis: the brand itself is the
/// progress indicator of the sign-in flow, so no spinner is shown elsewhere.
/// With reduce motion the spin is replaced by a soft pulse of opacity.
///
/// The static logo stays behind the 3D surface while it loads and becomes the
/// fallback if the platform renderer cannot display the GLB model.
class Animated3dLogo extends StatefulWidget {
  const Animated3dLogo({super.key, this.busy = false});

  /// True while the app is waiting on the sign-in flow.
  final bool busy;

  @override
  State<Animated3dLogo> createState() => _Animated3dLogoState();
}

class _Animated3dLogoState extends State<Animated3dLogo>
    with SingleTickerProviderStateMixin {
  static const String _viewerId = 'coachly-logo';

  late final AnimationController _glowController;
  late final Animation<double> _glow;

  /// Built once: `ModelViewer` reads its HTML inputs when the page is loaded,
  /// so rebuilding the strings on every frame would be wasted work.
  String? _pageJs;
  bool _isModelReady = false;
  bool _modelFailed = false;

  /// The `InAppWebViewController` handed out by `ModelViewer`. Kept untyped on
  /// purpose: `flutter_inappwebview` is only a transitive dependency and the
  /// single call we make (`evaluateJavascript`) does not justify adding it to
  /// the pubspec.
  dynamic _webView;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this);
    _glow = Tween<double>(begin: 0.55, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    _pageJs ??= _choreographyJs(reduceMotion: reduceMotion);
    if (reduceMotion) {
      _glowController.stop();
      _glowController.value = 1;
    } else if (!_glowController.isAnimating) {
      _glowController
        ..duration = context.motion.ambient
        ..repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant Animated3dLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.busy != widget.busy) {
      unawaited(_sendBusy());
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _sendBusy() async {
    if (_webView == null || !_isModelReady) return;
    await _webView.evaluateJavascript(
      source:
          'window.coachlyLogo && window.coachlyLogo.setBusy(${widget.busy});',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Stack(
      alignment: Alignment.center,
      children: [
        RepaintBoundary(
          child: IgnorePointer(
            child: FadeTransition(
              opacity: _glow,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: context.colors.brandGlow,
                ),
                child: SizedBox.square(dimension: sizes.authLogoGlow),
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: _isModelReady ? 0 : 1,
          duration: context.motion.resolve(context, context.motion.slow),
          child: Image.asset(AppAssets.logo, height: sizes.authLogo),
        ),
        if (!_modelFailed)
          Positioned.fill(
            child: RepaintBoundary(
              child: ModelViewer(
                id: _viewerId,
                src: AppAssets.logo3d,
                debugLogging: false,
                activeGestureInterceptor: false,
                // I gesti li gestisce il nostro JS, non model-viewer.
                cameraControls: false,
                disableTap: true,
                disableZoom: true,
                disablePan: true,
                autoRotate: false,
                autoPlay: false,
                interactionPrompt: InteractionPrompt.none,
                // Piccolo smussamento residuo sopra la coreografia: toglie
                // l'ultimo scalino ai cambi di direzione senza introdurre
                // ritardo percepibile.
                interpolationDecay: 25,
                // Posa di partenza dell'entrata: lontano, ruotato e visto dal
                // basso. Il JS la porta a riposo con la prima animazione.
                cameraOrbit: '-200deg 100deg 300%',
                relatedCss: _pageCss,
                relatedJs: _pageJs,
                onWebViewCreated: (controller) => _webView = controller,
                onLoad: (_) {
                  if (!mounted) return;
                  setState(() => _isModelReady = true);
                  unawaited(_sendBusy());
                },
                onError: (_) {
                  if (!mounted) return;
                  setState(() => _modelFailed = true);
                },
              ),
            ),
          ),
      ],
    );
  }

  /// The model is hidden until `load`, so the viewer never shows its default
  /// white poster or progress bar over the transparent WebView.
  static const String _pageCss = '''
model-viewer {
  opacity: 0;
  transition: opacity 500ms ease-out;
  will-change: transform;
  transform-origin: 50% 55%;
  touch-action: none;
  cursor: grab;
  --poster-color: transparent;
}
model-viewer.is-ready { opacity: 1; }
model-viewer.is-dragging { cursor: grabbing; }
model-viewer.is-busy-soft { animation: coachly-pulse 1400ms ease-in-out infinite alternate; }
@keyframes coachly-pulse { from { opacity: 1; } to { opacity: 0.65; } }
model-viewer::part(default-progress-bar),
model-viewer::part(default-progress-mask) { display: none; }
''';

  /// Choreography engine plus the behaviours.
  ///
  /// A small state (`theta`, `phi`, `radius` for the camera orbit; `x`, `y`,
  /// `scale` for the CSS transform) is driven by one of a few modes:
  ///
  /// - `seq`: tweens through a list of segments, each with its own duration
  ///   and easing. Used for the entrance, the tap nod and the settle after a
  ///   spin.
  /// - `idle`: barely perceptible sway and breath.
  /// - `drag`: theta/phi follow the finger.
  /// - `fling`: keeps the release velocity with friction, then settles.
  /// - `busy`: eases in over ~900 ms to a steady, slow spin; when the flag
  ///   drops it completes the current turn and eases to a stop.
  ///
  /// The rest pose keeps a wide safety margin inside the stage (`radius` well
  /// above 100%) so nothing ever leaves the visible area. With reduce motion
  /// the model is revealed in its rest pose, gestures are off and `busy`
  /// only toggles a CSS opacity pulse.
  static String _choreographyJs({required bool reduceMotion}) =>
      '''
(function () {
  var mv = document.getElementById('$_viewerId');
  if (!mv) { return; }
  var reduce = ${reduceMotion ? 'true' : 'false'};

  function call(name, arg) {
    var bridge = window.flutter_inappwebview;
    if (bridge && bridge.callHandler) { bridge.callHandler(name, arg); }
  }
  function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }
  // Riporta un angolo in (-180, 180] cosi' il ritorno a riposo prende la via
  // corta invece di svolgere tutti i giri accumulati.
  function wrap(deg) { return ((deg + 180) % 360 + 360) % 360 - 180; }

  // phi > 90 guarda leggermente dal basso: compensa l'inclinazione in avanti
  // del modello. radius > 100% lascia margine dentro il palco.
  var REST = { theta: 0, phi: 92, radius: 229, x: 0, y: 0, scale: 1 };
  var SWAY_THETA = 5, SWAY_PHI = 2;
  var SPIN_SPEED = 330;      // gradi al secondo a regime: un giro in ~1.1 s
  var SPIN_RAMP = 900;       // ms per arrivare a regime

  var EASE = {
    outQuad: function (t) { return 1 - (1 - t) * (1 - t); },
    inQuad: function (t) { return t * t; },
    outCubic: function (t) { return 1 - Math.pow(1 - t, 3); },
    inOutCubic: function (t) {
      return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
    },
    outBack: function (t) {
      var c1 = 1.70158, c3 = c1 + 1;
      return 1 + c3 * Math.pow(t - 1, 3) + c1 * Math.pow(t - 1, 2);
    }
  };

  function seg(ms, to, ease) { return { d: ms, to: to || {}, e: ease || 'outCubic' }; }

  // Cenno al tocco: si inclina indietro e in avanti, come un "si'".
  function nod() {
    return [
      seg(200, { phi: 80, scale: 1.02 }, 'outQuad'),
      seg(220, { phi: 100 }, 'inOutCubic'),
      seg(180, { phi: 86 }, 'inOutCubic'),
      seg(340, { phi: REST.phi, scale: 1 }, 'outBack')
    ];
  }

  // ---- Motore -------------------------------------------------------------

  var state = { theta: -200, phi: 100, radius: 300, x: 0, y: 0, scale: 0.6 };
  var mode = 'boot';
  var seq = null, drag = null, fling = null;
  var busy = false, busyV = 0, busyT = 0;
  var idle = { t0: 0, thetaPhase: 0, phiPhase: 0 };
  var lastOrbit = '', lastNow = 0, running = false;

  function apply(now) {
    var orbit = state.theta.toFixed(2) + 'deg ' + state.phi.toFixed(2) + 'deg ' + state.radius.toFixed(2) + '%';
    if (orbit !== lastOrbit) { mv.setAttribute('camera-orbit', orbit); lastOrbit = orbit; }
    var breath = reduce ? 0 : Math.sin(now / 650) * 2.5;
    mv.style.transform = 'translate3d(' + state.x.toFixed(2) + 'px,' + (state.y + breath).toFixed(2) + 'px,0) scale(' + state.scale.toFixed(3) + ')';
  }

  function enterIdle(now) {
    mode = 'idle';
    idle.t0 = now;
    state.theta = wrap(state.theta);
    // Fase iniziale scelta in modo che l'oscillazione parta dal valore
    // corrente: niente salto quando una sequenza finisce.
    idle.thetaPhase = Math.asin(clamp(state.theta / SWAY_THETA, -1, 1));
    idle.phiPhase = Math.asin(clamp((state.phi - REST.phi) / SWAY_PHI, -1, 1));
  }

  function play(list) { seq = { list: list, index: -1, from: null, start: 0 }; mode = 'seq'; }

  function stepSeq(now) {
    if (seq.index < 0 || now - seq.start >= seq.list[seq.index].d) {
      if (seq.index >= 0) {
        var done = seq.list[seq.index];
        for (var k in done.to) { state[k] = done.to[k]; }
      }
      seq.index++;
      if (seq.index >= seq.list.length) {
        seq = null;
        if (busy) { startBusy(); } else { enterIdle(now); }
        return;
      }
      seq.from = Object.assign({}, state);
      seq.start = now;
    }
    var cur = seq.list[seq.index];
    var t = Math.min(1, (now - seq.start) / cur.d), e = EASE[cur.e](t);
    for (var key in cur.to) { state[key] = seq.from[key] + (cur.to[key] - seq.from[key]) * e; }
  }

  function stepIdle(now) {
    var s = (now - idle.t0) / 1000;
    state.theta = Math.sin(s * 0.45 + idle.thetaPhase) * SWAY_THETA;
    state.phi = REST.phi + Math.sin(s * 0.33 + idle.phiPhase) * SWAY_PHI;
    state.radius = REST.radius; state.x = 0; state.y = 0; state.scale = 1;
  }

  // Frena con attrito, poi si assesta a riposo prendendo la via corta.
  function stepFling(now, dt) {
    state.theta += fling.v * dt / 1000;
    fling.v *= Math.exp(-dt / 320);
    state.phi += (REST.phi - state.phi) * Math.min(1, dt / 200);
    if (Math.abs(fling.v) < 40) {
      fling = null;
      state.theta = wrap(state.theta);
      play([seg(760, { theta: 0, phi: REST.phi, radius: REST.radius, scale: 1 }, 'outBack')]);
    }
  }

  // Giro di caricamento: partenza dolce fino a velocita' costante.
  function startBusy() { mode = 'busy'; busyT = 0; }
  function stepBusy(now, dt) {
    busyT += dt;
    busyV = SPIN_SPEED * EASE.outCubic(Math.min(1, busyT / SPIN_RAMP));
    state.theta += busyV * dt / 1000;
    var k = Math.min(1, dt / 220);
    state.phi += (REST.phi - state.phi) * k;
    state.scale += (1 - state.scale) * k;
    state.radius += (REST.radius - state.radius) * k;
    state.x = 0; state.y = 0;
  }
  // Fine caricamento: completa il giro in corso e si ferma con easing.
  function stopBusy() {
    var target = Math.ceil(state.theta / 360) * 360;
    if (target - state.theta < 45) { target += 360; }
    var ms = clamp((target - state.theta) / Math.max(busyV, 30) * 1000 * 1.5, 600, 1500);
    play([seg(ms, { theta: target, phi: REST.phi, scale: 1 }, 'outCubic')]);
  }

  function tick(now) {
    if (document.hidden) { running = false; return; }
    running = true;
    var dt = lastNow ? Math.min(50, now - lastNow) : 16;
    lastNow = now;
    if (mode === 'seq') { stepSeq(now); }
    else if (mode === 'idle') { stepIdle(now); }
    else if (mode === 'fling') { stepFling(now, dt); }
    else if (mode === 'busy') { stepBusy(now, dt); }
    // 'drag' e' pilotato dagli eventi pointer.
    apply(now);
    requestAnimationFrame(tick);
  }

  // ---- Gesti ----------------------------------------------------------------

  mv.addEventListener('pointerdown', function (e) {
    if (reduce || mode === 'boot' || mode === 'busy') { return; }
    mv.setPointerCapture(e.pointerId);
    mv.classList.add('is-dragging');
    seq = null; fling = null;
    drag = {
      id: e.pointerId, x0: e.clientX, y0: e.clientY, t0: performance.now(),
      theta0: state.theta, phi0: state.phi,
      lastX: e.clientX, lastT: performance.now(), v: 0, moved: false
    };
    mode = 'drag';
  });

  mv.addEventListener('pointermove', function (e) {
    if (!drag || e.pointerId !== drag.id) { return; }
    var dx = e.clientX - drag.x0, dy = e.clientY - drag.y0;
    if (Math.abs(dx) + Math.abs(dy) > 6) { drag.moved = true; }
    state.theta = drag.theta0 + dx * 0.6;
    state.phi = clamp(drag.phi0 - dy * 0.2, 70, 108);
    state.scale = 1.02;
    var now = performance.now(), dt = now - drag.lastT;
    if (dt > 0) {
      var v = (e.clientX - drag.lastX) * 0.6 / dt * 1000;
      drag.v = drag.v * 0.6 + v * 0.4;
    }
    drag.lastX = e.clientX; drag.lastT = now;
  });

  function release(e) {
    if (!drag || e.pointerId !== drag.id) { return; }
    mv.classList.remove('is-dragging');
    var wasTap = !drag.moved && performance.now() - drag.t0 < 300;
    var v = drag.v;
    drag = null;
    if (busy) { startBusy(); return; }
    if (wasTap) { play(nod()); return; }
    fling = { v: clamp(v, -1000, 1000) };
    mode = 'fling';
  }
  mv.addEventListener('pointerup', release);
  mv.addEventListener('pointercancel', release);

  // ---- Bridge verso Flutter --------------------------------------------------

  window.coachlyLogo = {
    setBusy: function (on) {
      on = !!on;
      if (on === busy) { return; }
      busy = on;
      if (reduce) { mv.classList.toggle('is-busy-soft', on); return; }
      if (mode === 'boot') { return; }
      if (on) {
        seq = null; drag = null; fling = null;
        mv.classList.remove('is-dragging');
        startBusy();
      } else if (mode === 'busy') {
        stopBusy();
      }
    }
  };

  // ---- Avvio ------------------------------------------------------------------

  mv.addEventListener('load', function () {
    call('onLoadChannel', '/model');
    mv.classList.add('is-ready');
    if (reduce) {
      Object.assign(state, REST);
      apply(performance.now());
      mv.classList.toggle('is-busy-soft', busy);
      return;
    }
    play([seg(950, { theta: 0, phi: REST.phi, radius: REST.radius, scale: 1 }, 'outCubic')]);
    requestAnimationFrame(tick);
  }, { once: true });

  mv.addEventListener('error', function (event) {
    var detail = event && event.detail ? event.detail.type : 'error';
    call('onErrorChannel', String(detail));
  });

  document.addEventListener('visibilitychange', function () {
    if (!document.hidden && !running && mode !== 'boot' && !reduce) {
      lastNow = 0;
      if (seq) { seq.start = performance.now(); }
      requestAnimationFrame(tick);
    }
  });
})();
''';
}
