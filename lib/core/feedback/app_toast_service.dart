import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  }

  void _show(
    BuildContext context, {
    required AppToastType type,
    required String title,
    required String message,
    required Duration duration,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final theme = Theme.of(context);
    final palette = _ToastPalette.from(type, theme.colorScheme);
    final textColor =
        ThemeData.estimateBrightnessForColor(palette.backgroundStart) ==
            Brightness.dark
        ? Colors.white
        : Colors.black87;

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
        borderRadius: BorderRadius.circular(18),
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
            color: Colors.black.withValues(alpha: 0.25),
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

  factory _ToastPalette.from(AppToastType type, ColorScheme scheme) {
    switch (type) {
      case AppToastType.success:
        return _ToastPalette(
          icon: Icons.check_circle_rounded,
          accent: const Color(0xFF41D17E),
          backgroundStart: _blend(
            scheme.surface,
            const Color(0xFF0D3E2B),
            0.82,
          ),
          backgroundEnd: _blend(scheme.surface, const Color(0xFF102A22), 0.9),
        );
      case AppToastType.error:
        return _ToastPalette(
          icon: Icons.error_rounded,
          accent: const Color(0xFFFF6B6B),
          backgroundStart: _blend(
            scheme.surface,
            const Color(0xFF4A1620),
            0.82,
          ),
          backgroundEnd: _blend(scheme.surface, const Color(0xFF2D1217), 0.9),
        );
      case AppToastType.warning:
        return _ToastPalette(
          icon: Icons.warning_rounded,
          accent: const Color(0xFFFFC145),
          backgroundStart: _blend(
            scheme.surface,
            const Color(0xFF4B3413),
            0.82,
          ),
          backgroundEnd: _blend(scheme.surface, const Color(0xFF322612), 0.9),
        );
      case AppToastType.info:
        return _ToastPalette(
          icon: Icons.info_rounded,
          accent: const Color(0xFF56B3FF),
          backgroundStart: _blend(
            scheme.surface,
            const Color(0xFF142F53),
            0.82,
          ),
          backgroundEnd: _blend(scheme.surface, const Color(0xFF16233E), 0.9),
        );
    }
  }

  static Color _blend(Color base, Color tint, double opacity) {
    return Color.alphaBlend(tint.withValues(alpha: opacity), base);
  }
}
