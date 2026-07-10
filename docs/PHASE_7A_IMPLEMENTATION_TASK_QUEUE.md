# Phase 7A Implementation Task Queue

Date: 2026-07-04.

Status: implementation backlog prepared. App-code is still on HOLD until repo split approval or explicit mixed-tree approval.

## Goal

Execute the first visual redesign slice after repo approval:

- design foundation;
- shared UI primitives;
- App Shell and bottom navigation;
- Welcome/Login/Register/Password Reset;
- tests, scans and Redmi 7 smoke.

## Global Rules

- Mobile Implementation is the only app-code owner.
- Product, UI UX, Mobile Architecture and QA Release are review/gate owners.
- Do not change router/auth data/session storage/core database/API/storage/generation/billing/upload/platform files.
- Do not add packages, assets, fonts, permissions, provider SDKs, billing/IAP or live backend wiring.
- Prefer a new `test/phase7a_auth_shell_test.dart` instead of editing the mixed `test/widget_test.dart`.
- Avoid `lib/shared/widgets/status_chip.dart` until the existing Phase 5 hunk is committed or explicit mixed-tree approval is given.

## Ticket 7A-01: Design Tokens And Theme

Owner: Mobile Implementation.

Reviewers: UI UX, Mobile Architecture, QA Release.

Depends on:

- repo split approval or explicit mixed-tree approval.

Allowed files:

- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_typography.dart`
- `lib/app/theme/app_theme.dart`
- optional `lib/app/theme/app_radii.dart`

Acceptance:

- color, typography, spacing, radii, disabled/error/loading states feel coherent and mobile-premium;
- contrast is strong on Redmi 7;
- no one-off screen hardcoding appears where theme tokens should be used;
- no behavior changes.

Fail conditions:

- default Flutter look remains dominant;
- inconsistent text sizes or weak contrast;
- `pubspec.yaml`, platform files, router/auth/data/generation/billing files are touched.

## Ticket 7A-02: Shared UI Primitives

Owner: Mobile Implementation.

Reviewers: UI UX, Mobile Architecture, QA Release.

Depends on:

- 7A-01.

Allowed files:

- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_text_field.dart`
- optionally `lib/shared/widgets/loading_state.dart`
- optionally `lib/shared/widgets/error_state.dart`
- optionally `lib/shared/widgets/empty_state.dart`
- `lib/shared/widgets/status_chip.dart` only after its Phase 5 hunk is clean/committed or explicitly approved.

Acceptance:

- buttons, cards, fields, chips and state widgets share consistent visual language;
- tap targets are at least 48dp;
- default, pressed, disabled, loading and error states remain clear;
- public APIs stay backward-compatible for existing Create/Catalog/Result/Library usage.

Fail conditions:

- duplicated per-screen styles;
- breaking existing shared widget callers;
- changing `status_chip.dart` while its Phase 5 dirty hunk remains unresolved.

## Ticket 7A-03: App Shell And Bottom Navigation

Owner: Mobile Implementation.

Reviewers: UI UX, Mobile Architecture, QA Release.

Depends on:

- 7A-01;
- 7A-02.

Allowed files:

- `lib/app/shell/app_shell.dart`

Acceptance:

- bottom nav labels are `Главная`, `Создать`, `Библиотека`, `Студия`, `Профиль`;
- selected state is visually obvious;
- labels fit on Redmi 7 without clipping;
- tap targets are at least 48dp;
- safe area is respected.

Fail conditions:

- `goBranch`, route destinations, router redirects or route list change;
- selected state is ambiguous;
- labels overlap or clip on 320-360dp width.

## Ticket 7A-04: Welcome Screen

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, QA Release.

Depends on:

- 7A-01;
- 7A-02.

Allowed files:

- `lib/features/auth/presentation/screens/auth_welcome_screen.dart`

Acceptance:

- first viewport shows `AllAi`;
- headline is `Создавайте фото и видео с ИИ`;
- support copy is short and product-like;
- preview cards/chips show `Фото`, `Видео`, `Шаблоны`;
- primary CTA is `Создать аккаунт`;
- secondary CTA is `Войти`;
- Welcome no longer feels sparse or unfinished.

