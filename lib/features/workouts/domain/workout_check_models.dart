import 'package:coachly/features/exercises/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workouts/domain/workout_draft.dart';

enum WorkoutCheckSeverity { positive, information, review, insufficientData }

enum WorkoutCheckCategory {
  muscleCoverage,
  exerciseOverlap,
  movementProfile,
  sessionStructure,
  estimatedDuration,
  goalAlignment,
}

enum WorkoutCheckDataQuality { complete, partial, insufficient }

class WorkoutCheckFinding {
  final String id;
  final WorkoutCheckCategory category;
  final WorkoutCheckSeverity severity;
  final String titleKey;
  final String explanationKey;
  final Map<String, String> params;
  final List<WorkoutCheckEvidence> evidence;
  final String? sectionId;

  const WorkoutCheckFinding({
    required this.id,
    required this.category,
    required this.severity,
    required this.titleKey,
    required this.explanationKey,
    this.params = const {},
    this.evidence = const [],
    this.sectionId,
  });
}

class WorkoutCheckEvidence {
  final String key;
  final Map<String, String> params;
  const WorkoutCheckEvidence(this.key, {this.params = const {}});
}

class WorkoutCheckReport {
  final String mode;
  final List<WorkoutCheckFinding> findings;
  final WorkoutCheckDataQuality dataQuality;
  final DateTime generatedAt;
  final String draftRevision;
  final Map<String, int> muscleSetExposure;

  const WorkoutCheckReport({
    required this.mode,
    required this.findings,
    required this.dataQuality,
    required this.generatedAt,
    required this.draftRevision,
    this.muscleSetExposure = const {},
  });

  int get positiveCount => findings
      .where((finding) => finding.severity == WorkoutCheckSeverity.positive)
      .length;
  int get reviewCount => findings
      .where((finding) => finding.severity == WorkoutCheckSeverity.review)
      .length;
  int get insufficientCount => findings
      .where(
        (finding) => finding.severity == WorkoutCheckSeverity.insufficientData,
      )
      .length;
}

class WorkoutCheckContext {
  final WorkoutDraft draft;
  final Map<String, ExerciseDetailModel> exerciseDetails;

  const WorkoutCheckContext({
    required this.draft,
    required this.exerciseDetails,
  });
}

abstract interface class WorkoutCheckRule {
  String get id;
  bool supports(WorkoutCheckContext context);
  List<WorkoutCheckFinding> evaluate(WorkoutCheckContext context);
}
