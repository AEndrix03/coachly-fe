// ignore_for_file: no_hardcoded_strings
//
// Contenuto editoriale, non stringhe di interfaccia: 55 paragrafi che spiegano
// concetti di allenamento (azioni articolari, stabilità, profili di resistenza,
// tensione nel ROM). Tradurli a macchina significherebbe inventare contenuto
// formativo, quindi la versione inglese è un **lavoro di contenuto**, non di
// refactor: vedi `docs/development/13-i18n.md`.
//
// Quando la versione inglese esisterà, questo file va diviso per locale e
// l'ignore rimosso.

import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:flutter/material.dart';

enum CoachlyGuideTopic {
  jointActions,
  stability,
  trainingCharacteristics,
  resistanceSources,
  resistanceProfile,
  tensionInRom,
  dataMethodology,
}

extension CoachlyGuideTopicCopy on CoachlyGuideTopic {
  String get title => switch (this) {
    CoachlyGuideTopic.jointActions => 'Azioni articolari',
    CoachlyGuideTopic.stability => 'Stabilità richiesta',
    CoachlyGuideTopic.trainingCharacteristics =>
      'Caratteristiche di allenamento',
    CoachlyGuideTopic.resistanceSources => 'Fonti di resistenza',
    CoachlyGuideTopic.resistanceProfile => 'Profilo di resistenza',
    CoachlyGuideTopic.tensionInRom => 'Tensione nel ROM',
    CoachlyGuideTopic.dataMethodology => 'Leggere i dati Coachly',
  };

  String get intro => switch (this) {
    CoachlyGuideTopic.jointActions =>
      'Un modo semplice per descrivere quali articolazioni si muovono e in quale direzione durante un esercizio.',
    CoachlyGuideTopic.stability =>
      'Quanto supporto ricevi dall’esterno e quanto controllo deve produrre il tuo corpo mentre applichi forza.',
    CoachlyGuideTopic.trainingCharacteristics =>
      'Tre coordinate per capire quanto controllo, carico sulla colonna e precisione tecnica richiede un esercizio.',
    CoachlyGuideTopic.resistanceSources =>
      'La resistenza non arriva sempre dalla stessa direzione: capire la fonte rende più leggibile tutto il movimento.',
    CoachlyGuideTopic.resistanceProfile =>
      'Una mappa qualitativa di come cambia la richiesta meccanica dall’inizio alla fine del movimento.',
    CoachlyGuideTopic.tensionInRom =>
      'Una lettura qualitativa delle zone del movimento in cui il muscolo target può ricevere tensione significativa.',
    CoachlyGuideTopic.dataMethodology =>
      'Come distinguere dati osservati, modelli biomeccanici e stime senza trasformarli in falsa precisione.',
  };
}

class CoachlyConceptGuidePage extends StatelessWidget {
  final CoachlyGuideTopic topic;

