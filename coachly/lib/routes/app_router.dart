import '../features/workout/workout_edit_page/workout_edit_page.dart';
import '../features/workout/workout_organize_page/workout_organize_page.dart';
import 'package:coachly/features/workout/workout_page/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/common/navigation/widgets/navigation_bar.dart';
import '../features/exercise/exercise_info_page/exercise_info_page.dart';
import '../features/home/home.dart';
import '../features/workout/workout_active_page/workout_active_page.dart';
import '../features/workout/workout_detail_page/workout_detail_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/community',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workouts',
              builder: (context, state) => const WorkoutPage(),
              routes: [
                GoRoute(
                  path: 'organize',
                  pageBuilder: (context, state) => _fadeTransition(
                    state,
                    const WorkoutOrganizePage(),
                  ),
                ),
                GoRoute(
                  path: 'workout/:id',
                  pageBuilder: (context, state) => _fadeTransition(
                    state,
                    WorkoutDetailPage(id: state.pathParameters['id']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      pageBuilder: (context, state) => _fadeTransition(
                        state,
                        WorkoutEditPage(
                          workoutId: state.pathParameters['id']!,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: 'active',
                      pageBuilder: (context, state) => _fadeTransition(
                        state,
                        WorkoutActivePage(
                          workoutId: state.pathParameters['id']!,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: 'workout_exercise_page/:exerciseId',
                      pageBuilder: (context, state) => _fadeTransition(
                        state,
                        ExercisePage(id: state.pathParameters['exerciseId']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/coach',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _fadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
