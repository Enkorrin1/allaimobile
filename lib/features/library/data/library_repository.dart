import '../../../core/api/mock_allai_api.dart';
import '../../generation_jobs/domain/generation_job_models.dart';
import '../../tools/domain/catalog_models.dart';
import '../domain/library_history_item.dart';

abstract class LibraryRepository {
  Future<List<LibraryHistoryItem>> getHistory();
  Future<LibraryHistoryItem?> getByAssetId(String assetId);
}

class MockLibraryRepository implements LibraryRepository {
  const MockLibraryRepository(this._api);

  final MockAllAiApi _api;

  @override
  Future<List<LibraryHistoryItem>> getHistory() async {
    final catalog = CatalogResponse.fromJson(await _api.getCatalog());
    final jobs = await _api.getJobs();
    return Future.wait(
      jobs.map((jobJson) async {
        final job = GenerationJob.fromJson(jobJson);
        final model = catalog.models.firstWhere(
          (candidate) => candidate.id == job.modelId,
        );
        Template? template;
        if (job.templateId != null) {
          template = catalog.templates.firstWhere(
            (candidate) => candidate.id == job.templateId,
          );
        }
        Asset? outputAsset;
        if (job.outputAssetIds.isNotEmpty) {
          final assetJson = await _api.getAsset(job.outputAssetIds.first);
          if (assetJson != null) outputAsset = Asset.fromJson(assetJson);
        }
        return LibraryHistoryItem(
          job: job,
          model: model,
          template: template,
          outputAsset: outputAsset,
        );
      }),
    );
  }

  @override
  Future<LibraryHistoryItem?> getByAssetId(String assetId) async {
    final history = await getHistory();
    for (final item in history) {
      if (item.outputAsset?.id == assetId || item.job.id == assetId) {
        return item;
      }
    }
    return null;
  }
}
