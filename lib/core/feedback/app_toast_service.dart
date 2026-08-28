import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/design_system/tokens/coachly_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final appToastServiceProvider = Provider<AppToastService>((ref) {
  return const AppToastService();
});

enum AppToastType { success, error, info, warning }

class AppToastService {
  const AppToastService();

  static const Duration _defaultDuration = Duration(seconds: 3);

  void showSuccess(
    BuildContext context,
    String message, {
    String title = 'Success',
    Duration duration = _defaultDuration,
  }) {
    _show(
      context,
      type: AppToastType.success,
      title: title,
      message: message,
      duration: duration,
    );
  }

  void showError(
    BuildContext context,
    String message, {
    String title = 'Error',
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      type: AppToastType.error,
      title: title,
      message: message,
      duration: duration,
    );
  }

  void showInfo(
    BuildContext context,
    String message, {
    String title = 'Info',
    Duration duration = _defaultDuration,
  }) {
    _show(
      context,
      type: AppToastType.info,
      title: title,
      message: message,
      duration: duration,
    );
  }

  void showWarning(
    BuildContext context,
    String message, {
    String title = 'Warning',
    Duration duration = _defaultDuration,
  }) {
    _show(
      context,
      type: AppToastType.warning,
      title: title,
      message: message,
      duration: duration,
    );
  }

  void hide(BuildContext context) {
    final messenger = appScaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.hideCurrentSnackBar();
      return;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  }

  void _show(
    BuildContext context, {
    required AppToastType type,
    required String title,
    required String message,
    required Duration duration,
  }) {
    final messenger =
        appScaffoldMessengerKey.currentState ??
        (context.mounted ? ScaffoldMessenger.maybeOf(context) : null);
    if (messenger == null) return;

    final themeContext = appScaffoldMessengerKey.currentContext;
    if (themeContext == null) return;

    final colors = themeContext.colors;
    final palette = _ToastPalette.from(type, colors);
    final textColor = colors.textPrimary;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          padding: EdgeInsets.zero,
          duration: duration,
          dismissDirection: DismissDirection.horizontal,
          content: _ToastCard(
            title: title,
            message: message,
            textColor: textColor,
            palette: palette,
          ),
        ),
      );
  }
}

class _ToastCard extends StatelessWidget {
  final String title;
  final String message;
  final Color textColor;
  final _ToastPalette palette;

  const _ToastCard({
    required this.title,
    required this.message,
    required this.textColor,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radii.card),
        border: Border.all(color: palette.accent.withValues(alpha: 0.45)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.backgroundStart, palette.backgroundEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
          BoxShadow(
            // L'ombra è la superficie di base, non il nero assoluto: su un
            // fondale già scuro il nero puro crea un alone sporco.
            color: context.colors.surface.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accent.withValues(alpha: 0.2),
                border: Border.all(
                  color: palette.accent.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              child: Icon(palette.icon, color: palette.accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToastPalette {
  final IconData icon;
  final Color accent;
  final Color backgroundStart;
  final Color backgroundEnd;

  const _ToastPalette({
    required this.icon,
    required this.accent,
    required this.backgroundStart,
    required this.backgroundEnd,
  });

  /// Deriva il fondale dall'accento invece di usare tinte scelte a mano.
  ///
  /// Prima esisteva una **seconda palette di feedback** con valori diversi da
  /// quelli dei temi: stessi ruoli, colori diversi. I token sono ora l'unica
  /// sorgente. Vedi `docs/development/09-design-tokens.md`.
  factory _ToastPalette.from(AppToastType type, CoachlyColors colors) {
    final (icon, accent) = switch (type) {
      AppToastType.success => (
        Icons.check_circle_rounded,
        colors.feedbackSuccess,
      ),
      AppToastType.error => (Icons.error_rounded, colors.feedbackDanger),
      AppToastType.warning => (Icons.warning_rounded, colors.feedbackWarning),
      AppToastType.info => (Icons.info_rounded, colors.feedbackInfo),
    };

    return _ToastPalette(
      icon: icon,
      accent: accent,
      backgroundStart: _blend(colors.surfaceElevated, accent, 0.18),
      backgroundEnd: _blend(colors.surface, accent, 0.10),
    );
  }

  static Color _blend(Color base, Color tint, double opacity) {
    return Color.alphaBlend(tint.withValues(alpha: opacity), base);
  }
}
