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

class WorkoutPage extends ConsumerStatefulWidget {
  const WorkoutPage({super.key});

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(workoutListProvider.notifier).loadWorkouts();
      // ref.read(workoutStatsProvider.notifier).loadStats(); // Commentato il caricamento delle stats
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [scheme.primary, scheme.secondary],
    );
    final workoutState = ref.watch(workoutListProvider);
    final statsState = ref.watch(workoutStatsProvider);
    return Scaffold(
      backgroundColor: scheme.surface,
      floatingActionButton: _buildFAB(context, scheme),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(workoutListProvider.notifier).refresh();
          await ref.read(workoutStatsProvider.notifier).refresh();
        },
        child: Container(
          color: scheme.surface,
          child: _buildBody(
            context,
            ref,
            workoutState,
            statsState,
            scheme,
            gradient,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    WorkoutListState workoutState,
    WorkoutStatsState statsState,
    ColorScheme scheme,
    LinearGradient gradient,
  ) {
    if (workoutState.hasError) {
      return Center(
        child: ShadAlert(
          title: Text('Errore'),
          description: Text(workoutState.errorMessage ?? 'Errore sconosciuto'),
        ),
      );
    }
    if (workoutState.isLoading && workoutState.workouts.isEmpty) {
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(
            stats: null, // statsState.stats,
            isLoading: false, // statsState.isLoading,
            onNotifications: () => _showNotifications(context),
          ),
          const Gap(18),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: WorkoutStatsOverview(
          //     stats: statsState.stats,
          //     isLoading: statsState.isLoading,
          //   ),
          // ),
          const Gap(28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SectionBar(title: 'Schede Recenti'),
          ),
          const Gap(10),
          _buildRecentWorkouts(workoutState.recentWorkouts, scheme),
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
          _buildAllWorkouts(workoutState.workouts, scheme),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildRecentWorkouts(List<WorkoutModel> workouts, ColorScheme scheme) {
    if (workouts.isEmpty) {
      return const SizedBox(
        height: 365,
        child: Center(
          child: Text(
            'Nessuna scheda recente',
            style: TextStyle(color: Color(0x80000000)),
          ),
        ),
      );
    }
    return SizedBox(
      height: 365,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: workouts.length,
        itemBuilder: (context, index) => SizedBox(
          width: 290,
          child: WorkoutRecentCard(workout: workouts[index]),
        ),
      ),
    );
  }

  Widget _buildAllWorkouts(List<WorkoutModel> workouts, ColorScheme scheme) {
    if (workouts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Nessuna scheda disponibile',
            style: TextStyle(color: Color(0x80000000)),
          ),
        ),
      );
    }
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

  void _showSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings'), duration: Duration(seconds: 1)),
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
