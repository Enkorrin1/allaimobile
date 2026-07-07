import 'package:allai_mobile/app/allai_app.dart';
import 'package:allai_mobile/app/router/app_router.dart';
import 'package:allai_mobile/app/router/app_routes.dart';
import 'package:allai_mobile/core/api/mock_allai_api.dart';
import 'package:allai_mobile/core/auth/auth_session.dart';
import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/core/database/database_providers.dart';
import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:allai_mobile/features/auth/data/auth_repository.dart';
import 'package:allai_mobile/features/auth/domain/auth_models.dart';
import 'package:allai_mobile/features/billing/data/billing_api_data_source.dart';
import 'package:allai_mobile/features/generation_jobs/data/generation_api_data_source.dart';
import 'package:allai_mobile/features/generation_jobs/data/generation_repository.dart';
import 'package:allai_mobile/features/generation_jobs/domain/generation_job_models.dart';
import 'package:allai_mobile/features/billing/presentation/providers/billing_providers.dart';
import 'package:allai_mobile/features/generation_jobs/presentation/providers/generation_job_providers.dart';
import 'package:allai_mobile/features/tools/data/catalog_api_data_source.dart';
import 'package:allai_mobile/features/tools/presentation/providers/catalog_providers.dart';
import 'package:allai_mobile/shared/widgets/generated_asset_preview.dart';
import 'package:allai_mobile/shared/widgets/neon_media_card.dart';
import 'package:allai_mobile/shared/widgets/template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class TestAppHarness {
  const TestAppHarness({required this.database, required this.storage});

  final AppDatabase database;
  final InMemorySecureStorage storage;
}

Future<TestAppHarness> pumpAllAi(
  WidgetTester tester, {
  bool signedIn = true,
  String initialLocation = AppRoutes.welcome,
  AppDatabase? database,
  CatalogApiDataSource? catalogApiDataSource,
  BillingApiDataSource? billingApiDataSource,
  List<Duration>? generationPollingDelays,
}) async {
  final appDatabase = database ?? AppDatabase.memory();
  final storage = InMemorySecureStorage();
  if (database == null) addTearDown(appDatabase.close);

  if (signedIn) {
    await MockAuthRepository(AuthSessionStore(storage)).login(
      const LoginRequest(
        email: MockAuthRepository.mockEmail,
        password: MockAuthRepository.mockPassword,
      ),
    );
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(appDatabase),
        secureStorageProvider.overrideWithValue(storage),
        initialLocationProvider.overrideWithValue(initialLocation),
        if (catalogApiDataSource != null)
          catalogApiDataSourceProvider.overrideWithValue(catalogApiDataSource),
        if (billingApiDataSource != null)
          billingApiDataSourceProvider.overrideWithValue(billingApiDataSource),
        if (generationPollingDelays != null)
          generationPollingDelaysProvider.overrideWithValue(
            generationPollingDelays,
          ),
      ],
      child: const AllAiApp(),
    ),
  );
  await tester.pumpAndSettle();
  return TestAppHarness(database: appDatabase, storage: storage);
}

Future<void> pumpRoute(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pumpAndSettle();
}

