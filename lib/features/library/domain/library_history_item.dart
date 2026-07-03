import '../../generation_jobs/domain/generation_job_models.dart';
import '../../tools/domain/catalog_models.dart';

class LibraryHistoryItem {
  const LibraryHistoryItem({
    required this.job,
    required this.model,
    required this.template,
    required this.outputAsset,
  });

  final GenerationJob job;
  final AiModel model;
  final Template? template;
  final Asset? outputAsset;
}
