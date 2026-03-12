import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/navigation_provider.dart';

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  static const _tabs = [
    {'icon': Icons.people, 'label': 'Community', 'route': '/community'},
    {'icon': Icons.fitness_center, 'label': 'Workouts', 'route': '/workouts'},
    {'icon': Icons.home, 'label': 'Home', 'route': '/home'},
    {'icon': Icons.settings, 'label': 'Settings', 'route': '/settings'},
    {'icon': Icons.person, 'label': 'Coach', 'route': '/coach'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return NavigationBar(
      selectedIndex: currentIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: (index) {
        ref.read(navigationIndexProvider.notifier).set(index);
        context.go(_tabs[index]['route'] as String);
      },
      destinations: _tabs
          .map(
            (tab) => NavigationDestination(
              icon: Icon(tab['icon'] as IconData),
              label: tab['label'] as String,
            ),
          )
          .toList(),
    );
  }
}
