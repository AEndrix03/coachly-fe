import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_stats_provider/workout_stats_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/buttons/add_fab_button.dart';
import 'package:coachly/shared/widgets/sections/section_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/workout_card.dart';
import 'widgets/workout_empty_state.dart';
import 'widgets/workout_header.dart';
import 'widgets/workout_recent_card.dart';

class WorkoutPage extends ConsumerWidget {
  static const double _fabSize = 56;
  static const double _listBottomSpacerHeight = _fabSize + 10;
  static const double _recentCardsHeight = 304;

  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final workoutState = ref.watch(workoutListProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      floatingActionButton: workoutState.maybeWhen(
        data: (workouts) => workouts.isEmpty ? null : _buildFAB(context),
        orElse: () => _buildFAB(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(workoutListProvider);
          ref.invalidate(recentWorkoutsProvider);
          await ref.read(workoutListProvider.future);
        },
        child: workoutState.when(
          loading: () => _buildLoading(scheme),
          error: (err, stack) => _buildError(context, err),
          data: (workouts) {
            final recentWorkoutsState = ref.watch(recentWorkoutsProvider);
            final statsState = ref.watch(workoutStatsProvider);
            return _buildBody(
              context,
              ref,
              workouts,
              recentWorkoutsState,
              statsState,
              scheme,
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    List<WorkoutModel> workouts,
    AsyncValue<List<WorkoutModel>> recentWorkoutsState,
    WorkoutStatsState statsState,
    ColorScheme scheme,
  ) {
    final activeWorkouts = workouts.where((workout) => workout.active).toList();
    final archivedWorkouts = workouts
        .where((workout) => !workout.active)
        .toList();

    if (activeWorkouts.isEmpty && archivedWorkouts.isEmpty) {
      return _buildEmptyState(context, scheme);
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(
            stats: statsState.stats,
            isLoading: statsState.isLoading,
            onNotifications: () => _showNotifications(context, ref),
          ),
          const Gap(18),
          recentWorkoutsState.when(
            loading: () => _buildRecentLoading(scheme),
            error: (err, stack) => Text(err.toString()),
            data: (recent) {
              if (recent.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SectionBar(title: context.tr('workout.recent')),
                  ),
                  const Gap(10),
                  _buildRecentWorkouts(recent, scheme),
                ],
              );
            },
          ),
          const Gap(28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SectionBar(title: context.tr('workout.all'), icon: null),
          ),
          if (activeWorkouts.isEmpty)
            _buildNoActiveWorkouts(context)
          else
            _buildAllWorkouts(activeWorkouts, scheme),
          if (archivedWorkouts.isNotEmpty) ...[
            const Gap(20),
            _buildArchivedWorkouts(context, archivedWorkouts, scheme),
          ],
          const SizedBox(height: _listBottomSpacerHeight),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme scheme) {
    return const WorkoutEmptyState();
  }

  Widget _buildLoading(ColorScheme scheme) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: scheme.surface,
        highlightColor: scheme.primary.withValues(alpha: 0.2),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentLoading(ColorScheme scheme) {
    return SizedBox(
      height: _recentCardsHeight,
      child: Shimmer.fromColors(
        baseColor: scheme.surface,
        highlightColor: scheme.primary.withValues(alpha: 0.2),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            3,
            (index) => const SizedBox(
              width: 290,
              height: _recentCardsHeight,
              child: Card(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object err) {
    return Center(
      child: ShadAlert(
        title: Text(context.tr('common.error')),
        description: Text(err.toString()),
      ),
    );
  }

  Widget _buildRecentWorkouts(List<WorkoutModel> workouts, ColorScheme scheme) {
    return SizedBox(
      height: _recentCardsHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: workouts.length,
        separatorBuilder: (_, __) => const Gap(16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 290,
            child: WorkoutRecentCard(workout: workouts[index]),
          );
        },
      ),
    );
  }

  Widget _buildAllWorkouts(List<WorkoutModel> workouts, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: workouts.length,
        separatorBuilder: (_, __) => const Gap(11),
        itemBuilder: (context, i) => WorkoutCard(workout: workouts[i]),
      ),
    );
  }

  Widget _buildNoActiveWorkouts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Text(
        context.tr('workout.no_active'),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildArchivedWorkouts(
    BuildContext context,
    List<WorkoutModel> workouts,
    ColorScheme scheme,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18),
        childrenPadding: const EdgeInsets.only(bottom: 4),
        leading: Icon(
          Icons.inventory_2_outlined,
          color: scheme.onSurfaceVariant,
        ),
        title: Text(
          context.tr(
            'workout.archived_count',
            params: {'count': '${workouts.length}'},
          ),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(context.tr('workout.archived_hint')),
        children: [_buildAllWorkouts(workouts, scheme)],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return AddFabButton(
      size: _fabSize,
      onPressed: () => context.push('/workouts/workout/new/edit'),
    );
  }

  void _showNotifications(BuildContext context, WidgetRef ref) {
    ref
        .read(appToastServiceProvider)
        .showInfo(
          context,
          context.tr('workout.notifications_soon'),
          title: context.tr('workout.notifications'),
          duration: const Duration(seconds: 2),
        );
  }
}
