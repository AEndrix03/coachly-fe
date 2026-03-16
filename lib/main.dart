import 'package:coachly/core/sync/app_data_sync_service.dart';
import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseService().initialize();

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
      background: colorScheme.surface,
    );

    return ShadTheme(
      data: ShadThemeData(
        colorScheme: shadColorScheme,
        brightness: Brightness.light,
      ),
      child: _AppSyncBootstrap(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Coachly',
          theme: AppThemeScheme.lightTheme,
          darkTheme: AppThemeScheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: router,
        ),
      ),
    );
  }
}

class _AppSyncBootstrap extends ConsumerStatefulWidget {
  final Widget child;

  const _AppSyncBootstrap({required this.child});

  @override
  ConsumerState<_AppSyncBootstrap> createState() => _AppSyncBootstrapState();
}

class _AppSyncBootstrapState extends ConsumerState<_AppSyncBootstrap> {
  bool _isAuthenticated(AsyncValue authState) {
    return authState.value?.isAuthenticated == true &&
        authState.value?.isTokenValid == true;
  }

  Future<void> _syncIfAuthenticated() async {
    final authState = ref.read(authProvider);
    if (_isAuthenticated(authState)) {
      await ref.read(appDataSyncServiceProvider).syncOnAuthenticatedAccess();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_syncIfAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      final syncService = ref.read(appDataSyncServiceProvider);
      final isAuthenticated = _isAuthenticated(next);
      final wasAuthenticated = previous != null && _isAuthenticated(previous);

      if (!isAuthenticated) {
        syncService.resetSession();
        return;
      }

      if (!wasAuthenticated && isAuthenticated) {
        syncService.syncOnAuthenticatedAccess(force: true);
      }
    });

    return widget.child;
  }
}
