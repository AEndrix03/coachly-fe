import 'package:coachly/app/router/routes.dart';
import 'package:coachly/core/flags/feature_flags.dart';
import 'package:coachly/core/observability/debug_screen.dart';
import 'package:coachly/features/auth/pages/loading_page/loading_page.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/workout/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/workout_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coachly/features/auth/pages/login_page/login_page.dart';
import 'package:coachly/features/common/navigation/widgets/navigation_bar.dart';
import 'package:coachly/features/exercise/exercise_create_page/exercise_create_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/exercise_info_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_biomechanics_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_muscles_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_variants_page.dart';
import 'package:coachly/features/exercise/personal_exercises_page/personal_exercises_page.dart';
import 'package:coachly/features/home/home.dart';
import 'package:coachly/features/profile/profile_page.dart';
import 'package:coachly/features/workout/workout_active_page/workout_active_page.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/workout_completion_page.dart';
import 'package:coachly/features/workout/workout_builder/create_workout_flow.dart';
import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_check/workout_check_page.dart';
import 'package:coachly/features/workout/add_exercise_page/add_exercise_page.dart';
import 'package:coachly/features/workout/workout_detail_page/workout_detail_page.dart';
import 'package:coachly/features/workout/workout_edit_page/workout_edit_page.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/loading',
    redirect: (context, state) {
      // La diagnostica deve restare raggiungibile anche — soprattutto — quando
      // e' l'autenticazione a non funzionare (`18-observability.md`).
      if (state.matchedLocation == DebugScreen.routePath) return null;

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
        return AppTab.workouts.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      // Non compare in nessuna navigazione: si raggiunge digitando la rotta.
      // Nelle build release il flag e' spento e la rotta non esiste.
      if (FeatureFlags.isEnabled(FeatureFlag.debugScreen))
        GoRoute(
          path: DebugScreen.routePath,
          builder: (context, state) => const DebugScreen(),
        ),
      GoRoute(
        path: '/exercises/create',
        builder: (context, state) => const ExerciseCreatePage(),
      ),
      GoRoute(
        path: '/exercises/:exerciseId',
        pageBuilder: (context, state) => _fadeTransition(
          state,
          ExercisePage(
            id: state.pathParameters['exerciseId']!,
            showAddButton: state.uri.queryParameters['mode'] != 'view',
          ),
        ),
        routes: [
          GoRoute(
            path: 'biomechanics',
            pageBuilder: (context, state) => _exerciseDetailTransition(
              context,
              state,
              ExerciseBiomechanicsPage(
                exerciseId: state.pathParameters['exerciseId']!,
              ),
            ),
          ),
          GoRoute(
            path: 'muscles',
            pageBuilder: (context, state) => _exerciseDetailTransition(
              context,
              state,
              ExerciseMusclesPage(
                exerciseId: state.pathParameters['exerciseId']!,
              ),
            ),
          ),
          GoRoute(
            path: 'variants',
            pageBuilder: (context, state) => _exerciseDetailTransition(
              context,
              state,
              ExerciseVariantsPage(
                exerciseId: state.pathParameters['exerciseId']!,
              ),
            ),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [for (final tab in AppTab.values) _branchFor(tab)],
      ),
    ],
  );
}

/// Genera il branch di un tab. La lista dei tab vive in `AppTab`: qui si
/// descrivono solo la pagina root e le rotte figlie di ciascuno.
StatefulShellBranch _branchFor(AppTab tab) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: tab.path,
        builder: (context, state) => switch (tab) {
          AppTab.community => const HomeScreen(),
          AppTab.workouts => const WorkoutPage(),
          AppTab.profile => const ProfilePage(),
        },
        routes: switch (tab) {
          AppTab.community => _communityRoutes,
          AppTab.workouts => _workoutRoutes,
          AppTab.profile => _profileRoutes,
        },
      ),
    ],
  );
}

final List<RouteBase> _communityRoutes = [
  GoRoute(
    path: 'workout-completed',
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (context, state) =>
        _athleteTransition(state, const WorkoutCompletionPage()),
  ),
];

final List<RouteBase> _workoutRoutes = [
  GoRoute(
    path: 'workout/:id',
    pageBuilder: (context, state) {
      final workout = state.extra as WorkoutModel?;
      if (workout == null) {
        return _fadeTransition(state, const WorkoutPage());
      }
      return _fadeTransition(state, WorkoutDetailPage(workout: workout));
    },
    routes: [
      GoRoute(
        path: 'check',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final draft = state.extra as WorkoutDraft?;
          if (draft == null) {
            return _fadeTransition(state, const WorkoutPage());
          }
          return _athleteTransition(state, WorkoutCheckPage(draft: draft));
        },
      ),
      GoRoute(
        path: 'add-exercise',
        pageBuilder: (context, state) => _athleteTransition(
          state,
          AddExercisePage(workoutId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: 'edit',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          if (state.pathParameters['id'] == 'new') {
            return _fadeTransition(state, const CreateWorkoutFlow());
          }
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
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _athleteTransition(
          state,
          WorkoutActivePage(workoutId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: 'workout_exercise_page/:exerciseId',
        pageBuilder: (context, state) => _athleteTransition(
          state,
          ExercisePage(
            id: state.pathParameters['exerciseId']!,
            showAddButton: false,
          ),
        ),
      ),
    ],
  ),
];

final List<RouteBase> _profileRoutes = [
  GoRoute(
    path: 'personal-exercises',
    pageBuilder: (context, state) =>
        _fadeTransition(state, const PersonalExercisesPage()),
  ),
];

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

CustomTransitionPage<void> _athleteTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(.08, 0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: Tween<double>(begin: .92, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

Page<void> _exerciseDetailTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return CupertinoPage<void>(key: state.pageKey, child: child);
  }
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: Tween<double>(begin: 0.92, end: 1).animate(curved),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
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
