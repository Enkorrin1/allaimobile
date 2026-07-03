# Phase 4 Execution Brief: Auth And Account MVP

Дата: 2026-07-03.

## Objective

Add an auth/account MVP foundation for AllAI Mobile App:

- user can login/register in dev/mock environment;
- legal consent and 18+ confirmation are captured;
- session is stored in `flutter_secure_storage`;
- session survives restart;
- logout clears local session;
- Profile reflects signed-in/signed-out state.

Decision source: `docs/PHASE_4_CONTRACT_REVIEW.md`.

## Implementation Slices

### Slice A: Contract And UI Gate

No app code edits except docs.

- Product acceptance.
- Backend/Data auth DTO contract.
- Architecture provider/routing/storage review.
- UI/UX screen-state review.
- QA test plan.

### Slice B: Mock Auth Runtime

Code owner: Mobile Implementation.

- `core/storage/secure_storage.dart` wrapper.
- `core/auth/auth_session.dart`.
- `features/auth/domain/auth_models.dart`.
- `features/auth/data/auth_repository.dart`.
- `features/auth/presentation/providers/auth_providers.dart`.
- Mock auth adapter with deterministic users.
- Session restore through secure storage.
- Logout and local session clear.

### Slice C: Screens And Route State

- Welcome screen links to login/register.
- Login form with validation and wrong-credentials error.
- Registration form with legal/18+ gate.
- Password reset entry placeholder.
- Profile reflects session state and logout.
- go_router redirect/guard only after Architecture approves exact behavior.

### Slice D: Verification

Required local checks:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug`

Required tests:

- fresh install starts signed out or approved guest/dev mode;
- login success stores session;
- wrong credentials show safe error and do not store session;
- registration requires legal/18+ acceptance;
- session restore after provider/app reconstruction;
- logout clears session;
- no token/session data is stored in Drift/plain text.

## Acceptance

Phase 4 is complete when:

- Product accepts the auth/account behavior.
- Architecture confirms storage/provider/routing boundaries.
- QA passes auth smoke.
- No secrets or real credentials are committed.
- No live backend auth is added unless explicitly approved.

## Resolved Decisions

- Main app is gated behind auth for MVP.
- No guest product mode; deterministic mock credentials are allowed for dev/test only.
- Registration is email/password only for MVP.
- Legal consent and 18+ confirmation are required before registration submit.
- Password reset is a mock success flow with no real email delivery.
- Logout clears secure session and preserves local mock generated history.

Remaining P1 details:

- Replace placeholder Terms/Privacy links with approved URLs.
- Add OAuth/social auth only after explicit approval.
