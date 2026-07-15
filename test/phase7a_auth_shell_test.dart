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

class Phase7AHarness {
  const Phase7AHarness({required this.storage});

  final InMemorySecureStorage storage;
}

Future<Phase7AHarness> pumpPhase7AApp(
  WidgetTester tester, {
  bool signedIn = false,
  String initialLocation = AppRoutes.welcome,
}) async {
  ignoreNetworkImageLoadErrors();
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
      ],
      child: const AllAiApp(),
    ),
  );
  await tester.pumpAndSettle();
  return Phase7AHarness(storage: storage);
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
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -520));
    await tester.pump(const Duration(milliseconds: 300));
  }

  expect(finder, findsWidgets);
}

void main() {
  testWidgets('Phase 7A Welcome shows product-ready entry hierarchy', (
    tester,
  ) async {
    await pumpPhase7AApp(tester);

    expect(find.text('Image to Video'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });

  testWidgets('Phase 7A login keeps validation and session behavior', (
    tester,
  ) async {
    final harness = await pumpPhase7AApp(tester);

    final loginLink = find.text('I already have an account');
    await scrollUntilVisible(tester, loginLink);
    await tester.tap(loginLink.last);
    await pumpRoute(tester);
    expect(find.text('Sign in'), findsWidgets);

    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await pumpRoute(tester);

    expect(find.text('Enter email'), findsOneWidget);
    expect(find.text('Enter password'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNull);
  });

  testWidgets('Phase 7A Google social login opens app shell', (tester) async {
    final harness = await pumpPhase7AApp(tester);

    final googleButton = find.byKey(const Key('social-google-button'));
    await scrollUntilVisible(tester, googleButton);
    await tester.tap(googleButton);
    await pumpRoute(tester);

    expect(find.text('Videos'), findsOneWidget);
    expect(await harness.storage.read(AuthSessionStore.sessionKey), isNotNull);
  });

  testWidgets('Phase 7A register keeps legal gates tappable', (tester) async {
    await pumpPhase7AApp(tester);

    final continueButton = find.widgetWithText(FilledButton, 'Continue');
    await scrollUntilVisible(tester, continueButton);
    await tester.tap(continueButton.last);
    await pumpRoute(tester);

    expect(find.text('Create account'), findsWidgets);
    await scrollUntilVisible(
      tester,
      find.byKey(const Key('register-terms-checkbox')),
    );
    expect(find.byKey(const Key('register-terms-checkbox')), findsOneWidget);
    await scrollUntilVisible(
      tester,
      find.byKey(const Key('register-privacy-checkbox')),
    );
    expect(find.byKey(const Key('register-privacy-checkbox')), findsOneWidget);
    await scrollUntilVisible(
      tester,
      find.byKey(const Key('register-age-checkbox')),
    );
    expect(find.byKey(const Key('register-age-checkbox')), findsOneWidget);

    final submit = find.widgetWithText(FilledButton, 'Create account');
    await scrollUntilVisible(tester, submit);
    expect(tester.widget<FilledButton>(submit.last).onPressed, isNull);
  });

  testWidgets('Phase 7A password reset uses safe mock copy', (tester) async {
    await pumpPhase7AApp(tester);

    final loginLink = find.text('I already have an account');
    await scrollUntilVisible(tester, loginLink);
    await tester.tap(loginLink.last);
    await pumpRoute(tester);

    final forgotPassword = find.widgetWithText(
      OutlinedButton,
      'Forgot password?',
    );
    await scrollUntilVisible(tester, forgotPassword);
    await tester.tap(forgotPassword.last);
    await pumpRoute(tester);

    expect(find.text('Restore access'), findsWidgets);
    await tester.enterText(
      find.byType(TextField).first,
      'creator@allai.market',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await pumpRoute(tester);

    expect(
      find.text(
        'If the account exists, the request was accepted in demo mode.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Phase 7A shell keeps reference bottom navigation labels', (
    tester,
  ) async {
    await pumpPhase7AApp(
      tester,
      signedIn: true,
      initialLocation: AppRoutes.home,
    );

    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
  });
}
