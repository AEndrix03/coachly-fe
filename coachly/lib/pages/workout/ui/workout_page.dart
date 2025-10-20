import 'package:coachly/pages/workout/ui/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import 'widgets/workout_card.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  const WorkoutPage({super.key});

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  final ScrollController _scrollController = ScrollController();
  double _headerHeight = 180;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final double offset = _scrollController.offset.clamp(0, 120);
    setState(() => _headerHeight = 180 - offset);
  }

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: _headerHeight,
              curve: Curves.easeOut,
              child: const WorkoutHeader(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final workout = workouts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: WorkoutCard(workout: workout),
                  );
                },
                childCount: workouts.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
