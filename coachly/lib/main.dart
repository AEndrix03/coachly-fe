import 'package:coachly/core/themes/theme.dart';
import 'package:coachly/features/home/home.dart';
import 'package:coachly/features/workout/workout_page/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:coachly/features/auth/providers/auth_provider.dart'; // Import authProvider
import 'routes/app_router.dart';

Future<void> main() async {
  // Ensure flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Create a ProviderContainer to access providers before runApp.
  final container = ProviderContainer();
  
  // Initialize Auth provider to check for existing session
  await container.read(authProvider.notifier).checkAuthStatus();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CoachlyApplication(),
    ),
  );
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

class CoachlyApplication extends ConsumerWidget {
  const CoachlyApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
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
        routerConfig: router,
        builder: (context, child) =>
            Stack(children: [child!, const NavbarPagesPrecache()]),
      ),
    );
  }
}
