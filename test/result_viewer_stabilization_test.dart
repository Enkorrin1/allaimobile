import 'package:allai_mobile/features/generation_jobs/domain/generation_job_models.dart';
import 'package:allai_mobile/features/library/data/library_repository.dart';
import 'package:allai_mobile/features/library/domain/library_history_item.dart';
import 'package:allai_mobile/features/library/presentation/providers/library_providers.dart';
import 'package:allai_mobile/features/result_viewer/presentation/screens/result_viewer_screen.dart';
import 'package:allai_mobile/features/tools/domain/catalog_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('active job route shows progress state without result actions', (
    tester,
  ) async {
    await _pumpResultViewer(
      tester,
      _historyItem(
        job: _job(
          id: 'job-active',
          status: GenerationJobStatus.queued,
          outputAssetIds: const [],
        ),
      ),
      routeId: 'job-active',
    );

    expect(find.text('Задача в очереди'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Сохранить'), findsNothing);
    expect(find.text('Поделиться'), findsNothing);
    expect(find.text('Повторить'), findsNothing);
  });

  testWidgets('completed actions show safe feedback or disabled affordance', (
    tester,
  ) async {
    await _pumpResultViewer(
      tester,
      _historyItem(
        job: _job(
          status: GenerationJobStatus.completed,
          outputAssetIds: const ['asset-completed'],
        ),
        outputAsset: _asset('asset-completed'),
      ),
      routeId: 'asset-completed',
    );

    await _scrollUntilVisible(tester, find.text('Сохранить'));
    expect(find.text('Сохранить'), findsOneWidget);
    await tester.tap(find.text('Сохранить'));
    await tester.pump();
    expect(
      find.text('Сохранение появится в следующем обновлении'),
      findsOneWidget,
    );

    final sourceChip = tester.widget<ActionChip>(
      find.widgetWithText(ActionChip, 'Источник скоро'),
    );
    expect(sourceChip.onPressed, isNull);
  });
}

Future<void> _pumpResultViewer(
  WidgetTester tester,
  LibraryHistoryItem item, {
  required String routeId,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(item),
        ),
      ],
      child: MaterialApp(home: ResultViewerScreen(assetId: routeId)),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> _scrollUntilVisible(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(Scrollable);
  for (var i = 0; i < 6; i += 1) {
    if (tester.any(finder)) {
      await tester.ensureVisible(finder);
      await tester.pump(const Duration(milliseconds: 100));
      return;
    }
    await tester.drag(scrollable, const Offset(0, -320));
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(finder, findsWidgets);
}

LibraryHistoryItem _historyItem({
  required GenerationJob job,
  Asset? outputAsset,
}) {
  return LibraryHistoryItem(
    job: job,
    model: _model,
    template: _template,
    outputAsset: outputAsset,
  );
}

GenerationJob _job({
  String id = 'job-completed',
  required GenerationJobStatus status,
  required List<String> outputAssetIds,
}) {
  final now = DateTime(2026, 7, 4, 9);
  return GenerationJob(
    id: id,
    userId: 'user-test',
    modelId: _model.id,
    templateId: _template.id,
    status: status,
    prompt: 'Test product image',
    inputAssetIds: const [],
    outputAssetIds: outputAssetIds,
    settings: const {'aspectRatio': '1:1'},
    costCoins: 80,
    createdAt: now,
    updatedAt: now,
  );
}

Asset _asset(String id) {
  return Asset(
    id: id,
    type: AssetType.image,
    role: AssetRole.output,
    url: 'mock://generated/$id.png',
    mimeType: 'image/png',
    createdAt: DateTime(2026, 7, 4, 9, 1),
  );
}

const _model = AiModel(
  id: 'photo-studio',
  name: 'NanoBanana',
  category: AiModelCategory.image,
  description: 'Prompt image generation',
  supportedInputs: [SupportedInput.prompt],
  supportedOutputs: [SupportedOutput.image],
  capabilities: ModelCapabilities(aspectRatios: ['1:1']),
  isAvailable: true,
  cost: CoinCost(minCoins: 80),
);

const _template = Template(
  id: 'beauty-hook',
  title: 'Beauty Hook',
  category: TemplateCategory.beauty,
  description: 'Studio style',
  previewUrl: 'mock://template/beauty.png',
  defaultModelId: 'photo-studio',
  defaultPrompt: 'Clean image',
  requiredInputs: ['prompt'],
  outputFormat: OutputFormat.image,
);

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.item);

  final LibraryHistoryItem item;

  @override
  Future<List<LibraryHistoryItem>> getHistory() async => [item];

  @override
  Future<LibraryHistoryItem?> getByAssetId(String assetId) async {
    if (item.job.id == assetId || item.outputAsset?.id == assetId) {
      return item;
    }
    return null;
  }
}
