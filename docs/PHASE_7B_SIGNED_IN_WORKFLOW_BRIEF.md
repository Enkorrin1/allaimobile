# Phase 7B Signed-In Workflow Redesign Brief

Date: 2026-07-04.

Status: planning-only. Phase 7B app-code is blocked until Phase 7A is implemented/reviewed and the repo gate is resolved.

## Goal

Redesign the signed-in creative workflow so the app feels like a real mobile AI studio after the polished Welcome/Auth/AppShell experience from Phase 7A.

Phase 7B should improve:

- Home / signed-in entry;
- Create / Generator;
- Tools / Catalog;
- Template Detail;
- Result Viewer;
- Library;
- Profile / Pricing only if needed for consistency.

## Entry Conditions

Phase 7B implementation can start only after:

- Phase 7A is implemented and reviewed with no P0 blockers;
- repo split/dirty-tree gate is resolved;
- Phase 7A design tokens and shared primitives are stable;
- old Phase 5/6/7A dirty hunks are clean, committed or explicitly approved;
- Product, UI UX, Architecture, QA, Repo and Task Chat Logic gates remain aligned.

## Product Scope

P0:

- Home / Studio entry.
- Create / Generator.
- Tools / Catalog.
- Template Detail.
- Active generation progress.
- Result Viewer.
- Library.

P1:

- Profile visual polish.
- Pricing visual polish.
- Extended filters.
- Animations.
- Editor-like controls.
- Deeper personalization.

Recommended first implementation slice:

- Home + Create/Generator + shared creative cards/states.

Reason:

- This is the most common signed-in path and validates Phase 7A tokens/shared primitives on a real workflow before expanding to Catalog, Result and Library.

## Product Acceptance

Home:

- User immediately understands how to create a photo/video, choose a template and open history.
- The screen does not look like an empty dashboard.

Create / Generator:

- Feels like a production workspace, not a placeholder form.
- Prompt, format, model, template, cost and available coins are clear.
- Disabled/upload-soon states do not confuse users.

Catalog / Template Detail:

- Cards make models/templates distinguishable.
- Filters and unavailable states are readable.
- Template Detail clearly explains what will be created and how to start.

Result / Library:

- Result Viewer is media-first and distinguishes active/completed/failed states.
- Library feels like an asset history/gallery, not a debug list.

Forbidden claims/scope:

- no live provider claims;
- no real billing/IAP;
- no upload/image-to-image activation;
- no media permissions;
- no guaranteed quality/speed;
- no production share/download promises.

## UI Direction

Overall:

- Signed-in flow should follow: format -> scenario -> prompt/source -> cost -> result.
- Screens should feel like a compact mobile studio, not a landing page or debug UI.

Home:

- top area: balance plus active job;
- quick entry into `Создать`;
- format/scenario shortcuts;
- recent results.

Create / Generator:

- format selector;
- selected model/template card;
- prompt input;
- source slot as disabled/upload-soon if still out of scope;
- quote/reserve cost;
- sticky or clearly reachable CTA.

Tools / Catalog:

- visual model/template cards;
- filters and search if already available;
- category, preview, cost and availability status;
- clear no-results/reset state.

Template Detail:

- preview;
- what the template creates;
- required inputs;
- model/cost;
- CTA `Использовать шаблон`.

Result Viewer:

- large preview;
- status;
- prompt/settings metadata;
- safe actions;
- strict active/completed/failed separation.

Library:

- media-gallery feel;
- completed thumbnails;
- active progress cards;
- failed retry/refund cards;
- filters if safe.

Profile / Pricing:

- Profile remains a quiet account/settings hub.
- Pricing behaves as balance utility with clear available/reserved coins and disabled packages.

Redmi 7 risks:

- long Russian copy;
- chips/action bars;
- Create keyboard;
- compact card grids;
- bottom nav height.

## Architecture Boundaries

Allowed presentation modules:

- `lib/features/home/presentation/*`
- `lib/features/generator/presentation/*`
- `lib/features/tools/presentation/*`
- `lib/features/result_viewer/presentation/*`
- `lib/features/library/presentation/*`
- selected `lib/features/billing/presentation/*` only for visual pricing polish;
- selected `lib/features/profile/presentation/*` only for visual profile polish.

