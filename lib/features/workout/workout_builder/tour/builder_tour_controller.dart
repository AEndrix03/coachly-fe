import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BuilderTourOrigin { automatic, manual }

enum BuilderTourTarget {
  addExercise,
  mainSectionHeader,
  sectionsAction,
  mainSectionMenu,
  blocksAction,
  workoutCheck,
  discover,
  reviewWorkout,
}

class BuilderTourState {
  final bool isActive;
  final int currentStepIndex;
  final BuilderTourOrigin origin;
  final bool dontShowAgain;

  const BuilderTourState({
    this.isActive = false,
    this.currentStepIndex = 0,
    this.origin = BuilderTourOrigin.automatic,
    this.dontShowAgain = false,
  });

  BuilderTourState copyWith({
    bool? isActive,
    int? currentStepIndex,
    BuilderTourOrigin? origin,
    bool? dontShowAgain,
  }) => BuilderTourState(
    isActive: isActive ?? this.isActive,
    currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    origin: origin ?? this.origin,
    dontShowAgain: dontShowAgain ?? this.dontShowAgain,
  );
}

final builderTourProvider =
    NotifierProvider.autoDispose<BuilderTourController, BuilderTourState>(
      BuilderTourController.new,
    );

/// "Tour visto" è una **preferenza banale**: sta in `SharedPreferencesAsync`,
/// non in Drift (`docs/development/04-data-layer.md`). Perderla significa al
/// massimo rivedere una volta il tour.
class BuilderTourController extends Notifier<BuilderTourState> {
  static const String autoShowKey = 'workoutBuilderTourAutoShow';
  static const stepCount = 7;

  @visibleForTesting
  static SharedPreferencesAsync preferences = SharedPreferencesAsync();

  /// Valore idratato dalle preferenze. Il default è `true`, lo stesso che
  /// valeva quando la chiave non era mai stata scritta.
  bool _autoShow = true;

  @override
  BuilderTourState build() {
    // Eccezione dichiarata, non regola indebolita: la regola esiste per il
    // `Future.microtask(load)` che carica DATI nel build di un Notifier, dove
    // la risposta e' `AsyncNotifier`. Qui si idrata una PREFERENZA che ha gia'
    // un default valido, e lo stato sincrono e' un requisito dei chiamanti che
    // si aspettano un valore, non un `AsyncValue`.
    // ignore: no_side_effects_in_build
    unawaited(_restore());
    return const BuilderTourState();
  }

  Future<void> _restore() async {
    _autoShow = await preferences.getBool(autoShowKey) ?? true;
  }

  /// Lettura sincrona: il chiamante decide se avviare il tour dentro un
  /// `build`, dove non può attendere. L'idratazione parte alla creazione del
  /// controller, molto prima che la pagina raggiunga lo step in cui il tour
  /// si propone.
  bool get shouldAutoShow => _autoShow;

  /// Variante attendibile, per i test e per i chiamanti asincroni.
  Future<bool> shouldAutoShowAsync() async {
    await _restore();
    return _autoShow;
  }

  void start(BuilderTourOrigin origin) {
    state = BuilderTourState(isActive: true, origin: origin);
  }

  void next() {
    if (state.currentStepIndex >= stepCount - 1) {
      close();
      return;
    }
    state = state.copyWith(currentStepIndex: state.currentStepIndex + 1);
  }

  void previous() {
    if (state.currentStepIndex == 0) return;
    state = state.copyWith(currentStepIndex: state.currentStepIndex - 1);
  }

  void close() => state = state.copyWith(isActive: false);

  Future<void> setDontShowAgain(bool value) async {
    state = state.copyWith(dontShowAgain: value);
    _autoShow = !value;
    await preferences.setBool(autoShowKey, _autoShow);
  }
}
