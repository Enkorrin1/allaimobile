# Phase 7B Implementation Task Queue

Date: 2026-07-05.

Status: planning-only. Phase 7B app-code is BLOCKED until Phase 7A is implemented/reviewed and the repo gate is resolved.

## Goal

Prepare implementation tickets for the signed-in creative workflow redesign after Phase 7A establishes the design foundation, auth screens and app shell.

Phase 7B covers:

- Home dashboard;
- Create / Generator production flow;
- Tools / Catalog and Template Detail;
- Result Viewer and Library media history;
- Profile / Pricing only if needed for visual consistency;
- tests, scans and Redmi 7 smoke.

## Global Dependencies

Phase 7B implementation can start only after:

- Phase 7A app-code is complete;
- Phase 7A review gates have no P0 blockers;
- repo split/dirty-tree gate is resolved;
- Phase 7A tokens, shared primitives and AppShell are stable;
- old Phase 5/6/7A dirty hunks are clean, committed or explicitly approved.

## Global Rules

- Mobile Implementation is the only future app-code owner.
- Product, UI UX, Architecture, QA, Backend/Data, Repo and Task Chat Logic remain review/gate owners.
- Phase 7B must remain UI/presentation-only unless a separate gate expands scope.
- Do not activate upload/image-to-image.
- Do not add media permissions.
- Do not add live backend URLs, provider SDKs, direct AI provider calls, real billing/IAP, dependencies, fonts or binary assets.
- Do not touch API/schema/storage/auth/session/router behavior.

## Ticket 7B-01: Home Dashboard

Priority: P0.

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, Mobile Architecture, QA Release.

Likely touch files:

- `lib/features/home/presentation/screens/home_screen.dart`
- possible shared widgets:
  - `lib/shared/widgets/coin_balance_chip.dart`
  - `lib/shared/widgets/section_header.dart`
  - `lib/shared/widgets/media_asset_tile.dart`
  - `lib/shared/widgets/model_card.dart`
  - `lib/shared/widgets/template_card.dart`

Acceptance:

- signed-in Home immediately guides users to Create, Tools/Templates and history;
- balance and active job are readable;
- quick scenarios/templates feel like creative entry points;
- recent results are visible when available;
- screen does not look like an empty dashboard or debug list.

Fail conditions:

- CTA leads to the wrong route;
- first viewport is text-heavy without media/product feel;
- providers, data, router or billing/catalog/library logic are changed.

## Ticket 7B-02: Create / Generator Production Flow

Priority: P0.

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, Mobile Architecture, QA Release, Backend/Data.

Likely touch files:

- `lib/features/generator/presentation/screens/generator_screen.dart`
- possible shared widgets:
  - `lib/shared/widgets/generation_mode_selector.dart`
  - `lib/shared/widgets/model_card.dart`
  - `lib/shared/widgets/template_card.dart`
  - `lib/shared/widgets/cost_preview_card.dart`
  - `lib/shared/widgets/upload_placeholder.dart`
  - `lib/shared/widgets/app_text_field.dart`
  - `lib/shared/widgets/status_chip.dart`

Acceptance:

- flow is format-first and production-like;
- selected model/template is clear;
- prompt/source slot, quote/reserve cost, available coins and disabled reason are visible near the CTA;
- prompt-only generation still works;
- empty prompt remains disabled;
- keyboard does not hide prompt, quote or CTA on Redmi 7.

Fail conditions:

- upload/image-to-image becomes active;
- generation starts without visible cost/available state;
- prompt-only path, balance blocking, active job polling or retry behavior regresses;
- generation data/repository/domain contracts are changed.

## Ticket 7B-03: Tools / Catalog And Template Detail

Priority: P0.

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, Mobile Architecture, QA Release, Backend/Data.

Likely touch files:

- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/screens/tool_detail_screen.dart`
- `lib/features/tools/presentation/screens/template_detail_screen.dart`
- `lib/features/tools/presentation/view_models/catalog_ui_mappers.dart`
- possible shared widgets:
  - `lib/shared/widgets/model_card.dart`
  - `lib/shared/widgets/template_card.dart`
  - `lib/shared/widgets/status_chip.dart`

Acceptance:

- Catalog reads as visual AI formats/models, not a technical list;
- filters, reset and no-results states are clear;
- unavailable models are visibly unavailable;
- cards show preview/category/cost/status where available;
- Template Detail starts with preview, explains what will be created and has CTA `Использовать шаблон`;
- template detail to Create selection remains correct.

Fail conditions:

- filters feel decorative or do not affect content;
- cards are indistinguishable;
- detail page reads like metadata/debug output;
- `/tools` or `/templates/:id` routes regress;
- catalog repository/domain/cache/sanitizer behavior changes.

## Ticket 7B-04: Result Viewer And Library Media History

Priority: P0.

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, Mobile Architecture, QA Release, Backend/Data.

Likely touch files:

- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- shared widgets:
  - `lib/shared/widgets/generated_asset_preview.dart`
  - `lib/shared/widgets/media_asset_tile.dart`
  - `lib/shared/widgets/result_action_bar.dart`

Acceptance:

- Result Viewer is media-first;
- active, completed and failed states are visually distinct;
- active jobs do not show completed-result actions;
- completed results have safe preview and actions;
- failed results preserve retry/refund clarity;
- Library feels like media history/gallery;
- Library cards open the correct Result state;
- restart persistence sanity remains intact.

Fail conditions:

- active job shows completed actions;
- technical exceptions or decompression errors are visible;
- placeholder dominates the result;
- Library remains a debug list;
- job polling, Library repository boundary, asset persistence schema or result status semantics change.

## Ticket 7B-05: Profile / Pricing Polish

Priority: P1 / optional.

Owner: Mobile Implementation.

Reviewers: Product Lead, UI UX, Mobile Architecture, QA Release, Backend/Data.

Likely touch files:

- `lib/features/profile/presentation/screens/profile_screen.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- possible shared widgets:
  - `lib/shared/widgets/coin_balance_chip.dart`
  - `lib/shared/widgets/cost_preview_card.dart`
  - `lib/shared/widgets/status_chip.dart`

Acceptance:

- Profile remains a quiet account/settings hub;
- Pricing clearly explains balance, available coins, reserved coins, packages and history;
- disabled purchases look intentional and mock-safe;
- logout/settings routes remain intact.

Fail conditions:

- real billing/IAP is activated;
- purchases look broken or scary;
- logout/session behavior regresses;
- billing reserve/charge/refund or package cache behavior changes.

## Ticket 7B-06: Tests, Scans And Redmi 7 Smoke

Priority: mandatory release gate.

Owner: QA Release.

Support: Mobile Implementation.

Preferred tests:

- new focused files such as `test/phase7b_signed_in_ui_test.dart`;
- use `test/widget_test.dart` only after the existing mixed hunks are clean or explicitly approved.

Verification commands:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

Smoke matrix:

- login/session restore to Home;
- Home empty/active states;
- Create empty prompt, keyboard, ready CTA and progress;
- Tools filters/reset/no-results;
- Template Detail to Create;
- Result active/completed/failed;
- Library empty/active/completed/failed;
- Pricing/Profile if touched;
- logout and back protection.

Required screenshots:

- Home empty/active;
- Create empty;
- Create with keyboard;
- Create ready CTA;
- Create progress;
- Tools filtered/no-results;
- Template Detail;
- Result active/completed/failed;
- Library states;
- Pricing/Profile if touched.

Release blockers:

- Phase 7A/repo gate not closed;
- failing format/analyze/tests/scans;
- no Redmi 7 smoke;
- broken routes/back stack;
- broken generation/library/result persistence;
- CTA hidden by keyboard;
- clipped Russian copy;
- provider/backend/IAP/upload/permission creep;
- staged build outputs, screenshots, APKs or secrets.

## Role Review Result

- Product Lead: accepted P0/P1 priority; recommended 7B-01 + 7B-02 as the first implementation path.
- UI UX: accepted ticket order and visual acceptance; highlighted Redmi 7 overflow/keyboard/card risks.
- Mobile Architecture: accepted order and presentation-only boundaries; listed allowed and forbidden modules/imports.
- Mobile Implementation: accepted likely touch files, dependencies and blockers; confirmed app-code HOLD.
- QA Release: accepted smoke matrix, screenshots and release blockers; confirmed planning-only/BLOCKED status.

## Current Coordinator Decision

Phase 7B task queue is ready for future implementation, but it does not unlock code. Start with 7B-01 Home and 7B-02 Create only after Phase 7A is complete, reviewed and safely separated in git.
