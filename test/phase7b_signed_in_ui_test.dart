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

import 'test_image_error_handling.dart';

Future<void> pumpPhase7BApp(
  WidgetTester tester, {
  String initialLocation = AppRoutes.home,
  List<Duration>? generationPollingDelays,
}) async {
  ignoreNetworkImageLoadErrors();
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

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
  testWidgets('Phase 7B Home exposes signed-in creative dashboard', (
    tester,
  ) async {
    await pumpPhase7BApp(tester);

    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Product UGC Hook'), findsWidgets);
    expect(find.text('Try Now'), findsOneWidget);
    expect(find.text('Готовые сценарии'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Маркетинг студия'));
    expect(find.text('Маркетинг студия'), findsOneWidget);
  });

  testWidgets('Phase 7B plus opens Create sheet before composer', (
    tester,
  ) async {
    await pumpPhase7BApp(tester);

    await openCreateComposer(tester);

    expect(find.text('Video Generation'), findsOneWidget);
    expect(find.text('Describe a video...'), findsOneWidget);
    expect(find.text('Add image'), findsOneWidget);
    expect(find.text('Generate'), findsOneWidget);
    expect(find.text('ФОРМАТ'), findsOneWidget);
    expect(find.text('МОДЕЛИ'), findsOneWidget);
    expect(find.text('Kling'), findsOneWidget);
    expect(find.text('Seedance'), findsOneWidget);
  });

  testWidgets('Phase 7B Create keeps video composer visible', (tester) async {
    await pumpPhase7BApp(tester, initialLocation: AppRoutes.create);

    expect(find.text('Video Generation'), findsOneWidget);
    expect(find.text('Describe a video...'), findsOneWidget);
    expect(find.text('Add image'), findsOneWidget);
    expect(find.text('Generate'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).first,
      'Clean cinematic product reveal on a bright studio background',
    );
    await pumpRoute(tester);

    expect(
      find.text('Kling · Cost 240 coins · 1 250 available'),
      findsOneWidget,
    );
    expect(find.text('Futuristic walk of her'), findsOneWidget);
    await tester.tap(find.text('Фото'));
    await pumpRoute(tester);
    expect(find.text('Image Generation'), findsOneWidget);
    expect(find.text('NanoBanana'), findsOneWidget);
  });

  testWidgets('Phase 7B Catalog and template detail present scenario flow', (
    tester,
  ) async {
    await pumpPhase7BApp(tester, initialLocation: AppRoutes.tools);

    expect(find.text('NanoBanana'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Product UGC Hook'));
    expect(find.text('Product UGC Hook'), findsOneWidget);

    final productTemplate = find.widgetWithText(
      TemplateCard,
      'Product UGC Hook',
    );
    await tapVisible(tester, productTemplate);

    expect(find.text('Product UGC Hook'), findsWidgets);
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
      'Clean hero shot for the library',
    );
    await pumpRoute(tester);
    await tapVisible(tester, find.text('Generate'));

    expect(find.byType(GeneratedAssetPreview), findsWidgets);

    await tester.binding.handlePopRoute();
    await pumpRoute(tester);

    await tester.tap(find.byIcon(Icons.close));
    await pumpRoute(tester);

    await tester.tap(find.text('Projects').last);
    await pumpRoute(tester);

    expect(find.text('Projects'), findsWidgets);
    expect(find.textContaining('saved generations'), findsOneWidget);
    expect(find.byType(NeonMediaCard), findsWidgets);
  });
}
