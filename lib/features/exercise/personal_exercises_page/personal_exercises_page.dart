import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
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
    final repository = ref.read(exerciseInfoPageRepositoryProvider);
    final response = await repository.getMyExercises();
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
      if (response.success) {
        _exercises = response.data ?? const [];
      } else {
        _error = response.message ?? context.tr('common.error');
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
              ? context.tr('exercise.personal.create')
              : context.tr('exercise.personal.edit'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: context.tr('exercise.personal.name'),
              ),
            ),
            TextField(
              controller: descriptionController,
              maxLength: 160,
              decoration: InputDecoration(
                labelText: context.tr('exercise.personal.description'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.tr('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.tr('common.confirm')),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    final repository = ref.read(exerciseInfoPageRepositoryProvider);
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    if (name.isEmpty) {
      return;
    }

    if (editing == null) {
      await repository.createPersonalExercise(
        nameI18n: {locale: name},
        descriptionI18n: description.isNotEmpty ? {locale: description} : null,
        tipsI18n: const {},
        difficultyLevel: 'beginner',
        mechanicsType: 'compound',
        isBodyweight: true,
        isUnilateral: false,
      );
    } else {
      await repository.updatePersonalExercise(
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
        title: Text(context.tr('exercise.personal.delete')),
        content: Text(context.tr('exercise.personal.delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.tr('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.tr('common.confirm')),
          ),
        ],
      ),
    );
    if (confirm != true || exercise.id == null) {
      return;
    }
    await ref
        .read(exerciseInfoPageRepositoryProvider)
        .deletePersonalExercise(exercise.id!);
    await _loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('profile.personal_exercises'))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateDialog(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _exercises.isEmpty
          ? Center(child: Text(context.tr('exercise.personal.empty')))
          : ListView.separated(
              itemCount: _exercises.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ListTile(
                  title: Text(
                    exercise.nameI18n?.fromI18n(locale) ??
                        exercise.id ??
                        context.tr('common.na'),
                  ),
                  subtitle: Text(
                    exercise.descriptionI18n?.fromI18n(locale) ??
                        context.tr('common.na'),
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
