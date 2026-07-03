import '../../../core/auth/auth_session.dart';
import '../domain/auth_models.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();
  Future<AuthSession> login(LoginRequest request);
  Future<AuthSession> register(RegisterRequest request);
  Future<void> logout();
  Future<void> requestPasswordReset(String email);
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._sessionStore);

  static const mockEmail = 'creator@allai.market';
  static const mockPassword = 'allai-demo';
  static final _mockCreatedAt = DateTime.utc(2026, 7, 3, 10);
  static final _mockConsent = LegalConsent(
    acceptedTerms: true,
    acceptedPrivacy: true,
    confirmedAge18: true,
    consentVersion: '2026-07',
    acceptedAt: _mockCreatedAt,
  );

  final AuthSessionStore _sessionStore;
  final Set<String> _registeredEmails = <String>{};

  @override
  Future<AuthSession?> restoreSession() async {
    final session = await _sessionStore.read();
    if (session == null) return null;

    if (session.tokens.isRefreshExpired) {
      await _sessionStore.clear();
      return null;
    }

    final restoredAt = DateTime.now().toUtc();
    final restored = session.tokens.isAccessExpired
        ? session.copyWith(
            tokens: _issueTokens(session.user.id),
            restoredAt: restoredAt,
          )
        : session.copyWith(restoredAt: restoredAt);
    await _sessionStore.write(restored);
    return restored;
  }

  @override
  Future<AuthSession> login(LoginRequest request) async {
    final email = _normalizeEmail(request.email);
    if (email != mockEmail || request.password != mockPassword) {
      throw const AuthFailure(
        AuthErrorCode.invalidCredentials,
        'Invalid mock credentials',
      );
    }

    final session = _createSession(
      user: AuthUser(
        id: 'user-demo-creator',
        email: mockEmail,
        displayName: 'Демо-креатор',
        locale: 'ru',
        createdAt: _mockCreatedAt,
        legalConsent: _mockConsent,
      ),
    );
    await _sessionStore.write(session);
    return session;
  }

  @override
  Future<AuthSession> register(RegisterRequest request) async {
    final email = _normalizeEmail(request.email);
    if (!request.legalConsent.acceptedTerms ||
        !request.legalConsent.acceptedPrivacy) {
      throw const AuthFailure(
        AuthErrorCode.consentRequired,
        'Legal consent is required',
      );
    }
    if (!request.legalConsent.confirmedAge18) {
      throw const AuthFailure(
        AuthErrorCode.ageConfirmationRequired,
        'Age confirmation is required',
      );
    }
    if (request.password.length < 8) {
      throw const AuthFailure(AuthErrorCode.weakPassword, 'Weak password');
    }
    if (email == mockEmail || _registeredEmails.contains(email)) {
      throw const AuthFailure(
        AuthErrorCode.emailAlreadyExists,
        'Email already exists',
      );
    }

    _registeredEmails.add(email);
    final now = DateTime.now().toUtc();
    final session = _createSession(
      user: AuthUser(
        id: 'user-${now.microsecondsSinceEpoch}',
        email: email,
        displayName: _emptyToNull(request.displayName),
        locale: request.locale,
        createdAt: now,
        legalConsent: request.legalConsent,
      ),
    );
    await _sessionStore.write(session);
    return session;
  }

  @override
  Future<void> logout() => _sessionStore.clear();

  @override
  Future<void> requestPasswordReset(String email) async {
    _normalizeEmail(email);
  }

  AuthSession _createSession({required AuthUser user}) {
    final now = DateTime.now().toUtc();
    return AuthSession(
      user: user,
      tokens: _issueTokens(user.id),
      createdAt: now,
    );
  }

  AuthTokenPair _issueTokens(String userId) {
    final now = DateTime.now().toUtc();
    final marker = now.microsecondsSinceEpoch;
    return AuthTokenPair(
      accessToken: 'mock_access_${userId}_$marker',
      refreshToken: 'mock_refresh_${userId}_$marker',
      tokenType: 'Bearer',
      accessExpiresAt: now.add(const Duration(hours: 1)),
      refreshExpiresAt: now.add(const Duration(days: 30)),
    );
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
