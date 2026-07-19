import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExerciseCreatePage extends ConsumerStatefulWidget {
  const ExerciseCreatePage({super.key});

  @override
  ConsumerState<ExerciseCreatePage> createState() => _ExerciseCreatePageState();
}

class _ExerciseCreatePageState extends ConsumerState<ExerciseCreatePage> {
  final _page = PageController();
  final _nameIt = TextEditingController();
  final _nameEn = TextEditingController();
  final _descriptionIt = TextEditingController();
  final _tipsIt = TextEditingController();
  int _step = 0;
  bool _saving = false;
  String _difficulty = 'beginner';
  String _mechanics = 'compound';
  bool _bodyweight = true;
  bool _unilateral = false;

  @override
  void dispose() {
    _page.dispose();
    _nameIt.dispose();
    _nameEn.dispose();
    _descriptionIt.dispose();
    _tipsIt.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step == 0 && _nameIt.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci almeno il nome in italiano.')),
      );
      return;
    }
    if (_step < 2) {
      setState(() => _step += 1);
      await _page.animateToPage(
        _step,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
      return;
    }
    await _save();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final names = <String, String>{'it': _nameIt.text.trim()};
    if (_nameEn.text.trim().isNotEmpty) names['en'] = _nameEn.text.trim();
    final response = await ref
        .read(exerciseInfoPageRepositoryProvider)
        .createPersonalExercise(
          nameI18n: names,
          descriptionI18n: _descriptionIt.text.trim().isEmpty
              ? null
              : {'it': _descriptionIt.text.trim()},
          tipsI18n: _tipsIt.text.trim().isEmpty
              ? null
              : {'it': _tipsIt.text.trim()},
          difficultyLevel: _difficulty,
          mechanicsType: _mechanics,
          isBodyweight: _bodyweight,
          isUnilateral: _unilateral,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (!response.success || response.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? 'Impossibile salvare l’esercizio'),
        ),
      );
      return;
    }
    context.pop<ExerciseDetailModel>(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: const Text('Crea esercizio'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: LinearProgressIndicator(value: (_step + 1) / 3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                ['Identità', 'Tecnica', 'Istruzioni e media'][_step],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Completa un blocco alla volta: potrai sempre modificare l’esercizio in seguito.',
                style: TextStyle(color: Colors.white60),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                children: [_identity(), _technique(), _guidance()],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: () async {
                        setState(() => _step -= 1);
                        await _page.animateToPage(
                          _step,
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        );
                      },
                      child: const Text('Indietro'),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _saving ? null : _next,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _step == 2
                                ? Icons.save_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                    label: Text(_step == 2 ? 'Salva esercizio' : 'Continua'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _identity() => _stepBody([
    _field(_nameIt, 'Nome in italiano *'),
    _field(_nameEn, 'Nome in inglese (opzionale)'),
    _field(_descriptionIt, 'Descrizione', lines: 4),
  ]);
  Widget _technique() => _stepBody([
    DropdownButtonFormField(
      initialValue: _difficulty,
      items: const [
        'beginner',
        'intermediate',
        'advanced',
      ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) => setState(() => _difficulty = v!),
      decoration: const InputDecoration(labelText: 'Difficoltà'),
    ),
    const SizedBox(height: 16),
    DropdownButtonFormField(
      initialValue: _mechanics,
      items: const [
        'compound',
        'isolation',
      ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) => setState(() => _mechanics = v!),
      decoration: const InputDecoration(labelText: 'Meccanica'),
    ),
    SwitchListTile(
      value: _bodyweight,
      onChanged: (v) => setState(() => _bodyweight = v),
      title: const Text('A corpo libero'),
    ),
    SwitchListTile(
      value: _unilateral,
      onChanged: (v) => setState(() => _unilateral = v),
      title: const Text('Unilaterale'),
    ),
  ]);
  Widget _guidance() => _stepBody([
    _field(_tipsIt, 'Istruzioni e suggerimenti', lines: 6),
    const SizedBox(height: 16),
    const ListTile(
      leading: Icon(Icons.photo_library_outlined),
      title: Text('Foto e video'),
      subtitle: Text(
        'L’upload sarà disponibile quando verrà configurato lo storage media.',
      ),
    ),
  ]);
  Widget _stepBody(List<Widget> children) =>
      ListView(padding: const EdgeInsets.all(20), children: children);
  Widget _field(
    TextEditingController controller,
    String label, {
    int lines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}
