# Phase 7B Implementation File Plan

Date: 2026-07-05.

Status: planning-only. Phase 7B app-code is blocked until Phase 7A is implemented/reviewed and the repo gate is resolved.

## Purpose

This file turns the Phase 7B signed-in workflow task queue into a concrete file-level plan for the future UI code pass.

Phase 7B goal: make the signed-in app feel like a usable mobile AI creative studio while preserving existing mock runtime, routing, persistence, billing and generation behavior.

## Start Preconditions

Phase 7B code can start only after all of these are true:

- Phase 7A is implemented and reviewed with no P0 blockers.
- Repo split/dirty-tree gate is closed.
- Phase 7A tokens, shared primitives and AppShell are stable.
- Coordinator states: `Phase 7B app-code authorized`.
- Fresh `git status --short -uall` is clean or contains only explicitly approved 7B planning docs.
- Mobile Implementation is the sole app-code owner.

Recommended future branch:

- `codex/phase-7b-signed-in-redesign`

## Product Priorities

P0 order:

1. Home dashboard.
2. Create / Generator.
3. Tools / Catalog and Template Detail.
4. Result Viewer and Library.
5. Tests, scans and Redmi 7 smoke.

P1 optional:

- Profile polish.
- Pricing polish.
- Advanced filters.
- Motion/animation.
- Deeper personalization.

Recommended first implementation slice:

- Home + Create / Generator.

Reason:

- Home must route users into the main generation path, and Create must prove the signed-in creative workflow before polishing secondary screens.

## Approved Claims And Copy Boundaries

Allowed claims:

- prompt-first AI photo/video creation;
- templates/scenarios;
- model/category availability;
- coin cost and available balance;
- mock/demo pricing clearly marked as not a real purchase.

Forbidden claims:

- live provider availability;
- real upload/image-to-image;
- real billing/IAP;
- guaranteed generation quality or speed;
- production download/share;
- real media permissions.

Important labels:

- Create CTA: `Создать`
- Template Detail CTA: `Использовать шаблон`
- States should use clear Russian copy for active, completed, failed, unavailable, no-results and disabled actions.

## Slice 7B-01: Home Dashboard

Likely files:

- `lib/features/home/presentation/screens/home_screen.dart`
- optional `lib/shared/widgets/coin_balance_chip.dart`
- optional `lib/shared/widgets/section_header.dart`
- optional `lib/shared/widgets/media_asset_tile.dart`
- optional `lib/shared/widgets/model_card.dart`
- optional `lib/shared/widgets/template_card.dart`

Layout requirements:

- top balance plus active job;
- primary `Создать` entry;
- format cards;
- quick scenarios/templates;
- recent results.

Acceptance:

- signed-in first viewport has a clear next action;
- Home routes users into Create, Tools/Templates and history;
- active job and recent results are readable;
- screen does not feel like an empty dashboard or debug list.

Stop conditions:

- CTA leads to wrong route;
- Home requires router/data/provider changes;
- first viewport becomes text-heavy without product/media feel.

## Slice 7B-02: Create / Generator

Likely files:

- `lib/features/generator/presentation/screens/generator_screen.dart`
- optional `lib/shared/widgets/generation_mode_selector.dart`
- optional `lib/shared/widgets/model_card.dart`
- optional `lib/shared/widgets/template_card.dart`
- optional `lib/shared/widgets/cost_preview_card.dart`
- optional `lib/shared/widgets/upload_placeholder.dart`
- optional `lib/shared/widgets/app_text_field.dart`
- optional `lib/shared/widgets/status_chip.dart`

Layout requirements:

- format-first selector;
- selected model/template card;
- prompt/source area;
- quote/reserve cost;
- available balance;
- disabled reason;
- sticky or clearly reachable CTA.

Acceptance:

- prompt-only generation still works;
- empty prompt stays disabled;
- insufficient balance is visible and blocking;
- upload/source slot remains disabled or clearly `soon`;
- keyboard does not hide prompt, quote or CTA on Redmi 7.

Stop conditions:

- upload/image-to-image becomes active;
- generation starts without visible cost/balance state;
- generation create/poll/retry behavior changes;
- data/repository/domain contracts change.

## Slice 7B-03: Tools / Catalog And Template Detail

Likely files:

- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/screens/tool_detail_screen.dart`
- `lib/features/tools/presentation/screens/template_detail_screen.dart`
- `lib/features/tools/presentation/view_models/catalog_ui_mappers.dart`
- optional `lib/shared/widgets/model_card.dart`
- optional `lib/shared/widgets/template_card.dart`
- optional `lib/shared/widgets/status_chip.dart`

Layout requirements:

- search where already available;
- filters;
- visual model/template cards;
- preview/category/cost/status;
- unavailable reasons;
- clear no-results/reset state;
- Template Detail starts with preview and scenario summary.

Acceptance:

- Catalog reads as AI formats/models, not technical list;
- cards are distinguishable;
- Template Detail explains what will be created;
- CTA is `Использовать шаблон`;
- template detail to Create selection remains correct.

Stop conditions:

- filters are decorative or broken;
- page reads like metadata/debug output;
- `/tools` or `/templates/:id` routes regress;
- catalog data/cache/sanitizer behavior changes.

## Slice 7B-04: Result Viewer And Library

Likely files:

- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`

Layout requirements:

