import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer per evitare troppe chiamate consecutive
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Extension per debounce su funzioni
extension DebouncedFunction on Function {
  VoidCallback debounce([Duration delay = const Duration(milliseconds: 500)]) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => this());
    };
  }
}
