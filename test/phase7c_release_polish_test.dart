import 'package:allai_mobile/app/allai_app.dart';
import 'package:allai_mobile/app/router/app_router.dart';
import 'package:allai_mobile/app/router/app_routes.dart';
import 'package:allai_mobile/core/auth/auth_session.dart';
import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/core/database/database_providers.dart';
import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:allai_mobile/features/auth/data/auth_repository.dart';
import 'package:allai_mobile/features/auth/domain/auth_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_image_error_handling.dart';

Future<void> pumpPhase7CApp(
  WidgetTester tester, {
  String initialLocation = AppRoutes.profile,
}) async {
  ignoreNetworkImageLoadErrors();
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

Future<void> scrollUntilVisible(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 8; i += 1) {
    if (tester.any(finder)) {
      await tester.ensureVisible(finder.last);
      await tester.pump(const Duration(milliseconds: 300));
      return;
    }
    final scrollables = find.byType(Scrollable);
    expect(scrollables, findsWidgets);
    await tester.drag(scrollables.first, const Offset(0, -520));
    await tester.pump(const Duration(milliseconds: 300));
  }

  expect(finder, findsWidgets);
}

void main() {
  testWidgets('Phase 7C Profile reads as a coherent account hub', (
    tester,
  ) async {
    await pumpPhase7CApp(tester);

    expect(find.text('Профиль'), findsWidgets);
    expect(find.text('Демо-креатор'), findsOneWidget);
    expect(find.text('Сессия активна'), findsOneWidget);
    expect(find.text('Койны и баланс'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Настройки'));
    expect(find.text('Настройки'), findsOneWidget);
    await scrollUntilVisible(tester, find.text('Выйти'));
    expect(find.widgetWithText(OutlinedButton, 'Выйти'), findsOneWidget);
  });

  testWidgets('Phase 7C Pricing keeps demo billing honest', (tester) async {
    await pumpPhase7CApp(tester, initialLocation: AppRoutes.pricing);

    await scrollUntilVisible(tester, find.text('Start Creating Now'));
    expect(find.text('Start Creating Now'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.textContaining('coins available'), findsOneWidget);
    await scrollUntilVisible(tester, find.textContaining('Demo mode'));
    expect(find.textContaining('No live payment'), findsOneWidget);
  });

  testWidgets('Phase 7C Settings avoids technical release wording', (
    tester,
  ) async {
    await pumpPhase7CApp(tester, initialLocation: AppRoutes.settings);

    expect(find.text('Настройки приложения'), findsOneWidget);
    expect(find.text('Без живых платежей'), findsOneWidget);
    expect(find.text('Юридические документы'), findsOneWidget);
    expect(find.textContaining('backend'), findsNothing);
    expect(find.textContaining('job'), findsNothing);
    expect(find.textContaining('contracts'), findsNothing);
  });
}
