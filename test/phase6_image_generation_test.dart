import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/core/database/database_providers.dart';
import 'package:allai_mobile/features/billing/presentation/providers/billing_providers.dart';
import 'package:allai_mobile/features/generation_jobs/data/generation_data_providers.dart';
import 'package:allai_mobile/features/generation_jobs/domain/generation_job_models.dart';
import 'package:allai_mobile/features/generation_jobs/presentation/providers/generation_job_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderContainer testContainer(AppDatabase database) {
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      generationPollingDelaysProvider.overrideWithValue(const [Duration.zero]),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test(
    'controller creates prompt-only image job and polls to success',
    () async {
      final database = AppDatabase.memory();
      addTearDown(database.close);
      final container = testContainer(database);

      final beforeBalance = await container.read(balanceProvider.future);
      final response = await container
          .read(generationJobControllerProvider.notifier)
          .createPromptOnlyJob(
            modelId: 'photo-studio',
            templateId: 'beauty-hook',
            prompt: 'Clean image hero shot',
            settings: const {'aspectRatio': '4:5'},
          );
      final afterBalance = await container.read(balanceProvider.future);

      expect(response, isNotNull);
      expect(response!.job.status, GenerationJobStatus.completed);
      expect(response.assets.single.type, AssetType.image);
      expect(afterBalance.coinBalance, beforeBalance.coinBalance - 80);
    },
  );

  test('controller polls failed job and keeps prompt/settings', () async {
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final container = testContainer(database);

    final beforeBalance = await container.read(balanceProvider.future);
    final response = await container
        .read(generationJobControllerProvider.notifier)
        .createPromptOnlyJob(
          modelId: 'photo-studio',
          prompt: 'fail this prompt',
          settings: const {'aspectRatio': '9:16'},
        );
    final afterBalance = await container.read(balanceProvider.future);

    expect(response, isNotNull);
    expect(response!.job.status, GenerationJobStatus.failed);
    expect(response.job.prompt, 'fail this prompt');
    expect(response.job.settings['aspectRatio'], '9:16');
    expect(afterBalance.coinBalance, beforeBalance.coinBalance);
  });

  test(
    'active job survives controller reconstruction and resumes polling',
    () async {
      final database = AppDatabase.memory();
      addTearDown(database.close);
      final firstContainer = testContainer(database);
      final repository = firstContainer.read(generationRepositoryProvider);

      final created = await repository.createJob(
        const CreateGenerationJobInput(
          modelId: 'photo-studio',
          templateId: 'beauty-hook',
          prompt: 'restore active image job',
          settings: {'aspectRatio': '4:5'},
          clientRequestId: 'phase6-restore',
        ),
      );

      final restoredContainer = testContainer(database);
      final restored = await restoredContainer
          .read(generationJobControllerProvider.notifier)
          .restoreLatestActiveJob();

      expect(created.job.status, GenerationJobStatus.validating);
      expect(restored, isNotNull);
      expect(restored!.job.status, GenerationJobStatus.completed);
      expect(restored.assets.single.type, AssetType.image);
    },
  );
}
