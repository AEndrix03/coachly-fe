import 'dart:ui';

import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/features/feedback/feedback_hub_controller.dart';
import 'package:coachly/shared/widgets/headers/page_header.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  final _feedbackTitle = TextEditingController();
  final _feedbackBody = TextEditingController();
  final _featureTitle = TextEditingController();
  final _featureBody = TextEditingController();
  final _comment = TextEditingController();

  final Map<String, Set<String>> _pollSelection = <String, Set<String>>{};

  bool _loadingFeedback = false;
  bool _loadingFeature = false;
  bool _loadingComment = false;
  final Set<String> _loadingPolls = <String>{};
  final Set<String> _loadingVotes = <String>{};

  String _feedbackType = 'GENERAL';
  int _rating = 4;
  String _severity = 'MEDIUM';
  bool _reproducible = true;
  String _category = 'UX';

  static const _categories = ['UX', 'Performance', 'Workout', 'AI Coach'];

  static const _panelColor = Color(0xFF0B1223);
  static const _panelBorder = Color(0xFF2A3A5D);
  static const _accentA = Color(0xFF14B8A6);
  static const _accentB = Color(0xFF0EA5E9);
  static const _accentC = Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _feedbackTitle.dispose();
    _feedbackBody.dispose();
    _featureTitle.dispose();
    _featureBody.dispose();
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackHubControllerProvider);
    final ctrl = ref.read(feedbackHubControllerProvider.notifier);
    final toast = ref.read(appToastServiceProvider);

    final online = ref
        .watch(connectivityProvider)
        .maybeWhen(
          data: (values) => values.any((v) => v != ConnectivityResult.none),
          orElse: () => true,
        );

    final commentsTotal = state.featureRequests.fold<int>(
      0,
      (prev, item) => prev + item.commentsCount,
    );

    return Scaffold(
      body: Stack(
        children: [
          const _FeedbackBackdrop(),
          Column(
            children: [
              PageHeader(
                badgeIcon: Icons.forum_rounded,
                badgeLabel: 'Feedback Hub',
                title: 'Roadmap Collaborativa',
                subtitle:
                    'Voti, discussioni e insight in una control room unica e condivisa.',
                gradientColors: const [
                  Color(0xFF0F766E),
                  Color(0xFF0C4A6E),
                  Color(0xFF1E3A8A),
                ],
                bottom: Row(
                  children: [
                    _headStat('Sondaggi', '${state.polls.length}'),
                    const SizedBox(width: 8),
                    _headStat('Richieste', '${state.featureRequests.length}'),
                    const SizedBox(width: 8),
                    _headStat('Commenti', '$commentsTotal'),
                  ],
                ),
              ),
              if (!online)
                _banner(
                  message: 'Offline: sincronizzazione sospesa.',
                  icon: Icons.cloud_off_rounded,
                  color: _accentC,
                ),
              if (state.errorMessage != null)
                _banner(
                  message: state.errorMessage!.replaceFirst('Exception: ', ''),
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFFB7185),
                ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF111A30), Color(0xFF121D39)],
                  ),
                  border: Border.all(
                    color: _panelBorder.withValues(alpha: 0.55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabs,
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.tab,
                  splashBorderRadius: BorderRadius.circular(14),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _accentB.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Panoramica'),
                    Tab(text: 'Sondaggi'),
                    Tab(text: 'Richieste'),
                    Tab(text: 'Invia'),
                  ],
                ),
              ),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabs,
                        children: [
                          _overview(state),
                          _polls(state, ctrl, toast, online),
                          _features(state, ctrl, toast, online),
                          _sendFeedback(ctrl, toast, online),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withValues(alpha: 0.16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _banner({
    required String message,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child, {EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: padding ?? const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _panelColor.withValues(alpha: 0.82),
                const Color(0xFF101A33).withValues(alpha: 0.82),
              ],
            ),
            border: Border.all(color: _panelBorder.withValues(alpha: 0.65)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {String? subtitle, IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accentA.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _accentA.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: _accentA, size: 18),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _overview(FeedbackHubState state) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                'Situazione Prodotto',
                subtitle:
                    'Allinea team e utenti su priorita reali basate su segnali concreti.',
                icon: Icons.auto_graph_rounded,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _metricTile(
                      title: 'Poll Attivi',
                      value: '${state.polls.length}',
                      color: _accentB,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _metricTile(
                      title: 'Feature Aperte',
                      value: '${state.featureRequests.length}',
                      color: _accentA,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (state.featureRequests.isEmpty)
          _emptyStateCard(
            title: 'Nessuna richiesta disponibile',
            subtitle:
                'Quando arriveranno nuove proposte le vedrai qui con voti e trend.',
            icon: Icons.lightbulb_outline_rounded,
          )
        else
          ...state.featureRequests
              .take(3)
              .map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _card(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                f.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _softPill(f.status, color: const Color(0xFF60A5FA)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          f.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _inlineMetric(
                              icon: Icons.rocket_launch_rounded,
                              label: '${f.upvotesCount} voti',
                              color: _accentA,
                            ),
                            const SizedBox(width: 10),
                            _inlineMetric(
                              icon: Icons.chat_bubble_outline_rounded,
                              label: '${f.commentsCount} commenti',
                              color: _accentB,
                            ),
                            const Spacer(),
                            Text(
                              _formatDate(f.createdAt),
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _polls(
    FeedbackHubState state,
    FeedbackHubController ctrl,
    AppToastService toast,
    bool online,
  ) {
    if (state.polls.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          _emptyStateCard(
            title: 'Nessun sondaggio disponibile',
            subtitle: 'Appena ne viene pubblicato uno, compare qui.',
            icon: Icons.how_to_vote_rounded,
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      itemCount: state.polls.length,
      itemBuilder: (_, i) {
        final p = state.polls[i];
        final selected = _pollSelection[p.id] ?? <String>{};
        final result = state.pollResultsById[p.id];
        final sending = _loadingPolls.contains(p.id);
        final answered = state.answeredPollIds.contains(p.id);
        final canVote = online && p.status == 'PUBLISHED' && !answered;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _softPill(
                      p.multipleChoice ? 'Multi' : 'Singola',
                      color: _accentB,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  p.description,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 10),
                ...p.options.map((o) {
                  final active = selected.contains(o.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: active
                            ? _accentB.withValues(alpha: 0.18)
                            : Colors.white.withValues(alpha: 0.04),
                        border: Border.all(
                          color: active
                              ? _accentB.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: canVote
                            ? () {
                                setState(() {
                                  final set =
                                      _pollSelection[p.id] ?? <String>{};
                                  if (p.multipleChoice) {
                                    active ? set.remove(o.id) : set.add(o.id);
                                  } else {
                                    set
                                      ..clear()
                                      ..add(o.id);
                                  }
                                  _pollSelection[p.id] = set;
                                });
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                active
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                color: active ? _accentB : Colors.white54,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  o.label,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: sending
                            ? null
                            : () async {
                                setState(() => _loadingPolls.add(p.id));
                                try {
                                  await ctrl.loadPollResults(p.id);
                                } catch (e) {
                                  if (mounted) {
                                    toast.showError(
                                      context,
                                      '$e',
                                      title: 'Errore',
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _loadingPolls.remove(p.id));
                                  }
                                }
                              },
                        icon: const Icon(Icons.bar_chart_rounded),
                        label: const Text('Risultati'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: !canVote || selected.isEmpty || sending
                            ? null
                            : () async {
                                setState(() => _loadingPolls.add(p.id));
                                try {
                                  await ctrl.submitPollResponse(
                                    pollId: p.id,
                                    optionIds: selected.toList(),
                                  );
                                  if (mounted) {
                                    toast.showSuccess(
                                      context,
                                      'Risposta inviata',
                                      title: 'Ok',
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    toast.showError(
                                      context,
                                      '$e',
                                      title: 'Errore',
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _loadingPolls.remove(p.id));
                                  }
                                }
                              },
                        icon: const Icon(Icons.send_rounded),
                        label: Text(sending ? 'Invio...' : 'Vota'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _accentA,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                if (result != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Partecipanti: ${result.participants}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  ...result.options.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  r.label,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                '${r.votes} Ã¢â‚¬Â¢ ${r.percentage.toStringAsFixed(1)}%',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 9,
                              value: (r.percentage / 100).clamp(0, 1),
                              backgroundColor: Colors.white12,
                              color: _accentA,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _features(
    FeedbackHubState state,
    FeedbackHubController ctrl,
    AppToastService toast,
    bool online,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                'Proponi Una Feature',
                subtitle:
                    'Descrivi il valore, scegli la categoria e mettila subito in votazione.',
                icon: Icons.add_circle_outline_rounded,
              ),
              const SizedBox(height: 10),
              _input(_featureTitle, 'Titolo richiesta'),
              const SizedBox(height: 8),
              _input(_featureBody, 'Descrizione', min: 3, max: 5),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _categories
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                        selectedColor: _accentA.withValues(alpha: 0.2),
                        side: BorderSide(
                          color: _category == c
                              ? _accentA.withValues(alpha: 0.9)
                              : Colors.white.withValues(alpha: 0.18),
                        ),
                        labelStyle: TextStyle(
                          color: _category == c ? _accentA : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        showCheckmark: false,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: !online || _loadingFeature
                      ? null
                      : () async {
                          final title = _featureTitle.text.trim();
                          final body = _featureBody.text.trim();
                          if (title.isEmpty || body.isEmpty) {
                            toast.showWarning(
                              context,
                              'Compila titolo e descrizione',
                              title: 'Attenzione',
                            );
                            return;
                          }
                          setState(() => _loadingFeature = true);
                          try {
                            await ctrl.submitFeatureRequest(
                              title: title,
                              description: body,
                              category: _category,
                            );
                            _featureTitle.clear();
                            _featureBody.clear();
                            if (mounted) {
                              toast.showSuccess(
                                context,
                                'Richiesta inviata',
                                title: 'Ok',
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              toast.showError(context, '$e', title: 'Errore');
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _loadingFeature = false);
                            }
                          }
                        },
                  icon: const Icon(Icons.campaign_rounded),
                  label: Text(_loadingFeature ? 'Invio...' : 'Invia richiesta'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _accentA,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (state.featureRequests.isEmpty)
          _emptyStateCard(
            title: 'Nessuna richiesta presente',
            subtitle: 'Proponi la prima feature e avvia la discussione.',
            icon: Icons.hub_outlined,
          )
        else
          ...state.featureRequests.map((f) {
            final selected = f.id == state.selectedFeatureId;
            final voting = _loadingVotes.contains(f.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _card(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            f.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _softPill(f.status, color: const Color(0xFF60A5FA)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      f.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _softPill('${f.upvotesCount} voti', color: _accentA),
                        _softPill(
                          '${f.commentsCount} commenti',
                          color: _accentB,
                        ),
                        if ((f.category ?? '').isNotEmpty)
                          _softPill(f.category!, color: _accentC),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => ctrl.loadComments(f.id),
                            icon: Icon(
                              selected
                                  ? Icons.forum_rounded
                                  : Icons.forum_outlined,
                            ),
                            label: Text(
                              selected ? 'Thread aperto' : 'Apri thread',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: !online || voting
                                ? null
                                : () async {
                                    setState(() => _loadingVotes.add(f.id));
                                    try {
                                      await ctrl.voteFeatureRequest(f.id);
                                      if (mounted) {
                                        toast.showSuccess(
                                          context,
                                          'Voto registrato',
                                          title: 'Ok',
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        toast.showError(
                                          context,
                                          '$e',
                                          title: 'Errore',
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(
                                          () => _loadingVotes.remove(f.id),
                                        );
                                      }
                                    }
                                  },
                            icon: const Icon(Icons.thumb_up_alt_rounded),
                            label: Text(voting ? 'Invio...' : 'Supporta'),
                            style: FilledButton.styleFrom(
                              backgroundColor: _accentA,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        if (state.selectedFeatureId != null) ...[
          const SizedBox(height: 4),
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(
                  'Discussione',
                  subtitle: 'Commenti e confronto sulla richiesta selezionata.',
                  icon: Icons.chat_rounded,
                ),
                const SizedBox(height: 10),
                if (state.comments.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Text(
                      'Nessun commento, apri tu la discussione.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ...state.comments.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.body,
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _inlineMetric(
                                  icon: Icons.auto_awesome_rounded,
                                  label: 'Score ${c.score}',
                                  color: _accentB,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _formatDate(c.createdAt),
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                _input(_comment, 'Aggiungi un commento', min: 2, max: 4),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: !online || _loadingComment
                        ? null
                        : () async {
                            final featureId = state.selectedFeatureId;
                            final body = _comment.text.trim();
                            if (featureId == null || body.isEmpty) {
                              return;
                            }
                            setState(() => _loadingComment = true);
                            try {
                              await ctrl.submitComment(
                                featureId: featureId,
                                body: body,
                              );
                              _comment.clear();
                              if (mounted) {
                                toast.showSuccess(
                                  context,
                                  'Commento pubblicato',
                                  title: 'Ok',
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                toast.showError(context, '$e', title: 'Errore');
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _loadingComment = false);
                              }
                            }
                          },
                    icon: const Icon(Icons.send_rounded),
                    label: Text(
                      _loadingComment ? 'Invio...' : 'Pubblica commento',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _accentA,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _sendFeedback(
    FeedbackHubController ctrl,
    AppToastService toast,
    bool online,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                'Invia Feedback Strutturato',
                subtitle:
                    'Segnala bug, review o contesto: ogni input alimenta le decisioni prodotto.',
                icon: Icons.edit_note_rounded,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ['GENERAL', 'REVIEW', 'BUG', 'CONTEXTUAL']
                    .map(
                      (t) => ChoiceChip(
                        label: Text(t),
                        selected: _feedbackType == t,
                        onSelected: (_) => setState(() => _feedbackType = t),
                        selectedColor: _accentB.withValues(alpha: 0.2),
                        side: BorderSide(
                          color: _feedbackType == t
                              ? _accentB.withValues(alpha: 0.9)
                              : Colors.white.withValues(alpha: 0.18),
                        ),
                        labelStyle: TextStyle(
                          color: _feedbackType == t ? _accentB : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        showCheckmark: false,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              _input(_feedbackTitle, 'Titolo feedback'),
              const SizedBox(height: 8),
              _input(_feedbackBody, 'Descrizione', min: 4, max: 7),
              if (_feedbackType == 'REVIEW') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.04),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Rating',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ...List.generate(
                        5,
                        (i) => IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => setState(() => _rating = i + 1),
                          icon: Icon(
                            i < _rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: _accentC,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_feedbackType == 'BUG') ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _severity,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: const Color(0xFF0F172A),
                  decoration: _inputDecoration('Severita'),
                  items: const [
                    DropdownMenuItem(value: 'LOW', child: Text('LOW')),
                    DropdownMenuItem(value: 'MEDIUM', child: Text('MEDIUM')),
                    DropdownMenuItem(value: 'HIGH', child: Text('HIGH')),
                    DropdownMenuItem(
                      value: 'CRITICAL',
                      child: Text('CRITICAL'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _severity = v ?? 'MEDIUM'),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.04),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: SwitchListTile(
                    value: _reproducible,
                    onChanged: (v) => setState(() => _reproducible = v),
                    title: const Text(
                      'Riproducibile',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeThumbColor: _accentA,
                    activeTrackColor: _accentA.withValues(alpha: 0.45),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: !online || _loadingFeedback
                      ? null
                      : () async {
                          final title = _feedbackTitle.text.trim();
                          final body = _feedbackBody.text.trim();
                          if (title.isEmpty || body.isEmpty) {
                            toast.showWarning(
                              context,
                              'Compila titolo e descrizione',
                              title: 'Attenzione',
                            );
                            return;
                          }
                          setState(() => _loadingFeedback = true);
                          try {
                            await ctrl.submitFeedback(
                              type: _feedbackType,
                              title: title,
                              body: body,
                              ratingValue: _feedbackType == 'REVIEW'
                                  ? _rating
                                  : null,
                              severity: _feedbackType == 'BUG'
                                  ? _severity
                                  : null,
                              reproducible: _feedbackType == 'BUG'
                                  ? _reproducible
                                  : null,
                            );
                            _feedbackTitle.clear();
                            _feedbackBody.clear();
                            if (mounted) {
                              toast.showSuccess(
                                context,
                                'Feedback inviato',
                                title: 'Grazie',
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              toast.showError(context, '$e', title: 'Errore');
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _loadingFeedback = false);
                            }
                          }
                        },
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: Text(_loadingFeedback ? 'Invio...' : 'Invia feedback'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _accentA,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    int min = 1,
    int max = 1,
  }) {
    return TextField(
      controller: controller,
      minLines: min,
      maxLines: max,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accentB, width: 1.2),
      ),
    );
  }

  Widget _metricTile({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inlineMetric({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _softPill(String text, {required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _emptyStateCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return _card(
      Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentB.withValues(alpha: 0.16),
              border: Border.all(color: _accentB.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: _accentB),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'adesso';
    }
    final d = date.toLocal();
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month';
  }
}

class _FeedbackBackdrop extends StatelessWidget {
  const _FeedbackBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF030712), Color(0xFF071126), Color(0xFF0B132B)],
        ),
      ),
      child: Stack(
        children: [
          _blob(
            size: 280,
            top: -70,
            left: -60,
            color: const Color(0xFF0891B2).withValues(alpha: 0.22),
          ),
          _blob(
            size: 220,
            top: 180,
            right: -90,
            color: const Color(0xFF10B981).withValues(alpha: 0.18),
          ),
          _blob(
            size: 200,
            bottom: -40,
            left: 70,
            color: const Color(0xFFF59E0B).withValues(alpha: 0.14),
          ),
        ],
      ),
    );
  }

  Widget _blob({
    required double size,
    Color color = Colors.white,
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 80, spreadRadius: 16),
            ],
          ),
        ),
      ),
    );
  }
}
