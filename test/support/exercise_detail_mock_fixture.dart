import 'package:coachly/features/exercises/domain/exercise_detail_view_data.dart';

const latPulldownExerciseFixture = ExerciseDetailViewData(
  id: 'lat-pulldown',
  code: 'LAT_PULLDOWN',
  name: 'Lat Pulldown',
  description:
      'Trazione verticale al cavo che allena soprattutto dorsali e parte superiore della schiena.',
  catalogStatus: 'published',
  exerciseKind: 'Multi-joint',
  unilateral: false,
  bodyweight: false,
  media: ExerciseMediaViewData(
    kind: ExerciseMediaKind.placeholder,
    movementLabel: 'Vertical Pull',
  ),
  movementProfile: ExerciseMovementProfileViewData(
    pattern: 'Vertical Pull',
    jointClass: 'Multi-joint',
    resistanceSource: 'Cavo',
    kineticChain: 'Aperta',
    laterality: 'Bilaterale',
  ),
  biomechanics: ExerciseBiomechanicsViewData(
    training: ExerciseTrainingCharacteristicsViewData(
      stability: 'Moderata',
      spinalLoad: 'Basso',
      technicalDemand: 'Moderata',
    ),
    jointActions: [
      JointActionViewData(joint: 'Spalla', action: 'Adduzione ed estensione'),
      JointActionViewData(joint: 'Gomito', action: 'Flessione'),
      JointActionViewData(
        joint: 'Scapola',
        action: 'Depressione e rotazione verso il basso',
      ),
    ],
    resistanceProfile: [0.44, 0.58, 0.72, 0.78, 0.7, 0.55],
    evidenceOrigin: 'Modello biomeccanico Coachly',
    evidenceConfidence: 'Moderata',
  ),
  muscles: [
    MuscleViewData(
      id: 'latissimus-dorsi',
      name: 'Gran dorsale',
      role: MuscleRole.primary,
      tension: MuscleTensionViewData(
        lengthened: TensionLevel.high,
        midRange: TensionLevel.high,
        shortened: TensionLevel.moderate,
      ),
    ),
    MuscleViewData(
      id: 'teres-major',
      name: 'Grande rotondo',
      role: MuscleRole.secondary,
      tension: MuscleTensionViewData(
        lengthened: TensionLevel.moderate,
        midRange: TensionLevel.high,
        shortened: TensionLevel.moderate,
      ),
    ),
    MuscleViewData(
      id: 'biceps-brachii',
      name: 'Bicipite brachiale',
      role: MuscleRole.secondary,
      tension: MuscleTensionViewData(
        lengthened: TensionLevel.moderate,
        midRange: TensionLevel.moderate,
        shortened: TensionLevel.moderate,
      ),
    ),
    MuscleViewData(
      id: 'brachialis',
      name: 'Brachiale',
      role: MuscleRole.secondary,
      tension: MuscleTensionViewData(
        lengthened: TensionLevel.moderate,
        midRange: TensionLevel.moderate,
        shortened: TensionLevel.low,
      ),
    ),
    MuscleViewData(
      id: 'rhomboids',
      name: 'Romboidi',
      role: MuscleRole.stabilizer,
      tension: MuscleTensionViewData(
        lengthened: TensionLevel.low,
        midRange: TensionLevel.moderate,
        shortened: TensionLevel.moderate,
      ),
    ),
  ],
  equipment: [EquipmentViewData(name: 'Lat Pulldown Machine', required: true)],
  execution: ExerciseExecutionViewData(
    steps: [
      'Blocca le cosce sotto i rulli e appoggia bene i piedi.',
      'Mantieni il torace stabile con una presa comoda.',
      'Porta i gomiti verso il basso controllando il ritorno.',
      'Fermati quando la barra raggiunge la parte alta del petto.',
      'Ritorna in allungamento senza perdere il controllo delle scapole.',
    ],
    commonMistakes: [
      'Oscillare il busto per generare slancio.',
      'Tirare la barra dietro al collo.',
      'Chiudere il movimento solo flettendo i gomiti.',
      'Lasciare risalire il carico senza controllo.',
    ],
  ),
  variants: [
    VariantViewData(
      id: 'close-grip-lat-pulldown',
      name: 'Close Grip Lat Pulldown',
      relationAxis: 'Presa',
      similarity: VariantSimilarity.verySimilar,
      summary: 'Presa più stretta e maggiore flessione del gomito.',
    ),
    VariantViewData(
      id: 'reverse-grip-lat-pulldown',
      name: 'Reverse Grip Lat Pulldown',
      relationAxis: 'Presa',
      similarity: VariantSimilarity.similar,
      summary: 'Presa supina con una diversa posizione di braccia e gomiti.',
    ),
    VariantViewData(
      id: 'single-arm-lat-pulldown',
      name: 'Single Arm Lat Pulldown',
      relationAxis: 'Unilaterale',
      similarity: VariantSimilarity.similar,
      summary:
          'Lavoro indipendente per lato con maggiore libertà di traiettoria.',
    ),
    VariantViewData(
      id: 'wide-grip-lat-pulldown',
      name: 'Wide Grip Lat Pulldown',
      relationAxis: 'Presa',
      similarity: VariantSimilarity.verySimilar,
      summary: 'Presa più ampia e ROM leggermente ridotto.',
    ),
    VariantViewData(
      id: 'straight-arm-pulldown',
      name: 'Straight Arm Pulldown',
      relationAxis: 'Tecnica',
      similarity: VariantSimilarity.different,
      summary: 'Movimento monoarticolare con gomito quasi esteso.',
    ),
  ],
  safetyNote:
      'Evita di generare slancio eccessivo con il busto e non tirare la barra dietro al collo.',
);
