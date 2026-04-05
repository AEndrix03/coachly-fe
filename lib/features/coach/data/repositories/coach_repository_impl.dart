import 'package:coachly/features/coach/data/models/coach_summary/coach_summary.dart';
import 'package:coachly/features/coach/data/repositories/coach_repository.dart';
import 'package:coachly/features/coach/data/services/coach_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  return CoachRepositoryImpl(
    ref.watch(coachServiceProvider),
    useMockData: true,
  );
});

class CoachRepositoryImpl implements CoachRepository {
  CoachRepositoryImpl(this._service, {this.useMockData = true});

  final CoachService _service;
  final bool useMockData;

  @override
  Future<List<CoachSummary>> getCoaches() async {
    if (useMockData) {
      return _mockCoaches;
    }

    return _service.fetchCoaches();
  }

  static final List<CoachSummary> _mockCoaches = <CoachSummary>[
    const CoachSummary(
      id: 'coach-1',
      displayName: 'Marco Vitali',
      handle: 'marcofit',
      accentColorHex: '#4A3AFF',
      specialties: <String>['Powerlifting', 'Forza', 'Online', 'Principianti'],
      rating: 4.9,
      activeClients: 58,
      avgResponseHours: 3,
      retentionRate: 0.91,
      isVerified: true,
      acceptingClients: true,
      priceRangeLabel: 'da EUR89/mese',
      modalityLabel: 'Online',
    ),
    const CoachSummary(
      id: 'coach-2',
      displayName: 'Elena Rossi',
      handle: 'elena_strength',
      accentColorHex: '#7B2FFF',
      specialties: <String>['Ipertrofia', 'Solo donne', 'Online'],
      rating: 4.8,
      activeClients: 42,
      avgResponseHours: 4,
      retentionRate: 0.87,
      isVerified: true,
      acceptingClients: true,
      priceRangeLabel: 'da EUR99/mese',
      modalityLabel: 'Ibrido',
    ),
    const CoachSummary(
      id: 'coach-3',
      displayName: 'Luca Ferretti',
      handle: 'cross_luca',
      accentColorHex: '#00D68F',
      specialties: <String>['CrossFit', 'Condizionamento', 'In presenza'],
      rating: 4.7,
      activeClients: 67,
      avgResponseHours: 6,
      retentionRate: 0.84,
      isVerified: true,
      acceptingClients: false,
      priceRangeLabel: 'da EUR120/mese',
      modalityLabel: 'In presenza',
    ),
    const CoachSummary(
      id: 'coach-4',
      displayName: 'Sara Bianchi',
      handle: 'sara_calis',
      accentColorHex: '#4A3AFF',
      specialties: <String>['Calisthenics', 'Mobilita', 'Principianti'],
      rating: 4.6,
      activeClients: 31,
      avgResponseHours: 5,
      retentionRate: 0.8,
      isVerified: false,
      acceptingClients: true,
      priceRangeLabel: 'da EUR69/mese',
      modalityLabel: 'Online',
    ),
    const CoachSummary(
      id: 'coach-5',
      displayName: 'Davide Neri',
      handle: 'davide_peak',
      accentColorHex: '#7B2FFF',
      specialties: <String>['Powerlifting', 'Ipertrofia', 'In presenza'],
      rating: 4.9,
      activeClients: 76,
      avgResponseHours: 2,
      retentionRate: 0.93,
      isVerified: true,
      acceptingClients: true,
      priceRangeLabel: 'da EUR140/mese',
      modalityLabel: 'Ibrido',
    ),
    const CoachSummary(
      id: 'coach-6',
      displayName: 'Giulia Conti',
      handle: 'coachgiulia',
      accentColorHex: '#00D68F',
      specialties: <String>['Ipertrofia', 'CrossFit', 'Online', 'Principianti'],
      rating: 4.5,
      activeClients: 24,
      avgResponseHours: 8,
      retentionRate: 0.76,
      isVerified: false,
      acceptingClients: true,
      modalityLabel: 'Online',
    ),
  ];
}
