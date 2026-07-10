# Phase 2 Execution Brief

Date: 2026-07-02.

Phase: Design System And Static UI.

Status: execution started.

## Goal

Build a demoable Flutter static/mock UI for AllAi Mobile App before backend integration.

The app must feel like a mobile creative workstation, not a landing page.

## Implementation Scope

Build static/mock screens for:

- Home dashboard.
- Create/Generator composer.
- Tools/Catalog.
- Model or tool detail.
- Template detail.
- Library/history.
- Result Viewer.
- Pricing/coins.
- Profile/settings.
- Studio templates/drafts.

Keep Auth as static placeholders for now.

## Main Demo Flow

1. Open Home.
2. See balance, active job, quick templates, recent generations.
3. Open Create.
4. Pick generation mode.
5. See prompt field, model selector, upload placeholder, settings, and cost preview.
6. Open a result mock.
7. Return to Library/history.
8. Open Pricing/Profile.

## P0 Generation Modes

- Photo.
- Video.
- Upscale.
- Avatars.
- Motion.

All modes are static/mock in Phase 2. Do not add real provider SDKs, provider keys, or live AI calls.

## P0 Templates

Show these first:

- Product UGC Hook.
- Social Hook Cut.
- Try-On.
- Unboxing.
- Beauty Hook.
- UGC.

Optional demo template:

- Cinema.

## Mock Pricing Copy

Use RU-first copy:

- `Баланс: 1 250 койнов`.
- `Стоимость: от 80 койнов`.
- `Койны зарезервируются при запуске. При сбое генерации мы вернем их автоматически.`
- `Недостаточно койнов для этой генерации`.
- `Пополнить баланс`.
- `Пакеты показаны для демо. Реальные покупки будут подключены после решения по App Store / Google Play.`

Mock packages:

- Start: `1 000 койнов`.
- Creator: `5 000 койнов`.
- Pro: `12 000 койнов`.
- Studio: `30 000 койнов`.

## Architecture Rules

- Keep feature boundaries clear.
- Add separate features for tools/catalog, billing, result viewer, and generation jobs if needed.
- Do not turn `generator` into a catch-all feature.
- Keep fixtures outside widgets and screens.
- Use explicit `Demo` or `Fixture` naming for static values.
- Do not introduce Dio calls, Drift persistence, real auth, real billing, or polling in Phase 2.
- Riverpod providers may expose static lists/state only.
- Add named route constants before adding many secondary routes.
- Do not hardcode real provider ids, real prices, purchase ids, API endpoints, moderation rules, or billing behavior as product truth.

## Suggested Fixture Placement

Prefer feature-level presentation fixtures:

```text
lib/features/generator/presentation/fixtures/
lib/features/tools/presentation/fixtures/
lib/features/library/presentation/fixtures/
lib/features/billing/presentation/fixtures/
lib/features/result_viewer/presentation/fixtures/
```

Shared fixtures are allowed only when multiple features truly use them.

## Shared Components To Build

- `SectionHeader`.
- `AppCard`.
- `CoinBalanceChip`.
- `GenerationModeSelector`.
- `ModelCard`.
- `TemplateCard`.
- `MediaAssetTile`.
- `CostPreviewCard`.
- `UploadPlaceholder`.
- `LoadingState`.
- `ErrorState`.
- `ResultActionBar`.

Reuse and improve existing:

- `AppButton`.
- `AppTextField`.
- `EmptyState`.
- `PlaceholderCard`.
- `StatusChip`.
- `AppShell`.

## Routes To Add

Keep existing:

- `/`
- `/create`
- `/library`
- `/studio`
- `/profile`
- `/welcome`
- `/login`

Add static secondary routes:

- `/tools`
- `/tools/:toolId`
- `/templates/:templateId`
- `/result/:assetId`
- `/pricing`
- `/settings`

Generation status route is optional for this pass:

- `/generation/status/:jobId`

## QA Gate

Phase 2 cannot close unless:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .` passes.
- `D:\flutter\bin\flutter.bat analyze` passes.
- `D:\flutter\bin\flutter.bat test` passes.
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug` passes.
- App has no blank screens in primary routes.
- Main tabs work.
- Secondary routes work.
- Create prompt remains usable with keyboard.
- Small-screen layout has no text/button overlap.
- No secrets, real provider SDKs, or production billing logic are added.

## Role Execution

Mobile Implementation owns code changes.

UI UX, Product Lead, Backend Data, Mobile Architecture, and QA Release support with review notes, decisions, data constraints, guardrails, and verification.

Only Mobile Implementation should edit app code during this pass unless the coordinator explicitly assigns another edit task.
