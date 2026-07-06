# Phase 7B Post-Implementation Review Plan

Date: 2026-07-05.

Status: planning-only. Phase 7B app-code is still blocked until Phase 7A is implemented/reviewed and the repo gate is resolved.

## Purpose

This file defines the review gates that must run after a future Phase 7B signed-in workflow implementation.

## Review Owners

- Product Lead: product acceptance, claims and P0 scope.
- UI UX: visual hierarchy, Redmi 7 screenshots and screen fail conditions.
- Mobile Architecture: touched-module boundaries, imports, behavior preservation and scans.
- Backend/Data: no API/schema/storage regressions.
- QA Release: commands, device setup, smoke matrix and release blockers.
- Repo GitHub: dirty tree, staged files, split commits, artifacts and push/PR hold.
- Task Chat Logic: ownership, no task-agent scope and next-slice readiness.

## Product Gate

Product Lead must review:

- Home clearly leads to Create, Templates/Tools and history.
- Create makes prompt, model, template, cost, `availableCoins`, disabled/insufficient states and progress understandable.
- Catalog/Templates explain format, capabilities, cost and availability.
- Template Detail routes users into Create with a selected scenario.
- Result Viewer is media-first for active/completed/failed states.
- Library feels like asset history, not a debug list.
- Pricing/Profile stay honest mock states if touched.

Product P0 blockers:

- Home looks empty, decorative or cannot start generation.
- Upload/image-to-image appears active without approval.
- Unavailable/coming-soon states look available.
- Active/failed results look like completed results.
- Pricing looks like real purchase/IAP.
- Live providers, real billing, media permissions, guaranteed quality/speed or production share/download promises appear.

## UI UX Gate

UI UX must review:

- Home: balance, active job, formats, quick scenarios, recent results and CTA `Создать`.
- Create/Generator: format-first flow, selected model/template, prompt, source slot, quote/reserve, disabled reason and reachable CTA.
- Tools/Catalog: filters/search, model cards, cost/status and unavailable states.
- Template Detail: preview-first layout, what will be created, required inputs, model/cost and CTA.
- Result Viewer: completed, active and failed states; media preview; progress; retry/refund; action chips.
- Library: thumbnails, active progress, failed cards, filters/statuses and list-first Redmi 7 layout.
- Pricing/Profile if touched: balance, reserved/available, disabled purchases, account/settings/logout.
- Phase 7A visual system consistency: spacing, radii, typography, buttons, chips, cards and 48dp tap targets.

Required screenshots:

- Home;
- Create with keyboard;
- Catalog;
- Template Detail;
- Result completed;
- Result active/failed;
- Library;
- Pricing/Profile if touched.

UI P0 blockers:

- missing/black/wrong-state screenshots;
- long Russian labels clipped;
- CTA hidden by keyboard;
- action chips overflow;
- cards too dense for Redmi 7;
- second design language appears;
- visual polish changes behavior or data boundaries.

## Architecture Gate

Mobile Architecture must review:

- changes are limited to signed-in presentation modules and shared visual widgets;
- forbidden files remain untouched;
- presentation/shared imports stay clean;
- screens read only existing providers/controllers;
- no local catalog/generation/billing/library business logic is introduced in widgets;
- Phase 7A tokens/shared primitives are reused;
- Result/Library actions are either wired through approved services or disabled/safe-feedback only.

Allowed areas:

- `lib/features/home/presentation/*`
- `lib/features/generator/presentation/*`
- `lib/features/tools/presentation/*`
- `lib/features/result_viewer/presentation/*`
- `lib/features/library/presentation/*`
- optional `lib/features/profile/presentation/*`
- optional `lib/features/billing/presentation/*`
- selected shared visual widgets.

Forbidden areas:

- `lib/core/api/*`
- `lib/core/network/*`
- `lib/core/database/*`
- `lib/core/storage/*`
- `lib/features/*/data/*`
- `lib/features/*/domain/*`
- `lib/features/auth/*`
- `lib/features/generation_jobs/data/*`
- `lib/app/router/*`
- `pubspec.yaml`
- `android/*`
- `ios/*`
- Drift generated files.

Required scans:

- `flutter analyze`;
- `flutter test`;
- presentation import scan;
- secrets/provider SDK/IAP scan;
- permission/platform diff scan;
- dependency diff scan;
- Drift schema/generated diff check.

