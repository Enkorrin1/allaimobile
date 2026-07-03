import 'package:allai_mobile/app/allai_app.dart';
import 'package:allai_mobile/app/router/app_router.dart';
import 'package:allai_mobile/app/router/app_routes.dart';
import 'package:allai_mobile/core/auth/auth_session.dart';
import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/core/database/database_providers.dart';
import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:allai_mobile/features/auth/data/auth_repository.dart';
import 'package:allai_mobile/features/auth/domain/auth_models.dart';
import 'package:allai_mobile/features/billing/data/billing_api_data_source.dart';
import 'package:allai_mobile/features/billing/presentation/providers/billing_providers.dart';
import 'package:allai_mobile/features/tools/data/catalog_api_data_source.dart';
import 'package:allai_mobile/features/tools/presentation/providers/catalog_providers.dart';
import 'package:allai_mobile/shared/widgets/media_asset_tile.dart';
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
  CatalogApiDataSource? catalogApiDataSource,
  BillingApiDataSource? billingApiDataSource,
}) async {
  final database = AppDatabase.memory();
  final storage = InMemorySecureStorage();
  addTearDown(database.close);

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
        appDatabaseProvider.overrideWithValue(database),
        secureStorageProvider.overrideWithValue(storage),
        initialLocationProvider.overrideWithValue(initialLocation),
        if (catalogApiDataSource != null)
          catalogApiDataSourceProvider.overrideWithValue(catalogApiDataSource),
        if (billingApiDataSource != null)
          billingApiDataSourceProvider.overrideWithValue(billingApiDataSource),
      ],
      child: const AllAiApp(),
    ),
  );
  await tester.pumpAndSettle();
  return TestAppHarness(database: database, storage: storage);
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

    expect(find.text('Создавайте AI-фото и видео'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
    expect(find.text('Главная'), findsNothing);
  });

  testWidgets('signed-out protected initial route redirects to Welcome', (
    tester,
  ) async {
    await pumpAllAi(
      tester,
      signedIn: false,
      initialLocation: AppRoutes.profile,
    );

    expect(find.text('Создавайте AI-фото и видео'), findsOneWidget);
    expect(find.text('Профиль'), findsNothing);
  });

  testWidgets('login success stores session and opens app shell', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
    await pumpRoute(tester);
    await tester.enterText(
      find.byType(TextField).at(1),
      MockAuthRepository.mockPassword,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
    await pumpRoute(tester);

    expect(find.text('Главная'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNotNull);
  });

  testWidgets('wrong credentials show safe error and do not store session', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
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

    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
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

    await tester.tap(find.widgetWithText(FilledButton, 'Войти'));
    await pumpRoute(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Забыли пароль?'));
    await pumpRoute(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Отправить инструкцию'));
    await pumpRoute(tester);
    expect(find.text('Введите email'), findsOneWidget);
    expect(
      find.text('Если аккаунт существует, мы отправим инструкцию'),
      findsNothing,
    );

    await tester.enterText(find.byType(TextField).first, 'bad-email');
    await tester.tap(find.widgetWithText(FilledButton, 'Отправить инструкцию'));
    await pumpRoute(tester);
    expect(find.text('Введите корректный email'), findsOneWidget);
    expect(
      find.text('Если аккаунт существует, мы отправим инструкцию'),
      findsNothing,
    );
  });

  testWidgets('registration legal links open placeholder', (tester) async {
    await pumpAllAi(tester, signedIn: false);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Создать аккаунт'));
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

    await tester.tap(find.widgetWithText(OutlinedButton, 'Создать аккаунт'));
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
    expect(find.text('Главная'), findsOneWidget);
  });

  testWidgets('signed-in restore renders main navigation', (tester) async {
    await pumpAllAi(tester);

    expect(find.text('AllAI'), findsOneWidget);
    expect(find.text('Главная'), findsOneWidget);
    expect(find.text('Создать'), findsOneWidget);
    expect(find.text('Библиотека'), findsOneWidget);
    expect(find.text('Студия'), findsOneWidget);
    expect(find.text('Профиль'), findsOneWidget);
    expect(find.text('1 250'), findsOneWidget);
  });

  testWidgets('Create tab renders provider-backed generator UI', (
    tester,
  ) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Создать'));
    await pumpRoute(tester);

    expect(find.text('Новая генерация'), findsOneWidget);
    expect(find.text('Промпт'), findsOneWidget);

    final costPreview = find.text('Стоимость: от 80 койнов');
    await scrollUntilVisible(tester, costPreview);
    expect(costPreview.last, findsOneWidget);
  });

  testWidgets('Tools and template detail routes render', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Инструменты'));
    await pumpRoute(tester);

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

  testWidgets('Create can run mock job and open result viewer', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Создать'));
    await pumpRoute(tester);

    final openResult = find.text('Запустить демо-результат');
    await tapVisible(tester, openResult);

    expect(find.text('Результат'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Unboxing'));
    expect(find.text('Unboxing'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Сохранить'));
    expect(find.text('Сохранить'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Метаданные'));
    expect(find.text('Метаданные'), findsOneWidget);
  });

  testWidgets('Pricing route renders disabled demo billing', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('1 250'));
    await pumpRoute(tester);

    expect(find.text('Баланс и пакеты'), findsOneWidget);
    expect(find.text('Пакеты'), findsOneWidget);
    await scrollUntilVisible(
      tester,
      find.text('Покупки будут подключены позже'),
    );
    expect(find.text('Покупки будут подключены позже'), findsOneWidget);
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

    expect(find.text('Баланс и пакеты'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Пакеты пока не добавлены'));
    expect(find.text('Пакеты пока не добавлены'), findsOneWidget);
  });

  testWidgets('Library and Studio tabs render mock runtime content', (
    tester,
  ) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Библиотека'));
    await pumpRoute(tester);
    expect(find.text('Пока нет созданных результатов'), findsOneWidget);

    await tester.tap(find.text('Студия'));
    await pumpRoute(tester);
    expect(find.text('Social Studio'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Создать social asset'));
    expect(find.text('Создать social asset'), findsOneWidget);
  });

  testWidgets('Back from result returns to Library tab', (tester) async {
    await pumpAllAi(tester);
    await tester.tap(find.byIcon(Icons.auto_awesome_outlined).last);
    await pumpRoute(tester);
    await tapVisible(tester, find.text('Запустить демо-результат'));
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    await tester.tap(find.text('Библиотека'));
    await pumpRoute(tester);

    final historyItem = find.widgetWithText(MediaAssetTile, 'Unboxing');
    await tapVisible(tester, historyItem);

    expect(find.text('Результат'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    expect(find.text('Библиотека'), findsWidgets);
    expect(find.text('Unboxing'), findsOneWidget);
  });

  testWidgets('Back from pricing returns to Profile tab', (tester) async {
    await pumpAllAi(tester);

    await tester.tap(find.text('Профиль'));
    await pumpRoute(tester);
    expect(find.text('Демо-креатор'), findsOneWidget);

    await tester.tap(find.text('Баланс: 1 250 койнов'));
    await pumpRoute(tester);

    expect(find.text('Баланс и пакеты'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    expect(find.text('Профиль'), findsWidgets);
    expect(find.text('Демо-креатор'), findsOneWidget);
  });

  testWidgets('logout clears session and back does not reveal shell', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester);

    await tester.tap(find.text('Профиль'));
    await pumpRoute(tester);
    await scrollUntilVisible(
      tester,
      find.widgetWithText(OutlinedButton, 'Выйти'),
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Выйти'));
    await pumpRoute(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Выйти'));
    await pumpRoute(tester);

    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNull);
    expect(find.text('Создавайте AI-фото и видео'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await pumpRoute(tester);
    expect(find.text('Создавайте AI-фото и видео'), findsOneWidget);
    expect(find.text('Главная'), findsNothing);
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