Fail conditions:

- CTA is below comfortable reach;
- screen reads like a marketing landing page instead of app entry;
- copy promises live upload/image-to-image, real providers, real payments, guaranteed quality/speed or production download/share.

## Ticket 7A-05: Login Screen

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, QA Release.

Depends on:

- 7A-01;
- 7A-02.

Allowed files:

- `lib/features/auth/presentation/screens/login_screen.dart`

Acceptance:

- title `Вход`;
- compact support copy;
- email/password fields remain keyed and testable;
- primary CTA `Войти`;
- links `Забыли пароль?` and `Создать аккаунт`;
- inline errors are visible and keyboard-safe;
- invalid login does not create a session.

Fail conditions:

- keyboard hides CTA/errors;
- technical auth copy leaks into UI;
- route destinations or validation behavior changes.

## Ticket 7A-06: Register Screen

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, QA Release.

Depends on:

- 7A-01;
- 7A-02.

Allowed files:

- `lib/features/auth/presentation/screens/register_screen.dart`

Acceptance:

- title `Создать аккаунт`;
- email/password fields remain keyed and testable;
- legal consent and `18+` control are visible and tappable;
- CTA stays disabled until form and consents are valid;
- legal copy fits on Redmi 7.

Fail conditions:

- consent can be bypassed;
- checkboxes/toggles are too small;
- legal copy overflows;
- auth repository, models, providers or secure storage are touched.

## Ticket 7A-07: Password Reset Screen

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, QA Release.

Depends on:

- 7A-01;
- 7A-02.

Allowed files:

- `lib/features/auth/presentation/screens/password_reset_screen.dart`

Acceptance:

- title `Восстановить доступ`;
- email field remains keyed and testable;
- CTA `Продолжить`;
- back-to-login link works;
- invalid email validation is visible;
- valid mock flow has success state;
- copy does not promise real email delivery.

Fail conditions:

- no success state;
- stuck state after submit;
- real email delivery is implied in mock mode.

## Ticket 7A-08: Tests, Scans And Static Verification

Owner: Mobile Implementation.

Reviewers: Mobile Architecture, QA Release.

Depends on:

- 7A-01 through 7A-07.

Preferred files:

- `test/phase7a_auth_shell_test.dart`

Avoid unless clean/approved:

- `test/widget_test.dart`

Required commands:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

Acceptance:

- format, analyze and tests pass;
- presentation import scan is clean;
- secret/provider/IAP/permission scan is clean;
- auth/session/navigation behaviors still pass.

Fail conditions:

- failing tests/analyze;
- new provider/backend/IAP/upload/permission markers;
- Phase 7A tests mixed into unresolved Phase 5/6 hunks.

## Ticket 7A-09: Redmi 7 Smoke And Screenshots

Owner: QA Release.

Support: Mobile Implementation.

Depends on:

- 7A-08.

Device target:

- Redmi 7;
- ADB serial `c7970e16`;
- physical size `720x1520`;
- density `320`.

Required screenshots:

- signed-out Welcome;
- Login without keyboard;
- Login with keyboard open;
- Register with legal/18+ controls;
- Password Reset validation/success;
- signed-in shell on main tab;
- each bottom-nav selected state.

Acceptance:

- no crash on fresh launch;
- Welcome no longer sparse;
- auth forms remain keyboard-safe;
- login/register/reset/logout/session restore still work;
- bottom nav labels and selected state are readable;
- Android Back does not reveal protected shell after logout.

Fail conditions:

- device unavailable and no replacement evidence is approved;
- keyboard covers CTA/errors;
- overflow/clipping on Redmi 7;
- provider/backend/IAP/upload/permission creep;
- staged artifacts, screenshots, secrets or build outputs.

## Role Review Result

- Product Lead: accepted priority and product claims; forbidden claims recorded.
- UI UX: accepted visual order and fail conditions.
- Mobile Architecture: accepted architecture order, allowed files and dependency constraints.
- Mobile Implementation: accepted implementation dependencies and blockers.
- QA Release: accepted conditional QA checks and release blockers.

## Current Coordinator Decision

The task queue is ready, but execution remains blocked until repo split approval or explicit mixed-tree implementation approval.