Architecture P0 blockers:

- data/domain/core/router/platform changes without approval;
- forbidden presentation imports;
- new packages/assets/permissions;
- live backend/provider SDK/direct AI calls;
- real billing/IAP;
- upload/image-to-image activation.

## Backend/Data Gate

Backend/Data must confirm:

- no API contracts, DTO/domain models, repositories, mock/live data sources, sanitizers, Drift schema, generated DB or secure storage were changed;
- Catalog reads through existing providers/repositories and does not expose provider-internal fields;
- Create/Result/Library preserve create/poll lifecycle, job statuses, asset contract, active job restore and `availableCoins` checks;
- Billing preserves `coinBalance/reservedCoins/availableCoins`, package cache fields, transactions and purchase verification behavior;
- Upload/source/use-as-source remains disabled or placeholder-only;
- no picker/file APIs, platform permissions or signed URL persistence are introduced;
- UI copy does not promise live backend, real payments, real upload, provider integrations, social publishing or guaranteed email delivery.

Data P0 blockers:

- API/schema/storage mutation;
- catalog/generation/billing/upload side effects;
- presentation imports raw data services;
- active/completed/failed job persistence regresses;
- Result/Library lookup regresses.

## QA Gate

QA Release must run:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
```

Additional checks:

- Android debug build;
- provider/secrets/IAP/upload/permission scans;
- presentation import scan.

Redmi 7 setup:

- `adb devices` shows `c7970e16 device`;
- `wm size` shows `720x1520`;
- `wm density` shows `320`;
- fresh APK install;
- `pm clear`;
- login with `creator@allai.market / allai-demo`.

Smoke matrix:

- session restore to Home;
- Home dashboard;
- Create prompt-only generation;
- progress;
- completed Result;
- Library opens the same result;
- Tools filters/reset/no-results;
- unavailable model state;
- Template Detail to Create;
- Result active/completed/failed;
- Pricing/Profile if touched;
- logout and back protection.

QA P0 blockers:

- failing checks;
- no Redmi smoke;
- broken generation/result/library persistence;
- route/back-stack regression;
- clipped critical UI;
- CTA hidden by keyboard;
- staged artifacts/secrets/APK;
- provider/backend/IAP/upload/permission creep.

## Repo Gate

Repo GitHub must review:

- `git status --short -uall`;
- `git diff --cached --name-status`;
- `git diff --cached --stat`;
- `git diff --cached --check`;
- staged scope matches a concrete 7B slice;
- Phase 7B is not mixed with Phase 7A or older Phase 5/6 changes.

Recommended future commit split:

- `docs: plan phase 7b signed-in workflow`;
- `ui: polish signed-in home/create/catalog`;
- `ui: polish result/library/pricing/profile`;
- `test: cover phase 7b signed-in workflow`.

Forbidden staged items:

- `build/`;
- screenshots from `build/`;
- APK/AAB/IPA;
- `.dart_tool/`;
- coverage;
- DB/sqlite/cache files;
- `.env*`;
- keys/certs;
- provider configs;
- `google-services.json`;
- `GoogleService-Info.plist`;
- generated files, `pubspec.yaml`, platform files or assets unless explicitly approved.

Repo P0 blockers:

- `git add .` usage;
- wrong split;
- forbidden artifacts staged;
- checks/scans failing;
- push/PR attempted before explicit approval.

## Task Chat Logic Gate

Task Chat Logic must confirm:

- app-code was changed only by Mobile Implementation;
- other roles stayed review/gate owners;
- no user-facing task-chat, agent roles, prompt-master orchestration, handoff UI or new agent/workflow entities were added;
- result note includes scope, touched files, screenshots/smoke evidence, verification, known blockers and review handoff;
- auth-gated navigation, Create quote/generation, catalog filters, Result Viewer, Library, Pricing, Profile and existing tests remain working.

Next slice can start only when:

- all Phase 7B gates are P0-free;
- QA small-screen/device smoke is accepted;
- Repo confirms safe commit/split state.

## Current Coordinator Decision

This review plan is ready for future Phase 7B implementation. It does not authorize code. Phase 7B implementation remains blocked until Phase 7A is complete and the repo gate is resolved.
