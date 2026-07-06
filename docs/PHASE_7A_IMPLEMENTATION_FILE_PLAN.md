# Phase 7A Implementation File Plan

Date: 2026-07-05.

Status: planning-only. Phase 7A app-code is still blocked until repo split approval or explicit mixed-tree implementation approval.

## Purpose

This file turns the Phase 7A implementation queue into a concrete file-level plan for the first UI code pass after repo unblock.

Phase 7A goal: fix the first product impression and establish a reusable UI foundation without changing auth, session, navigation, backend, billing, generation or storage behavior.

## Start Preconditions

Phase 7A code can start only after all of these are true:

- repo split is approved and completed, or the user explicitly approves mixed-tree implementation risk;
- coordinator states: `Phase 7A app-code authorized`;
- fresh `git status --short -uall` is clean or contains only explicitly approved leftovers;
- Phase 5/6 shared-widget/test hunks are clean, committed or explicitly released;
- Mobile Implementation is the sole app-code owner;
- Product/UI/Architecture/Data/QA/Repo gates are still valid.

Recommended future branch after repo unblock:

- `codex/phase-7a-ui-foundation`

## Ordered Implementation Slices

1. Theme tokens.
2. Shared primitives.
3. AppShell and bottom navigation.
4. Welcome.
5. Login.
6. Register.
7. Password Reset.
8. Focused test/scans.
9. Redmi 7 smoke and screenshots.

## Product Copy Source Of Truth

Approved Welcome copy and terms:

- Brand: `AllAI`
- Headline: `Создавайте фото и видео с ИИ`
- Format chips: `Фото`, `Видео`, `Шаблоны`
- Primary CTA: `Создать аккаунт`
- Secondary CTA: `Войти`
- Login title: `Вход`
- Login CTA: `Войти`
- Login links: `Забыли пароль?`, `Создать аккаунт`
- Register CTA: `Создать аккаунт`
- Password Reset title: `Восстановить доступ`
- Password Reset CTA: `Продолжить`
- Bottom nav labels: `Главная`, `Создать`, `Библиотека`, `Студия`, `Профиль`

Allowed claims:

- prompt-based photo/video creation;
- templates/scenarios;
- demo coins, account and history as app concepts;
- legal/18+ requirements.

Forbidden claims:

- live upload/image-to-image;
- real AI provider availability;
- real payments/IAP;
- guaranteed generation quality or speed;
- production download/share;
- real email delivery;
- production account deletion.

## Slice 7A-01: Theme Foundation

Allowed files:

- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_typography.dart`
- `lib/app/theme/app_theme.dart`
- optional `lib/app/theme/app_radii.dart`

Implementation notes:

- Define coherent colors, typography, spacing, radii and state colors.
- Keep contrast strong on Redmi 7.
- Avoid screen-local style duplication.
- Do not add fonts, assets, packages or platform changes.

Acceptance:

- default Flutter roughness no longer dominates;
- tokens can support auth, shell and later signed-in screens;
- no behavior or routing changes.

## Slice 7A-02: Shared Primitives

Allowed files:

- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_text_field.dart`
- optionally `lib/shared/widgets/loading_state.dart`
- optionally `lib/shared/widgets/error_state.dart`
- optionally `lib/shared/widgets/empty_state.dart`
- conditionally `lib/shared/widgets/status_chip.dart`

Rules:

- Public APIs must remain backward-compatible.
- Prefer optional/defaulted parameters instead of required new args.
- Tap targets should be at least 48dp.
- `status_chip.dart` can be changed only if clean after split or explicitly released for Phase 7A.
- Do not break Create/Catalog/Result/Library callers.

Acceptance:

- buttons, cards, fields, chips and states share one visual language;
- disabled/loading/error/pressed states remain clear;
- no one-off per-screen copies of primitives.

## Slice 7A-03: AppShell And Bottom Navigation

Allowed file:

- `lib/app/shell/app_shell.dart`

Rules:

- Polish bottom nav labels, selected state, tap targets and safe area.
- Do not change `goBranch`, route destinations, router redirects or route list.
- Labels must fit on 320-360dp width.

Acceptance:

- selected tab is obvious;
- labels do not clip or overlap on Redmi 7;
- tap targets are at least 48dp;
- signed-in shell behavior remains unchanged.

## Slice 7A-04: Welcome

Allowed file:

- `lib/features/auth/presentation/screens/auth_welcome_screen.dart`

Layout requirements:

- first viewport shows `AllAI`;
- headline uses `Создавайте фото и видео с ИИ`;
- compact creative preview uses `Фото`, `Видео`, `Шаблоны`;
- primary CTA is `Создать аккаунт`;
- secondary CTA is `Войти`;
- keep support copy short and app-like;
- include legal/support line without making the screen feel like a landing page.