  const CoachlyConceptGuidePage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: Builder(
        builder: (context) {
          final colors = context.exerciseTheme;
          return Scaffold(
            backgroundColor: colors.background,
            appBar: AppBar(
              backgroundColor: colors.background,
              surfaceTintColor: Colors.transparent,
              foregroundColor: colors.textPrimary,
              titleSpacing: 4,
              title: const Text(
                'Coachly Guide',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            body: SafeArea(
              top: false,
              child: CustomScrollView(
                key: Key('coachly-guide-${topic.name}'),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                    sliver: SliverList.list(
                      children: [
                        Text(
                          'IMPARA IL CONCETTO',
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          topic.title,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 29,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          topic.intro,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _GuideVisual(child: _topicVisual(topic)),
                        const SizedBox(height: 30),
                        ..._topicContent(topic),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topicVisual(CoachlyGuideTopic topic) => switch (topic) {
    CoachlyGuideTopic.jointActions => const _JointActionsVisual(),
    CoachlyGuideTopic.stability => const _StabilityVisual(),
    CoachlyGuideTopic.trainingCharacteristics =>
      const _TrainingCharacteristicsVisual(),
    CoachlyGuideTopic.resistanceSources => const _ResistanceSourcesVisual(),
    CoachlyGuideTopic.resistanceProfile => const _ResistanceProfileVisual(),
    CoachlyGuideTopic.tensionInRom => const _TensionRomVisual(),
    CoachlyGuideTopic.dataMethodology => const _EvidenceVisual(),
  };

  List<Widget> _topicContent(CoachlyGuideTopic topic) => switch (topic) {
    CoachlyGuideTopic.jointActions => const [
      _GuideSection(
        title: 'Leggile così',
        body:
            'Il nome dell’articolazione indica dove osservare il movimento. Il termine successivo descrive la direzione: per esempio, flessione del gomito significa che l’angolo tra braccio e avambraccio si riduce.',
      ),
      _GuideSection(
        title: 'Un esercizio, più azioni',
        body:
            'Nei movimenti multi-articolari succedono più cose insieme. Nel Lat Pulldown la spalla adduce o estende mentre il gomito si flette. L’elenco non è una classifica dei muscoli: è una descrizione del gesto.',
      ),
      _GuideCallout(
        icon: Icons.compare_arrows_rounded,
        title: 'Per confrontare esercizi',
        body:
            'Due esercizi possono allenare la stessa zona ma usare azioni articolari o traiettorie diverse. Questo può renderli complementari, anche se a prima vista sembrano simili.',
      ),
      _GuideSection(
        title: 'Parole che incontrerai spesso',
        child: _DefinitionList(
          items: [
            ('Flessione / estensione', 'L’angolo si chiude / si apre.'),
            (
              'Abduzione / adduzione',
              'L’arto si allontana / si avvicina al corpo.',
            ),
            ('Rotazione', 'Il segmento ruota attorno al proprio asse.'),
          ],
        ),
      ),
    ],
    CoachlyGuideTopic.stability => const [
      _GuideSection(
        title: 'Che cosa misura davvero',
        body:
            'Non misura quanto sei bravo a stare in equilibrio. Indica quanta parte della posizione e della traiettoria viene sostenuta da panca, macchina o appoggi, e quanta devi controllarne tu.',
      ),
      _GuideSection(
        title: 'Due esempi',
        child: _DefinitionList(
          items: [
            (
              'Rematore con petto supportato',
              'Più stabile: il busto è sostenuto e puoi concentrarti sulla trazione.',
            ),
            (
              'Rematore busto flesso',
              'Meno stabile: anche tronco e anche devono mantenere la posizione.',
            ),
          ],
        ),
      ),
      _GuideCallout(
        icon: Icons.balance_rounded,
        title: 'Più stabile non significa migliore',
        body:
            'La stabilità può aiutare a portare sforzo sul target. Una richiesta di controllo maggiore può essere utile per altri obiettivi. La scelta dipende da ciò che vuoi allenare e dalla fatica che puoi gestire.',
      ),
      _GuideSection(
        title: 'Domanda pratica',
        body:
            'Il limite della serie è il muscolo che vuoi allenare oppure il tentativo di mantenere posizione e traiettoria? La risposta aiuta a scegliere il livello di stabilità adatto.',
      ),
    ],
    CoachlyGuideTopic.trainingCharacteristics => const [
      _GuideSection(
        title: 'Tre informazioni, non un voto',
        body:
            'Stabilità richiesta, carico spinale e richiesta tecnica descrivono aspetti diversi dell’esercizio. Un valore alto o basso non rende automaticamente il movimento migliore o peggiore.',
      ),
      _GuideSection(
        title: 'Come leggerle',
        child: _DefinitionList(
          items: [
            (
              'Stabilità richiesta',
              'Quanto controllo devi produrre rispetto al supporto offerto da macchina, panca e appoggi.',
            ),
            (
              'Carico spinale',
              'Quanto la colonna tende a partecipare alla gestione del carico esterno e della posizione.',
            ),
            (
              'Richiesta tecnica',
              'Quanto coordinazione, precisione e pratica servono per ripetere bene il gesto.',
            ),
          ],
        ),
      ),
      _GuideCallout(
        icon: Icons.tune_rounded,
        title: 'Usale nel contesto',
        body:
            'Dopo molto lavoro per schiena o gambe potresti preferire più supporto e minor carico spinale. Quando vuoi allenare anche il controllo del gesto, una richiesta tecnica maggiore può invece essere intenzionale.',
      ),
      _GuideSection(
        title: 'Per confrontare due esercizi',
        body:
            'Parti dal target e dal pattern, poi usa queste tre caratteristiche per capire quale variante si integra meglio nella seduta e quale costo di fatica o apprendimento comporta.',
      ),
    ],
    CoachlyGuideTopic.resistanceSources => const [
      _GuideSection(
        title: 'Pesi liberi',
        body:
            'Con manubri, bilancieri e kettlebell la gravità tira sempre verso il basso. La difficoltà cambia quando cambia la distanza tra il peso e l’articolazione che ruota.',
      ),
      _GuideSection(
        title: 'Cavi',
        body:
            'Il cavo tira lungo la direzione della fune, verso la carrucola. Spostare altezza e posizione della carrucola cambia la linea di forza senza cambiare necessariamente il gesto.',
      ),
      _GuideSection(
        title: 'Macchine',
        body:
            'Guide, leve e camme definiscono gran parte della traiettoria e possono modificare il vantaggio meccanico durante il ROM. Due macchine con lo stesso nome possono quindi avere sensazioni diverse.',
      ),
      _GuideSection(
        title: 'Corpo libero ed elastici',
        body:
            'Nel corpo libero la resistenza dipende dal peso corporeo e dalle leve. Negli elastici aumenta in genere con l’allungamento: più li tendi, più cresce la forza che producono.',
      ),
      _GuideCallout(
        icon: Icons.explore_rounded,
        title: 'La domanda da farti',
        body:
            'In quale direzione mi sta tirando la resistenza in questo punto del movimento? È il primo passo per capire il profilo dell’esercizio.',
      ),
    ],
    CoachlyGuideTopic.resistanceProfile => const [
      _GuideSection(
        title: 'Come si legge il grafico',
        body:
            'Da sinistra a destra percorri il range di movimento. Una linea più alta indica una richiesta meccanica esterna relativamente maggiore; una linea più bassa indica una richiesta minore.',
      ),
      _GuideCallout(
        icon: Icons.warning_amber_rounded,
        title: 'Non è una misura diretta della tensione',
        body:
            'Il profilo descrive la resistenza esterna. La tensione del muscolo dipende anche da tecnica, leve articolari, anatomia e capacità del muscolo nelle diverse lunghezze.',
      ),
      _GuideSection(title: 'Tre forme frequenti', child: _ProfileExamples()),
      _GuideSection(
        title: 'Allungato, medio, accorciato',
        body:
            'Queste parole descrivono la lunghezza del muscolo target, non automaticamente inizio, metà e fine del gesto. Prima identifica quale muscolo osservi, poi collega la sua lunghezza alla posizione articolare.',
      ),
      _GuideSection(
        title: 'Capire la ridondanza',
        body:
            'Due esercizi sono potenzialmente ridondanti quando condividono target, azioni articolari, traiettoria e zona di massima richiesta. Se il profilo enfatizza regioni diverse del ROM, possono invece completarsi.',
      ),
      _GuideChecklist(
        title: 'Confronto rapido tra due esercizi',
        items: [
          'Allenano davvero lo stesso muscolo target?',
          'Usano azioni articolari e traiettorie simili?',
          'Dove cresce e dove cala la richiesta esterna?',
          'Quale dei due aggiunge uno stimolo che l’altro non copre?',
        ],
      ),
    ],
    CoachlyGuideTopic.tensionInRom => const [
      _GuideSection(
        title: 'Le tre zone',
        child: _DefinitionList(
          items: [
            ('Allungato', 'Il muscolo target è vicino a una posizione lunga.'),
            ('Medio ROM', 'Il muscolo attraversa una lunghezza intermedia.'),
            ('Accorciato', 'Il muscolo è vicino a una posizione corta.'),
          ],
        ),
      ),
      _GuideSection(
        title: 'Che cosa significa “alta”',
        body:
            'Coachly segnala qualitativamente che in quella regione può esserci tensione significativa sul target. Non significa 90%, non è un voto dell’esercizio e non garantisce più crescita.',
      ),
      _GuideCallout(
        icon: Icons.science_outlined,
        title: 'Non è EMG',
        body:
            'L’indicatore combina una lettura biomeccanica del movimento con la funzione del muscolo. Non rappresenta attività elettrica misurata né una percentuale di ipertrofia.',
      ),
      _GuideSection(
        title: 'Come usarlo',
        body:
            'Confronta esercizi per lo stesso target e cerca coperture diverse del ROM. Poi considera comfort, progressione, stabilità e capacità di eseguire serie di qualità: il profilo non sostituisce questi criteri.',
      ),
    ],
    CoachlyGuideTopic.dataMethodology => const [
      _GuideSection(
        title: 'Tre livelli di informazione',
        child: _DefinitionList(
          items: [
            ('Misurazione', 'Un dato raccolto direttamente con uno strumento.'),
            ('Osservazione', 'Ciò che si vede nella tecnica o nel movimento.'),
            ('Modello', 'Una stima costruita da anatomia, leve e meccanica.'),
          ],
        ),
      ),
      _GuideSection(
        title: 'Che cosa indica l’affidabilità',
        body:
            'Descrive quanto è solida la base dell’informazione e quanto dipende da assunzioni. “Moderata” non significa inutile: significa che va letta come guida, non come misura esatta per ogni persona.',
      ),
      _GuideCallout(
        icon: Icons.straighten_rounded,
        title: 'Perché evitiamo le percentuali',
        body:
            'Numeri molto precisi possono suggerire una certezza che i dati non possiedono. Categorie qualitative chiare sono spesso più oneste e più utili per decidere.',
      ),
      _GuideSection(
        title: 'La variabilità individuale conta',
        body:
            'Proporzioni corporee, tecnica, attrezzatura e mobilità possono cambiare l’esperienza meccanica. Usa Coachly per formulare una buona ipotesi, poi verifica esecuzione, comfort e progressi.',
      ),
    ],
  };
}

class _GuideVisual extends StatelessWidget {
  final Widget child;

  const _GuideVisual({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colors.border),
        ),
        child: Padding(padding: const EdgeInsets.all(18), child: child),
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  final String title;
  final String? body;
  final Widget? child;

  const _GuideSection({required this.title, this.body, this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 9),
          if (body case final body?)
            Text(
              body,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          if (child case final child?) child,
        ],
      ),
    );
  }
}

class _GuideCallout extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _GuideCallout({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.primaryMuted.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(color: colors.textSecondary, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DefinitionList extends StatelessWidget {
  final List<(String, String)> items;

  const _DefinitionList({required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    items[index].$1,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    items[index].$2,
                    style: TextStyle(color: colors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          if (index != items.length - 1)
            Divider(height: 1, color: colors.border),
        ],
      ],
    );
  }
}

class _GuideChecklist extends StatelessWidget {
  final String title;
  final List<String> items;

  const _GuideChecklist({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 15,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(color: colors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ResistanceSourcesVisual extends StatelessWidget {
  const _ResistanceSourcesVisual();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SourceGlyph(
              width: width,
              icon: Icons.fitness_center_rounded,
              direction: Icons.south_rounded,
              label: 'Pesi liberi',
              caption: 'Gravità verso il basso',
            ),
            _SourceGlyph(
              width: width,
              icon: Icons.cable_rounded,
              direction: Icons.trending_flat_rounded,
              label: 'Cavi',
              caption: 'Forza lungo la fune',
            ),
            _SourceGlyph(
              width: width,
              icon: Icons.precision_manufacturing_rounded,
              direction: Icons.alt_route_rounded,
              label: 'Macchine',
              caption: 'Leve e traiettoria guidata',
            ),
            _SourceGlyph(
              width: width,
              icon: Icons.accessibility_new_rounded,
              direction: Icons.compress_rounded,
              label: 'Corpo / elastici',
              caption: 'Leve o tensione crescente',
            ),
          ],
        );
      },
    );
  }
}

class _SourceGlyph extends StatelessWidget {
  final double width;
  final IconData icon;
  final IconData direction;
  final String label;
  final String caption;

  const _SourceGlyph({
    required this.width,
    required this.icon,
    required this.direction,
    required this.label,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.textPrimary, size: 25),
              const Spacer(),
              Icon(direction, color: colors.primary, size: 21),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResistanceProfileVisual extends StatelessWidget {
  const _ResistanceProfileVisual();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label:
          'Grafico del profilo di resistenza: richiesta bassa all’inizio, massima nel medio ROM e moderata alla fine.',
      child: SizedBox(
        height: 210,
        width: double.infinity,
        child: CustomPaint(
          painter: _GuideProfilePainter(theme: context.exerciseTheme),
        ),
      ),
    );
  }
}

class _GuideProfilePainter extends CustomPainter {
  final CoachlyExerciseTheme theme;

  const _GuideProfilePainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    const left = 12.0;
    final bottom = size.height - 34;
    final chartWidth = size.width - 24;
    final chartHeight = size.height - 64;
    final axisPaint = Paint()
      ..color = theme.border
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(left, bottom),
      Offset(size.width - 12, bottom),
      axisPaint,
    );

    final path = Path()
      ..moveTo(left, bottom - chartHeight * 0.2)
      ..cubicTo(
        left + chartWidth * 0.22,
        bottom - chartHeight * 0.35,
        left + chartWidth * 0.35,
        bottom - chartHeight * 0.88,
        left + chartWidth * 0.52,
        bottom - chartHeight * 0.86,
      )
      ..cubicTo(
        left + chartWidth * 0.7,
        bottom - chartHeight * 0.84,
        left + chartWidth * 0.78,
        bottom - chartHeight * 0.42,
        size.width - 12,
        bottom - chartHeight * 0.48,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = theme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    final peak = Offset(left + chartWidth * 0.52, bottom - chartHeight * 0.86);
    canvas.drawCircle(peak, 5, Paint()..color = theme.primary);
    _paintLabel(canvas, 'MASSIMO', peak.translate(0, -27), theme.primary);
    _paintLabel(
      canvas,
      'INIZIO ROM',
      Offset(left, bottom + 10),
      theme.textSecondary,
      align: TextAlign.left,
    );
    _paintLabel(
      canvas,
      'FINE ROM',
      Offset(size.width - 12, bottom + 10),
      theme.textSecondary,
      align: TextAlign.right,
    );
  }

  void _paintLabel(
    Canvas canvas,
    String text,
    Offset anchor,
    Color color, {
    TextAlign align = TextAlign.center,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    final dx = switch (align) {
      TextAlign.left => anchor.dx,
      TextAlign.right => anchor.dx - painter.width,
      _ => anchor.dx - painter.width / 2,
    };
    painter.paint(canvas, Offset(dx, anchor.dy));
  }

  @override
  bool shouldRepaint(covariant _GuideProfilePainter oldDelegate) =>
      oldDelegate.theme != theme;
}

class _ProfileExamples extends StatelessWidget {
  const _ProfileExamples();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ProfileExample(
          icon: Icons.trending_up_rounded,
          title: 'Crescente',
          body: 'La richiesta aumenta procedendo nel ROM.',
        ),
        _ProfileExample(
          icon: Icons.show_chart_rounded,
          title: 'Picco nel mezzo',
          body: 'La regione centrale è relativamente più impegnativa.',
        ),
        _ProfileExample(
          icon: Icons.trending_down_rounded,
          title: 'Decrescente',
          body: 'La richiesta è maggiore prima e poi diminuisce.',
        ),
      ],
    );
  }
}

class _ProfileExample extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _ProfileExample({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: colors.primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: TextStyle(color: colors.textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JointActionsVisual extends StatelessWidget {
  const _JointActionsVisual();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MotionGlyph(icon: Icons.compress_rounded, label: 'Flessione'),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _MotionGlyph(
            icon: Icons.open_in_full_rounded,
            label: 'Estensione',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _MotionGlyph(
            icon: Icons.rotate_right_rounded,
            label: 'Rotazione',
          ),
        ),
      ],
    );
  }
}

class _MotionGlyph extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MotionGlyph({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colors.primary, size: 27),
        ),
        const SizedBox(height: 9),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _TrainingCharacteristicsVisual extends StatelessWidget {
  const _TrainingCharacteristicsVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TrainingMetric(
          icon: Icons.balance_rounded,
          label: 'Stabilità',
          value: 'Controllo',
        ),
        SizedBox(height: 12),
        _TrainingMetric(
          icon: Icons.vertical_align_center_rounded,
          label: 'Carico spinale',
          value: 'Stress',
        ),
        SizedBox(height: 12),
        _TrainingMetric(
          icon: Icons.gesture_rounded,
          label: 'Tecnica',
          value: 'Precisione',
        ),
      ],
    );
  }
}

class _TrainingMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TrainingMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: colors.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

class _StabilityVisual extends StatelessWidget {
  const _StabilityVisual();

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      children: [
        Row(
          children: [
            _StabilityNode(
              icon: Icons.airline_seat_recline_normal_rounded,
              color: colors.primary,
            ),
            Expanded(child: Divider(color: colors.border, thickness: 2)),
            _StabilityNode(
              icon: Icons.fitness_center_rounded,
              color: colors.info,
            ),
            Expanded(child: Divider(color: colors.border, thickness: 2)),
            _StabilityNode(
              icon: Icons.directions_run_rounded,
              color: colors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Text(
                'Più supporto esterno',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Più controllo tuo',
                textAlign: TextAlign.end,
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StabilityNode extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _StabilityNode({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.exerciseTheme.surfaceElevated,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class _TensionRomVisual extends StatelessWidget {
  const _TensionRomVisual();

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _RomBar(
          label: 'Allungato',
          level: 'ALTA',
          height: 104,
          color: colors.primary,
        ),
        const SizedBox(width: 10),
        _RomBar(
          label: 'Medio',
          level: 'ALTA',
          height: 104,
          color: colors.primary,
        ),
        const SizedBox(width: 10),
        _RomBar(
          label: 'Accorciato',
          level: 'MODERATA',
          height: 72,
          color: colors.info,
        ),
      ],
    );
  }
}

class _RomBar extends StatelessWidget {
  final String label;
  final String level;
  final double height;
  final Color color;

  const _RomBar({
    required this.label,
    required this.level,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: double.infinity,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.28)),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _EvidenceVisual extends StatelessWidget {
  const _EvidenceVisual();

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Column(
      children: [
        _EvidenceLayer(
          icon: Icons.straighten_rounded,
          label: 'Misurazione',
          color: colors.primary,
        ),
        const SizedBox(height: 9),
        _EvidenceLayer(
          icon: Icons.visibility_outlined,
          label: 'Osservazione',
          color: colors.info,
        ),
        const SizedBox(height: 9),
        _EvidenceLayer(
          icon: Icons.hub_outlined,
          label: 'Modello biomeccanico',
          color: colors.textSecondary,
        ),
      ],
    );
  }
}

class _EvidenceLayer extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _EvidenceLayer({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: context.exerciseTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 11),
          Text(
            label,
            style: TextStyle(
              color: context.exerciseTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
