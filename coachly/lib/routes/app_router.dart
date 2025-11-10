import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/home.dart';
import '../pages/workout/ui/detail/workout_detail_page.dart';
import '../pages/workout/ui/exercise/exercise_page.dart';
import '../pages/workout/ui/workout_page.dart';
import '../widgets/navigation/navigation_bar.dart';

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
                  path: 'workout/:id',
                  pageBuilder: (context, state) => _fadeTransition(
                    state,
                    WorkoutDetailPage(id: state.pathParameters['id']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'exercise/:exerciseId',
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
