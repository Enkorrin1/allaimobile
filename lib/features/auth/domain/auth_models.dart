import '../../../core/auth/auth_session.dart';

class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;
}

class RegisterRequest {
  const RegisterRequest({
    required this.email,
    required this.password,
    required this.legalConsent,
    this.displayName,
    this.locale = 'ru',
  });

  final String email;
  final String password;
  final String? displayName;
  final String locale;
  final LegalConsent legalConsent;
}

enum AuthErrorCode {
  invalidCredentials,
  emailAlreadyExists,
  weakPassword,
  consentRequired,
  ageConfirmationRequired,
  sessionExpired,
  refreshFailed,
  networkUnavailable,
  unknownAuthError,
}

class AuthFailure implements Exception {
  const AuthFailure(this.code, this.message);

  final AuthErrorCode code;
  final String message;

  String get safeMessage => switch (code) {
    AuthErrorCode.invalidCredentials => 'Email или пароль неверны',
    AuthErrorCode.emailAlreadyExists => 'Аккаунт с таким email уже существует',
    AuthErrorCode.weakPassword => 'Пароль должен быть не короче 8 символов',
    AuthErrorCode.consentRequired =>
      'Примите условия и политику конфиденциальности',
    AuthErrorCode.ageConfirmationRequired => 'Подтвердите, что вам есть 18 лет',
    AuthErrorCode.sessionExpired => 'Сессия истекла. Войдите снова',
    AuthErrorCode.refreshFailed => 'Не удалось восстановить сессию',
    AuthErrorCode.networkUnavailable => 'Сеть недоступна',
    AuthErrorCode.unknownAuthError => 'Не удалось выполнить действие',
  };

  @override
  String toString() => 'AuthFailure($code)';
}

extension AuthErrorCodeWire on AuthErrorCode {
  String get wireValue => switch (this) {
    AuthErrorCode.invalidCredentials => 'invalid_credentials',
    AuthErrorCode.emailAlreadyExists => 'email_already_exists',
    AuthErrorCode.weakPassword => 'weak_password',
    AuthErrorCode.consentRequired => 'consent_required',
    AuthErrorCode.ageConfirmationRequired => 'age_confirmation_required',
    AuthErrorCode.sessionExpired => 'session_expired',
    AuthErrorCode.refreshFailed => 'refresh_failed',
    AuthErrorCode.networkUnavailable => 'network_unavailable',
    AuthErrorCode.unknownAuthError => 'unknown_auth_error',
  };
}
