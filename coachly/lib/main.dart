import 'package:coachly/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: CoachlyApplication()));
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
      ),
    );
  }
}
