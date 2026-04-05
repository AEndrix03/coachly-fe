import 'dart:async';

import 'package:coachly/features/coach/providers/coach_discovery_provider/coach_discovery_provider.dart';
import 'package:coachly/features/coach/presentation/widgets/coach_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class CoachDiscoveryPage extends ConsumerStatefulWidget {
  const CoachDiscoveryPage({super.key});

  @override
  ConsumerState<CoachDiscoveryPage> createState() => _CoachDiscoveryPageState();
}

class _CoachDiscoveryPageState extends ConsumerState<CoachDiscoveryPage> {
  static const Color background = Color(0xFF0D0D18);
  static const Color surfaceAlt = Color(0xFF1A1A2E);
  static const Color border = Color(0xFF2A2A40);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color accentBlue = Color(0xFF4A3AFF);

  static const List<String> _filters = <String>[
    'Tutti',
    'Online',
    'In presenza',
    'Powerlifting',
    'Ipertrofia',
    'Calisthenics',
    'CrossFit',
    'Principianti',
    'Solo donne',
    'Verificati',
    'Accetta clienti',
  ];

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(coachDiscoveryProvider.notifier).loadCoaches();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coachDiscoveryProvider);
    final notifier = ref.read(coachDiscoveryProvider.notifier);

    if (_searchController.text != state.searchQuery) {
      _searchController.value = TextEditingValue(
        text: state.searchQuery,
        selection: TextSelection.collapsed(offset: state.searchQuery.length),
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(color: background),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _HeaderSection(totalCoaches: state.coaches.length),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(
                controller: _searchController,
                onChanged: (value) {
                  _searchDebounce?.cancel();
                  _searchDebounce = Timer(
                    const Duration(milliseconds: 400),
                    () {
                      notifier.updateSearch(value);
                    },
                  );
                },
                onClear: () {
                  _searchDebounce?.cancel();
                  _searchController.clear();
                  notifier.updateSearch('');
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final filter = _filters[i];
                  final isAll = filter == 'Tutti';
                  final selected = isAll
                      ? state.activeFilters.isEmpty
                      : state.activeFilters.contains(filter);

                  return FilterChip(
                    selected: selected,
                    onSelected: (_) => notifier.toggleFilter(filter),
                    showCheckmark: false,
                    side: BorderSide(color: selected ? accentBlue : border),
                    selectedColor: accentBlue,
                    backgroundColor: surfaceAlt,
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: selected ? textPrimary : textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${state.coaches.length} risultati',
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(state, notifier)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    CoachDiscoveryState state,
    CoachDiscoveryNotifier notifier,
  ) {
    if (state.isLoading && state.coaches.isEmpty) {
      return const _ShimmerList();
    }

    if (state.errorMessage != null && state.coaches.isEmpty) {
      return _ErrorState(
        message: state.errorMessage!,
        onRetry: notifier.loadCoaches,
      );
    }

    if (state.coaches.isEmpty) {
      return _EmptyState(
        onReset: () {
          notifier.updateSearch('');
          notifier.toggleFilter('Tutti');
        },
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemBuilder: (_, i) {
          return CoachCard(coach: state.coaches[i]);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: state.coaches.length,
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.totalCoaches});

  final int totalCoaches;

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trova il tuo Coach',
          style: TextStyle(
            color: textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$totalCoaches coach disponibili',
          style: const TextStyle(
            color: textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  static const Color surface = Color(0xFF13131F);
  static const Color border = Color(0xFF2A2A40);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color accentBlue = Color(0xFF4A3AFF);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: textPrimary),
      decoration: InputDecoration(
        hintText: 'Cerca coach, specialita o modalita',
        hintStyle: const TextStyle(color: textSecondary),
        prefixIcon: const Icon(Icons.search_rounded, color: textSecondary),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, color: textSecondary),
              )
            : null,
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentBlue, width: 1.3),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color accentBlue = Color(0xFF4A3AFF);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: textSecondary,
              size: 36,
            ),
            const SizedBox(height: 10),
            const Text(
              'Errore durante il caricamento',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: textSecondary),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: accentBlue),
              child: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color accentBlue = Color(0xFF4A3AFF);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: textSecondary,
              size: 40,
            ),
            const SizedBox(height: 10),
            const Text(
              'Nessun coach trovato',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Prova a modificare la ricerca o resetta i filtri.',
              style: TextStyle(color: textSecondary),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onReset,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: accentBlue),
              ),
              child: const Text(
                'Reset filtri',
                style: TextStyle(color: textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  static const Color surface = Color(0xFF13131F);
  static const Color surfaceAlt = Color(0xFF1A1A2E);
  static const Color border = Color(0xFF2A2A40);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: surface,
          highlightColor: surfaceAlt,
          child: Container(
            height: 248,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
          ),
        );
      },
    );
  }
}