- Result Viewer is media-first;
- active progress state is separate from completed preview;
- failed state has retry/refund clarity;
- metadata sits below preview/actions;
- Library is list-first on Redmi 7;
- Library shows completed thumbnails, active progress cards and failed cards.

Acceptance:

- active jobs do not show completed actions;
- completed results have safe preview/actions;
- failed results preserve retry/refund clarity;
- Library opens the correct Result state;
- restart persistence sanity remains intact.

Stop conditions:

- active/completed/failed states blend together;
- technical exceptions are visible;
- Library remains debug-list-like;
- job polling, asset persistence or result status semantics change.

## Slice 7B-05: Optional Pricing / Profile Polish

Likely files:

- `lib/features/profile/presentation/screens/profile_screen.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- optional `lib/shared/widgets/coin_balance_chip.dart`
- optional `lib/shared/widgets/cost_preview_card.dart`
- optional `lib/shared/widgets/status_chip.dart`

Rules:

- P1 only unless shared UI requires consistency.
- Purchases remain disabled/mock-safe.
- Logout/settings behavior must not change.
- Billing reserve/charge/refund and package cache behavior must not change.

Acceptance:

- Profile remains quiet account/settings hub;
- Pricing clearly separates balance, available coins, reserved coins, packages and history;
- disabled purchases look intentional, not broken.

## Allowed Shared Visual Widgets

Can be touched after ownership is clean:

- `lib/shared/widgets/model_card.dart`
- `lib/shared/widgets/template_card.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `lib/shared/widgets/cost_preview_card.dart`
- `lib/shared/widgets/result_action_bar.dart`
- `lib/shared/widgets/section_header.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/shared/widgets/empty_state.dart`
- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/loading_state.dart`
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_button.dart`

Rules:

- keep APIs backward-compatible;
- do not add required new parameters without defaults;
- do not break Phase 7A Auth/AppShell;
- do not turn shared widgets into screen-specific components.

## Forbidden Files And Changes

Do not touch without separate approval:

- `lib/core/*`
- `lib/app/router/*`
- `lib/features/*/data/*`
- `lib/features/*/domain/*`
- `lib/features/auth/*`
- `lib/features/generation_jobs/data/*`
- `lib/features/generation_jobs/domain/*`
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

## Presentation Boundary Rules

Touched presentation/shared code must not import:

- `Dio`
- `AppDatabase`
- `Drift`
- `MockAllAiApi`
- secure storage
- raw data sources
- `image_picker`
- `file_picker`
- `dart:io`
- provider SDK/payment/IAP libraries.

Screens must read existing providers/controllers and repository states. Do not add local fake business state to paper over layout or data problems.

## Test Plan

Preferred new file:

- `test/phase7b_signed_in_ui_test.dart`

Avoid unless clean or explicitly approved:

- `test/widget_test.dart`

Suggested coverage:

- Home routes to Create/Tools/history.
- Create empty prompt stays disabled.
- Create valid prompt reaches ready CTA.
- Insufficient balance blocks generation.
- Tools filters/reset/no-results work.
- Template Detail CTA selects template and goes to Create.
- Result active/completed/failed states differ.
- Library opens a result.
- Pricing packages remain disabled/mock-safe if touched.

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

- Home.
- Create empty.
- Create with keyboard.
- Create ready CTA.
- Create progress.
- Tools filters/no-results.
- Template Detail.
- Result active.
- Result completed.
- Result failed.
- Library empty.
- Library active.
- Library completed.
- Library failed.
- Pricing/Profile if touched.

Smoke:

- login/session restore to Home;
- Home to Create;
- Create prompt-only job;
- progress to Result;
- Library opens the same result;
- Tools filter/detail;
- Pricing/Profile if touched;
- logout/back protection.

Accessibility and small-screen checks:

- tap targets are at least 48dp;
- contrast is readable;
- icon actions have semantic labels where practical;
- disabled/unavailable states are clear;
- no keyboard traps;
- no horizontal overflow;
- long Russian copy wraps cleanly;
- CTA remains visible or reachable by scroll.

## Repo Expectations

Future commit split:

- `docs: plan phase 7b`
- `ui: signed-in home create catalog`
- `ui: polish result library pricing profile`
- `test: add phase 7b coverage`

Before each future commit:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
```

Do not stage:

- `build/`
- screenshots from `build/`
- APK/AAB/IPA
- `.dart_tool/`
- coverage
- DB/sqlite/cache files
- `.env*`
- signing keys/certs
- provider configs
- generated files unrelated to approved model/schema changes.

## Handoff Evidence

Mobile Implementation must provide:

- changed-file list by ticket;
- confirmation of presentation-only scope;
- test/check output summary;
- import/secret scan summary;
- screenshots/smoke notes for Home/Create/Tools/Result/Library and optional Pricing/Profile;
- known blockers;
- review handoff to Product/UI/Architecture/Data/QA/Repo.

## P0 Stop Conditions

Stop if:

- Phase 7A/repo gate is not closed;
- Phase 7B app-code authorization is missing;
- a forbidden file must be changed;
- data/domain/core/router/platform/dependency changes are needed;
- upload/live/billing/provider behavior is requested;
- enabled no-op critical actions appear;
- tests/analyze/scans fail;
- generation/result/library persistence regresses;
- route/back-stack regresses;
- Redmi 7 has hidden CTA, clipped copy, overflow or unreadable actions.

## Current Coordinator Decision

This file plan is ready for future Phase 7B implementation after Phase 7A and repo gates close. It does not authorize code. Phase 7B remains HOLD.
