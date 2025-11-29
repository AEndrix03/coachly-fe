import 'package:coachly/core/themes/theme.dart';
import 'package:coachly/features/home/home.dart';
import 'package:coachly/features/workout/workout_page/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'routes/app_router.dart';

void main() {
  runApp(const ProviderScope(child: CoachlyApplication()));
}

class NavbarPagesPrecache extends StatelessWidget {
  const NavbarPagesPrecache({super.key});

  @override
  Widget build(BuildContext context) {
    // Costruisce tutte le pagine della navbar in background (invisibile)
    return Offstage(
      offstage: true,
      child: IndexedStack(
        children: const [
          // Sostituisci con i tuoi widget reali delle pagine navbar
          // Se usi provider/riverpod, puoi passarli qui senza problemi
          // Esempio:
          // CommunityPage(),
          // WorkoutPage(),
          // HomeScreen(),
          // SettingsPage(),
          // CoachPage(),
          // Per ora metto HomeScreen e WorkoutPage come da tua struttura
          HomeScreen(),
          WorkoutPage(),
        ],
      ),
    );
  }
}

class CoachlyApplication extends StatelessWidget {
  const CoachlyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppThemeScheme.lightTheme.colorScheme;
    final shadColorScheme = ShadSlateColorScheme.light().copyWith(
      primary: colorScheme.primary,
      secondary: colorScheme.secondary,
      background: colorScheme.background,
    );
    return ShadTheme(
      data: ShadThemeData(
        colorScheme: shadColorScheme,
        brightness: Brightness.light,
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Coachly',
        theme: AppThemeScheme.lightTheme,
        darkTheme: AppThemeScheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
        builder: (context, child) =>
            Stack(children: [child!, const NavbarPagesPrecache()]),
      ),
    );
  }
}
