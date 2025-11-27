enum WorkoutSortBy { name, date, duration, difficulty }

class WorkoutFilter {
  final WorkoutSortBy sortBy;
  final bool ascending;
  final String? searchQuery;
  final List<String>? coachIds;

  const WorkoutFilter({
    this.sortBy = WorkoutSortBy.date,
    this.ascending = false,
    this.searchQuery,
    this.coachIds,
  });

  WorkoutFilter copyWith({
    WorkoutSortBy? sortBy,
    bool? ascending,
    String? searchQuery,
    List<String>? coachIds,
  }) {
    return WorkoutFilter(
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      searchQuery: searchQuery ?? this.searchQuery,
      coachIds: coachIds ?? this.coachIds,
    );
  }
}
