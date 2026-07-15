import 'package:allai_mobile/core/auth/auth_session.dart';
import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:allai_mobile/features/auth/data/auth_repository.dart';
import 'package:allai_mobile/features/auth/domain/auth_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemorySecureStorage storage;
  late AuthSessionStore sessionStore;
  late MockAuthRepository repository;

  setUp(() {
    storage = InMemorySecureStorage();
    sessionStore = AuthSessionStore(storage);
    repository = MockAuthRepository(sessionStore);
  });

  test('login success stores secure session', () async {
    final session = await repository.login(
      const LoginRequest(
        email: MockAuthRepository.mockEmail,
        password: MockAuthRepository.mockPassword,
      ),
    );

    expect(session.user.email, MockAuthRepository.mockEmail);
    expect(await storage.read(AuthSessionStore.sessionKey), isNotNull);
  });

  test('social login success stores secure session', () async {
    final session = await repository.loginWithSocialProvider(
      const SocialLoginRequest(
        provider: SocialAuthProvider.google,
        email: 'google.creator@example.com',
        displayName: 'Google Creator',
      ),
    );

    expect(session.user.email, 'google.creator@example.com');
    expect(session.user.displayName, 'Google Creator');
    expect(session.user.legalConsent.isComplete, isTrue);
    expect(await storage.read(AuthSessionStore.sessionKey), isNotNull);
  });

  test(
    'wrong credentials show safe failure and do not store session',
    () async {
      expect(
        () => repository.login(
          const LoginRequest(email: 'wrong@example.com', password: 'bad-pass'),
        ),
        throwsA(
          isA<AuthFailure>().having(
            (error) => error.code,
            'code',
            AuthErrorCode.invalidCredentials,
          ),
        ),
      );

      expect(await storage.read(AuthSessionStore.sessionKey), isNull);
    },
  );

  test('registration requires legal consent and 18 confirmation', () async {
    final now = DateTime.utc(2026, 7, 3, 12);

    await expectLater(
      repository.register(
        RegisterRequest(
          email: 'new@example.com',
          password: 'strong-pass',
          legalConsent: LegalConsent(
            acceptedTerms: true,
            acceptedPrivacy: true,
            confirmedAge18: false,
            consentVersion: '2026-07',
            acceptedAt: now,
          ),
        ),
      ),
      throwsA(
        isA<AuthFailure>().having(
          (error) => error.code,
          'code',
          AuthErrorCode.ageConfirmationRequired,
        ),
      ),
    );

    final session = await repository.register(
      RegisterRequest(
        email: 'new@example.com',
        password: 'strong-pass',
        displayName: 'Новый креатор',
        legalConsent: LegalConsent(
          acceptedTerms: true,
          acceptedPrivacy: true,
          confirmedAge18: true,
          consentVersion: '2026-07',
          acceptedAt: now,
        ),
      ),
    );

    expect(session.user.email, 'new@example.com');
    expect(session.user.legalConsent.isComplete, isTrue);
  });

  test('restore reads session and logout clears it', () async {
    final login = await repository.login(
      const LoginRequest(
        email: MockAuthRepository.mockEmail,
        password: MockAuthRepository.mockPassword,
      ),
    );

    final restored = await MockAuthRepository(sessionStore).restoreSession();
    expect(restored?.user.id, login.user.id);

    await repository.logout();
    expect(await MockAuthRepository(sessionStore).restoreSession(), isNull);
  });

  test('expired refresh session is cleared on restore', () async {
    final now = DateTime.now().toUtc();
    await sessionStore.write(
      AuthSession(
        user: AuthUser(
          id: 'expired-user',
          email: 'expired@example.com',
          locale: 'ru',
          createdAt: now.subtract(const Duration(days: 40)),
          legalConsent: LegalConsent(
            acceptedTerms: true,
            acceptedPrivacy: true,
            confirmedAge18: true,
            consentVersion: '2026-07',
            acceptedAt: now.subtract(const Duration(days: 40)),
          ),
        ),
        tokens: AuthTokenPair(
          accessToken: 'expired_access',
          refreshToken: 'expired_refresh',
          tokenType: 'Bearer',
          accessExpiresAt: now.subtract(const Duration(days: 2)),
          refreshExpiresAt: now.subtract(const Duration(days: 1)),
        ),
        createdAt: now.subtract(const Duration(days: 40)),
      ),
    );

    expect(await repository.restoreSession(), isNull);
    expect(await storage.read(AuthSessionStore.sessionKey), isNull);
  });
}