Future<void> scrollCurrentScreen(
  WidgetTester tester, [
  double distance = 560,
]) async {
  final scrollables = find.byType(Scrollable);
  expect(scrollables, findsWidgets);
  await tester.drag(scrollables.last, Offset(0, -distance));
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> scrollUntilVisible(
  WidgetTester tester,
  Finder finder, {
  int maxScrolls = 8,
}) async {
  for (var i = 0; i < maxScrolls; i += 1) {
    if (tester.any(finder)) {
      await tester.ensureVisible(finder.last);
      await tester.pump(const Duration(milliseconds: 300));
      return;
    }
    await scrollCurrentScreen(tester);
  }

  expect(finder, findsWidgets);
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await scrollUntilVisible(tester, finder);
  await tester.tap(finder.last);
  await pumpRoute(tester);
}

void main() {
  testWidgets('fresh signed-out app opens Welcome, not shell', (tester) async {
    await pumpAllAi(tester, signedIn: false);

    expect(find.text('Image to Video'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('signed-out protected initial route redirects to Welcome', (
    tester,
  ) async {
    await pumpAllAi(
      tester,
      signedIn: false,
      initialLocation: AppRoutes.profile,
    );

    expect(find.text('Image to Video'), findsOneWidget);
    expect(find.text('Профиль'), findsNothing);
  });

  testWidgets('login success stores session and opens app shell', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.text('I already have an account'));
    await pumpRoute(tester);
    await tester.enterText(
      find.byType(TextField).at(1),
      MockAuthRepository.mockPassword,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
    await pumpRoute(tester);

    expect(find.text('Videos'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNotNull);
  });

  testWidgets('wrong credentials show safe error and do not store session', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.text('I already have an account'));
    await pumpRoute(tester);
    await tester.enterText(find.byType(TextField).at(1), 'wrong-password');
    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
    await pumpRoute(tester);

    expect(find.text('Email или пароль неверны'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNull);
  });

  testWidgets('login validates empty and invalid input before auth call', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.text('I already have an account'));
    await pumpRoute(tester);
    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');
    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
    await pumpRoute(tester);

    expect(find.text('Введите email'), findsOneWidget);
    expect(find.text('Введите пароль'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNull);

    await tester.enterText(find.byType(TextField).at(0), 'bad-email');
    await tester.enterText(find.byType(TextField).at(1), 'strong-pass');
    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
    await pumpRoute(tester);

    expect(find.text('Введите корректный email'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNull);
  });

  testWidgets('password reset validates email before success state', (
    tester,
  ) async {
    await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.text('I already have an account'));
    await pumpRoute(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Забыли пароль?'));
    await pumpRoute(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Продолжить'));
    await pumpRoute(tester);
    expect(find.text('Введите email'), findsOneWidget);
    expect(
      find.text('Если аккаунт существует, запрос принят в демо-режиме'),
      findsNothing,
    );

    await tester.enterText(find.byType(TextField).first, 'bad-email');
    await tester.tap(find.widgetWithText(FilledButton, 'Продолжить'));
    await pumpRoute(tester);
    expect(find.text('Введите корректный email'), findsOneWidget);
    expect(
      find.text('Если аккаунт существует, запрос принят в демо-режиме'),
      findsNothing,
    );
  });

  testWidgets('registration legal links open placeholder', (tester) async {
    await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await pumpRoute(tester);
    await scrollUntilVisible(tester, find.text('условия использования'));
    await tester.tap(find.text('условия использования'));
    await pumpRoute(tester);

    expect(find.text('Условия использования'), findsOneWidget);
    expect(
      find.text(
        'Юридический текст будет подключен после утверждения ссылок. Сейчас это демо-заглушка.',
      ),
      findsOneWidget,
    );
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);
  });

  testWidgets('registration requires legal consent and 18 confirmation', (
    tester,
  ) async {
    await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await pumpRoute(tester);
    await tester.enterText(find.byType(TextField).at(0), 'new@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'Новый креатор');
    await tester.enterText(find.byType(TextField).at(2), 'strong-pass');
    await tester.enterText(find.byType(TextField).at(3), 'strong-pass');
    await pumpRoute(tester);

    Future<void> tapConsentCheckbox(Key key) async {
      final tile = find.byKey(key);
      await scrollUntilVisible(tester, tile);
      await tester.tap(
        find.descendant(of: tile, matching: find.byType(Checkbox)),
      );
      await pumpRoute(tester);
    }

    await scrollUntilVisible(
      tester,
      find.byKey(const Key('register-terms-checkbox')),
    );
    await tapConsentCheckbox(const Key('register-terms-checkbox'));
    await tapConsentCheckbox(const Key('register-privacy-checkbox'));
    await tapConsentCheckbox(const Key('register-age-checkbox'));
    final submit = find.widgetWithText(FilledButton, 'Создать аккаунт');
    await scrollUntilVisible(tester, submit);
    expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);

    await tester.tap(submit);
    await pumpRoute(tester);
    expect(find.text('Videos'), findsOneWidget);
  });

  testWidgets('signed-in restore renders main navigation', (tester) async {
    await pumpAllAi(tester);

    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('1 250'), findsOneWidget);
  });

  testWidgets('Create tab renders provider-backed generator UI', (
    tester,
  ) async {
    await pumpAllAi(tester);

    await tester.tap(find.byIcon(Icons.add).last);
    await pumpRoute(tester);

    expect(find.text('Новая генерация'), findsOneWidget);
    expect(find.text('Промпт'), findsOneWidget);

    final costPreview = find.text('Стоимость: 80 койнов');
    await scrollUntilVisible(tester, costPreview);
    expect(costPreview.last, findsOneWidget);
  });

  testWidgets('Create validates empty prompt before job creation', (
    tester,
  ) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);

    await tester.tap(find.byIcon(Icons.add).last);
    await pumpRoute(tester);

    await scrollUntilVisible(
      tester,
      find.text('Добавьте описание изображения'),
    );
    expect(find.text('Добавьте описание изображения'), findsOneWidget);

    final submit = find.widgetWithText(FilledButton, 'Запустить генерацию');
    await scrollUntilVisible(tester, submit);
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);

    expect(find.text('Результат'), findsNothing);
  });

  testWidgets('Create blocks generation with insufficient available coins', (
    tester,
  ) async {
    await pumpAllAi(
      tester,
      initialLocation: AppRoutes.create,
      billingApiDataSource: const _LowBalanceBillingApiDataSource(),
      generationPollingDelays: const [Duration.zero],
    );

    await tester.enterText(
      find.byType(TextField).first,
      'Проверка недостаточного баланса',
    );
    await pumpRoute(tester);

    await scrollUntilVisible(
      tester,
      find.text('Недостаточно койнов: нужно 80, доступно 10'),
    );
    expect(
      find.text('Недостаточно койнов: нужно 80, доступно 10'),
      findsOneWidget,
    );
    final submit = find.widgetWithText(FilledButton, 'Запустить генерацию');
    await scrollUntilVisible(tester, submit);
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
  });

  testWidgets('Failed image job keeps retry copy visible', (tester) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);

    await tester.tap(find.byIcon(Icons.add).last);
    await pumpRoute(tester);
    await tester.enterText(find.byType(TextField).first, 'fail this image job');
    await pumpRoute(tester);

    await tapVisible(tester, find.text('Запустить генерацию'));

    expect(
      find.text('Генерация не завершилась. Настройки сохранены.'),
      findsOneWidget,
    );
    expect(find.text('Коины возвращены на баланс.'), findsOneWidget);
    expect(find.text('Повторить с теми же настройками'), findsOneWidget);
  });

  testWidgets('Tools and template detail routes render', (tester) async {
    await pumpAllAi(tester);

    await pumpAllAi(tester, initialLocation: AppRoutes.tools);

    expect(find.text('Каталог инструментов'), findsOneWidget);
    expect(find.text('AllAI Photo Studio'), findsOneWidget);

    final productTemplate = find.widgetWithText(
      TemplateCard,
      'Product UGC Hook',
    );
    await tapVisible(tester, productTemplate);

    await scrollUntilVisible(tester, find.text('Что нужно от пользователя'));
    expect(find.text('Что нужно от пользователя'), findsOneWidget);
    expect(find.text('Использовать шаблон'), findsOneWidget);
  });

  testWidgets('Tools category filters update catalog results', (tester) async {
    await pumpAllAi(tester, initialLocation: AppRoutes.tools);

    expect(find.text('AllAI Photo Studio'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Видео'));
    await pumpRoute(tester);

    expect(find.text('Video Hook Maker'), findsOneWidget);
    expect(find.text('AllAI Photo Studio'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Все'));
    await pumpRoute(tester);

    expect(find.text('AllAI Photo Studio'), findsOneWidget);
  });

  testWidgets('Create can run mock job and open result viewer', (tester) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);

    await tester.tap(find.byIcon(Icons.add).last);
    await pumpRoute(tester);

    await tester.enterText(
      find.byType(TextField).first,
      'Сделай чистый hero shot продукта',
    );
    await pumpRoute(tester);
    final openResult = find.text('Запустить генерацию');
    await tapVisible(tester, openResult);

    expect(find.text('Результат'), findsOneWidget);
    expect(find.byType(GeneratedAssetPreview), findsWidgets);
    expect(find.textContaining('Could not decompress image'), findsNothing);
    await scrollUntilVisible(tester, find.text('Unboxing'));
    expect(find.text('Unboxing'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Сохранить'));
    expect(find.text('Сохранить'), findsOneWidget);
    await tester.tap(find.text('Сохранить'));
    await tester.pump();
    expect(
      find.text('Сохранение появится в следующем обновлении'),
      findsOneWidget,
    );
    await scrollUntilVisible(tester, find.text('Метаданные'));
    expect(find.text('Метаданные'), findsOneWidget);
  });

  testWidgets('Result route for active job shows progress, not actions', (
    tester,
  ) async {
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final generation = MockGenerationRepository(
      MockGenerationApiDataSource(MockAllAiApi(database: database)),
    );
    final created = await generation.createJob(
      const CreateGenerationJobInput(
        modelId: 'photo-studio',
        templateId: 'beauty-hook',
        prompt: 'Активная задача для экрана результата',
        settings: {'aspectRatio': '4:5'},
        clientRequestId: 'widget-active-result',
      ),
    );

    await pumpAllAi(
      tester,
      initialLocation: AppRoutes.result(created.job.id),
      database: database,
      generationPollingDelays: const [Duration(minutes: 1)],
    );

    expect(find.text('Результат'), findsOneWidget);
    expect(find.text('Проверяем запрос'), findsOneWidget);
    expect(
      find.text(
        'Задача ещё выполняется. Результат появится здесь автоматически после завершения.',
      ),
      findsOneWidget,
    );
    expect(find.text('Сохранить'), findsNothing);
    expect(find.text('Поделиться'), findsNothing);
    expect(find.text('Повторить'), findsNothing);
  });

  testWidgets('Pricing route renders disabled demo billing', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('1 250'));
    await pumpRoute(tester);

    await scrollUntilVisible(tester, find.text('Start Creating Now'));
    expect(find.text('Start Creating Now'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.textContaining('Demo mode'), findsOneWidget);
  });

  testWidgets('Tools route shows user-facing catalog error', (tester) async {
    await pumpAllAi(
      tester,
      initialLocation: AppRoutes.tools,
      catalogApiDataSource: const _FailingCatalogApiDataSource(),
    );

    expect(find.text('Не удалось загрузить каталог'), findsOneWidget);
    expect(find.textContaining('FormatException'), findsNothing);
    expect(find.textContaining('Mock'), findsNothing);
  });

  testWidgets('Pricing route shows empty packages state', (tester) async {
    await pumpAllAi(
      tester,
      initialLocation: AppRoutes.pricing,
      billingApiDataSource: const _EmptyPackagesBillingApiDataSource(),
    );

    await scrollUntilVisible(tester, find.text('Start Creating Now'));
    expect(find.text('Start Creating Now'), findsOneWidget);
    await scrollUntilVisible(
      tester,
      find.text('Coin packages will appear here after billing setup.'),
    );
    expect(
      find.text('Coin packages will appear here after billing setup.'),
      findsOneWidget,
    );
  });

  testWidgets('Projects tab renders mock runtime content', (tester) async {
    await pumpAllAi(tester, initialLocation: AppRoutes.library);
    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Create Your Magic'), findsOneWidget);
  });

  testWidgets('Studio route renders mock runtime content', (tester) async {
    await pumpAllAi(tester, initialLocation: AppRoutes.studio);
    expect(find.text('Студия соцконтента'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Создать ассет'));
    expect(find.text('Создать ассет'), findsOneWidget);
  });

  testWidgets('Back from result returns to Library tab', (tester) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);
    await tester.tap(find.byIcon(Icons.add).last);
    await pumpRoute(tester);
    await tester.enterText(
      find.byType(TextField).first,
      'Сделай результат для библиотеки',
    );
    await pumpRoute(tester);
    await tapVisible(tester, find.text('Запустить генерацию'));
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    await tester.tap(find.text('Projects').last);
    await pumpRoute(tester);

    final historyItem = find.widgetWithText(NeonMediaCard, 'Unboxing');
    await tapVisible(tester, historyItem);

    expect(find.text('Результат'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Unboxing'), findsOneWidget);
  });

  testWidgets('Back from pricing returns to Profile tab', (tester) async {
    await pumpAllAi(tester, initialLocation: AppRoutes.profile);
    expect(find.text('Демо-креатор'), findsOneWidget);

    await tester.tap(find.text('Баланс: 1 250 койнов'));
    await pumpRoute(tester);

    await scrollUntilVisible(tester, find.text('Start Creating Now'));
    expect(find.text('Start Creating Now'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    expect(find.text('Профиль'), findsWidgets);
    expect(find.text('Демо-креатор'), findsOneWidget);
  });

  testWidgets('logout clears session and back does not reveal shell', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, initialLocation: AppRoutes.profile);
    await scrollUntilVisible(
      tester,
      find.widgetWithText(OutlinedButton, 'Выйти'),
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Выйти'));
    await pumpRoute(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Выйти'));
    await pumpRoute(tester);

    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNull);
    expect(find.text('Image to Video'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await pumpRoute(tester);
    expect(find.text('Image to Video'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });
}

class _FailingCatalogApiDataSource implements CatalogApiDataSource {
  const _FailingCatalogApiDataSource();

  @override
  Future<Map<String, dynamic>> fetchCatalog() {
    throw const CatalogApiDataSourceException(
      'network_unavailable',
      'Catalog unavailable in test',
    );
  }
}

class _EmptyPackagesBillingApiDataSource implements BillingApiDataSource {
  const _EmptyPackagesBillingApiDataSource();

  @override
  Future<Map<String, dynamic>> fetchBalance() async {
    return {
      'userId': 'demo-user',
      'coinBalance': 1250,
      'reservedCoins': 0,
      'availableCoins': 1250,
      'updatedAt': '2026-07-03T09:00:00.000Z',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPackages() async {
    return const [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    return const [];
  }
}

class _LowBalanceBillingApiDataSource implements BillingApiDataSource {
  const _LowBalanceBillingApiDataSource();

  @override
  Future<Map<String, dynamic>> fetchBalance() async {
    return {
      'userId': 'demo-user',
      'coinBalance': 10,
      'reservedCoins': 0,
      'availableCoins': 10,
      'updatedAt': '2026-07-03T09:00:00.000Z',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPackages() async {
    return const [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    return const [];
  }
}
