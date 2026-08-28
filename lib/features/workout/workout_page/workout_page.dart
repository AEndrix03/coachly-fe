import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/presentation/models/today_home_view_data.dart';
import 'package:coachly/features/workout/workout_page/application/today_home_provider.dart';
import 'package:coachly/features/workout/workout_page/presentation/widgets/today_home_widgets.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutPage extends ConsumerWidget {
  const WorkoutPage({super.key});

  static const _navigationBarHeight = 64.0;
  static const _navigationBarTopInset = 10.0;
  static const _navigationBarBottomSpacing = 14.0;
  static const _contentClearance = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final state = ref.watch(todayHomeViewDataProvider(locale));
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.exerciseTheme.background,
          body: SafeArea(
            bottom: false,
            child: state.when(
              loading: () => const TodayHomeSkeleton(),
              error: (_, _) => _HomeError(
                onRetry: () => ref.invalidate(workoutListProvider),
              ),
              data: (data) => _HomeContent(
                data: data,
                bottomInset: _bottomContentInset(context),
                onRefresh: () async {
                  ref.invalidate(workoutListProvider);
                  await ref.read(workoutListProvider.future);
                },
                onCreateWorkout: () => _createWorkout(context),
                onQuickAction: (action) => _handleQuickAction(context, action),
                onStart: (id) => _openWorkout(context, ref, id, active: true),
                onRoutine: (id) => _openWorkout(context, ref, id),
                onNotifications: () =>
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.tr('workout.notifications_soon')),
                      ),
                    ),
                onSettings: () => context.go('/profile'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _bottomContentInset(BuildContext context) =>
      _navigationBarHeight +
      _navigationBarTopInset +
      _navigationBarBottomSpacing +
      MediaQuery.viewPaddingOf(context).bottom +
      _contentClearance;

  void _createWorkout(BuildContext context) {
    HapticFeedback.lightImpact();
    context.push('/workouts/workout/new/edit');
  }

  void _handleQuickAction(
    BuildContext context,
    HomeQuickActionViewData action,
  ) {
    switch (action.destination) {
      case HomeQuickActionDestination.createWorkout:
      case HomeQuickActionDestination.emptyWorkout:
        context.push('/workouts/workout/new/edit');
      case HomeQuickActionDestination.createExercise:
        context.push('/exercises/create');
    }
  }

  void _openWorkout(
    BuildContext context,
    WidgetRef ref,
    String id, {
    bool active = false,
  }) {
    final workouts = ref.read(workoutListProvider).value;
    WorkoutModel? workout;
    for (final item in workouts ?? const <WorkoutModel>[]) {
      if (item.id == id) {
        workout = item;
        break;
      }
    }
    if (workout == null) return;
    if (active) HapticFeedback.mediumImpact();
    context.push(
      '/workouts/workout/$id${active ? '/active' : ''}',
      extra: workout,
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.data,
    required this.bottomInset,
    required this.onRefresh,
    required this.onCreateWorkout,
    required this.onQuickAction,
    required this.onStart,
    required this.onRoutine,
    required this.onNotifications,
    required this.onSettings,
  });
  final TodayHomeViewData data;
  final double bottomInset;
  final Future<void> Function() onRefresh;
  final VoidCallback onCreateWorkout;
  final ValueChanged<HomeQuickActionViewData> onQuickAction;
  final ValueChanged<String> onStart;
  final ValueChanged<String> onRoutine;
  final VoidCallback onNotifications;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          sliver: SliverToBoxAdapter(
            child: TodayHeader(
              data: data.header,
              syncState: data.syncState,
              onNotifications: onNotifications,
              onSettings: onSettings,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: SliverToBoxAdapter(
            child: TodayHero(
              data: data.today,
              onOpen: data.today.workoutId == null
                  ? null
                  : () => onRoutine(data.today.workoutId!),
              onStart: data.today.workoutId == null
                  ? null
                  : () => onStart(data.today.workoutId!),
              onCreate: onCreateWorkout,
            ),
          ),
        ),
        if (data.programContext != null)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: ProgramContext(data: data.programContext!),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
          sliver: SliverToBoxAdapter(
            child: CalendarFeatureCard(data: data.calendar),
          ),
        ),
        _section(
          context,
          title: context.tr('home.insights.title'),
          child: InsightsRail(items: data.insights),
        ),
        _section(
          context,
          title: context.tr('home.actions.title'),
          child: QuickActionsRail(
            items: data.quickActions,
            onTap: onQuickAction,
          ),
        ),
        _section(
          context,
          title: context.tr('home.guides.title'),
          child: GuidesRail(items: data.guides),
        ),
        _section(
          context,
          title: context.tr('home.routines.title'),
          child: RoutinesRail(
            items: data.routines,
            onTap: (routine) => onRoutine(routine.id),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: bottomInset)),
      ],
    ),
  );

  SliverPadding _section(
    BuildContext context, {
    required String title,
    required Widget child,
  }) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
    sliver: SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(title: title),
          const SizedBox(height: 14),
          child,
        ],
      ),
    ),
  );
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: CoachlyAthleteTheme.pagePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: context.exerciseTheme.textSecondary,
            size: 30,
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('home.error.title'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.exerciseTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('home.error.body'),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.exerciseTheme.textSecondary),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(context.tr('common.retry')),
          ),
        ],
      ),
    ),
  );
}
