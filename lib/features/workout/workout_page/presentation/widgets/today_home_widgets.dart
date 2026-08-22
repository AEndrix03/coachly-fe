import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/design_system/coachly_surface.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

import '../models/today_home_view_data.dart';

class TodayHeader extends StatelessWidget {
  const TodayHeader({
    super.key,
    required this.data,
    required this.syncState,
    required this.onNotifications,
    required this.onSettings,
  });
  final TodayHeaderViewData data;
  final HomeSyncState syncState;
  final VoidCallback onNotifications;
  final VoidCallback onSettings;
  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final greeting = data.firstName.isEmpty
        ? context.tr('home.header.greeting_generic')
        : context.tr('home.header.greeting', params: {'name': data.firstName});
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                context.tr('home.header.subtitle'),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
        if (syncState != HomeSyncState.synced) _SyncStatus(state: syncState),
        IconButton(
          onPressed: onNotifications,
          tooltip: context.tr('workout.notifications'),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          onPressed: onSettings,
          tooltip: context.tr('common.settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}

class _SyncStatus extends StatelessWidget {
  const _SyncStatus({required this.state});
  final HomeSyncState state;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 4),
    child: Semantics(
      label: context.tr(
        state == HomeSyncState.offline
            ? 'home.sync.offline'
            : 'home.sync.syncing',
      ),
      child: Icon(
        state == HomeSyncState.offline
            ? Icons.cloud_off_outlined
            : Icons.sync_rounded,
        size: 18,
        color: context.exerciseTheme.textSecondary,
      ),
    ),
  );
}

class TodayHero extends StatelessWidget {
  const TodayHero({
    super.key,
    required this.data,
    required this.onStart,
    required this.onCreate,
  });
  final HomeTodayViewData data;
  final VoidCallback? onStart;
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : CoachlyAthleteTheme.expandDuration,
    child: Container(
      key: ValueKey(data.kind),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.exerciseTheme.surface,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        border: Border.all(
          color: context.exerciseTheme.primary.withValues(alpha: .22),
        ),
      ),
      child: switch (data.kind) {
        HomeTrainingStateKind.noTrainingConfigured => _NoTraining(
          onCreate: onCreate,
        ),
        HomeTrainingStateKind.restDay => _PassiveToday(
          data: data,
          eyebrowKey: 'home.today.title',
          titleKey: 'home.today.recovery_day',
        ),
        HomeTrainingStateKind.plannedBreak => _PassiveToday(
          data: data,
          eyebrowKey: 'home.today.planned_break',
          titleKey: 'home.today.program_paused',
        ),
        _ => _ActionToday(data: data, onStart: onStart),
      },
    ),
  );
}

