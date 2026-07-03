# Phase 4 Contract Review: Auth And Account MVP

Date: 2026-07-03.

Status: planning gates collected; Slice B can start with Mobile Implementation as the only app-code owner.

## Product Decisions

- Main app shell is auth-gated for MVP: Home, Create, Library, Pricing and Profile require signed-in state.
- No guest mode in product scope. Dev/test can use deterministic mock credentials only.
- Auth MVP is email/password only. OAuth, Apple, Google and social auth are P1.
- Password reset is P0 as an entry and mock success state only; no real email delivery.
- Registration must require legal consent and 18+ confirmation before submit.
- Logout clears secure session and returns to Welcome/Login.
- Logout preserves local mock generation history in Phase 4, but that history is inaccessible while signed out.
- Account Settings P0: email/display name, language placeholder, notifications placeholder, legal links, logout, disabled delete-account placeholder.

## Scope Boundary

Allowed in Phase 4:

- Auth domain models and repository interfaces.
- Mock/dev auth adapter with deterministic behavior.
- Secure storage wrapper for session/tokens.
- Welcome, login, registration, password reset entry, Profile signed-in/signed-out states.
- Session restore, refresh handling for mock tokens, logout/session clear.
- go_router auth redirects after async restore is represented explicitly.
- Unit/widget/router tests for auth behavior.

Not allowed without explicit approval:

- Real backend auth endpoints or production credentials.
- OAuth SDKs or Firebase/provider auth setup.
- Tokens/session data in Drift, SharedPreferences, fixtures, logs or docs with real values.
- Analytics/crash logging of credentials.
- Account deletion backend call.
- Commit or push.

## Data Contract

P0 DTOs:

- `AuthUser`: id, email, optional displayName, locale, createdAt, legalConsent.
- `LegalConsent`: acceptedTerms, acceptedPrivacy, confirmedAge18, consentVersion, acceptedAt.
- `AuthTokenPair`: accessToken, refreshToken, tokenType, accessExpiresAt, refreshExpiresAt.
- `AuthSession`: user, tokens, createdAt, optional restoredAt.
- `LoginRequest`: email, password.
- `RegisterRequest`: email, password, optional displayName, locale, legalConsent.

P0 error codes:

- `invalid_credentials`
- `email_already_exists`
- `weak_password`
- `consent_required`
- `age_confirmation_required`
- `session_expired`
- `refresh_failed`
- `network_unavailable`
- `unknown_auth_error`

Storage rules:

- Session/tokens are stored only through `flutter_secure_storage`.
- Preferred key: `allai.auth.session.v1`.
- Auth restore flow: `restoring -> signedOut` when missing, `restoring -> signedIn` when valid, refresh when access expired and refresh valid, clear session on refresh expiry/failure.
- Password is never persisted.

Future backend endpoints are documented only as placeholders:

- `POST /v1/auth/login`
- `POST /v1/auth/register`
- `POST /v1/auth/refresh`
- `POST /v1/auth/logout`
- `POST /v1/auth/password-reset`
- `GET /v1/auth/session`
- `GET /v1/users/me`
- `PATCH /v1/users/me`
- `DELETE /v1/users/me`

## Architecture Contract

- Add a clear auth boundary; do not put login/logout logic directly in screens.
- Suggested structure:
  - `lib/core/auth/auth_session.dart`
  - `lib/core/storage/secure_storage.dart`
  - `lib/features/auth/domain/auth_models.dart`
  - `lib/features/auth/data/auth_repository.dart`
  - `lib/features/auth/presentation/providers/auth_providers.dart`
- Provider chain: `secureStorageProvider -> authSessionStoreProvider -> authRepositoryProvider -> authControllerProvider/authStateProvider -> router/Profile/Auth screens`.
- Router must not redirect before restore is complete.
- Auth states must include at least `restoring`, `signedOut`, and `signedIn`.
- Signed out on protected route redirects to `/welcome`.
- Signed in on auth route redirects to `/`.
- Future migration swaps `MockAuthRepository` or mock data source for live Dio auth without changing UI/router contracts.

## UX Contract

P0 screens and states:

- Welcome: `AllAI`, short value copy, `Войти`, `Создать аккаунт`.
- Login: email, password, show/hide password, forgot-password entry, register link, loading text `Входим...`, safe error `Email или пароль неверны`.
- Registration: email, password, optional repeat password, required legal consent and 18+ confirmation, disabled submit until valid.
- Password reset: email field, `Отправить инструкцию`, mock success copy: `Если аккаунт существует, мы отправим инструкцию`.
- Profile signed-in: email/name, balance, account/settings placeholders, legal links, support placeholder, logout.
- Profile signed-out should only appear if an intentionally reachable route is kept; otherwise routing sends signed-out users to auth.
- Logout confirmation: `Выйти из аккаунта? Локальная история останется на устройстве.`
- Forms must remain usable with keyboard on small Android screens.

## QA Gate

P0 checks:

- Fresh install opens signed-out Welcome/Login, not main tabs.
- Signed-out deep links/protected tabs redirect to auth.
- Login success stores secure session and opens app shell.
- Wrong credentials show safe error and do not create session.
- Registration is blocked without legal consent and 18+ confirmation.
- Registration success creates mock session and opens app shell.
- Session survives force-stop/relaunch.
- Logout clears secure session, returns to auth, and back navigation does not reveal protected screens.
- Tokens/session do not appear in Drift/plain files/logs.
- Existing Phase 3 Create/Library/Pricing/Result flows still work after auth.

Required verification:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug`
- read-only secrets scan before handoff.

## Repo Hygiene

- Keep Phase 4 auth work in a separate future commit/PR from existing Phase 2/3 local changes.
- Do not stage `build`, `.dart_tool`, Gradle caches, APKs, local DBs, env files or signing artifacts.
- Extend ignore policy before any OAuth/Firebase/App Store key work: `google-services.json`, `GoogleService-Info.plist`, `*.p8`, `*.pem`, `*.key`.
- CI should eventually add build_runner/dirty-check and Android debug build.
- Do not commit or push without explicit user confirmation.

## Implementation Dispatch

Next task: Phase 4 Slice B - Mock Auth Runtime.

Mobile Implementation is the only code owner and should implement:

- secure storage/session store wrapper with fakeable tests;
- auth DTOs/models;
- mock auth repository;
- auth controller/provider;
- session restore and logout;
- route constants and protected-route policy;
- welcome/login/register/password-reset/profile wiring;
- tests for login, wrong credentials, registration consent, restore, logout and routing.

Other roles move to review/QA mode after implementation result is available.
