import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_stats_provider/workout_stats_provider.dart';
import 'package:coachly/shared/widgets/buttons/add_fab_button.dart';
import 'package:coachly/shared/widgets/buttons/glass_icon_button.dart';
import 'package:coachly/shared/widgets/sections/section_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/workout_card.dart';
import 'widgets/workout_header.dart';
import 'widgets/workout_recent_card.dart';

class WorkoutPage extends ConsumerWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final workoutState = ref.watch(workoutListProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      floatingActionButton: workoutState.maybeWhen(
        data: (workouts) =>
            workouts.isEmpty ? null : _buildFAB(context, scheme),
        orElse: () => _buildFAB(context, scheme),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(workoutListProvider);
          ref.invalidate(recentWorkoutsProvider);
          // ref.invalidate(workoutStatsProvider);
          await ref.read(workoutListProvider.future);
        },
        child: workoutState.when(
          loading: () => _buildLoading(scheme),
          error: (err, stack) => _buildError(err),
          data: (workouts) {
            final recentWorkoutsState = ref.watch(recentWorkoutsProvider);
            final statsState = ref.watch(workoutStatsProvider);
            return _buildBody(
              context,
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
    List<WorkoutModel> workouts,
    AsyncValue<List<WorkoutModel>> recentWorkoutsState,
    WorkoutStatsState statsState,
    ColorScheme scheme,
  ) {
    if (workouts.isEmpty) {
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
            onNotifications: () => _showNotifications(context),
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
                    child: SectionBar(title: 'Schede Recenti'),
                  ),
                  const Gap(10),
                  _buildRecentWorkouts(recent, scheme),
                ],
              );
            },
          ),
          const Gap(28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SectionBar(title: 'Tutte le Schede', icon: null),
              ),
              GlassIconButton(
                icon: Icons.edit_note,
                onPressed: () {
                  context.go('/workouts/organize');
                },
                marginRight: 8,
                iconColor: Colors.white,
                size: 20,
              ),
            ],
          ),
          _buildAllWorkouts(workouts, scheme),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Crea la tua prima scheda!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          ShadButton(
            onPressed: () {
              context.push('/workouts/workout/new/edit');
            },
            backgroundColor: scheme.primary,
            child: const Text('Iniziamo'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(ColorScheme scheme) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: scheme.surface,
        highlightColor: scheme.primary.withOpacity(0.2),
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
      height: 365,
      child: Shimmer.fromColors(
        baseColor: scheme.surface,
        highlightColor: scheme.primary.withOpacity(0.2),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            3,
            (index) => const SizedBox(width: 290, child: Card()),
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object err) {
    return Center(
      child: ShadAlert(
        title: Text('Errore'),
        description: Text(err.toString()),
      ),
    );
  }

  Widget _buildRecentWorkouts(List<WorkoutModel> workouts, ColorScheme scheme) {
    if (workouts.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 365,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final bool isLast = index == workouts.length - 1;
          return Row(
            children: [
              SizedBox(
                width: 290,
                child: WorkoutRecentCard(workout: workouts[index]),
              ),
              if (!isLast) const Gap(16),
            ],
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

  Widget _buildFAB(BuildContext context, ColorScheme scheme) {
    return AddFabButton(
      onPressed: () {
        context.push('/workouts/workout/new/edit');
      },
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifiche'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
