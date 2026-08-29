import 'package:coachly/app/bootstrap/provider_overrides.dart';
import 'package:coachly/core/analytics/analytics_event.dart';
import 'package:coachly/core/analytics/analytics_tracker.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/observability/crash_reporter.dart';
import 'package:coachly/app/router/app_router.dart';
import 'package:coachly/app/sync/app_data_sync_service.dart';
import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/core/themes/theme.dart';
import 'package:coachly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Senza questo, un errore fuori dal frame di build finisce nella console del
  // dispositivo e da nessun'altra parte (`docs/development/18-observability.md`).
  installErrorHandlers(const LoggingCrashReporter(ConsoleAppLogger()));

  runApp(buildAppScope(child: const CoachlyApplication()));
}

class CoachlyApplication extends ConsumerWidget {
  const CoachlyApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(languageProvider);
    final colorScheme = AppThemeScheme.darkTheme.colorScheme;
    final shadColorScheme = const ShadSlateColorScheme.dark().copyWith(
      primary: colorScheme.primary,
      secondary: colorScheme.secondary,
      background: colorScheme.surface,
    );

    return ShadTheme(
      data: ShadThemeData(
        colorScheme: shadColorScheme,
        brightness: Brightness.dark,
      ),
      child: _AppSyncBootstrap(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: context.l10n.commonAppName,
          scaffoldMessengerKey: appScaffoldMessengerKey,
          theme: AppThemeScheme.lightTheme,
          darkTheme: AppThemeScheme.darkTheme,
          themeMode: ThemeMode.dark,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
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

class _AppSyncBootstrapState extends ConsumerState<_AppSyncBootstrap>
    with WidgetsBindingObserver {
  bool _isAuthenticated(AsyncValue authState) {
    return authState.value?.isAuthenticated == true &&
        authState.value?.isTokenValid == true;
  }

  Future<void> _handleAuthState(AsyncValue? previous, AsyncValue next) async {
    final syncService = ref.read(appDataSyncServiceProvider);
    final isAuthenticated = _isAuthenticated(next);
    final wasAuthenticated = previous != null && _isAuthenticated(previous);

    if (!isAuthenticated) {
      syncService.resetSession();
      return;
    }

    if (!wasAuthenticated && isAuthenticated) {
      await syncService.syncOnAuthenticatedAccess(force: true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Il primo evento del canale analytics. Non serve al prodotto: serve a
    // tenere il canale **provato**. Un'interfaccia che nessuno chiama e' una
    // promessa, e questo repository ha appena finito di rimuovere tre feature
    // complete che nessuno poteva eseguire.
    ref.read(analyticsTrackerProvider).track(AnalyticsEvent.appOpened);

    ref.listenManual(authProvider, (previous, next) {
      _handleAuthState(previous, next);
    });

    Future.microtask(() {
      _handleAuthState(null, ref.read(authProvider));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed ||
        !_isAuthenticated(ref.read(authProvider))) {
      return;
    }

    ref.read(appDataSyncServiceProvider).refreshExercisesOnAppResume();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
