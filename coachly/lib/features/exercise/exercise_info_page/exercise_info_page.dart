import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/exercise/exercise_info_page/widgets/exercise_header.dart';
import 'package:coachly/features/exercise/exercise_info_page/widgets/exercise_stats_cards.dart';
import 'package:coachly/features/exercise/exercise_info_page/widgets/exercise_video_section.dart';
import 'package:coachly/features/exercise/exercise_info_page/widgets/tabs/exercise_muscles_tab.dart';
import 'package:coachly/features/exercise/exercise_info_page/widgets/tabs/exercise_technique_tab.dart';
import 'package:coachly/features/exercise/exercise_info_page/widgets/tabs/exercise_variants_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ExercisePage extends ConsumerStatefulWidget {
  final String id;

  const ExercisePage({super.key, required this.id});

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(exerciseInfoProvider.notifier).loadExerciseDetail(widget.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    ref.read(exerciseInfoProvider.notifier).clearSelectedExercise();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseInfoProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        color: const Color(0xFF0F0F1E),
        child: _buildBody(context, state, scheme),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ExerciseInfoState state,
    ColorScheme scheme,
  ) {
    // 1. Error State
    if (state.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: scheme.error),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onSurface.withAlpha((255 * 0.7).toInt()),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(exerciseInfoProvider.notifier)
                    .loadExerciseDetail(widget.id),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Loading State
    if (state.isLoadingDetail || !state.hasSelectedExercise) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: const Color(0xFF1A1A2E),
          highlightColor: const Color(
            0xFF6C5CE7,
          ).withAlpha((255 * 0.2).toInt()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading exercise...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Content State
    final exercise = state.selectedExercise!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ExerciseHeader(
            onBack: () => Navigator.of(context).pop(),
            onShare: () {
              // TODO: Implement share functionality
            },
            onSave: () {
              // TODO: Implement save functionality
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ExerciseVideoSection(
                videoUrl: exercise.videoUrl,
                exerciseName: exercise.name,
                tags: exercise.tags,
              ),
              const SizedBox(height: 24),
              ExerciseStatsCards(
                difficulty: exercise.difficulty,
                mechanics: exercise.mechanics,
                type: exercise.type,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.secondary],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withAlpha((255 * 0.3).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: scheme.onPrimary,
              unselectedLabelColor: scheme.onSurface.withAlpha(
                (255 * 0.5).toInt(),
              ),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Tecnica'),
                Tab(text: 'Muscoli'),
                Tab(text: 'Varianti'),
              ],
            ),
          ),
          pinned: true,
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              ExerciseTechniqueTab(
                description: exercise.description,
                techniqueSteps: exercise.techniqueSteps,
              ),
              ExerciseMusclesTab(
                primaryMuscles: exercise.primaryMuscles,
                secondaryMuscles: exercise.secondaryMuscles,
              ),
              ExerciseVariantsTab(variants: exercise.variants),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height + 16.0;

  @override
  double get maxExtent => _tabBar.preferredSize.height + 16.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: const Color(0xFF0F0F1E),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withAlpha((255 * 0.5).toInt()),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.onSurface.withAlpha((255 * 0.1).toInt()),
            width: 1,
          ),
        ),
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
