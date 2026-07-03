# Phase 4 Role Assignments: Auth And Account MVP

Дата: 2026-07-03.

## Goal

Start Phase 4: Auth And Account MVP.

This phase adds a real mobile auth/account flow shape while staying safe for the current repository state. Until backend auth endpoints are explicitly approved, implementation must use a dev/mock auth contract and `flutter_secure_storage` for session persistence.

## Phase Boundary

Allowed:

- Auth domain models and repository interfaces.
- Mock/dev auth adapter.
- Secure storage wrapper for tokens/session data.
- Welcome, login, registration, password reset entry, legal consent and 18+ confirmation.
- Auth session restore.
- Logout and account settings placeholder.
- Route/state gating where safe.
- Tests for session restore, logout, wrong credentials, consent state.

Not allowed without explicit approval:

- Real backend credentials.
- Real production auth endpoints.
- OAuth provider SDKs.
- Storing tokens in Drift/plain text.
- Analytics/crash logging of credentials.
- Account deletion backend call.
- Commit or push.

## Product Lead

Define Phase 4 acceptance:

- Login/register/password reset copy and expected behavior.
- Legal consent and 18+ flow.
- Whether app shell is blocked before login or dev mode may continue as guest/mock user.
- Logout behavior and post-logout destination.
- Account settings P0 vs P1.
- Product blockers for Phase 4 closure.

## Backend Data

Produce auth data contract:

- User/session/token DTOs.
- Mock auth response shape.
- Token storage rules.
- Refresh token/session restore rules.
- Wrong credentials and expired session error shape.
- Logout/session clear contract.
- Future backend endpoint outline, no real secrets.

## Mobile Architecture

Review architecture:

- `core/auth` and `core/storage` placement.
- Riverpod providers for auth state/session restore.
- go_router redirect/auth gating strategy.
- Secure storage abstraction.
- Repository boundary between mock/dev auth and future Dio backend.
- Migration path from mock auth to live auth.

## UI UX

Define UI states and copy:

- Welcome screen.
- Login screen.
- Registration screen.
- Password reset entry.
- Legal consent and 18+ checkbox/sheet.
- Loading/error/locked states.
- Profile signed-in/signed-out states.
- Small-screen keyboard behavior.

## Mobile Implementation

Code owner after gates are clear:

- Implement auth domain/data/providers.
- Implement secure storage wrapper.
- Wire mock auth to existing auth/profile screens.
- Add session restore and logout.
- Add tests.
- Keep the app mock/dev only unless backend contract is approved.

## QA Release

Prepare Phase 4 QA gate:

- Fresh install signed-out state.
- Login success.
- Login wrong credentials.
- Registration success.
- Legal/18+ required.
- Session survives app restart.
- Logout clears session and returns to auth state.
- No secrets in logs/files.

## Repo GitHub

Repo/CI scope:

- Confirm `flutter_secure_storage` generated/platform files are expected.
- Watch for secrets/env/key files.
- Recommend commit split.
- Recommend CI additions for auth tests.

## Task Chat Logic

Coordination:

- Keep Phase 4 auth/account work separate from future in-app task-agent design.
- Track live handoff in `docs/ACTIVE_SPRINT.md`.
- Only one code owner should edit app code during implementation.
