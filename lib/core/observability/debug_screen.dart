import 'package:coachly/core/observability/debug_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La schermata diagnostica interna (`docs/development/18-observability.md`).
///
/// Non è raggiungibile dalla navigazione: esiste come rotta `/debug`,
/// registrata solo quando `FeatureFlag.debugScreen` è attivo. Non è parte del
/// prodotto e non usa il design system di proposito — deve continuare a
/// funzionare anche quando è il tema ad essere rotto.
///
/// Le stringhe sono in inglese e non localizzate: il pubblico è chi sviluppa.
class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  static const routePath = '/debug';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(debugReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(debugReportProvider),
          ),
        ],
      ),
      body: report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(child: Text('$error\n\n$stack')),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section(
              title: 'Sync queue',
              rows: {
                'total': '${data.sync.total}',
                for (final entry in data.sync.countsByStatus.entries)
                  entry.key: '${entry.value}',
                'oldest pending': _formatDate(data.sync.oldestPendingAt),
                'next attempt': _formatDate(data.sync.nextAttemptAt),
                'last error': data.sync.lastError ?? '—',
              },
            ),
            _Section(
              title: 'Database',
              rows: {
                'schemaVersion': '${data.schemaVersion}',
                'catalog_version': '${data.catalogVersion ?? '—'}',
                'catalog applied at': _formatDate(data.catalogAppliedAt),
              },
            ),
            _Section(
              title: 'Feature flags',
              rows: {
                for (final entry in data.flags.entries)
                  entry.key: '${entry.value}',
              },
            ),
            _Section(
              title: 'AppConfig',
              rows: {
                for (final entry in data.config.entries)
                  entry.key: '${entry.value}',
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _copy(context, data),
              icon: const Icon(Icons.copy_all_outlined),
              label: const Text('Copy report'),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime? value) =>
      value == null ? '—' : value.toIso8601String();

  static Future<void> _copy(BuildContext context, DebugReport data) async {
    final buffer = StringBuffer()
      ..writeln('schemaVersion: ${data.schemaVersion}')
      ..writeln('catalog_version: ${data.catalogVersion}')
      ..writeln('sync: ${data.sync.countsByStatus}')
      ..writeln('sync.lastError: ${data.sync.lastError}')
      ..writeln('flags: ${data.flags}')
      ..writeln('config: ${data.config}');
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Report copied')));
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final Map<String, String> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const Divider(),
          for (final entry in rows.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(entry.key, style: theme.textTheme.bodySmall),
                  ),
                  Expanded(
                    child: SelectableText(
                      entry.value,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
