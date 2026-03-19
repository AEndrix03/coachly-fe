import 'package:flutter/material.dart';

Future<bool> showAppConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  String cancelLabel = 'Annulla',
  String confirmLabel = 'Conferma',
  bool destructive = false,
  IconData? icon,
  bool barrierDismissible = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      final scheme = Theme.of(dialogContext).colorScheme;
      final accent = destructive ? scheme.error : scheme.primary;
      final foregroundOnAccent = destructive
          ? scheme.onError
          : scheme.onPrimary;

      return AlertDialog(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.75),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        actionsAlignment: MainAxisAlignment.end,
        title: _DialogTitle(
          title: title,
          icon: icon,
          accent: accent,
          textColor: scheme.onSurface,
        ),
        content: Text(
          content,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.78),
            fontSize: 15,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: scheme.onSurface.withValues(alpha: 0.75),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              cancelLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: foregroundOnAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              confirmLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

Future<void> showAppNoticeDialog(
  BuildContext context, {
  required String title,
  required String content,
  String actionLabel = 'Chiudi',
  IconData? icon,
}) async {
  final scheme = Theme.of(context).colorScheme;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.75),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: _DialogTitle(
          title: title,
          icon: icon,
          accent: scheme.primary,
          textColor: scheme.onSurface,
        ),
        content: Text(
          content,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.78),
            fontSize: 15,
            height: 1.4,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
    },
  );
}

class _DialogTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color accent;
  final Color textColor;

  const _DialogTitle({
    required this.title,
    required this.icon,
    required this.accent,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon;
    if (effectiveIcon == null) {
      return Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      );
    }

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(effectiveIcon, color: accent, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
