# Phase 7A Decision Packet

Date: 2026-07-04.

Status: coordination complete for the next slice. App-code is still on HOLD until repo approval.

## Current Decision

Phase 7A is ready as a narrow visual implementation slice, but code must not start while the working tree is mixed across Phase 5, Phase 6 and Phase 7.

The safe next user decision is one of:

1. Approve a careful commit split of the current dirty tree.
2. Explicitly approve Phase 7A implementation on top of the mixed dirty tree.

Coordinator recommendation: use option 1.

## Distributed Role Tasks

- Repo GitHub: prepare commit split/staging packet and forbidden staging patterns.
- Mobile Implementation: prepare exact implementation checklist, file list and verification commands.
- UI UX: define strict acceptance checklist for Welcome, Auth screens and App shell on Redmi 7.
- QA Release: define post-implementation smoke script for Redmi 7.

## Repo Decision Packet

Recommended split groups before Phase 7A code:

1. `feat: polish catalog pricing states`.
   Phase 5 Slice C: database/package metadata, billing, tools, studio, catalog mapper, Phase 5 tests and only Phase 5 hunks from shared tests.
2. `feat: add prompt image generation loop`.
   Phase 6 Slice A/Stabilization: mock API, generation jobs, generator, library, result viewer, generated preview/action widgets, Phase 6 tests and only Phase 6 hunks from shared tests.
3. `docs: record phase 5 and phase 6 gates`.
   `docs/PHASE_5_*`, `docs/PHASE_6_*`, plus only matching hunks from `docs/ACTIVE_SPRINT.md` and `docs/README.md` if strict split is required.
4. `docs: plan phase 7 ui overhaul`.
   `docs/PHASE_7_*`, `docs/PHASE_7A_*`, including baseline, split-plan and decision-packet docs.

Phase 7A docs can be staged separately only if `docs/ACTIVE_SPRINT.md` and `docs/README.md` are reviewed carefully, because both files also include Phase 5/6 doc-index history.

Never stage for Phase 7A:

- `build/`
- `.dart_tool/`
- `coverage/`
- `android/.gradle/`
- `android/build/`
- `ios/Pods/`
- APK files
- `*.aab`
- `*.ipa`
- screenshots
- `*.db`
- `*.sqlite*`
- `.env`
- `.env.*` except `.env.example`
- `*.jks`
- `*.keystore`
- `key.properties`
- `*.p8`
- `*.pem`
- `*.key`
- `google-services.json`
- `GoogleService-Info.plist`
- Android/iOS permission changes unless separately approved
- generated database files for UI-only work

Staging rules:

- Do not use `git add .`.
- Stage explicit files only.
- Prefer hunk review for `docs/ACTIVE_SPRINT.md`, `docs/README.md` and `test/widget_test.dart` if strict split commits are required.

Safest approval wording:

`Разрешаю выполнить только repo split staging/commits без push: отдельные commits для Phase 5 Slice C, Phase 6 Slice A/Stabilization, Phase 5/6 docs и Phase 7/7A docs. Не использовать git add .; staging только явными путями/patch hunks; build/cache/secrets/APK исключить.`

## Mobile Implementation Checklist

HOLD until repo approval.

Allowed file area after approval:

- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_typography.dart`
- `lib/app/theme/app_theme.dart`
- `lib/app/shell/app_shell.dart`
- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_text_field.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/features/auth/presentation/screens/auth_welcome_screen.dart`
- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/screens/register_screen.dart`
- `lib/features/auth/presentation/screens/password_reset_screen.dart`
- `test/widget_test.dart` or new `test/phase7a_auth_shell_test.dart`

Implementation order:

1. Update theme tokens: colors, typography, spacing, radii and component states.
2. Polish shared primitives without breaking public APIs.
3. Polish `AppShell` bottom navigation without changing `goBranch`.
4. Rebuild Welcome using the approved hierarchy.
5. Polish Login, Register and Password Reset while preserving validation paths.
6. Add or update minimal widget tests.

Must preserve:

- router, auth repository/controller and session storage behavior;
- route destinations for Welcome/Login/Register/Reset/Home;
- auth field keys used by tests;
- keyboard-safe scrolling;
- legal consent and 18+ flow;
- no backend/provider SDK/billing/IAP/upload/permission/Drift/dependency/asset creep.

Verification:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

## UI Acceptance Checklist

Welcome:

- `AllAI` is visible in the first viewport.
- Headline: `Создавайте фото и видео с ИИ`.
- Support copy is short and product-like.
- Preview cards or chips show `Фото`, `Видео`, `Шаблоны`.
- Primary CTA: `Создать аккаунт`.
- Secondary CTA: `Войти`.
- Fails if the screen still feels empty, the CTA is low/offscreen, or the screen reads like a landing page.

Login:

- Title `Вход`, compact support copy, email/password fields.
- Primary CTA `Войти`, forgot-password link and register link.
- Inline validation below fields.
- Fails if keyboard hides CTA/errors or technical auth text appears.

Register:

- Title `Создать аккаунт`.
- Email/password fields.
- Legal consent and `18+` controls visible and tappable.
- CTA disabled until fields and consents are valid.
- Fails if consent copy overflows, controls are too small, or CTA enables too early.

Password Reset:

- Title `Восстановить доступ`.
- Email field, CTA `Продолжить`, link back to login.
- Success state exists.
- Fails if it promises real email delivery in mock mode.

App Shell / Bottom Nav:

- Labels: `Главная`, `Создать`, `Библиотека`, `Студия`, `Профиль`.
- Selected tab is obvious.
- Five tabs fit on Redmi 7 without label clipping.
- Tap targets are at least 48dp.
- Safe area is respected.

Global visual rules:

- 16px screen padding.
- 12px card gaps.
- 8px radius.
- No horizontal overflow at 320-360dp.
- Buttons, chips and cards have consistent default, pressed, disabled and loading states.

## QA Smoke Script

Setup:

- `adb devices` shows `c7970e16 device`.
- `adb -s c7970e16 shell wm size` returns `720x1520`.
- `adb -s c7970e16 shell wm density` returns `320`.
- Install fresh APK, clear data and launch app.

Screenshots to capture:

- signed-out Welcome;
- Login without keyboard;
- Login with keyboard open;
- Register with legal/18+ controls;
- Password Reset validation/success;
- signed-in shell on main tab;
- selected state for every bottom-nav tab.

Auth smoke:

- invalid login shows user-facing error and creates no session;
- valid login `creator@allai.market / allai-demo` opens shell;
- Register requires legal consent and 18+;
- Reset validates invalid email and shows success for valid email;
- logout returns to Welcome and Android Back does not reveal protected shell.

Keyboard and navigation smoke:

- Login/Register/Reset keyboard does not cover CTA/errors;
- focused field remains visible while scrolling;
- session restores after force-stop/relaunch;
- bottom nav labels are readable, selected states are obvious and tap targets are stable.

No-regression scans:

- `flutter analyze` PASS;
- `flutter test` PASS;
- no provider SDK/keys/direct AI calls;
- no real billing/IAP;
- no upload/image-to-image activation;
- no Android/iOS permission changes.

## Final Readiness Review

Final role review was collected after this packet was created:

- Product Lead: CONDITIONAL. Product scope is ready for Welcome/Auth/App shell. Allowed claims are AllAI, photo/video AI creation, formats/templates and mock app concepts such as coins/history/account. Forbidden claims remain live upload/image-to-image, real AI providers, real payments/IAP, guaranteed quality/speed and production email/download/share. No product P0 blocker after repo approval.
- Mobile Architecture: CONDITIONAL. Architecture accepts the UI-only slice if work stays in theme, shared primitives, App Shell and auth screens. Router, auth/session data, core API/database/storage, generation, billing, tools/library/result data, platform files, permissions, Drift/generated DB, deps/assets remain forbidden. No architecture P0 blocker after repo approval.
- Backend/Data: PASS. No API, schema or storage work is required. Existing mock user/session/profile data is enough. Backend/storage/billing/upload/provider/IAP boundaries must remain untouched.
- Task Chat Logic: CONDITIONAL. Mobile Implementation remains the sole app-code owner after approval; other roles remain review/gate owners. No task-agent, live backend/provider, billing/IAP, upload/image-to-image, permission, Drift/schema, dependency or asset creep.

Readiness conclusion: Phase 7A implementation is prepared, but app-code is still blocked by the repo/dirty-tree decision.

## Coordinator State

Tasks are distributed and ready. The only blocking question is repo handling before app-code starts.
