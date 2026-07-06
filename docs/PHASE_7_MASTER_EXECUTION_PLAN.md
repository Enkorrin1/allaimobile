# Phase 7 Master Execution Plan

Date: 2026-07-05.

Status: planning-only. This plan connects repo unblock, Phase 7A, Phase 7B and Phase 7C. It does not authorize git actions or app-code work.

## Purpose

Phase 7 is the mobile UI/UX overhaul path from the current mixed dirty tree to release-ready polish.

This plan defines the top-level execution sequence, phase gates, ownership, evidence and stop conditions.

## Master Sequence

1. Repo unblock / safe split.
2. Phase 7A: first impression, auth and app shell foundation.
3. Phase 7A review and QA fixes.
4. Phase 7B: signed-in creative workflow.
5. Phase 7B review and QA fixes.
6. Phase 7C: final release polish.
7. Final QA/repo release-readiness gate.

Do not start Phase 7B before Phase 7A is PASS or CONDITIONAL with no P0 blockers.

Do not start Phase 7C before Phase 7B is PASS or CONDITIONAL with no P0 blockers.

## Ownership

- Repo GitHub: repo-unblock/split guidance, staged review and push/PR policy.
- Mobile Implementation: only app-code owner for 7A, 7B and 7C.
- Product Lead: product claims, priorities and sign-off.
- UI UX: screen hierarchy, consistency and small-screen visual gates.
- Mobile Architecture: boundaries, imports, dependencies and behavior preservation.
- Backend/Data: data invariants and no backend/schema/storage regressions.
- QA Release: checks, Redmi evidence and PASS/CONDITIONAL/BLOCKED gates.
- Task Chat Logic: ownership and handoff discipline.

## Approval Rules

Explicit user approval is required for:

- repo split/staging/commit;
- push or PR;
- working on a mixed dirty tree;
- expanding scope into backend/provider/billing/upload/platform/dependency work.

General instructions like `continue` or `do the next step` are not approval for staging, commit, push or mixed-tree app-code work.

## Repo Unblock Gate

Required before app-code:

- explicit user approval for repo split, or explicit mixed-tree implementation approval;
- no `git add .`;
- no forbidden artifacts or secrets staged;
- split groups follow Phase 5 code, Phase 6 code, Phase 5/6 docs and Phase 7 planning docs;
- `git diff --cached --name-status`, `git diff --cached --stat` and `git diff --cached --check` before every future commit.

Recommended repo-unblock branch:

- `codex/repo-unblock-phase-7`

Repo PASS:

- split is clean;
- checks/scans pass;
- remaining dirty tree is empty or explicitly documented.

Repo BLOCKED:

- missing approval;
- mixed hunks unresolved;
- `git add .`;
- forbidden artifacts/secrets staged;
- failing checks;
- push/PR attempted without explicit approval.

## Branch Strategy

Recommended branches:

- repo unblock: `codex/repo-unblock-phase-7`
- Phase 7A: `codex/phase-7a-ui-foundation`
- Phase 7B: `codex/phase-7b-signed-in-redesign`
- Phase 7C: `codex/phase-7c-release-polish`

Push policy:

- no push to `main`;
- no push or PR without explicit user approval;
- draft PR preferred over direct main push after local commits, checks and QA evidence are ready.

## Phase 7A Gate

Scope:

- theme/tokens;
- shared UI primitives;
- AppShell/bottom navigation;
- Welcome/Login/Register/Password Reset;
- focused auth/shell tests;
- Redmi Auth/Shell smoke.

Allowed:

- `lib/app/theme/*`
- `lib/app/shell/app_shell.dart`
- selected shared UI primitives
- auth presentation screens
- `test/phase7a_auth_shell_test.dart`

Forbidden:

- router redirects/routes;
- auth data/domain/providers;
- core/database/API/storage;
- generation/billing/upload/platform/dependency files.

7A PASS:

- Welcome/Auth/AppShell feel polished;
- auth/session/logout/back behavior unchanged;
- keyboard-safe forms;
- bottom nav readable on Redmi 7;
- analyze/test/scans pass;
- Redmi screenshots available.

7A BLOCKED:

- broken auth/session/router;
- clipped critical auth copy or CTA;
- hidden keyboard CTA/errors;
- forbidden files touched;
- provider/billing/upload/permission creep.

## Phase 7B Gate

Scope:

- Home;
- Create/Generator;
- Tools/Catalog;
- Template Detail;
- Result Viewer;
- Library;
- optional Profile/Pricing visual polish;
- signed-in workflow tests;
- Redmi signed-in workflow smoke.

