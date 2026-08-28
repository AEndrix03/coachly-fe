import 'package:coachly/app/sync/local_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class BuilderTourController extends Notifier<BuilderTourState> {
  static const _autoShowKey = 'workoutBuilderTourAutoShow';
  static const stepCount = 7;

  @override
  BuilderTourState build() => const BuilderTourState();

  bool get shouldAutoShow {
    final value = LocalDatabaseService().settings.get(_autoShowKey);
    return value is! bool || value;
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
    await LocalDatabaseService().settings.put(_autoShowKey, !value);
  }
}
