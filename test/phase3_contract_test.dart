import 'package:allai_mobile/core/api/mock_allai_api.dart';
import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/features/billing/data/billing_api_data_source.dart';
import 'package:allai_mobile/features/billing/data/billing_cache_data_source.dart';
import 'package:allai_mobile/features/billing/data/billing_repository.dart';
import 'package:allai_mobile/features/generation_jobs/data/generation_api_data_source.dart';
import 'package:allai_mobile/features/generation_jobs/data/generation_repository.dart';
import 'package:allai_mobile/features/generation_jobs/domain/generation_job_models.dart';
import 'package:allai_mobile/features/tools/data/catalog_api_data_source.dart';
import 'package:allai_mobile/features/tools/data/catalog_cache_data_source.dart';
import 'package:allai_mobile/features/tools/data/catalog_repository.dart';
import 'package:allai_mobile/features/tools/domain/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase memoryDatabase() {
  final database = AppDatabase.memory();
  addTearDown(database.close);
  return database;
}

MockCatalogRepository catalogRepository(
  MockAllAiApi api,
  AppDatabase database,
) {
  return MockCatalogRepository(
    MockCatalogApiDataSource(api),
    CatalogCacheDataSource(database),
  );
}

MockBillingRepository billingRepository(
  MockAllAiApi api,
  AppDatabase database,
) {
  return MockBillingRepository(
    MockBillingApiDataSource(api),
    BillingCacheDataSource(database),
  );
}

MockGenerationRepository generationRepository(MockAllAiApi api) {
  return MockGenerationRepository(MockGenerationApiDataSource(api));
}

Future<GenerationJobResponse> pollToTerminal(
  MockGenerationRepository repository,
  CreateGenerationJobInput input,
) async {
  final created = await repository.createJob(input);
  var response = GenerationJobResponse(job: created.job, assets: const []);
  while (!response.job.isTerminal) {
    response = await repository.pollJob(response.job.id);
  }
  return response;
}

