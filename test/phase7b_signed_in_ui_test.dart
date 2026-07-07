import 'package:allai_mobile/app/allai_app.dart';
import 'package:allai_mobile/app/router/app_router.dart';
import 'package:allai_mobile/app/router/app_routes.dart';
import 'package:allai_mobile/core/auth/auth_session.dart';
import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/core/database/database_providers.dart';
import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:allai_mobile/features/auth/data/auth_repository.dart';
import 'package:allai_mobile/features/auth/domain/auth_models.dart';
import 'package:allai_mobile/features/generation_jobs/presentation/providers/generation_job_providers.dart';
import 'package:allai_mobile/shared/widgets/generated_asset_preview.dart';
import 'package:allai_mobile/shared/widgets/neon_media_card.dart';
import 'package:allai_mobile/shared/widgets/template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpPhase7BApp(
  WidgetTester tester, {
  String initialLocation = AppRoutes.home,
  List<Duration>? generationPollingDelays,
}) async {
  final database = AppDatabase.memory();
  final storage = InMemorySecureStorage();
  addTearDown(database.close);

  await MockAuthRepository(AuthSessionStore(storage)).login(
    const LoginRequest(
      email: MockAuthRepository.mockEmail,
      password: MockAuthRepository.mockPassword,
    ),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        secureStorageProvider.overrideWithValue(storage),
        initialLocationProvider.overrideWithValue(initialLocation),
        if (generationPollingDelays != null)
          generationPollingDelaysProvider.overrideWithValue(
            generationPollingDelays,
          ),
      ],
      child: const AllAiApp(),
    ),
  );
  await tester.pumpAndSettle();
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
  final listView = find.byType(ListView);
  final customScrollView = find.byType(CustomScrollView);
  final target = tester.any(listView)
      ? listView.first
      : tester.any(customScrollView)
      ? customScrollView.first
      : find.byType(Scrollable).first;
  await tester.drag(target, Offset(0, -distance));
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
  testWidgets('Phase 7B Home exposes signed-in creative dashboard', (
    tester,
  ) async {
    await pumpPhase7BApp(tester);

    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Mermaid'), findsOneWidget);
    expect(find.text('Try Now'), findsOneWidget);
    expect(find.text('Most Popular'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Crazy Effects'));
    expect(find.text('Crazy Effects'), findsOneWidget);
  });

  testWidgets('Phase 7B Create keeps prompt, source and quote visible', (
    tester,
  ) async {
    await pumpPhase7BApp(tester, initialLocation: AppRoutes.create);

    expect(find.text('Новая генерация'), findsOneWidget);
    expect(find.text('Формат'), findsOneWidget);
    expect(find.text('Описание'), findsOneWidget);
    expect(find.text('Промпт'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField).first,
      'Чистый рекламный кадр продукта на светлом фоне',
    );
    await pumpRoute(tester);

    await scrollUntilVisible(tester, find.text('Референс-изображение'));
    expect(find.text('Референс-изображение'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Стоимость: 80 койнов'));
    expect(find.text('Стоимость: 80 койнов'), findsOneWidget);
  });

  testWidgets('Phase 7B Catalog and template detail present scenario flow', (
    tester,
  ) async {
    await pumpPhase7BApp(tester, initialLocation: AppRoutes.tools);

    expect(find.text('Каталог инструментов'), findsOneWidget);
    expect(find.text('Модели и инструменты'), findsOneWidget);
    expect(find.text('AllAI Photo Studio'), findsOneWidget);

    final productTemplate = find.widgetWithText(
      TemplateCard,
      'Product UGC Hook',
    );
    await tapVisible(tester, productTemplate);

    expect(find.text('Шаблон'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Что нужно от пользователя'));
    expect(find.text('Что нужно от пользователя'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Стартовая идея'));
    expect(find.text('Стартовая идея'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Использовать шаблон'));
    expect(find.text('Использовать шаблон'), findsOneWidget);
  });

  testWidgets('Phase 7B Result and Library show media history states', (
    tester,
  ) async {
    await pumpPhase7BApp(
      tester,
      initialLocation: AppRoutes.create,
      generationPollingDelays: const [Duration.zero],
    );

    await tester.enterText(
      find.byType(TextField).first,
      'Сделай чистый hero shot продукта для библиотеки',
    );
    await pumpRoute(tester);
    await tapVisible(tester, find.text('Запустить генерацию'));

    expect(find.text('Результат'), findsOneWidget);
    expect(find.byType(GeneratedAssetPreview), findsWidgets);
    await scrollUntilVisible(tester, find.text('Сохранить'));
    expect(find.text('Сохранить'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await pumpRoute(tester);
    await tester.tap(find.text('Projects').last);
    await pumpRoute(tester);

    expect(find.text('Projects'), findsWidgets);
    expect(find.textContaining('saved generations'), findsOneWidget);
    expect(find.byType(NeonMediaCard), findsWidgets);
  });
}
