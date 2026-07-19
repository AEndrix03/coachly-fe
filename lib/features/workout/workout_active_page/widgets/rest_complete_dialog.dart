import 'dart:async';

import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

class RestCompleteDialog extends StatefulWidget {
  const RestCompleteDialog({super.key});

  @override
  State<RestCompleteDialog> createState() => _RestCompleteDialogState();
}

class _RestCompleteDialogState extends State<RestCompleteDialog> {
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _autoCloseTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: scheme.outlineVariant, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.22),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.alarm_on_rounded,
                      color: scheme.primary,
                      size: 36,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            Text(
              context.tr('session.rest_complete_title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('session.rest_complete_body'),
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.72),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
