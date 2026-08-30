import 'package:coachly/app/router/routes.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navbar di primo livello.
///
/// Le voci si generano da `AppTab.values`: nessuna lista duplicata rispetto al
/// router. Il cambio tab passa da `goBranch`, che preserva lo stack di ogni
/// branch. Vedi `docs/development/08-routing-navigation.md`.
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Tap sul tab già attivo: torna alla root del branch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.xs,
        spacing.lg,
        bottomPadding + spacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Superficie opaca al posto del `BackdropFilter` permanente: il blur
          // sotto uno stack animato ridisegna a ogni frame.
          color: colors.surfaceOverlay,
          borderRadius: BorderRadius.circular(context.radii.pill),
          border: Border.all(color: colors.border),
        ),
        child: SizedBox(
          height: context.sizes.touchTargetWorkout,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / AppTab.values.length;
              return Stack(
                children: [
                  _Indicator(
                    itemWidth: itemWidth,
                    currentIndex: navigationShell.currentIndex,
                  ),
                  Row(
                    children: [
                      for (final tab in AppTab.values)
                        Expanded(
                          child: _NavItem(
                            tab: tab,
                            isSelected:
                                tab.index == navigationShell.currentIndex,
                            onTap: () => _onTap(tab.index),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.itemWidth, required this.currentIndex});

  final double itemWidth;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final size = context.sizes.touchTarget;
    final motion = context.motion;

    return AnimatedPositioned(
      duration: motion.resolve(context, motion.standard),
      curve: motion.standardCurve,
      left: currentIndex * itemWidth + (itemWidth - size) / 2,
      top: (context.sizes.touchTargetWorkout - size) / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.colors.surfaceAccent,
          borderRadius: BorderRadius.circular(context.radii.lg),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final AppTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final motion = context.motion;

    return Semantics(
      button: true,
      selected: isSelected,
      label: context.tr(tab.labelKey),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: context.sizes.touchTargetWorkout,
          child: Center(
            child: AnimatedScale(
              duration: motion.resolve(context, motion.quick),
              curve: motion.standardCurve,
              scale: isSelected ? 1.0 : 0.9,
              child: Icon(
                isSelected ? tab.selectedIcon : tab.icon,
                color: isSelected ? colors.textOnAccent : colors.textSecondary,
                size: context.sizes.iconMd,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
