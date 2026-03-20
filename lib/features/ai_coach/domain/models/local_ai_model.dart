import 'package:flutter_gemma/flutter_gemma.dart';

enum LocalAiModel { minimal, good, best }

class LocalAiModelConfig {
  const LocalAiModelConfig({
    required this.id,
    required this.url,
    required this.modelType,
    required this.storageGb,
  });

  final String id;
  final String url;
  final ModelType modelType;

  /// Approximate storage in GB (used for display).
  final double storageGb;

  String get storageSizeLabel {
    if (storageGb < 1.0) {
      final mb = (storageGb * 1024).round();
      return '$mb MB';
    }
    return '${storageGb.toStringAsFixed(1)} GB';
  }

  static LocalAiModelConfig forModel(LocalAiModel model) {
    switch (model) {
      case LocalAiModel.minimal:
        return const LocalAiModelConfig(
          id: 'gemma-3-1b-it-int4.task',
          url:
              'https://huggingface.co/google/gemma-3-1b-it-litert-preview/resolve/main/gemma-3-1b-it-int4.task',
          modelType: ModelType.gemmaIt,
          storageGb: 0.5,
        );
      case LocalAiModel.good:
        return const LocalAiModelConfig(
          id: 'gemma-3n-E2B-it-int4.task',
          url:
              'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview/resolve/main/gemma-3n-E2B-it-int4.task',
          modelType: ModelType.gemmaIt,
          storageGb: 3.1,
        );
      case LocalAiModel.best:
        return const LocalAiModelConfig(
          id: 'gemma-3n-E4B-it-int4.task',
          url:
              'https://huggingface.co/google/gemma-3n-E4B-it-litert-preview/resolve/main/gemma-3n-E4B-it-int4.task',
          modelType: ModelType.gemmaIt,
          storageGb: 6.5,
        );
    }
  }
}
