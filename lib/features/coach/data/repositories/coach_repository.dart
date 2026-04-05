import 'package:coachly/features/coach/data/models/coach_summary/coach_summary.dart';

abstract class CoachRepository {
  Future<List<CoachSummary>> getCoaches();
}
