import 'package:coachly/pages/home/home.dart';
import 'package:coachly/pages/workout/ui/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation/navigation_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const AppNavigationBar(),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/workouts',
          builder: (context, state) => const WorkoutPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
  ],
);