class _ActionToday extends StatelessWidget {
  const _ActionToday({required this.data, required this.onStart});
  final HomeTodayViewData data;
  final VoidCallback? onStart;
  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final inProgress = data.kind == HomeTrainingStateKind.activeWorkout;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(
          context.tr(
            inProgress ? 'home.today.in_progress' : 'home.today.title',
          ),
        ),
        const SizedBox(height: 13),
        Text(
          data.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
            height: 1.02,
          ),
        ),
        if (data.contextLabel != null) ...[
          const SizedBox(height: 9),
          Text(
            data.contextLabel!,
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        if (data.focusLabel?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 9),
          Text(
            data.focusLabel!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: colors.textSecondary, height: 1.35),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          inProgress
              ? context.tr(
                  'home.today.progress_metadata',
                  params: {
                    'minutes': '${data.durationMinutes ?? 0}',
                    'done': '${data.completedExercises ?? 0}',
                    'total': '${data.totalExercises ?? 0}',
                  },
                )
              : context.tr(
                  'home.today.training_metadata',
                  params: {
                    'minutes': '${data.durationMinutes ?? 0}',
                    'sets': '${data.workingSets ?? 0}',
                  },
                ),
          style: TextStyle(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(
                CoachlyAthleteTheme.primaryActionHeight,
              ),
              backgroundColor: colors.primary,
              foregroundColor: colors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  CoachlyAthleteTheme.actionRadius,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.tr(
                    inProgress
                        ? 'home.today.resume_workout'
                        : 'home.today.start_workout',
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 19),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PassiveToday extends StatelessWidget {
  const _PassiveToday({
    required this.data,
    required this.eyebrowKey,
    required this.titleKey,
  });
  final HomeTodayViewData data;
  final String eyebrowKey;
  final String titleKey;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Eyebrow(context.tr(eyebrowKey)),
      const SizedBox(height: 13),
      Text(
        context.tr(titleKey),
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: context.exerciseTheme.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      if (data.nextSessionLabel != null) ...[
        const SizedBox(height: 14),
        Text(
          data.nextSessionLabel!,
          style: TextStyle(color: context.exerciseTheme.textSecondary),
        ),
      ],
    ],
  );
}

class _NoTraining extends StatelessWidget {
  const _NoTraining({required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Eyebrow(context.tr('home.today.title')),
      const SizedBox(height: 13),
      Text(
        context.tr('home.empty.title'),
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: context.exerciseTheme.textPrimary,
          fontWeight: FontWeight.w800,
          height: 1.05,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        context.tr('home.empty.body'),
        style: TextStyle(
          color: context.exerciseTheme.textSecondary,
          height: 1.45,
        ),
      ),
      const SizedBox(height: 22),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onCreate,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(
              CoachlyAthleteTheme.primaryActionHeight,
            ),
            backgroundColor: context.exerciseTheme.primary,
            foregroundColor: context.exerciseTheme.background,
          ),
          child: Text(
            context.tr('home.action.create_workout'),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    ],
  );
}

class ProgramContext extends StatelessWidget {
  const ProgramContext({super.key, required this.data});
  final HomeProgramContextViewData data;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.programName,
                style: TextStyle(
                  color: context.exerciseTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              data.positionLabel,
              style: TextStyle(
                color: context.exerciseTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < data.steps.length; i++) ...[
                _ProgramStep(data: data.steps[i]),
                if (i != data.steps.length - 1)
                  Container(
                    width: 22,
                    height: 1,
                    color: context.exerciseTheme.border,
                  ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _ProgramStep extends StatelessWidget {
  const _ProgramStep({required this.data});
  final HomeProgramStepViewData data;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        data.isComplete
            ? Icons.check_circle_rounded
            : data.isToday
            ? Icons.radio_button_checked_rounded
            : Icons.circle_outlined,
        size: 15,
        color: data.isToday || data.isComplete
            ? context.exerciseTheme.primary
            : context.exerciseTheme.textSecondary,
      ),
      const SizedBox(width: 5),
      Text(
        data.label,
        style: TextStyle(
          color: data.isToday
              ? context.exerciseTheme.textPrimary
              : context.exerciseTheme.textSecondary,
          fontSize: 12,
          fontWeight: data.isToday ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ],
  );
}

class AtAGlanceSection extends StatelessWidget {
  const AtAGlanceSection({
    super.key,
    required this.calendar,
    required this.goal,
  });
  final HomeCalendarPreviewViewData calendar;
  final HomeGoalPreviewViewData goal;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final sideBySide =
          constraints.maxWidth >= 680 &&
          MediaQuery.textScalerOf(context).scale(1) <= 1.2;
      if (sideBySide)
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: CalendarFeatureCard(data: calendar)),
            const SizedBox(width: 12),
            Expanded(child: GoalFeatureCard(data: goal)),
          ],
        );
      final width = (constraints.maxWidth * .86).clamp(280.0, 390.0);
      return SizedBox(
        height: goal.hasGoal ? 238 : 210,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              width: width,
              child: CalendarFeatureCard(data: calendar),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width,
              child: GoalFeatureCard(data: goal),
            ),
          ],
        ),
      );
    },
  );
}

