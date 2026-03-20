import 'package:coachly/core/sync/app_data_sync_service.dart';
import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/ai_coach/data/services/gemma_inference_service.dart';
import 'package:coachly/features/ai_coach/domain/models/local_ai_model.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterGemma.initialize();
  await LocalDatabaseService().initialize();

  runApp(const ProviderScope(child: CoachlyApplication()));
}

class CoachlyApplication extends ConsumerWidget {
  const CoachlyApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(languageProvider);
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
          title: context.tr('common.app_name'),
          theme: AppThemeScheme.lightTheme,
          darkTheme: AppThemeScheme.darkTheme,
          themeMode: ThemeMode.dark,
          locale: locale,
          supportedLocales: AppStrings.supportedLocales,
          localizationsDelegates: const [
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

class _AppSyncBootstrapState extends ConsumerState<_AppSyncBootstrap> {
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
    ref.listenManual(authProvider, (previous, next) {
      _handleAuthState(previous, next);
    });

    Future.microtask(() {
      _handleAuthState(null, ref.read(authProvider));
    });

    Future.microtask(() async {
      final aiSettings = ref.read(localAiSettingsProvider);
      if (!aiSettings.enabled) return;

      final service = ref.read(gemmaInferenceServiceProvider);
      service.configure(LocalAiModelConfig.forModel(aiSettings.model));
      final installed = await service.isModelInstalled();
      if (installed) {
        await service.ensureInitialized();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
