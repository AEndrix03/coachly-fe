import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/navigation_provider.dart';

class AppNavigationBar extends ConsumerStatefulWidget {
  const AppNavigationBar({super.key});

  @override
  ConsumerState<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends ConsumerState<AppNavigationBar>
    with TickerProviderStateMixin {
  static const _tabs = [
    _NavTab(icon: Icons.people, label: 'Community', route: '/community'),
    _NavTab(icon: Icons.fitness_center, label: 'Workouts', route: '/workouts'),
    _NavTab(icon: Icons.home, label: 'Home', route: '/home'),
    _NavTab(icon: Icons.tune, label: 'Settings', route: '/settings'),
    _NavTab(icon: Icons.person, label: 'Coach', route: '/coach'),
  ];

  // Per-item bounce controllers
  late final List<AnimationController> _bounceControllers;
  late final List<Animation<double>> _bounceAnimations;

  @override
  void initState() {
    super.initState();
    _bounceControllers = List.generate(
      _tabs.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _bounceAnimations = _bounceControllers.map((c) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.75)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.75, end: 1.15)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 35,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.15, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 35,
        ),
      ]).animate(c);
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _bounceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTap(int index, int currentIndex) {
    if (index == currentIndex) return;
    _bounceControllers[index].forward(from: 0.0);
    ref.read(navigationIndexProvider.notifier).set(index);
    context.go(_tabs[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 14),
      child: SizedBox(
        height: 64,
        child: _buildBar(currentIndex),
      ),
    );
  }

  Widget _buildBar(int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E3A), Color(0xFF0D0D1F)],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.09),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withValues(alpha: 0.18),
            blurRadius: 28,
            spreadRadius: -6,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _buildIndicator(constraints.maxWidth, currentIndex),
              Row(
                children: List.generate(_tabs.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onTap(index, currentIndex),
                      child: AnimatedBuilder(
                        animation: _bounceAnimations[index],
                        builder: (_, __) => Transform.scale(
                          scale: _bounceAnimations[index].value,
                          child: _NavItem(
                            tab: _tabs[index],
                            isSelected: index == currentIndex,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIndicator(double totalWidth, int currentIndex) {
    const indicatorW = 46.0;
    const indicatorH = 42.0;
    const barH = 64.0;

    final itemWidth = totalWidth / _tabs.length;
    final left = currentIndex * itemWidth + (itemWidth - indicatorW) / 2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
      left: left,
      top: (barH - indicatorH) / 2,
      child: Container(
        width: indicatorW,
        height: indicatorH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withValues(alpha: 0.55),
              blurRadius: 18,
              spreadRadius: -3,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: const Color(0xFF7B4BC1).withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: -4,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _NavTab tab;
  final bool isSelected;

  const _NavItem({required this.tab, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        scale: isSelected ? 1.0 : 0.88,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            tab.icon,
            key: ValueKey(isSelected),
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.38),
            size: isSelected ? 24 : 21,
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final String label;
  final String route;

  const _NavTab({
    required this.icon,
    required this.label,
    required this.route,
  });
}
