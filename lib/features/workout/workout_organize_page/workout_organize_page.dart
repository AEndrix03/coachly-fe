import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_organize_page/widgets/organize_workout_card.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/providers/workout_list_provider/workout_list_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:coachly/shared/widgets/buttons/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutOrganizePage extends ConsumerStatefulWidget {
  const WorkoutOrganizePage({super.key});

  @override
  ConsumerState<WorkoutOrganizePage> createState() =>
      _WorkoutOrganizePageState();
}

class _WorkoutOrganizePageState extends ConsumerState<WorkoutOrganizePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final workoutState = ref.watch(workoutListProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          _buildHeader(context),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: context.tr('workout.organize.active')),
              Tab(text: context.tr('workout.organize.inactive')),
            ],
          ),
          Expanded(
            child: workoutState.when(
              loading: () => _buildLoading(scheme),
              error: (err, stack) => _buildError(err),
              data: (workouts) {
                final activeWorkouts = workouts.where((w) => w.active).toList();
                final inactiveWorkouts = workouts
                    .where((w) => !w.active)
                    .toList();
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWorkoutList(context, activeWorkouts, scheme),
                    _buildWorkoutList(context, inactiveWorkouts, scheme),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF7B4BC1)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      context.pop();
                    },
                    iconColor: Colors.white,
                    size: 20,
                    marginRight: 0,
                  ),
                  GlassIconButton(
                    icon: Icons.save,
                    onPressed: () {
                      // TODO: Implement save functionality
                    },
                    iconColor: Colors.white,
                    size: 20,
                    marginRight: 0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text(
                context.tr('workout.organize.title'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutList(
    BuildContext context,
    List<WorkoutModel> workouts,
    ColorScheme scheme,
  ) {
    final locale = ref.watch(languageProvider);
    if (workouts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            context.tr('workout.organize.empty'),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return OrganizeWorkoutCard(
          workout: workout,
          onDelete: () async {
            final confirmed = await _showConfirmationDialog(
              context,
              context.tr('workout.organize.delete_title'),
              context.tr(
                'workout.organize.delete_content',
                params: {'name': workout.titleI18n?.fromI18n(locale) ?? ''},
              ),
              destructive: true,
            );
            if (confirmed) {
              ref.read(workoutListProvider.notifier).deleteWorkout(workout.id);
            }
          },
          onToggleActive: (isActive) async {
            final action = context.tr(
              isActive
                  ? 'workout.organize.action_activate'
                  : 'workout.organize.action_deactivate',
            );
            final confirmed = await _showConfirmationDialog(
              context,
              context.tr('workout.organize.status_title'),
              context.tr(
                'workout.organize.status_content',
                params: {
                  'action': action,
                  'name': workout.titleI18n?.fromI18n(locale) ?? '',
                },
              ),
            );
            if (confirmed) {
              if (isActive) {
                ref
                    .read(workoutListProvider.notifier)
                    .enableWorkout(workout.id);
              } else {
                ref
                    .read(workoutListProvider.notifier)
                    .disableWorkout(workout.id);
              }
            }
          },
          onEdit: () {
            context.push(
              '/workouts/workout/${workout.id}/edit',
              extra: workout,
            );
          },
        );
      },
    );
  }

  Widget _buildLoading(ColorScheme scheme) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: scheme.surface,
        highlightColor: scheme.primary.withValues(alpha: 0.2),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object err) {
    return Center(
      child: ShadAlert(
        title: Text(context.tr('common.error')),
        description: Text(err.toString()),
      ),
    );
  }
}

Future<bool> _showConfirmationDialog(
  BuildContext context,
  String title,
  String content, {
  bool destructive = false,
}) async {
  return showAppConfirmationDialog(
    context,
    title: title,
    content: content,
    confirmLabel: context.tr('common.confirm'),
    destructive: destructive,
    icon: destructive
        ? Icons.delete_outline_rounded
        : Icons.help_outline_rounded,
  );
}
