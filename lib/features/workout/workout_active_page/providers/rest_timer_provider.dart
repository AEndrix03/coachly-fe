import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestTimerState {
  final int remainingSeconds;
  final bool isActive;
  final int initialSeconds;
  final bool isBellEnabled;
  final bool completedNaturally;

  const RestTimerState({
    required this.remainingSeconds,
    required this.isActive,
    required this.initialSeconds,
    required this.isBellEnabled,
    this.completedNaturally = false,
  });

  RestTimerState copyWith({
    int? remainingSeconds,
    bool? isActive,
    int? initialSeconds,
    bool? isBellEnabled,
    bool? completedNaturally,
  }) {
    return RestTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isActive: isActive ?? this.isActive,
      initialSeconds: initialSeconds ?? this.initialSeconds,
      isBellEnabled: isBellEnabled ?? this.isBellEnabled,
      completedNaturally: completedNaturally ?? this.completedNaturally,
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
      isBellEnabled: true,
      completedNaturally: false,
    );
  }

  void startTimer(int seconds) {
    _timer?.cancel();
    state = RestTimerState(
      remainingSeconds: seconds,
      isActive: true,
      initialSeconds: seconds,
      isBellEnabled: state.isBellEnabled,
      completedNaturally: false,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Finish in the same tick that reaches zero.  The completion listener
      // relies on this active -> inactive transition to trigger the alarm.
      if (state.remainingSeconds <= 1) {
        stopTimer(completedNaturally: true);
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      }
    });
  }

  void addTime(int seconds) {
    if (state.isActive) {
      final updatedSeconds = state.remainingSeconds + seconds;
      if (updatedSeconds <= 0) {
        state = state.copyWith(remainingSeconds: 1);
        return;
      }

      state = state.copyWith(
        remainingSeconds: updatedSeconds,
        initialSeconds: updatedSeconds > state.initialSeconds
            ? updatedSeconds
            : state.initialSeconds,
      );
    }
  }

  void stopTimer({bool completedNaturally = false}) {
    _timer?.cancel();
    state = state.copyWith(
      isActive: false,
      remainingSeconds: 0,
      completedNaturally: completedNaturally,
    );
  }

  void setBellEnabled(bool enabled) {
    state = state.copyWith(isBellEnabled: enabled);
  }

  void toggleBell() {
    state = state.copyWith(isBellEnabled: !state.isBellEnabled);
  }
}

final restTimerProvider = NotifierProvider<RestTimerNotifier, RestTimerState>(
  () {
    return RestTimerNotifier();
  },
);