class CalendarFeatureCard extends StatelessWidget {
  const CalendarFeatureCard({super.key, required this.data});
  final HomeCalendarPreviewViewData data;
  @override
  Widget build(BuildContext context) => _FeatureSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(context.tr('home.calendar.title')),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: data.days.map((day) => _CalendarDay(data: day)).toList(),
        ),
        if (data.nextWorkoutTitle != null) ...[
          const SizedBox(height: 17),
          Text(
            context.tr('home.calendar.next').toUpperCase(),
            style: TextStyle(
              color: context.exerciseTheme.textSecondary,
              fontSize: 10,
              letterSpacing: .8,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${data.nextWorkoutTitle} · ${data.nextWorkoutWhen}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.exerciseTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    ),
  );
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({required this.data});
  final HomeCalendarDayViewData data;
  @override
  Widget build(BuildContext context) {
    final l = MaterialLocalizations.of(context);
    return Semantics(
      selected: data.isToday,
      label: l.formatFullDate(data.date),
      child: Column(
        children: [
          Text(
            l.narrowWeekdays[data.date.weekday % 7],
            style: TextStyle(
              color: context.exerciseTheme.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 29,
            height: 29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: data.isToday
                  ? context.exerciseTheme.primary
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${data.date.day}',
              style: TextStyle(
                color: data.isToday
                    ? context.exerciseTheme.background
                    : context.exerciseTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Icon(
            data.isComplete
                ? Icons.check_rounded
                : data.isToday
                ? Icons.circle
                : data.hasTraining
                ? Icons.circle_outlined
                : Icons.remove_rounded,
            color: data.isToday || data.isComplete
                ? context.exerciseTheme.primary
                : context.exerciseTheme.textSecondary,
            size: data.isToday ? 7 : 12,
          ),
        ],
      ),
    );
  }
}

class GoalFeatureCard extends StatelessWidget {
  const GoalFeatureCard({super.key, required this.data});
  final HomeGoalPreviewViewData data;
  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : CoachlyAthleteTheme.expandDuration,
    child: _FeatureSurface(
      child: data.hasGoal ? _PopulatedGoal(data: data) : const _EmptyGoal(),
    ),
  );
}

class _PopulatedGoal extends StatelessWidget {
  const _PopulatedGoal({required this.data});
  final HomeGoalPreviewViewData data;
  @override
  Widget build(BuildContext context) => Semantics(
    label:
        '${data.exerciseName}, ${data.currentDisplay}, ${data.targetDisplay}',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(context.tr('home.goal.title')),
        const SizedBox(height: 13),
        Text(
          data.exerciseName!,
          style: TextStyle(
            color: context.exerciseTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          data.targetDisplay!,
          style: TextStyle(
            color: context.exerciseTheme.textPrimary,
            fontSize: 29,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          data.currentDisplay!,
          style: TextStyle(
            color: context.exerciseTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: data.progress!.clamp(0, 1)),
          duration: const Duration(milliseconds: 420),
          builder: (_, value, __) => LinearProgressIndicator(
            value: value,
            minHeight: 5,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: context.exerciseTheme.surfaceElevated,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          data.remainingDisplay!,
          style: TextStyle(
            color: context.exerciseTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _EmptyGoal extends StatelessWidget {
  const _EmptyGoal();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _Eyebrow(context.tr('home.goal.title')),
      const SizedBox(height: 14),
      Icon(Icons.flag_outlined, color: context.exerciseTheme.primary, size: 25),
      const SizedBox(height: 12),
      Text(
        context.tr('home.goal.empty_title'),
        style: TextStyle(
          color: context.exerciseTheme.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        context.tr('home.goal.empty_body'),
        style: TextStyle(
          color: context.exerciseTheme.textSecondary,
          height: 1.35,
        ),
      ),
    ],
  );
}

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      color: context.exerciseTheme.textPrimary,
      fontWeight: FontWeight.w800,
    ),
  );
}

class InsightsRail extends StatelessWidget {
  const InsightsRail({super.key, required this.items});
  final List<HomeInsightViewData> items;
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return _LearningInsight();
    return SizedBox(
      height: 176,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) =>
            SizedBox(width: 276, child: InsightCard(data: items[index])),
      ),
    );
  }
}

class _LearningInsight extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    decoration: BoxDecoration(
      color: context.exerciseTheme.surface,
      borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          color: context.exerciseTheme.info,
          size: 21,
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('home.insights.learning_title'),
                style: TextStyle(
                  color: context.exerciseTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                context.tr('home.insights.learning_body'),
                style: TextStyle(
                  color: context.exerciseTheme.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.data});
  final HomeInsightViewData data;
  @override
  Widget build(BuildContext context) {
    final color = switch (data.tone) {
      HomeInsightTone.progress => context.exerciseTheme.primary,
      HomeInsightTone.watch => context.exerciseTheme.warning,
      HomeInsightTone.coachly => context.exerciseTheme.info,
      HomeInsightTone.neutral => context.exerciseTheme.textSecondary,
      HomeInsightTone.danger => Theme.of(context).colorScheme.error,
    };
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: context.exerciseTheme.surface,
        borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.eyebrow.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10,
              letterSpacing: .8,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.exerciseTheme.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: Text(
              data.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.exerciseTheme.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionsRail extends StatelessWidget {
  const QuickActionsRail({super.key, required this.items, required this.onTap});
  final List<HomeQuickActionViewData> items;
  final ValueChanged<HomeQuickActionViewData> onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 132,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, index) =>
          QuickActionTile(data: items[index], onTap: () => onTap(items[index])),
    ),
  );
}

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.data, required this.onTap});
  final HomeQuickActionViewData data;
  final VoidCallback onTap;
  IconData get icon => switch (data.destination) {
    HomeQuickActionDestination.createWorkout => Icons.add_rounded,
    HomeQuickActionDestination.createExercise =>
      Icons.sports_gymnastics_rounded,
    HomeQuickActionDestination.emptyWorkout => Icons.bolt_rounded,
  };
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 104,
    child: CoachlyPressable(
      onTap: onTap,
      semanticLabel: context.tr(data.labelKey),
      child: Container(
        constraints: const BoxConstraints(minHeight: 108),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: context.exerciseTheme.surface,
          borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.exerciseTheme.primaryMuted.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: context.exerciseTheme.primary, size: 22),
            ),
            const Spacer(),
            Text(
              context.tr(data.labelKey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.exerciseTheme.textPrimary,
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class GuidesRail extends StatelessWidget {
  const GuidesRail({super.key, required this.items});
  final List<HomeGuideViewData> items;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 224,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, index) => GuideCard(data: items[index]),
    ),
  );
}

