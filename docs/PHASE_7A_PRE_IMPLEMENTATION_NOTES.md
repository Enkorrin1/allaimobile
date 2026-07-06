# Phase 7A Pre-Implementation Notes

Date: 2026-07-04.

Status: tasks dispatched; key UI/Architecture/Implementation gates collected; app-code remains on HOLD until Repo gate/commit split is resolved.

## Delivered Role Tasks

Phase 7A tasks were dispatched to:

- Product Lead.
- UI UX.
- Mobile Architecture.
- Mobile Implementation.
- QA Release.
- Backend Data.
- Repo GitHub.
- Task Chat Logic.

Some role turns were interrupted by repeated coordinator/user continuation prompts, so this file records the useful gates collected so far and the remaining pending gates.

## Collected Gates

### UI UX

PASS for Phase 7A scope.

Phase 7A should only cover:

- design foundation;
- Welcome;
- Login;
- Register;
- Password Reset;
- App shell/bottom navigation.

Welcome hierarchy:

1. `AllAI`.
2. `Создавайте фото и видео с ИИ`.
3. `Форматы, сценарии и результаты в одной мобильной студии.`
4. Compact preview cards: `Фото`, `Видео`, `Шаблоны`.
5. Primary CTA: `Создать аккаунт`.
6. Secondary CTA: `Войти`.
7. Legal line.

Bottom nav labels:

- `Главная`.
- `Создать`.
- `Библиотека`.
- `Студия`.
- `Профиль`.

Phase 7A can be built without binary assets using text logo, Material/Flutter icons, tinted preview cards, format chips and procedural state surfaces.

### Mobile Architecture

PASS with HOLD until repo gate.

Likely theme/token files:

- `lib/app/theme/app_colors.dart`.
- `lib/app/theme/app_spacing.dart`.
- `lib/app/theme/app_typography.dart`.
- `lib/app/theme/app_theme.dart`.
- Optional: `lib/app/theme/app_radii.dart`.

Likely shared widgets:

- `lib/shared/widgets/app_button.dart`.
- `lib/shared/widgets/app_card.dart`.
- `lib/shared/widgets/app_text_field.dart`.
- `lib/shared/widgets/status_chip.dart`.
- `lib/shared/widgets/loading_state.dart`.
- `lib/shared/widgets/error_state.dart`.
- `lib/shared/widgets/empty_state.dart`.
- `lib/shared/widgets/placeholder_card.dart`.

Likely screens/shell:

- `lib/app/shell/app_shell.dart`.
- `lib/features/auth/presentation/screens/auth_welcome_screen.dart`.
- `lib/features/auth/presentation/screens/login_screen.dart`.
- `lib/features/auth/presentation/screens/register_screen.dart`.
- `lib/features/auth/presentation/screens/password_reset_screen.dart`.

Must not touch:

- `lib/app/router/app_router.dart`.
- `lib/app/router/app_routes.dart`.
- `lib/features/auth/data/`.
- `lib/features/auth/domain/`.
- `lib/features/auth/presentation/providers/auth_providers.dart`.
- `lib/core/api/`.
- `lib/core/network/`.
- `lib/core/database/`.
- `lib/core/storage/`.
- generation, billing, tools data, library data, result viewer, `pubspec.yaml`, `android/`, `ios/`.

### Mobile Implementation

PASS for planning, code not started.

Recommended order:

1. Theme tokens.
2. Shared primitives.
3. App shell/bottom navigation.
4. Welcome.
5. Login/Register/Password Reset.
6. Tests/scans/checks.

Risk controls:

- Preserve auth field keys.
- Preserve auth submit paths and route destinations.
- Preserve keyboard-safe scroll behavior.
- Keep shared widget APIs backward-compatible.
- No new dependencies, assets, permissions, Drift/generated database changes, provider SDKs, backend URL, billing/IAP or upload activation.

## Pending / Needs Re-Collection

Product Lead:

- Collected as PASS.
- Welcome/Auth/App shell claims are acceptable if framed as AllAI mobile AI studio for photo/video generation, prompt-first creation, templates/scenarios, history and coins in demo/mock mode.
- Must not promise live upload/image-to-image, real AI providers, real payments/IAP, guaranteed generation quality/speed or production download/share.
- P0 boundary remains design foundation + Welcome/Auth/App shell polish with unchanged auth/navigation behavior and no backend/billing/upload/permission creep.

QA Release:

- Collected as CONDITIONAL.
- Baseline: `adb devices` must show Redmi 7 as `device`; record `wm size` and `wm density`; capture Welcome/Login/App shell screenshots.
- Auth smoke: fresh signed-out Welcome, valid/invalid login, register legal/18+, reset validation, logout clears session.
- Keyboard smoke: Login/Register/Reset must not cover CTA/errors and must not overflow on 320-360dp.
- App shell smoke: session restore after force-stop and bottom nav labels/tap targets/selected state.
- PASS only if flows do not regress, Welcome is no longer sparse and there is no provider/backend/IAP/upload/permission creep.

Backend Data:

- Collected as PASS.
- No API/schema changes are needed for Phase 7A.
- Existing mock user/session/profile data is sufficient for polished auth/profile shell.
- Do not touch auth/session storage, Drift schema, generation/billing contracts, upload/live backend/provider/IAP boundaries.

Repo GitHub:

- Collected as BLOCKED for Phase 7A code start.
- Phase 7A code should not start while the dirty tree mixes Phase 5, Phase 6, Phase 7 docs and already modified shared/test files.
- Need explicit commit split or explicit approval to work on top of the mixed tree.
- For UI-only Phase 7A avoid `lib/core/**`, billing, generation, generator, library, result viewer, tools, studio, existing modified shared widgets and current tests unless split/approval is resolved.
- Inspection-only commands: `git status --short -uall`, `git diff --name-status`, `git diff --stat`, `git diff -- docs/ACTIVE_SPRINT.md docs/README.md`.
- Do not use `git add .`.

Task Chat Logic:

- Collected as CONDITIONAL.
- Boundaries are clean, but app-code remains on HOLD until Repo/GitHub gate or explicit user approval for the mixed working tree.
- Confirmed: one future code owner, no task-agent scope, no live provider/backend/billing/upload/permission creep, no Drift schema/generated database changes, no commit/push, no `git add .`.

## Current Coordinator Decision

Do not start Phase 7A app-code yet.

Next useful action is to collect Repo GitHub split/staging guidance and then ask the user for explicit commit/split approval if required. After repo gate is resolved, start Phase 7A with the narrow file set above.

## Quick Gate Redispatch

Short PASS/CONDITIONAL/BLOCKED gates were re-sent to Product Lead, QA Release, Backend/Data and Repo/GitHub to avoid further long-turn interruptions.

Final quick gates were collected:

- Product Lead: PASS.
- QA Release: CONDITIONAL.
- Backend/Data: PASS.
- Repo/GitHub: BLOCKED for code start until split/approval.

## Baseline Micro-Gates

After physical-device baseline capture, quick baseline checks were collected:

- UI UX: CONDITIONAL; baseline proves the current first impression is too sparse, and post-change comparison must cover Welcome density, auth hierarchy, bottom-nav selected states and shell hierarchy.
- QA Release: CONDITIONAL; Redmi 7 evidence is usable, but post-change smoke must cover signed-out Welcome, Login keyboard, Register legal/18+, Reset success, signed-in shell and bottom-nav states.
- Repo/GitHub: CONDITIONAL; `build/` screenshots are ignored, but staging must stay explicit and must not include build artifacts, APKs, screenshots, `.dart_tool/`, runtime DB/cache or secrets.
- Mobile Implementation: BLOCKED; code can start only after commit split approval or explicit approval to work on top of the mixed dirty tree.

Current coordinator decision remains unchanged: Phase 7A app-code is not started.