Acceptance:

- first impression feels complete and product-ready;
- CTA is within comfortable reach or reachable by normal scroll;
- no forbidden live/provider/payment/upload claims.

## Slice 7A-05: Login

Allowed file:

- `lib/features/auth/presentation/screens/login_screen.dart`

Rules:

- Preserve field keys and testability.
- Preserve inline validation.
- Preserve safe error behavior.
- Do not change route names or auth/session behavior.

Acceptance:

- title `Вход`;
- CTA `Войти`;
- links `Забыли пароль?` and `Создать аккаунт`;
- invalid login does not create a session;
- keyboard does not hide critical CTA/errors.

## Slice 7A-06: Register

Allowed file:

- `lib/features/auth/presentation/screens/register_screen.dart`

Rules:

- Preserve email/password fields.
- Preserve legal consent and `18+` gating.
- Preserve disabled CTA logic.
- Keep legal copy tappable and readable.

Acceptance:

- CTA `Создать аккаунт`;
- consent cannot be bypassed;
- legal/18+ controls are at least 48dp or comfortably tappable;
- legal copy does not overflow on Redmi 7.

## Slice 7A-07: Password Reset

Allowed file:

- `lib/features/auth/presentation/screens/password_reset_screen.dart`

Rules:

- Preserve email validation.
- Preserve mock success behavior.
- Do not imply real email delivery.

Acceptance:

- title `Восстановить доступ`;
- CTA `Продолжить`;
- back-to-login link works;
- validation and success state are visible.

## Test Plan

Preferred new file:

- `test/phase7a_auth_shell_test.dart`

Avoid unless clean or explicitly approved:

- `test/widget_test.dart`

Suggested coverage:

- Welcome first viewport contains `AllAI` and main CTA.
- Login validation remains visible.
- Register requires legal consent and `18+`.
- Password Reset shows safe mock success.
- AppShell labels are present.
- Existing auth/session/router behavior remains unchanged.

## Required Verification

After future implementation:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched Dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

Build APK only when needed for device smoke:

```powershell
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
```

## Redmi 7 QA Matrix

Device target:

- serial `c7970e16`;
- size `720x1520`;
- density `320`.

Screenshots:

- Welcome.
- Login empty/error.
- Login with keyboard.
- Register legal/18+.
- Register with keyboard.
- Reset validation.
- Reset success.
- Signed-in shell.
- Each bottom-nav selected state.

Auth smoke:

- invalid login does not create session;
- valid login opens shell;
- register requires legal/18+;
- reset shows safe success;
- logout returns Welcome;
- Android Back does not reveal protected shell after logout.

Accessibility checks:

- tap targets are at least 48dp;
- contrast is readable;
- focus/scroll order is sane;
- icon labels exist where needed;
- disabled/loading/error states are distinguishable;
- bottom nav labels fit.

## Forbidden Files And Changes

Do not touch without separate approval:

- `lib/app/router/*`
- `lib/features/auth/data/*`
- `lib/features/auth/domain/*`
- `lib/features/auth/presentation/providers/auth_providers.dart`
- `lib/core/*`
- `lib/features/generation_jobs/*`
- `lib/features/billing/*`
- `lib/features/tools/*`
- `lib/features/library/*`
- `lib/features/result_viewer/*`
- `lib/features/generator/*`
- Drift/generated database files
- `pubspec.yaml`
- `android/*`
- `ios/*`

Forbidden scope:

- new packages, fonts, binary assets or permissions;
- live backend URL/env config;
- provider SDKs or direct AI calls;
- real billing/IAP;
- upload/image-to-image activation;
- picker/file APIs;
- storage/schema/session behavior changes.

## Handoff Evidence

Mobile Implementation must provide:

- changed-file list;
- confirmation of allowed file set;
- checks output summary;
- import/secret scan summary;
- Redmi screenshot paths and smoke notes;
- known blockers;
- remaining dirty-file note;
- review handoff to Product/UI/Architecture/Data/QA/Repo.

## P0 Stop Conditions

Stop if:

- repo remains mixed or app-code authorization is missing;
- a forbidden file must be changed;
- router/auth/session/core/data/schema/dependency/platform changes are needed;
- shared widget public API would break existing callers;
- bottom nav or auth flows require behavior changes;
- tests/analyze/scans fail;
- live backend/provider/billing/upload/permission creep appears;
- Redmi 7 layout has clipped text, hidden CTA/errors or unreadable nav.

## Current Coordinator Decision

This file plan is ready for future Phase 7A implementation after repo unblock. It does not authorize code. Phase 7A remains HOLD until the repo/dirty-tree gate is closed.
