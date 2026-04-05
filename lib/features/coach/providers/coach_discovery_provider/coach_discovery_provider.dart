import 'package:coachly/features/coach/data/models/coach_summary/coach_summary.dart';
import 'package:coachly/features/coach/data/repositories/coach_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_discovery_provider.g.dart';

class CoachDiscoveryState {
  const CoachDiscoveryState({
    this.coaches = const <CoachSummary>[],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.activeFilters = const <String>{},
  });

  final List<CoachSummary> coaches;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final Set<String> activeFilters;

  CoachDiscoveryState copyWith({
    List<CoachSummary>? coaches,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
    Set<String>? activeFilters,
  }) {
    return CoachDiscoveryState(
      coaches: coaches ?? this.coaches,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

@riverpod
class CoachDiscoveryNotifier extends _$CoachDiscoveryNotifier {
  List<CoachSummary> _allCoaches = const <CoachSummary>[];

  @override
  CoachDiscoveryState build() {
    return const CoachDiscoveryState();
  }

  Future<void> loadCoaches() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = ref.read(coachRepositoryProvider);
      _allCoaches = await repository.getCoaches();
      _applyFilters();
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
        coaches: const <CoachSummary>[],
      );
    }
  }

  void updateSearch(String q) {
    state = state.copyWith(searchQuery: q);
    _applyFilters();
  }

  void toggleFilter(String filter) {
    if (filter == 'Tutti') {
      state = state.copyWith(activeFilters: <String>{});
      _applyFilters();
      return;
    }

    final nextFilters = <String>{...state.activeFilters};
    if (nextFilters.contains(filter)) {
      nextFilters.remove(filter);
    } else {
      nextFilters.add(filter);
    }

    state = state.copyWith(activeFilters: nextFilters);
    _applyFilters();
  }

  Future<void> refresh() async {
    await loadCoaches();
  }

  void _applyFilters() {
    final query = state.searchQuery.trim().toLowerCase();
    final filters = state.activeFilters;

    final filtered = _allCoaches
        .where((coach) {
          final matchesQuery = query.isEmpty || _matchesQuery(coach, query);
          final matchesFilters =
              filters.isEmpty || filters.every((f) => _matchesFilter(coach, f));
          return matchesQuery && matchesFilters;
        })
        .toList(growable: false);

    state = state.copyWith(
      coaches: filtered,
      isLoading: false,
      clearError: true,
    );
  }

  bool _matchesQuery(CoachSummary coach, String query) {
    final haystack = <String>[
      coach.displayName,
      coach.handle,
      coach.modalityLabel,
      ...coach.specialties,
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  bool _matchesFilter(CoachSummary coach, String filter) {
    final normalized = filter.toLowerCase();

    switch (normalized) {
      case 'online':
        return coach.modalityLabel.toLowerCase().contains('online');
      case 'in presenza':
        return coach.modalityLabel.toLowerCase().contains('presenza');
      case 'verificati':
        return coach.isVerified;
      case 'accetta clienti':
        return coach.acceptingClients;
      case 'solo donne':
        return coach.specialties.any(
          (s) =>
              s.toLowerCase().contains('solo donne') ||
              s.toLowerCase().contains('women'),
        );
      default:
        return coach.specialties.any(
          (s) => s.toLowerCase().contains(normalized),
        );
    }
  }
}
