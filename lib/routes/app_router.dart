import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/auth/pages/loading_page/loading_page.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/pages/login_page/login_page.dart';
import '../features/common/navigation/widgets/navigation_bar.dart';
import '../features/coach/presentation/coach_discovery_page.dart';
import '../features/exercise/personal_exercises_page/personal_exercises_page.dart';
import '../features/exercise/exercise_info_page/exercise_info_page.dart';
import '../features/feedback/feedback_page.dart';
import '../features/home/home.dart';
import '../features/profile/profile_page.dart';
import '../features/workout/workout_active_page/workout_active_page.dart';
import '../features/workout/workout_detail_page/workout_detail_page.dart';
import '../features/workout/workout_edit_page/workout_edit_page.dart';
import '../features/workout/workout_organize_page/workout_organize_page.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/loading',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final canAccessApp = authState.value?.canAccessApp == true;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnLoading = state.matchedLocation == '/loading';

      if (isLoading) {
        return isOnLoading ? null : '/loading';
      }

      if (!canAccessApp) {
        return isOnLogin ? null : '/login';
      }

      if (isOnLogin || isOnLoading) {
        return '/workouts';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
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
                    pageBuilder: (context, state) =>
                        _fadeTransition(state, const WorkoutOrganizePage()),
                  ),
                  GoRoute(
                    path: 'workout/:id',
                    pageBuilder: (context, state) {
                      final workout = state.extra as WorkoutModel?;
                      if (workout == null) {
                        return _fadeTransition(state, const WorkoutPage());
                      }
                      return _fadeTransition(
                        state,
                        WorkoutDetailPage(workout: workout),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        pageBuilder: (context, state) {
                          final workout = state.extra as WorkoutModel?;
                          return _fadeTransition(
                            state,
                            WorkoutEditPage(
                              workoutId: state.pathParameters['id']!,
                              workout: workout,
                            ),
                          );
                        },
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
                path: '/coach',
                builder: (context, state) => const CoachDiscoveryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/feedback',
                builder: (context, state) => const FeedbackPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'personal-exercises',
                    pageBuilder: (context, state) =>
                        _fadeTransition(state, const PersonalExercisesPage()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

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
    // Static layout: body is constrained above the navbar — no content overlap.
    // Flutter automatically positions FABs and handles safe-area insets.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(navigationShell: navigationShell),
    );
  }
}
