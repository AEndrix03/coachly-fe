import 'package:coachly/core/assets/app_assets.dart';
import 'dart:io';

import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/auth/application/auth_provider.dart';
import 'package:coachly/features/auth/presentation/widgets/auth_legal_footer.dart';
import 'package:coachly/features/auth/presentation/widgets/auth_provider_button.dart';
import 'package:coachly/features/auth/presentation/widgets/animated_3d_logo.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      authProvider.select((state) => state.value?.status ?? AuthStatus.loading),
    );
    final isLoading = status == AuthStatus.loading;
    // Finche' la connettivita' non ha risposto si assume che ci sia: meglio
    // mostrare i provider per un istante che offrire una scorciatoia che non
    // serviva.
    final isOnline = ref.watch(isOnlineProvider).value ?? true;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.gymDarkBackground, fit: BoxFit.cover),
          Container(color: context.colors.surface.withValues(alpha: 0.5)),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: context.spacing.pagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 7),
                        Padding(
                          padding: EdgeInsets.only(
                            top: context.sizes.authLogoDrop,
                          ),
                          child: SizedBox(
                            height: context.sizes.authLogoStage,
                            child: Animated3dLogo(busy: isLoading),
                          ),
                        ),
                        SizedBox(height: context.spacing.xxs),
                        Semantics(
                          label: context.l10n.commonAppName,
                          image: true,
                          child: Image.asset(
                            AppAssets.titleSprite,
                            height: context.sizes.authTitle,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Spacer(flex: 13),
                        // Lo spazio di tre azioni e' riservato sempre, anche
                        // dove Apple non compare: cosi' il blocco del marchio
                        // resta fermo qualunque sia il numero di pulsanti.
                        SizedBox(
                          height:
                              context.sizes.authAction * 3 +
                              context.spacing.sm * 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: isOnline
                                ? [
                                    if (Platform.isIOS) ...[
                                      AuthProviderButton(
                                        type: AuthProviderType.apple,
                                        label: context
                                            .l10n
                                            .authLoginDescription,
                                        badge: context.l10n.authSoonBadge,
                                        onPressed: null,
                                        enabled: false,
                                      ),
                                      SizedBox(height: context.spacing.sm),
                                    ],
                                    AuthProviderButton(
                                      type: AuthProviderType.google,
                                      label: context
                                          .l10n
                                          .authLoginConfigurationHint,
                                      badge: context.l10n.authSoonBadge,
                                      onPressed: null,
                                      enabled: false,
                                    ),
                                    SizedBox(height: context.spacing.sm),
                                    AuthProviderButton(
                                      type: AuthProviderType.coachly,
                                      label: context.l10n.authLoginCta,
                                      onPressed: () {
                                        ref
                                            .read(authProvider.notifier)
                                            .login();
                                      },
                                      enabled: !isLoading,
                                      loading: isLoading,
                                    ),
                                  ]
                                : [
                                    // Senza rete l'accesso non puo' riuscire:
                                    // passa da un browser. Resta la memoria
                                    // locale, che e' la sorgente della app.
                                    AuthProviderButton(
                                      type: AuthProviderType.offline,
                                      label: context
                                          .l10n
                                          .authContinueOffline,
                                      onPressed: () {
                                        ref
                                            .read(authProvider.notifier)
                                            .continueOffline();
                                      },
                                      enabled: !isLoading,
                                    ),
                                  ],
                          ),
                        ),
                        if (status == AuthStatus.failed) ...[
                          SizedBox(height: context.spacing.md),
                          Text(
                            context.l10n.commonError,
                            textAlign: TextAlign.center,
                            style: context.text.bodyM.copyWith(
                              color: context.colors.feedbackDanger,
                            ),
                          ),
                        ],
                        SizedBox(height: context.spacing.xs),
                        AuthLegalFooter(
                          onTermsTap: () => _openLegalDocument(
                            ref,
                            AuthLegalDocument.terms,
                          ),
                          onPrivacyTap: () => _openLegalDocument(
                            ref,
                            AuthLegalDocument.privacy,
                          ),
                        ),
                        SizedBox(height: context.spacing.sm),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Documenti legali richiamati dal piede della schermata di accesso.
enum AuthLegalDocument { terms, privacy }

/// Apre un documento legale.
///
/// Oggi registra soltanto l'intenzione: la app non ha ancora né un modo di
/// aprire un indirizzo esterno né due schermate interne che ospitino i testi.
/// Quando una delle due cose esiste, questo è il solo punto da collegare.
void _openLegalDocument(WidgetRef ref, AuthLegalDocument document) {
  ref
      .read(appLoggerProvider)
      .warn(
        'Documento legale non ancora collegato',
        context: {'document': document.name},
      );
}
