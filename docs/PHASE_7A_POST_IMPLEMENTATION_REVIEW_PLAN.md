# Phase 7A Post-Implementation Review Plan

Date: 2026-07-04.

Status: review plan prepared. Phase 7A app-code is still on HOLD until repo split approval or explicit mixed-tree approval.

## Purpose

This file defines the review gates that must run after Mobile Implementation completes Phase 7A tickets.

## Review Owners

- Product Lead: product claims, first-impression acceptance and forbidden promises.
- UI UX: visual system, screen hierarchy and Redmi 7 screenshot review.
- Mobile Architecture: touched-file boundary, imports, route/auth/session behavior and dependency constraints.
- Backend/Data: no API/schema/storage regressions.
- QA Release: commands, device smoke, screenshots and release blockers.
- Repo GitHub: dirty tree, staged files, artifacts, commit split and push/PR hold.
- Task Chat Logic: role ownership, no task-agent scope and next-slice readiness.

## Product Gate

Product Lead must review:

- Welcome claims stay within approved scope: `AllAi`, `Создавайте фото и видео с ИИ`, `Фото`, `Видео`, `Шаблоны`, app-style creative studio framing.
- Welcome first viewport on Redmi 7 feels complete and premium, not empty MVP.
- `Создать аккаунт` and `Войти` are visible and reachable.
- Login, Register and Reset stay keyboard-safe with clear validation.
- Legal consent and `18+` remain visible and tappable.
- AppShell bottom nav labels fit and selected tab is obvious.

Product P0 blockers:

- live upload/image-to-image claims;
- real provider/payment/IAP promises;
- guaranteed generation quality/speed;
- production download/share promises;
- real email delivery implied in mock reset flow;
- missing Redmi 7 screenshots/smoke evidence.

## UI UX Gate

UI UX must review:

- Welcome: AllAi identity, headline, preview cards/chips, primary/secondary CTAs.
- Login: title `Вход`, email/password, CTA `Войти`, links, inline validation and loading state.
- Register: legal consent, `18+`, disabled CTA until valid and fitting legal copy.
- Password Reset: `Восстановить доступ`, `Продолжить`, success state and mock-safe copy.
- AppShell: `Главная`, `Создать`, `Библиотека`, `Студия`, `Профиль`, clear selected state and 48dp tap targets.
- Visual system: tokens/buttons/cards/chips/fields look consistent, no default Flutter roughness.

Required screenshots:

- Welcome;
- Login with keyboard;
- Register with consents;
- Reset success;
- signed-in shell with selected tab.

UI P0 blockers:

- black/screen-off or wrong-state screenshots;
- CTA offscreen;
- text overlap/clipping;
- horizontal overflow on Redmi 7;
- ambiguous active tab;
- technical/debug copy visible.

## Architecture Gate

Mobile Architecture must review:

- actual touched files stay within `lib/app/theme/*`, `lib/app/shell/app_shell.dart`, selected `lib/shared/widgets/*`, auth screens and tests;
- forbidden files remain untouched: router, auth data/domain/providers, core API/network/database/storage, generation, billing, platform files and `pubspec.yaml`;
- presentation/shared imports do not include `Dio`, `AppDatabase`, `Drift`, `MockAllAiApi`, picker/file APIs, `dart:io`, provider SDKs or IAP imports;
- signed-out redirect, login/register/reset, legal/18+, logout, session restore and Android Back behavior are preserved;
- design tokens/shared widgets are used instead of random screen-local styling;
- shared widget public APIs do not break Create/Catalog/Result/Library.

Required checks:

- `flutter analyze`;
- `flutter test`;
- presentation import scan;
- secrets/provider SDK/IAP scan;
- permission/platform diff scan.

Architecture P0 blockers:

- router/auth/session/core data changes without explicit approval;
- new dependencies/assets/platform permissions;
- Drift schema/generated DB changes;
- live backend/provider/billing/upload scope.

## Backend/Data Gate

Backend/Data must confirm:

- no API DTO, repository, mock/live data source, Drift schema, generated DB or sanitizer changes were introduced by Phase 7A;
- auth/session storage is untouched;
- `AuthUser`, `LegalConsent`, `AuthSession`, token pair and secure storage behavior are unchanged;
- billing/generation/upload boundaries are untouched;
- `availableCoins/reservedCoins`, generation create/poll/status and disabled upload skeleton are unchanged;
- UI copy does not imply live backend, real email delivery, real billing/IAP, upload/image-to-image or social publishing.

Backend/Data P0 blockers:

- storage/API/schema mutation;
- billing/generation/upload side effects;
- presentation importing data-layer classes;
- auth/session restore/logout regression.

## QA Gate

QA Release must execute:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
```

Required scans:

- provider/secrets/IAP/upload/permission scan;
- presentation import scan;
- platform permission diff scan.

Device setup:

- `adb devices` shows `c7970e16 device`;
- `wm size` shows `720x1520`;
- `wm density` shows `320`;
- install fresh APK;
- `pm clear`;
- launch `com.allai.mobile/.MainActivity`.

Required screenshots:

- signed-out Welcome;
- Login without keyboard;
- Login with keyboard open;
- Register legal/18+ controls;
- Reset validation/success;
- signed-in shell;
- each bottom-nav selected state.

QA P0 blockers:

- failing format/analyze/tests/scans;
- Redmi 7 smoke unavailable without approved replacement evidence;
- keyboard hides CTA/errors;
- auth/session/nav regressions;
- staged artifacts/secrets;
- live backend/provider/IAP/upload/permission creep.

## Repo Gate

Repo GitHub must review:

- `git status --short -uall`;
- `git diff --cached --name-status`;
- `git diff --cached --stat`;
- `git diff --cached --check`;
- Phase 7A changes are separated from old Phase 5/6 docs/code;
- staged set contains only approved Phase 7A files/docs.

Forbidden artifacts:

- `build/`;
- screenshots;
- APK/AAB/IPA;
- `.dart_tool/`;
- coverage;
- DB/sqlite/cache files;
- `.env*`;
- keys/certs;
- provider configs;
- `google-services.json`;
- `GoogleService-Info.plist`.

Repo P0 blockers:

- `git add .` usage;
- Phase 7A mixed with Phase 5/6 generated/data/generation/billing changes;
- forbidden artifacts staged;
- push/PR attempted before repo gate PASS;
- commit split not understood.

## Task Chat Logic Gate

Task Chat Logic must review:

- app-code was changed only by Mobile Implementation;
- Product/UI/Architecture/QA/Repo stayed review/gate owners;
- no user-facing task-chat, agent roles, handoff UI or orchestration was added in Phase 7A;
- result note includes scope, touched files, verification, screenshots/smoke status, blockers and review handoff;
- auth validation, legal/18+, session restore, router redirects, bottom nav routes and existing tests still work.

Next slice can start only if:

- no Phase 7A review gate has P0 blockers;
- Redmi/small-screen smoke passes or is explicitly downgraded;
- Repo confirms safe commit/split state.

## Current Coordinator Decision

This review plan is ready, but it does not unlock app-code. Phase 7A implementation still requires repo split approval or explicit mixed-tree implementation approval.
