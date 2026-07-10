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
import 'package:allai_mobile/features/generation_jobs/presentation/providers/generation_job_providers.dart';
import 'package:allai_mobile/shared/widgets/generated_asset_preview.dart';
import 'package:allai_mobile/shared/widgets/neon_media_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_image_error_handling.dart';

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
  BillingApiDataSource? billingApiDataSource,
  List<Duration>? generationPollingDelays,
}) async {
  ignoreNetworkImageLoadErrors();
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

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

Future<void> openCreateComposer(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add).last);
  await pumpRoute(tester);

  expect(find.text('Create'), findsOneWidget);
  expect(find.text('VIDEO'), findsOneWidget);
  expect(find.text('IMAGE'), findsOneWidget);
  expect(find.text('EFFECTS'), findsOneWidget);
  expect(find.text('MOTION'), findsOneWidget);

  await tester.tap(find.text('VIDEO'));
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
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('login success stores session and opens app shell', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, signedIn: false);

    await scrollUntilVisible(tester, find.text('I already have an account'));
    await tester.tap(find.text('I already have an account'));
    await pumpRoute(tester);
    await tester.enterText(
      find.byType(TextField).at(1),
      MockAuthRepository.mockPassword,
    );
    await tester.tap(find.byType(FilledButton).first);
    await pumpRoute(tester);

    expect(find.text('Videos'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNotNull);
  });

  testWidgets('wrong credentials show safe error and do not store session', (
    tester,
  ) async {
    final harness = await pumpAllAi(tester, signedIn: false);

    await scrollUntilVisible(tester, find.text('I already have an account'));
    await tester.tap(find.text('I already have an account'));
    await pumpRoute(tester);
    await tester.enterText(find.byType(TextField).at(1), 'wrong-password');
    await tester.tap(find.byType(FilledButton).first);
    await pumpRoute(tester);

    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNull);
    expect(find.text('Videos'), findsNothing);
  });

  testWidgets('signed-in restore renders main navigation', (tester) async {
    await pumpAllAi(tester);

    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('1 250'), findsOneWidget);
  });

  testWidgets('central plus opens Create sheet and video composer', (
    tester,
  ) async {
    await pumpAllAi(tester);

    await openCreateComposer(tester);

    expect(find.text('Video Generation'), findsOneWidget);
    expect(find.text('Describe a video...'), findsOneWidget);
    expect(find.text('Add image'), findsOneWidget);
    expect(find.text('Generate'), findsOneWidget);
    expect(find.text('FORMAT'), findsOneWidget);
    expect(find.text('MODELS'), findsOneWidget);
    expect(find.text('Kling'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('Create validates empty prompt before job creation', (
    tester,
  ) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);

    await openCreateComposer(tester);

    final submit = find.widgetWithText(FilledButton, 'Generate');
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
      'Low balance cinematic prompt',
    );
    await pumpRoute(tester);

    expect(
      find.text('Недостаточно койнов: нужно 240, доступно 10'),
      findsOneWidget,
    );
    final submit = find.widgetWithText(FilledButton, 'Generate');
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
  });

  testWidgets('Failed image job keeps retry copy visible', (tester) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);

    await openCreateComposer(tester);
    await tester.enterText(find.byType(TextField).first, 'fail this image job');
    await pumpRoute(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Generate'));
    await pumpRoute(tester);

    expect(
      find.text('Generation did not finish. Settings were saved.'),
      findsOneWidget,
    );
    expect(find.text('Coins were returned to your balance.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('Create can run mock job and open result viewer', (tester) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);

    await openCreateComposer(tester);
    await tester.enterText(
      find.byType(TextField).first,
      'Clean hero shot for a product reveal',
    );
    await pumpRoute(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Generate'));
    await pumpRoute(tester);

    expect(find.byType(GeneratedAssetPreview), findsWidgets);
    expect(find.textContaining('Could not decompress image'), findsNothing);
  });

  testWidgets('Tools route renders catalog content', (tester) async {
    await pumpAllAi(tester, initialLocation: AppRoutes.tools);

    expect(find.text('NanoBanana'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Product UGC Hook'));
    expect(find.text('Product UGC Hook'), findsOneWidget);
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

  testWidgets('Projects tab renders mock runtime content', (tester) async {
    await pumpAllAi(tester, initialLocation: AppRoutes.library);

    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Create Your Magic'), findsOneWidget);
  });

  testWidgets('Back from result returns to Library tab', (tester) async {
    await pumpAllAi(tester, generationPollingDelays: const [Duration.zero]);
    await openCreateComposer(tester);
    await tester.enterText(
      find.byType(TextField).first,
      'Create a result for the library',
    );
    await pumpRoute(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Generate'));
    await pumpRoute(tester);
    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    await tester.tap(find.byIcon(Icons.close));
    await pumpRoute(tester);

    await tester.tap(find.text('Projects').last);
    await pumpRoute(tester);

    final historyItem = find.widgetWithText(NeonMediaCard, 'Product UGC Hook');
    await tapVisible(tester, historyItem);

    expect(find.byType(GeneratedAssetPreview), findsWidgets);
  });
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
