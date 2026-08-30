import 'dart:ui' show Locale;
import 'package:coachly/core/assets/app_assets.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/features/auth/providers/user_provider.dart';
import 'package:coachly/features/workout/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/presentation/models/today_home_view_data.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todayHomeViewDataProvider =
    FutureProvider.family<TodayHomeViewData, Locale>((ref, locale) async {
      final items = await ref.watch(workoutListProvider.future);
      final user = ref.watch(userProvider);
      final connectivity = ref.watch(connectivityProvider).value;
      final sessions = await ref
          .watch(workoutPageRepositoryProvider)
          .getAllSessions();
      final openSessions =
          sessions
              .where(
                (session) =>
                    session.startedAt != null && session.completedAt == null,
              )
              .toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      final active = items.where((item) => item.active).toList()
        ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      final syncState = connectivity?.contains(ConnectivityResult.none) == true
          ? HomeSyncState.offline
          : items.any((item) => item.dirty)
          ? HomeSyncState.syncing
          : HomeSyncState.synced;
      final now = DateTime.now();
      final displayedMonth = DateTime(now.year, now.month);
      final firstWeekDay = now.subtract(
        Duration(days: now.weekday - DateTime.monday),
      );
      final suggested = active.isEmpty ? null : active.first;
      final openSession = openSessions.isEmpty ? null : openSessions.first;
      WorkoutModel? openWorkout;
      if (openSession != null) {
        for (final item in items) {
          if (item.id == openSession.workoutId) {
            openWorkout = item;
            break;
          }
        }
      }
      final calendar = HomeCalendarPreviewViewData(
        displayedMonth: displayedMonth,
        nextWorkoutTitle: suggested?.titleI18n?.fromI18n(locale),
        nextWorkoutWhen: suggested == null
            ? null
            : AppStrings.translate('home.calendar.today', locale: locale),
        days: List.generate(DateTime.daysPerWeek, (index) {
          final date = firstWeekDay.add(Duration(days: index));
          final matchesLastSession = items.any(
            (item) => _sameDay(item.lastUsed, date),
          );
          return HomeCalendarDayViewData(
            date: date,
            isInDisplayedMonth: date.month == displayedMonth.month,
            isToday: _sameDay(date, now),
            isComplete: matchesLastSession && date.isBefore(now),
            hasTraining:
                matchesLastSession ||
                (_sameDay(date, now) && suggested != null),
          );
        }),
      );

      if (suggested == null) {
        return TodayHomeViewData(
          header: TodayHeaderViewData(firstName: user?.firstName ?? ''),
          today: const HomeTodayViewData(
            kind: HomeTrainingStateKind.noTrainingConfigured,
          ),
          calendar: calendar,
          goal: const HomeGoalPreviewViewData.empty(),
          insights: const [],
          quickActions: _newUserActions,
          guides: _guides,
          routines: const [],
          syncState: syncState,
        );
      }

      final routineTitle =
          suggested.titleI18n?.fromI18n(locale) ?? suggested.id;
      final routines = active
          .take(6)
          .map(
            (workout) => HomeRoutineViewData(
              id: workout.id,
              title: workout.titleI18n?.fromI18n(locale) ?? workout.id,
              exerciseCount: workout.exercises,
              durationMinutes: workout.durationMinutes,
              lastUsed: workout.lastUsed,
            ),
          )
          .toList();
      final insights = suggested.progress >= .8
          ? [
              HomeInsightViewData(
                id: 'progression-${suggested.id}',
                eyebrow: routineTitle,
                title: AppStrings.translate(
                  'home.insight.progression_title',
                  locale: locale,
                ),
                body: AppStrings.translate(
                  'home.insight.progression_specific',
                  locale: locale,
                ),
                tone: HomeInsightTone.progress,
              ),
            ]
          : <HomeInsightViewData>[];
      final openWorkoutTitle =
          openWorkout?.titleI18n?.fromI18n(locale) ?? openWorkout?.id;
      final today = openSession != null && openWorkout != null
          ? HomeTodayViewData(
              kind: HomeTrainingStateKind.activeWorkout,
              workoutId: openWorkout.id,
              title: openWorkoutTitle,
              durationMinutes: DateTime.now()
                  .difference(openSession.startedAt!)
                  .inMinutes
                  .clamp(0, 999)
                  .toInt(),
              completedExercises: openSession.entries
                  .where((entry) => entry.completed == true)
                  .length,
              totalExercises: openSession.entries.length,
            )
          : HomeTodayViewData(
              kind: HomeTrainingStateKind.standaloneRoutineSuggestion,
              workoutId: suggested.id,
              title: routineTitle,
              focusLabel: suggested.goal,
              durationMinutes: suggested.durationMinutes,
              workingSets: suggested.workoutExercises.length * 3,
            );
      return TodayHomeViewData(
        header: TodayHeaderViewData(firstName: user?.firstName ?? ''),
        today: today,
        calendar: calendar,
        goal: const HomeGoalPreviewViewData.empty(),
        insights: insights,
        quickActions: _habitualActions,
        guides: _guides,
        routines: routines,
        syncState: syncState,
      );
    });

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

const _newUserActions = [
  HomeQuickActionViewData(
    labelKey: 'home.action.create_workout',
    destination: HomeQuickActionDestination.createWorkout,
  ),
  HomeQuickActionViewData(
    labelKey: 'home.action.create_exercise',
    destination: HomeQuickActionDestination.createExercise,
  ),
  HomeQuickActionViewData(
    labelKey: 'home.action.empty_workout',
    destination: HomeQuickActionDestination.emptyWorkout,
  ),
];
const _habitualActions = [
  HomeQuickActionViewData(
    labelKey: 'home.action.create_workout',
    destination: HomeQuickActionDestination.createWorkout,
  ),
  HomeQuickActionViewData(
    labelKey: 'home.action.create_exercise',
    destination: HomeQuickActionDestination.createExercise,
  ),
  HomeQuickActionViewData(
    labelKey: 'home.action.empty_workout',
    destination: HomeQuickActionDestination.emptyWorkout,
  ),
];
const _guides = [
  HomeGuideViewData(
    id: 'double-progression',
    titleKey: 'home.guide.double_progression',
    duration: Duration(minutes: 4, seconds: 20),
    levelKey: 'home.guide.beginner',
    assetPath: AppAssets.guideDoubleProgression,
    contextTag: 'progression',
  ),
  HomeGuideViewData(
    id: 'rir',
    titleKey: 'home.guide.rir',
    duration: Duration(minutes: 3, seconds: 45),
    levelKey: 'home.guide.beginner',
    assetPath: AppAssets.guideRir,
    contextTag: 'intensity',
  ),
  HomeGuideViewData(
    id: 'machines',
    titleKey: 'home.guide.machines',
    duration: Duration(minutes: 3, seconds: 45),
    levelKey: 'home.guide.all_levels',
    assetPath: AppAssets.guideMachineComparability,
    contextTag: 'new_gym',
  ),
  HomeGuideViewData(
    id: 'nine-day-cycle',
    titleKey: 'home.guide.nine_day_cycle',
    duration: Duration(minutes: 5, seconds: 10),
    levelKey: 'home.guide.intermediate',
    assetPath: AppAssets.guideNineDayCycle,
    contextTag: 'programming',
  ),
];
