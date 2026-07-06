# Phase 7A Repo Split Execution Handoff

Date: 2026-07-04.

Status: dry-run handoff only. No staging, commit, push or app-code edits performed.

## Purpose

This file defines the execution-ready handoff for the repo split that must happen before Phase 7A app-code starts, unless the user explicitly approves working on top of the mixed dirty tree.

## Role Distribution

- Repo GitHub: owns the repo split procedure, staged-file review and stop conditions.
- Mobile Implementation: owns Phase 7A app-code only after repo approval.
- QA Release: owns the pre-code and post-code smoke gates. Latest repo-split readiness status is CONDITIONAL.

## Repo Dry-Run Checklist

Pre-check commands, read-only:

```powershell
git status --short --branch -uall
git diff --name-status
git diff --stat
git diff -- docs/ACTIVE_SPRINT.md docs/README.md test/widget_test.dart
git ls-files | rg -n '(?i)(build|\.dart_tool|\.gradle|Pods|\.apk|\.aab|\.ipa|\.db|\.sqlite|\.jks|\.keystore|key\.properties|google-services\.json|GoogleService-Info\.plist)'
```

Recommended split order:

1. Phase 5 Slice C code: database/package metadata, billing/pricing, tools/studio, catalog mapper, Phase 5 tests and only Phase 5 hunks from `test/widget_test.dart`.
2. Phase 6 Slice A/Stabilization code: mock API, generation jobs, generator/library/result viewer, generated preview/action widgets, Phase 6 tests and only Phase 6 hunks from `test/widget_test.dart`.
3. Phase 5/6 docs: `docs/PHASE_5_*`, `docs/PHASE_6_*`, plus matching hunks from `docs/ACTIVE_SPRINT.md` and `docs/README.md` or a separate docs rollup commit.
4. Phase 7/7A docs: `docs/PHASE_7_*`, `docs/PHASE_7A_*`, including baseline, decision and split docs.

Before each commit, after manual staging:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
git diff --cached -- docs/ACTIVE_SPRINT.md docs/README.md test/widget_test.dart
```

For code commits, additionally:

```powershell
D:\flutter\bin\dart.bat format --output=none --set-exit-if-changed <touched-dart-files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
```

After each commit, if approval is given:

```powershell
git status --short -uall
git log -1 --oneline --name-status
git diff --name-status
```

The remaining dirty scope must belong only to the next split group.

## Stop Conditions

Stop the split immediately if:

- `build/`, `.dart_tool/`, APK, DB/cache, secrets/env/key/provider config are staged.
- `git add .` is used.
- staged scope is wider than the current split group.
- `docs/ACTIVE_SPRINT.md`, `docs/README.md` or `test/widget_test.dart` are staged whole-file without hunk review.
- code commits contain Phase 7 docs or docs commits contain app-code changes.
- Flutter checks fail.
- Drift generated output does not match schema changes.
- `pubspec.yaml`, platform permission files, provider SDK markers or IAP markers appear without separate approval.

## Mobile Implementation Handoff

Expected state after repo split:

- working tree is clean, or dirty only with explicitly agreed Phase 7/7A docs;
- Phase 5/6 code and tests are separately committed or removed from the current diff;
- `build/`, caches, APK/screenshots, secrets and platform permission files are neither staged nor part of Phase 7A dirty scope;
- no unresolved mixed hunks remain in `test/widget_test.dart`, `docs/ACTIVE_SPRINT.md` or `docs/README.md`.

Branch and commit assumptions:

- work can continue on the currently agreed branch after repo approval;
- commit and push still require separate user command;
- future Phase 7A staging must use explicit files, not `git add .`.

First implementation task after approval:

1. design foundation: `app_colors`, `app_spacing`, `app_typography`, `app_theme`;
2. API-compatible shared primitives: `AppButton`, `AppCard`, `AppTextField`, `StatusChip`;
3. `AppShell` bottom navigation;
4. Welcome;
5. Login, Register and Password Reset;
6. minimal widget tests and scans.

Implementation remains blocked by:

- mixed Phase 5/6/7 app-code in the dirty tree;
- no explicit repo approval or no explicit mixed-tree approval;
- new backend/provider SDK, billing/IAP, upload, permissions, Drift/schema, dependency or asset scope;
- removing Mobile Implementation as the sole Phase 7A app-code owner.

## QA Pre-Code Gate

QA gate is ready, but Phase 7A app-code can start only after actual repo split or explicit mixed-tree approval and the confirmations below.

Required after repo split:

- Repo GitHub confirms Phase 5/6/7 docs and code were split, `build/`, screenshots, APK, secrets, platform permissions and generated DB are not staged, and `git add .` was not used.
- Device baseline remains available: `adb devices` shows `c7970e16 device`, `wm size` is `720x1520`, and `wm density` is `320`.
- Current app launch can be confirmed with `com.allai.allai_mobile/.MainActivity`.
- Baseline screenshots remain available and unstaged.
- Pre-code verification has no red flags: `flutter analyze`, `flutter test`, provider/secret/IAP/upload/permission scans.

QA should block implementation if:

- repo split is incomplete or explicit approval is missing;
- `build/`, screenshots, APK, secrets, keystore, `.env` or platform permission files are staged;
- Redmi 7 is not visible through ADB or baseline screenshot evidence is missing/unusable;
- the current app build cannot launch before UI changes;
- any live backend/provider/billing/upload/permission creep appears before Phase 7A code.

## Current Coordinator Decision

Do not start Phase 7A app-code yet. The next executable step still requires explicit user approval for repo split without push, or explicit approval to work on top of the mixed dirty tree.
