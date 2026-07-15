import 'package:allai_mobile/features/generation_jobs/domain/generation_job_models.dart';
import 'package:allai_mobile/features/home/presentation/view_models/home_library_sections.dart';
import 'package:allai_mobile/features/library/domain/library_history_item.dart';
import 'package:allai_mobile/features/tools/domain/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('home sections separate active jobs from completed results', () {
    final sections = HomeLibrarySections.fromHistory([
      _item('failed', GenerationJobStatus.failed, minute: 4),
      _item('complete-old', GenerationJobStatus.completed, minute: 1),
      _item('queued', GenerationJobStatus.queued, minute: 3),
      _item('complete-new', GenerationJobStatus.completed, minute: 5),
      _item('running', GenerationJobStatus.running, minute: 2),
    ]);

    expect(sections.active.map((item) => item.job.id), ['queued', 'running']);
    expect(sections.recentResults.map((item) => item.job.id), [
      'complete-new',
      'complete-old',
    ]);
  });

  test('home sections cap each rail independently', () {
    final sections = HomeLibrarySections.fromHistory([
      for (var index = 0; index < 5; index += 1)
        _item('active-$index', GenerationJobStatus.processing, minute: index),
      for (var index = 0; index < 5; index += 1)
        _item('result-$index', GenerationJobStatus.completed, minute: index),
    ]);

    expect(sections.active, hasLength(3));
    expect(sections.recentResults, hasLength(3));
  });
}

LibraryHistoryItem _item(
  String id,
  GenerationJobStatus status, {
  required int minute,
}) {
  final completed = status == GenerationJobStatus.completed;
  final asset = completed
      ? Asset(
          id: 'asset-$id',
          type: AssetType.image,
          role: AssetRole.output,
          url: 'mock://$id.png',
          mimeType: 'image/png',
          createdAt: DateTime(2026, 7, 12, 10, minute),
        )
      : null;
  return LibraryHistoryItem(
    job: GenerationJob(
      id: id,
      userId: 'user',
      modelId: _model.id,
      status: status,
      prompt: 'Prompt $id',
      inputAssetIds: const [],
      outputAssetIds: asset == null ? const [] : [asset.id],
      settings: const {},
      costCoins: 80,
      progress: completed ? 1 : 0.5,
      createdAt: DateTime(2026, 7, 12, 10),
      updatedAt: DateTime(2026, 7, 12, 10, minute),
    ),
    model: _model,
    template: null,
    outputAsset: asset,
  );
}

const _model = AiModel(
  id: 'photo-model',
  name: 'Photo Model',
  category: AiModelCategory.image,
  description: 'Test model',
  supportedInputs: [SupportedInput.prompt],
  supportedOutputs: [SupportedOutput.image],
  capabilities: ModelCapabilities(),
  isAvailable: true,
  cost: CoinCost(minCoins: 80),
);