void main() {
  test('catalog parses typed models without provider routing keys', () async {
    final database = memoryDatabase();
    final api = MockAllAiApi(database: database);
    final catalog = await catalogRepository(api, database).getCatalog();

    expect(catalog.modes.map((mode) => mode.id), [
      'photo',
      'video',
      'upscale',
      'avatar',
      'motion',
    ]);
    expect(catalog.modes.last.isEnabled, isTrue);
    expect(catalog.models.first.id, 'photo-studio');
    expect(catalog.models.first.name, 'NanoBanana');
    expect(catalog.models.first.providerLabel, 'AllAi');
    expect(catalog.models.first.shortLabel, 'Редактура - ремикс');
    expect(
      catalog.models.first.thumbnailUrl,
      contains('storage.googleapis.com/allai-media/landing'),
    );
    final providerRoutingKey = 'provider${'Key'}';
    expect(
      catalog.models.first.toJson().containsKey(providerRoutingKey),
      isFalse,
    );
    expect(catalog.templates.first.outputFormat, OutputFormat.video);
  });

  test('successful mock job advances to completed and creates asset', () async {
    final database = memoryDatabase();
    final api = MockAllAiApi(database: database);
    final generation = generationRepository(api);
    final billing = billingRepository(api, database);

    final beforeBalance = await billing.getBalance();
    final response = await pollToTerminal(
      generation,
      const CreateGenerationJobInput(
        modelId: 'photo-studio',
        templateId: 'beauty-hook',
        prompt: 'Сделай чистый beauty hero shot',
        settings: {'aspectRatio': '4:5'},
        clientRequestId: 'test-success',
      ),
    );
    final afterBalance = await billing.getBalance();

    expect(response.job.status, GenerationJobStatus.completed);
    expect(response.job.progress, 1.0);
    expect(response.assets, hasLength(1));
    expect(response.assets.first.type, AssetType.image);
    expect(afterBalance.coinBalance, beforeBalance.coinBalance - 80);
  });

  test('failed mock job refunds balance and exposes failed status', () async {
    final database = memoryDatabase();
    final api = MockAllAiApi(database: database);
    final generation = generationRepository(api);
    final billing = billingRepository(api, database);

    final beforeBalance = await billing.getBalance();
    final response = await pollToTerminal(
      generation,
      const CreateGenerationJobInput(
        modelId: 'photo-studio',
        prompt: 'fail this image job',
        settings: {'aspectRatio': '9:16'},
        clientRequestId: 'test-fail',
      ),
    );
    final afterBalance = await billing.getBalance();

    expect(response.job.status, GenerationJobStatus.failed);
    expect(response.job.errorCode, 'mock_generation_failed');
    expect(response.assets, isEmpty);
    expect(afterBalance.coinBalance, beforeBalance.coinBalance);
  });

  test('insufficient balance is simulatable', () async {
    final api = MockAllAiApi(database: memoryDatabase(), initialBalance: 10);
    final generation = generationRepository(api);

    expect(
      () => generation.createJob(
        const CreateGenerationJobInput(
          modelId: 'photo-studio',
          prompt: 'Слишком дорогая генерация',
          settings: {'aspectRatio': '9:16'},
          clientRequestId: 'test-insufficient',
        ),
      ),
      throwsA(
        isA<GenerationRepositoryException>().having(
          (error) => error.code,
          'code',
          'insufficient_balance',
        ),
      ),
    );
  });

  test('fresh persistence seed keeps library history empty', () async {
    final api = MockAllAiApi(database: memoryDatabase());

    await api.getCatalog();
    await api.getPackages();

    expect(await api.getJobs(), isEmpty);
  });

  test('catalog, packages, and balance survive api reconstruction', () async {
    final database = memoryDatabase();
    final firstApi = MockAllAiApi(database: database);

    final firstCatalog = await firstApi.getCatalog();
    final firstPackages = await firstApi.getPackages();
    final firstBalance = await firstApi.getBalance();

    final secondApi = MockAllAiApi(database: database);

    expect(await secondApi.getCatalog(), firstCatalog);
    expect(await secondApi.getPackages(), firstPackages);
    expect(await secondApi.getBalance(), firstBalance);
  });

  test(
    'in-progress job survives reconstruction and continues lifecycle',
    () async {
      final database = memoryDatabase();
      final firstApi = MockAllAiApi(database: database);
      final generation = generationRepository(firstApi);

      final created = await generation.createJob(
        const CreateGenerationJobInput(
          modelId: 'photo-studio',
          prompt: 'active persisted job',
          settings: {'aspectRatio': '9:16'},
          clientRequestId: 'test-active',
        ),
      );
      final queued = await generation.pollJob(created.job.id);

      final secondGeneration = generationRepository(
        MockAllAiApi(database: database),
      );
      final restored = await secondGeneration.getJob(created.job.id);
      final advanced = await secondGeneration.pollJob(created.job.id);

      expect(restored.job.status, queued.job.status);
      expect(restored.job.status, GenerationJobStatus.queued);
      expect(advanced.job.status, GenerationJobStatus.running);
    },
  );

  test('completed job and generated asset survive reconstruction', () async {
    final database = memoryDatabase();
    final firstGeneration = generationRepository(
      MockAllAiApi(database: database),
    );

    final completed = await pollToTerminal(
      firstGeneration,
      const CreateGenerationJobInput(
        modelId: 'photo-studio',
        templateId: 'beauty-hook',
        prompt: 'persist completed job',
        settings: {'aspectRatio': '4:5'},
        clientRequestId: 'test-persist-completed',
      ),
    );

    final secondGeneration = generationRepository(
      MockAllAiApi(database: database),
    );
    final restored = await secondGeneration.getJob(completed.job.id);

    expect(restored.job.status, GenerationJobStatus.completed);
    expect(restored.assets, hasLength(1));
    expect(restored.assets.first.id, completed.assets.first.id);
  });

  test('failed job and balance survive reconstruction', () async {
    final database = memoryDatabase();
    final firstApi = MockAllAiApi(database: database);
    final firstGeneration = generationRepository(firstApi);
    final firstBilling = billingRepository(firstApi, database);

    final beforeBalance = await firstBilling.getBalance();
    final failed = await pollToTerminal(
      firstGeneration,
      const CreateGenerationJobInput(
        modelId: 'photo-studio',
        prompt: 'fail persisted job',
        settings: {'aspectRatio': '9:16'},
        clientRequestId: 'test-persist-failed',
      ),
    );

    final secondApi = MockAllAiApi(database: database);
    final restored = await generationRepository(
      secondApi,
    ).getJob(failed.job.id);
    final afterBalance = await billingRepository(
      secondApi,
      database,
    ).getBalance();

    expect(restored.job.status, GenerationJobStatus.failed);
    expect(restored.job.errorCode, 'mock_generation_failed');
    expect(afterBalance.coinBalance, beforeBalance.coinBalance);
  });

  test('runtime ids do not collide after reconstruction', () async {
    final database = memoryDatabase();
    final firstGeneration = generationRepository(
      MockAllAiApi(database: database),
    );
    final first = await firstGeneration.createJob(
      const CreateGenerationJobInput(
        modelId: 'photo-studio',
        prompt: 'first id',
        settings: {'aspectRatio': '9:16'},
        clientRequestId: 'test-first-id',
      ),
    );

    final secondGeneration = generationRepository(
      MockAllAiApi(database: database),
    );
    final second = await secondGeneration.createJob(
      const CreateGenerationJobInput(
        modelId: 'photo-studio',
        prompt: 'second id',
        settings: {'aspectRatio': '9:16'},
        clientRequestId: 'test-second-id',
      ),
    );

    expect(second.job.id, isNot(first.job.id));
  });
}