Allowed shared widgets:

- creative cards;
- model/template cards;
- media preview surfaces;
- generated asset preview;
- cost/quote cards;
- result action bar;
- section headers.

Forbidden modules:

- `lib/core/api`
- `lib/core/network`
- `lib/core/database`
- `lib/core/storage`
- `lib/features/*/data`
- `lib/features/*/domain`
- auth logic/screens unless 7A review asks for follow-up;
- generation job data;
- billing logic;
- router redirects;
- Drift schema/generated files;
- Android/iOS platform files.

Dependency constraints:

- no new packages;
- no new fonts/assets without separate approval;
- no platform permissions;
- no provider SDKs;
- no billing/IAP;
- no live backend URL/config;
- no upload/image-to-image activation.

Presentation import hygiene:

- no `Dio`;
- no `AppDatabase`;
- no `Drift`;
- no `MockAllAiApi`;
- no picker/file APIs;
- no `dart:io`.

## Suggested Implementation Slices

7B-01 Home dashboard:

- signed-in entry;
- active job/recent result summary;
- quick actions into Create and Tools.

7B-02 Create production flow:

- prompt workspace;
- model/template selection surface;
- cost/balance;
- disabled/upload-soon state;
- sticky/reachable CTA.

7B-03 Catalog and template detail:

- Tools filters/cards;
- template/tool detail presentation;
- unavailable/no-results states.

7B-04 Result and Library:

- active/completed/failed Result Viewer;
- Library gallery cards;
- retry/refund visual states.

7B-05 Profile/Pricing polish:

- balance utility;
- packages disabled state;
- account/settings consistency.

7B-06 Tests, scans and Redmi smoke:

- focused widget tests;
- format/analyze/test;
- import/secrets/provider/IAP/permission scans;
- Redmi 7 screenshots.

## QA Planning

Smoke matrix:

- signed-in Home launch;
- Create empty prompt, keyboard, valid prompt and CTA;
- model/template/cost/available coins;
- Tools filters/reset/no-results;
- Template Detail to Create;
- Result active/completed/failed;
- Library empty/active/completed/failed;
- Pricing balance/packages/history;
- Profile/logout/settings routes.

Required screenshots:

- Home;
- Create empty + keyboard + ready CTA;
- Tools filters/no-results;
- Template Detail;
- Result active/completed/failed;
- Library states;
- Pricing/Profile if touched.

Release blockers:

- failing analyze/tests/scans;
- no Redmi 7 smoke;
- broken generation/library/result persistence;
- route/back-stack regressions;
- keyboard hides CTA;
- placeholder actions look active;
- provider/backend/IAP/upload/permission creep;
- staged screenshots/build artifacts/secrets.

## Repo Gate

Phase 7B code must not start before:

- Phase 7A is closed;
- repo gate passes;
- old mixed dirty tree is resolved.

Planning docs can be staged later as a docs-only commit:

```text
docs: plan phase 7b signed-in redesign
```

Future implementation commits should stay split:

- `ui: polish signed-in home/create/catalog`
- `ui: polish result/library/pricing/profile`
- `test: cover phase 7b signed-in workflow`

No `git add .`.

## Role Gate Summary

- Product Lead: planning accepted; first implementation slice should be Home + Create/Generator + shared creative states.
- UI UX: planning accepted with screen-by-screen visual hierarchy and Redmi 7 risks.
- Mobile Architecture: planning accepted as UI-only if presentation boundaries remain intact.
- Mobile Implementation: planning accepted; 7B remains HOLD until 7A and repo gate close.
- QA Release: planning accepted with smoke matrix and release blockers.
- Backend/Data: PASS; 7B can remain UI-only with no API/schema/storage changes.
- Repo GitHub: BLOCKED for code start before 7A/repo gate; planning docs only are safe.
- Task Chat Logic: CONDITIONAL/BLOCKED for implementation; no task-agent scope allowed.

## Current Coordinator Decision

Phase 7B is planning-ready but implementation-blocked. Do not start Phase 7B app-code until Phase 7A is implemented, reviewed and safely separated in git.
