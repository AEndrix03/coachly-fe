enum HomeTrainingStateKind {
  activeWorkout,
  scheduledProgramSession,
  standaloneRoutineSuggestion,
  restDay,
  plannedBreak,
  noTrainingConfigured,
}

enum HomeSyncState { synced, syncing, offline }

enum HomeInsightTone { progress, watch, coachly, neutral, danger }

enum HomeQuickActionDestination { createWorkout, createExercise, emptyWorkout }

class TodayHomeViewData {
  const TodayHomeViewData({
    required this.header,
    required this.today,
    this.programContext,
    required this.calendar,
    required this.goal,
    required this.insights,
    required this.quickActions,
    required this.guides,
    required this.routines,
    required this.syncState,
  });
  final TodayHeaderViewData header;
  final HomeTodayViewData today;
  final HomeProgramContextViewData? programContext;
  final HomeCalendarPreviewViewData calendar;
  final HomeGoalPreviewViewData goal;
  final List<HomeInsightViewData> insights;
  final List<HomeQuickActionViewData> quickActions;
  final List<HomeGuideViewData> guides;
  final List<HomeRoutineViewData> routines;
  final HomeSyncState syncState;
}

class TodayHeaderViewData {
  const TodayHeaderViewData({required this.firstName});
  final String firstName;
}

class HomeTodayViewData {
  const HomeTodayViewData({
    required this.kind,
    this.workoutId,
    this.title,
    this.contextLabel,
    this.focusLabel,
    this.durationMinutes,
    this.workingSets,
    this.completedExercises,
    this.totalExercises,
    this.nextSessionLabel,
    this.breakLabel,
  });
  final HomeTrainingStateKind kind;
  final String? workoutId;
  final String? title;
  final String? contextLabel;
  final String? focusLabel;
  final int? durationMinutes;
  final int? workingSets;
  final int? completedExercises;
  final int? totalExercises;
  final String? nextSessionLabel;
  final String? breakLabel;
}

class HomeProgramStepViewData {
  const HomeProgramStepViewData({
    required this.label,
    required this.isComplete,
    required this.isToday,
  });
  final String label;
  final bool isComplete;
  final bool isToday;
}

class HomeProgramContextViewData {
  const HomeProgramContextViewData({
    required this.programName,
    required this.positionLabel,
    required this.steps,
  });
  final String programName;
  final String positionLabel;
  final List<HomeProgramStepViewData> steps;
}

class HomeCalendarDayViewData {
  const HomeCalendarDayViewData({
    required this.date,
    required this.isInDisplayedMonth,
    required this.isToday,
    required this.isComplete,
    required this.hasTraining,
  });
  final DateTime date;
  final bool? isInDisplayedMonth;
  final bool isToday;
  final bool isComplete;
  final bool hasTraining;
}

class HomeCalendarPreviewViewData {
  const HomeCalendarPreviewViewData({
    required this.displayedMonth,
    required this.days,
    this.nextWorkoutTitle,
    this.nextWorkoutWhen,
  });
  final DateTime displayedMonth;
  final List<HomeCalendarDayViewData> days;
  final String? nextWorkoutTitle;
  final String? nextWorkoutWhen;
}

class HomeGoalPreviewViewData {
  const HomeGoalPreviewViewData.empty()
    : exerciseName = null,
      targetDisplay = null,
      currentDisplay = null,
      progress = null,
      remainingDisplay = null;
  const HomeGoalPreviewViewData.populated({
    required this.exerciseName,
    required this.targetDisplay,
    required this.currentDisplay,
    required this.progress,
    required this.remainingDisplay,
  });
  final String? exerciseName;
  final String? targetDisplay;
  final String? currentDisplay;
  final double? progress;
  final String? remainingDisplay;
  bool get hasGoal => exerciseName != null;
}

class HomeInsightViewData {
  const HomeInsightViewData({
    required this.id,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.tone,
  });
  final String id;
  final String eyebrow;
  final String title;
  final String body;
  final HomeInsightTone tone;
}

class HomeQuickActionViewData {
  const HomeQuickActionViewData({
    required this.labelKey,
    required this.destination,
  });
  final String labelKey;
  final HomeQuickActionDestination destination;
}

class HomeGuideViewData {
  const HomeGuideViewData({
    required this.id,
    required this.titleKey,
    required this.duration,
    required this.levelKey,
    required this.assetPath,
    required this.contextTag,
  });
  final String id;
  final String titleKey;
  final Duration duration;
  final String levelKey;
  final String assetPath;
  final String contextTag;
}

class HomeRoutineViewData {
  const HomeRoutineViewData({
    required this.id,
    required this.title,
    required this.exerciseCount,
    required this.durationMinutes,
    required this.daysSinceLastUse,
  });
  final String id;
  final String title;
  final int exerciseCount;
  final int durationMinutes;

  /// Giorni dall'ultima esecuzione, gia' calcolati.
  ///
  /// Era una `DateTime` che il widget confrontava con `DateTime.now()`: una
  /// derivazione fatta in `presentation/`, quindi non testabile e legata
  /// all'orologio di sistema. Il calcolo sta dove sta l'orologio iniettato
  /// (`docs/development/03-state-riverpod.md`).
  final int daysSinceLastUse;
}
