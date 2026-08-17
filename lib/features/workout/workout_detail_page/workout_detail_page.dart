import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_content.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutDetailPage extends ConsumerWidget {
  final WorkoutModel workout;

  const WorkoutDetailPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolved = ref
        .watch(workoutListProvider)
        .maybeWhen(
          data: (workouts) =>
              workouts.where((item) => item.id == workout.id).firstOrNull ??
              workout,
          orElse: () => workout,
        );
    final locale = ref.watch(languageProvider);
    final viewData = WorkoutDetailAdapter.fromWorkout(resolved, locale);

    return Scaffold(
      backgroundColor: CoachlyAthleteTheme.background,
      body: RefreshIndicator(
        color: CoachlyAthleteTheme.primary,
        onRefresh: () async => ref.invalidate(workoutListProvider),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _WorkoutSliverHeader(
              title: viewData.title,
              onBack: () => context.pop(),
              onEdit: () => _openEditor(context, resolved),
            ),
            SliverToBoxAdapter(child: WorkoutIdentity(workout: viewData)),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
            SliverToBoxAdapter(child: WorkoutSummaryStrip(workout: viewData)),
            if (viewData.goal != null) ...[
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: WorkoutGoalSection(goal: viewData.goal!),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
            SliverToBoxAdapter(
              child: Padding(
                padding: CoachlyAthleteTheme.pagePadding,
                child: FilledButton.icon(
                  onPressed: viewData.exerciseCount == 0
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          context.go(
                            '/workouts/workout/${resolved.id}/active',
                            extra: resolved,
                          );
                        },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor: CoachlyAthleteTheme.primary,
                    disabledBackgroundColor:
                        CoachlyAthleteTheme.surfaceElevated,
                    foregroundColor: CoachlyAthleteTheme.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    context.tr('workout.start'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
            SliverToBoxAdapter(
              child: WorkoutStructure(
                workout: viewData,
                onEdit: () => _openEditor(context, resolved),
                onOpenExercise: (exercise) =>
                    context.push('/exercises/${exercise.exerciseId}'),
                onAddExercise: () => _openEditor(context, resolved),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(
              child: WorkoutProgrammingDetails(workout: viewData),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(
              child: WorkoutConceptsSection(workout: viewData),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 36 + MediaQuery.paddingOf(context).bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, WorkoutModel resolved) {
    context.push('/workouts/workout/${resolved.id}/edit', extra: resolved);
  }
}

class _WorkoutSliverHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const _WorkoutSliverHeader({
    required this.title,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: CoachlyAthleteTheme.background,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      actions: [
        TextButton(
          onPressed: onEdit,
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 44),
            foregroundColor: CoachlyAthleteTheme.primary,
          ),
          child: Text(context.tr('common.edit')),
        ),
        PopupMenuButton<String>(
          tooltip: context.tr('workout.actions'),
          icon: const Icon(Icons.more_horiz_rounded),
          color: CoachlyAthleteTheme.surfaceElevated,
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'duplicate',
              child: Text(context.tr('common.duplicate')),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                context.tr('common.delete'),
                style: const TextStyle(color: CoachlyAthleteTheme.danger),
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = MediaQuery.paddingOf(context).top;
          final opacity = ((88 - constraints.maxHeight + top) / 20).clamp(
            0.0,
            1.0,
          );
          return Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              child: Opacity(
                opacity: opacity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(72, 0, 120, 17),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CoachlyAthleteTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
