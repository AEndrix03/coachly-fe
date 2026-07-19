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

final workoutListSearchProvider = NotifierProvider<WorkoutListSearch, String>(
  WorkoutListSearch.new,
);
final workoutListSortProvider = NotifierProvider<WorkoutListSort, WorkoutSort>(
  WorkoutListSort.new,
);

class WorkoutListSearch extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

class WorkoutListSort extends Notifier<WorkoutSort> {
  @override
  WorkoutSort build() => WorkoutSort.lastUsed;

  void update(WorkoutSort value) => state = value;
}

class WorkoutPage extends ConsumerWidget {
  const WorkoutPage({super.key});

  static const double _fabSize = 56;
  static const double _listBottomSpacerHeight = _fabSize + 10;
  static const double _recentCardsHeight = 224;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final workoutState = ref.watch(workoutListProvider);
    final query = ref.watch(workoutListSearchProvider);
    final sort = ref.watch(workoutListSortProvider);

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
              query,
              sort,
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
    String query,
    WorkoutSort sort,
  ) {
    final activeWorkouts = _sortWorkouts(
      workouts.where((workout) => workout.active).toList(),
      sort,
    );
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
            onStatsTap: () => _showProgressOverview(context, statsState),
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
                    child: SectionBar(title: context.tr('workout.resume')),
                  ),
                  const Gap(10),
                  _buildResumeWorkout(recent.first, scheme),
                ],
              );
            },
          ),
          const Gap(28),
          _buildWorkoutListHeader(context, activeWorkouts.length, sort, ref),
          const Gap(10),
          _WorkoutSearchField(
            query: query,
            onChanged: (value) =>
                ref.read(workoutListSearchProvider.notifier).update(value),
          ),
          const Gap(12),
          if (_filterWorkouts(activeWorkouts, query).isEmpty)
            _buildNoActiveWorkouts(context, query)
          else
            _buildAllWorkouts(_filterWorkouts(activeWorkouts, query), scheme),
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

  Widget _buildResumeWorkout(WorkoutModel workout, ColorScheme scheme) {
    return SizedBox(
      height: _recentCardsHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: WorkoutRecentCard(workout: workout),
      ),
    );
  }

  Widget _buildWorkoutListHeader(
    BuildContext context,
    int count,
    WorkoutSort sort,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: SectionBar(
              title: context.tr(
                'workout.my_workouts_count',
                params: {'count': '$count'},
              ),
              icon: null,
            ),
          ),
          PopupMenuButton<WorkoutSort>(
            tooltip: context.tr('workout.sort'),
            onSelected: (value) =>
                ref.read(workoutListSortProvider.notifier).update(value),
            icon: const Icon(Icons.sort_rounded),
            itemBuilder: (context) => [
              _sortMenuItem(
                WorkoutSort.lastUsed,
                context.tr('workout.sort_recent'),
                sort,
              ),
              _sortMenuItem(
                WorkoutSort.name,
                context.tr('workout.sort_name'),
                sort,
              ),
              _sortMenuItem(
                WorkoutSort.progress,
                context.tr('workout.sort_progress'),
                sort,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<WorkoutSort> _sortMenuItem(
    WorkoutSort value,
    String label,
    WorkoutSort sort,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          if (sort == value)
            const Icon(Icons.check_rounded, size: 18)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 10),
          Text(label),
        ],
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

  Widget _buildNoActiveWorkouts(BuildContext context, String query) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Text(
        query.isEmpty
            ? context.tr('workout.no_active')
            : context.tr('workout.no_search_results'),
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

  List<WorkoutModel> _filterWorkouts(
    List<WorkoutModel> workouts,
    String rawQuery,
  ) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return workouts;
    return workouts.where((workout) {
      final title = workout.titleI18n?.values.join(' ').toLowerCase() ?? '';
      return title.contains(query) ||
          workout.goal.toLowerCase().contains(query) ||
          (workout.coachName?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  List<WorkoutModel> _sortWorkouts(
    List<WorkoutModel> workouts,
    WorkoutSort sort,
  ) {
    return [...workouts]..sort((a, b) {
      final aTitle = a.titleI18n?.values.isNotEmpty == true
          ? a.titleI18n!.values.first
          : '';
      final bTitle = b.titleI18n?.values.isNotEmpty == true
          ? b.titleI18n!.values.first
          : '';
      switch (sort) {
        case WorkoutSort.name:
          return aTitle.compareTo(bTitle);
        case WorkoutSort.progress:
          return b.progress.compareTo(a.progress);
        case WorkoutSort.lastUsed:
          return b.lastUsed.compareTo(a.lastUsed);
      }
    });
  }

  Future<void> _showProgressOverview(
    BuildContext context,
    WorkoutStatsState statsState,
  ) async {
    final stats = statsState.stats;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('workout.progress_overview'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(context.tr('workout.progress_overview_hint')),
            const SizedBox(height: 20),
            Text(
              '${stats?.completedWorkouts ?? 0} ${context.tr('workout.completed').toLowerCase()}',
            ),
            const SizedBox(height: 8),
            Text(
              '${stats?.activeWorkouts ?? 0} ${context.tr('workout.active_short').toLowerCase()}',
            ),
          ],
        ),
      ),
    );
  }
}

enum WorkoutSort { lastUsed, name, progress }

class _WorkoutSearchField extends StatefulWidget {
  const _WorkoutSearchField({required this.query, required this.onChanged});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<_WorkoutSearchField> createState() => _WorkoutSearchFieldState();
}

class _WorkoutSearchFieldState extends State<_WorkoutSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant _WorkoutSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: context.tr('workout.search_hint'),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: context.tr('workout.clear_search'),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() {});
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
