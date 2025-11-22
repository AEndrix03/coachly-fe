import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestTimerState {
  final int remainingSeconds;
  final bool isActive;
  final int initialSeconds;

  const RestTimerState({
    required this.remainingSeconds,
    required this.isActive,
    required this.initialSeconds,
  });

  RestTimerState copyWith({
    int? remainingSeconds,
    bool? isActive,
    int? initialSeconds,
  }) {
    return RestTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isActive: isActive ?? this.isActive,
      initialSeconds: initialSeconds ?? this.initialSeconds,
    );
  }
}

class RestTimerNotifier extends Notifier<RestTimerState> {
  Timer? _timer;

  @override
  RestTimerState build() {
    ref.onDispose(() => _timer?.cancel());
    return const RestTimerState(
      remainingSeconds: 0,
      isActive: false,
      initialSeconds: 0,
    );
  }

  void startTimer(int seconds) {
    _timer?.cancel();
    state = RestTimerState(
      remainingSeconds: seconds,
      isActive: true,
      initialSeconds: seconds,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        stopTimer();
      }
    });
  }

  void addTime(int seconds) {
    if (state.isActive) {
      state = state.copyWith(
        remainingSeconds: state.remainingSeconds + seconds,
      );
    }
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isActive: false, remainingSeconds: 0);
  }
}

final restTimerProvider = NotifierProvider<RestTimerNotifier, RestTimerState>(
  () {
    return RestTimerNotifier();
  },
);