Allowed:

- signed-in presentation modules;
- shared visual widgets;
- presentation-only mappers/copy helpers.

Forbidden:

- core/data/domain/router/platform/dependency changes;
- provider SDKs;
- real billing/IAP;
- upload/image-to-image activation;
- fake local business state replacing provider/repository state.

7B PASS:

- Home routes into primary workflow;
- Create prompt-only flow works;
- Tools/Template Detail route correctly;
- Result/Library active/completed/failed states work and persist;
- Pricing/Profile remain honest if touched;
- analyze/test/scans and Redmi smoke pass.

7B BLOCKED:

- broken generation/result/library persistence;
- route/back-stack regression;
- upload or real provider appears active;
- insufficient-balance or unavailable states are misleading;
- data contracts change.

## Phase 7C Gate

Scope:

- small-screen/accessibility;
- state polish;
- Russian copy cleanup;
- visual consistency;
- QA bugfix pass;
- release verification.

Allowed:

- UI-only polish in theme/shared widgets and touched screens;
- semantics labels;
- state visuals;
- presentation copy.

Forbidden:

- feature expansion;
- state ownership changes;
- provider/repository contracts;
- schema/storage/router/platform/dependency changes;
- live provider/billing/upload activation.

7C PASS:

- no open P0 release blockers;
- app is coherent across Welcome/Auth/Home/Create/Catalog/Result/Library/Pricing/Profile;
- critical CTAs are reachable;
- no clipped copy or raw technical errors;
- Redmi screenshots and walkthrough video exist;
- checks/scans pass.

7C BLOCKED:

- accessibility P0;
- clipped critical copy;
- broken auth/navigation/generation/persistence;
- misleading mock/live/billing/upload claims;
- no Redmi evidence;
- failing checks/scans.

## Shared Verification Bundle

Every implementation phase must hand off:

- scope summary;
- touched-file list;
- command result summary;
- `flutter analyze`;
- `flutter test`;
- format result for touched Dart files;
- presentation import scan;
- secrets/provider/IAP/upload/permission scan;
- Android debug build if smoke requires APK;
- Redmi screenshots/smoke notes;
- known blockers;
- reviewer handoff list.

Common commands:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched Dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

## Redmi Evidence

Device target:

- serial `c7970e16`;
- size `720x1520`;
- density `320`.

Required evidence grows by phase:

- 7A: Welcome/Auth/AppShell screenshots.
- 7B: signed-in workflow screenshots for Home/Create/Tools/Result/Library.
- 7C: full release screenshot pack plus continuous walkthrough video: login -> Home -> Create -> Result -> Library -> logout.

## Backend/Data Invariants

These must remain unchanged across all Phase 7 slices:

- login/register/reset/logout/session restore;
- legal consent and `18+`;
- protected routing;
- secure token storage;
- catalog sanitizer/cache/public fields;
- generation create/poll lifecycle;
- job statuses;
- asset contract;
- active job restore;
- Result/Library lookup;
- no signed URL persistence;
- `availableCoins = coinBalance - reservedCoins`;
- package metadata cache;
- transaction history;
- insufficient-balance blocking;
- reserve/charge/refund/no-charge semantics.

## P0 Release Blockers

Any of these blocks release readiness:

- broken auth/navigation/generation/result/library flow;
- clipped or overlapping critical text;
- CTA offscreen or hidden by keyboard;
- inaccessible tap targets;
- unreadable contrast;
- silent no-op critical actions;
- misleading live/provider/upload/billing claims;
- active/failed/completed states confused;
- raw exception/debug/mojibake text visible;
- failing analyze/tests/scans/build;
- no Redmi evidence;
- staged artifacts/secrets/APK;
- provider/backend/IAP/upload/permission creep.

## Decision States

`PASS`:

- repo/QA/role gates are clean;
- no P0 blockers;
- required evidence exists;
- next slice may start.

`CONDITIONAL`:

- planning/review is acceptable or implementation has only P1/P2 cosmetic issues;
- checks are green;
- no P0 remains;
- code remains HOLD if the condition is repo approval.

`BLOCKED`:

- missing approval;
- unsafe repo state;
- P0 regression;
- ownership violation;
- forbidden scope creep;
- failed checks/scans;
- missing required evidence.

## Current Coordinator Decision

The Phase 7 master execution plan is ready as planning. It does not authorize repo split, commit, push or app-code. The next unblocking decision remains explicit user approval for repo split without push, or explicit approval to work on the mixed dirty tree.
