import 'package:flutter/material.dart';

/// Le destinazioni di primo livello della app.
///
/// Unica fonte di verità: i `StatefulShellBranch` del router e le voci della
/// navbar si generano entrambi da `AppTab.values`, così le due liste non
/// possono divergere. Vedi `docs/development/08-routing-navigation.md` (R1).
enum AppTab {
  community(
    path: '/community',
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    labelKey: 'nav.community',
  ),
  workouts(
    path: '/workouts',
    icon: Icons.fitness_center_outlined,
    selectedIcon: Icons.fitness_center,
    labelKey: 'nav.workouts',
  ),
  profile(
    path: '/profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    labelKey: 'nav.profile',
  );

  const AppTab({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
  });

  /// Percorso della root del branch.
  final String path;

  /// Icona a riposo.
  final IconData icon;

  /// Icona quando il tab è selezionato.
  final IconData selectedIcon;

  /// Chiave di traduzione dell'etichetta.
  final String labelKey;
}