class GuideCard extends StatelessWidget {
  const GuideCard({super.key, required this.data});
  final HomeGuideViewData data;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 244,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
      child: ColoredBox(
        color: context.exerciseTheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    data.assetPath,
                    fit: BoxFit.cover,
                    cacheWidth: 520,
                  ),
                  Positioned(
                    right: 9,
                    bottom: 8,
                    child: _DurationPill(duration: data.duration),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(data.titleKey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.exerciseTheme.textPrimary,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      context.tr(data.levelKey),
                      style: TextStyle(
                        color: context.exerciseTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DurationPill extends StatelessWidget {
  const _DurationPill({required this.duration});
  final Duration duration;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .72),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class RoutinesRail extends StatelessWidget {
  const RoutinesRail({super.key, required this.items, required this.onTap});
  final List<HomeRoutineViewData> items;
  final ValueChanged<HomeRoutineViewData> onTap;
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty)
      return _FeatureSurface(
        child: Text(
          context.tr('home.routines.empty_body'),
          style: TextStyle(color: context.exerciseTheme.textSecondary),
        ),
      );
    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) =>
            RoutineCard(data: items[index], onTap: () => onTap(items[index])),
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  const RoutineCard({super.key, required this.data, required this.onTap});
  final HomeRoutineViewData data;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 285,
    child: CoachlyPressable(
      onTap: onTap,
      semanticLabel: data.title,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: context.exerciseTheme.surface,
          borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.exerciseTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                color: context.exerciseTheme.primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.exerciseTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr(
                      'home.routines.metadata',
                      params: {
                        'exercises': '${data.exerciseCount}',
                        'minutes': '${data.durationMinutes}',
                      },
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.exerciseTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _lastUsed(context),
                    style: TextStyle(
                      color: context.exerciseTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: context.exerciseTheme.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    ),
  );
  String _lastUsed(BuildContext context) {
    final days = DateTime.now().difference(data.lastUsed).inDays;
    return context.tr(
      days <= 1 ? 'home.routines.last_yesterday' : 'home.routines.last_days',
      params: {'days': '$days'},
    );
  }
}

class TodayHomeSkeleton extends StatelessWidget {
  const TodayHomeSkeleton({super.key});
  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        sliver: SliverList.list(
          children: const [
            _Skeleton(minHeight: 56),
            SizedBox(height: 24),
            _Skeleton(minHeight: 240),
            SizedBox(height: 32),
            _Skeleton(minHeight: 190),
            SizedBox(height: 32),
            _Skeleton(minHeight: 110),
          ],
        ),
      ),
    ],
  );
}

class _FeatureSurface extends StatelessWidget {
  const _FeatureSurface({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.exerciseTheme.surface,
      borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
      border: Border.all(color: context.exerciseTheme.border),
    ),
    child: child,
  );
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.minHeight});
  final double minHeight;
  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(minHeight: minHeight),
    decoration: BoxDecoration(
      color: context.exerciseTheme.surface,
      borderRadius: BorderRadius.circular(CoachlyAthleteTheme.cardRadius),
    ),
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      color: context.exerciseTheme.textSecondary,
      fontSize: 11,
      letterSpacing: .9,
      fontWeight: FontWeight.w800,
    ),
  );
}
