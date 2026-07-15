import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_session.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_models.dart';

enum AuthStatus { restoring, signedOut, signedIn }

class AuthState {
  const AuthState({
    required this.status,
    this.session,
    this.isSubmitting = false,
    this.errorMessage,
    this.passwordResetSent = false,
  });

  const AuthState.restoring()
    : status = AuthStatus.restoring,
      session = null,
      isSubmitting = false,
      errorMessage = null,
      passwordResetSent = false;

  const AuthState.signedOut({
    this.errorMessage,
    this.isSubmitting = false,
    this.passwordResetSent = false,
  }) : status = AuthStatus.signedOut,
       session = null;

  const AuthState.signedIn(this.session)
    : status = AuthStatus.signedIn,
      isSubmitting = false,
      errorMessage = null,
      passwordResetSent = false;

  final AuthStatus status;
  final AuthSession? session;
  final bool isSubmitting;
  final String? errorMessage;
  final bool passwordResetSent;

  bool get isRestoring => status == AuthStatus.restoring;
  bool get isSignedIn => status == AuthStatus.signedIn;
  bool get isSignedOut => status == AuthStatus.signedOut;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository(ref.watch(authSessionStoreProvider));
});

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return const AuthState.restoring();
  }

  Future<void> restoreSession() async {
    state = const AuthState.restoring();
    try {
      final session = await ref.read(authRepositoryProvider).restoreSession();
      state = session == null
          ? const AuthState.signedOut()
          : AuthState.signedIn(session);
    } on AuthFailure catch (error) {
      state = AuthState.signedOut(errorMessage: error.safeMessage);
    } catch (_) {
      state = const AuthState.signedOut(
        errorMessage: 'Не удалось восстановить сессию',
      );
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AuthState.signedOut(isSubmitting: true);
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(LoginRequest(email: email, password: password));
      state = AuthState.signedIn(session);
      return true;
    } on AuthFailure catch (error) {
      state = AuthState.signedOut(errorMessage: error.safeMessage);
      return false;
    } catch (_) {
      state = const AuthState.signedOut(
        errorMessage: 'Не удалось выполнить вход',
      );
      return false;
    }
  }

  Future<bool> loginWithSocialProvider(SocialAuthProvider provider) async {
    state = const AuthState.signedOut(isSubmitting: true);
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .loginWithSocialProvider(SocialLoginRequest(provider: provider));
      state = AuthState.signedIn(session);
      return true;
    } on AuthFailure catch (error) {
      state = AuthState.signedOut(errorMessage: error.safeMessage);
      return false;
    } catch (_) {
      state = const AuthState.signedOut(
        errorMessage: 'Не удалось выполнить вход через соцсервис',
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required LegalConsent legalConsent,
    String? displayName,
    String locale = 'ru',
  }) async {
    state = const AuthState.signedOut(isSubmitting: true);
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .register(
            RegisterRequest(
              email: email,
              password: password,
              displayName: displayName,
              locale: locale,
              legalConsent: legalConsent,
            ),
          );
      state = AuthState.signedIn(session);
      return true;
    } on AuthFailure catch (error) {
      state = AuthState.signedOut(errorMessage: error.safeMessage);
      return false;
    } catch (_) {
      state = const AuthState.signedOut(
        errorMessage: 'Не удалось создать аккаунт',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.signedOut();
  }

  Future<void> requestPasswordReset(String email) async {
    state = const AuthState.signedOut(isSubmitting: true);
    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(email);
      state = const AuthState.signedOut(passwordResetSent: true);
    } catch (_) {
      state = const AuthState.signedOut(
        errorMessage: 'Не удалось отправить инструкцию',
      );
    }
  }
}
