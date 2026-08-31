import 'package:coachly/design_system/components/product/coachly_loading.dart';
import 'package:coachly/features/exercises/application/exercise_catalog_controller.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercises/domain/models/exercise_model.dart';
import 'package:coachly/features/user_settings/application/settings_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalExercisesPage extends ConsumerStatefulWidget {
  const PersonalExercisesPage({super.key});

  @override
  ConsumerState<PersonalExercisesPage> createState() =>
      _PersonalExercisesPageState();
}

class _PersonalExercisesPageState extends ConsumerState<PersonalExercisesPage> {
  bool _isLoading = true;
  List<ExerciseModel> _exercises = const [];
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadExercises);
  }

  Future<void> _loadExercises() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final catalog = ref.read(exerciseCatalogControllerProvider);
    final result = await catalog.myExercises();
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
      switch (result) {
        case Ok(:final value):
          _exercises = value;
        // Il messaggio del Failure e' diagnostico: all'utente si mostra un
        // testo tradotto (docs/development/07-errors-and-feedback.md).
        case Err():
          _error = context.l10n.commonError;
      }
    });
  }

  Future<void> _openCreateDialog({ExerciseModel? editing}) async {
    final locale = ref.read(languageProvider).languageCode;
    final nameController = TextEditingController(
      text: editing?.nameI18n?.fromI18n(ref.read(languageProvider)) ?? '',
    );
    final descriptionController = TextEditingController(
      text:
          editing?.descriptionI18n?.fromI18n(ref.read(languageProvider)) ?? '',
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          editing == null
              ? context.l10n.exercisePersonalCreate
              : context.l10n.exercisePersonalEdit,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: context.l10n.exercisePersonalName,
              ),
            ),
            TextField(
              controller: descriptionController,
              maxLength: 160,
              decoration: InputDecoration(
                labelText: context.l10n.exercisePersonalDescription,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.commonConfirm),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    final catalog = ref.read(exerciseCatalogControllerProvider);
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    if (name.isEmpty) {
      return;
    }

    if (editing == null) {
      await catalog.createPersonal(
        nameI18n: {locale: name},
        descriptionI18n: description.isNotEmpty ? {locale: description} : null,
        tipsI18n: const {},
        difficultyLevel: 'beginner',
        mechanicsType: 'compound',
        isBodyweight: true,
        isUnilateral: false,
      );
    } else {
      await catalog.updatePersonal(
        editing.id!,
        nameI18n: {locale: name},
        descriptionI18n: description.isNotEmpty ? {locale: description} : null,
        tipsI18n: const {},
        difficultyLevel: editing.difficultyLevel,
        mechanicsType: editing.mechanicsType,
        forceType: editing.forceType,
        isBodyweight: editing.isBodyweight,
        isUnilateral: editing.isUnilateral,
      );
    }

    await _loadExercises();
  }

  Future<void> _deleteExercise(ExerciseModel exercise) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.exercisePersonalDelete),
        content: Text(context.l10n.exercisePersonalDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.commonConfirm),
          ),
        ],
      ),
    );
    if (confirm != true || exercise.id == null) {
      return;
    }
    await ref
        .read(exerciseCatalogControllerProvider)
        .deletePersonal(exercise.id!);
    await _loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profilePersonalExercises)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateDialog(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const CoachlyLoadingSection(sceneKey: 'personal-exercises')
          : _error != null
          ? Center(child: Text(_error!))
          : _exercises.isEmpty
          ? Center(child: Text(context.l10n.exercisePersonalEmpty))
          : ListView.separated(
              itemCount: _exercises.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ListTile(
                  title: Text(
                    exercise.nameI18n?.fromI18n(locale) ??
                        exercise.id ??
                        context.l10n.commonNa,
                  ),
                  subtitle: Text(
                    exercise.descriptionI18n?.fromI18n(locale) ??
                        context.l10n.commonNa,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _openCreateDialog(editing: exercise),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () => _deleteExercise(exercise),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
