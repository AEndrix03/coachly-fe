import 'package:coachly/app/router/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// L'unico modo di cambiare tab.
///
/// `context.go('/profile')` sembra equivalente e non lo e': con uno
/// `StatefulShellRoute` porta sul tab giusto ma **azzera lo stack** del ramo,
/// quindi chi torna indietro non trova dove stava. La regola sta in
/// `docs/development/08-routing-navigation.md` (R1) ed e' il divieto 14 di
/// `.claude/rules/development.md`; mancava il modo comodo di rispettarla, e
/// una schermata l'aveva gia' aggirata.
extension TabNavigation on BuildContext {
  /// Porta l'utente su [tab] preservando la navigazione degli altri rami.
  ///
  /// Un secondo tocco sul tab gia' selezionato torna alla sua radice, che e'
  /// il comportamento che le persone si aspettano da una navbar.
  void goToTab(AppTab tab) {
    final shell = StatefulNavigationShell.of(this);
    shell.goBranch(tab.index, initialLocation: tab.index == shell.currentIndex);
  }
}
