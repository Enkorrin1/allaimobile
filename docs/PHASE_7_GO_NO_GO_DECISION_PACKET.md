# Phase 7 Go/No-Go Decision Packet

Date: 2026-07-06.

Status: planning-only. This packet does not authorize staging, commit, push or app-code.

## Purpose

All Phase 7 planning artifacts are ready:

- repo-unblock plan;
- split file map;
- split execution runbook;
- Phase 7 master execution plan;
- Phase 7A, 7B and 7C file plans.

The project is now blocked on an explicit user decision about how to handle the mixed dirty tree.

## Role Consensus

All reviewed roles agree:

- GO for repo-unblock split after explicit approval.
- NO-GO for Phase 7 app-code until repo/dirty-tree gate is resolved.
- GO for Phase 7A only after repo split is complete or the user explicitly accepts mixed-tree risk.
- 7B and 7C remain blocked until prior phase gates are P0-free.

## Decision Options

### Option 1: Approve Repo Split Without Push

Recommendation: preferred.

What it enables:

- create/switch to `codex/repo-unblock-phase-7`;
- run read-only preflight;
- stage only explicit paths or reviewed patch hunks;
- make local commits for approved split groups;
- run local checks/scans;
- report commit hashes, status and blockers.

What it does not enable:

- push;
- pull request;
- direct commit to `main`;
- `git add .`;
- destructive reset/checkout;
- new app-code;
- provider/backend/billing/upload/platform/dependency changes.

Why this is preferred:

- separates Phase 5, Phase 6 and Phase 7 history;
- makes Phase 7A review clean;
- reduces accidental artifact/secrets staging risk;
- improves rollback and regression attribution.

### Option 2: Approve Phase 7 Work On Mixed Dirty Tree

Recommendation: possible but not preferred.

What it enables:

- Phase 7A app-code may start without full split;
- Mobile Implementation must touch only the allowed Phase 7A file set;
- no broad formatting/refactor;
- no commit/push unless separately approved.

Risks:

- difficult regression attribution;
- mixed Phase 5/6/7 hunks in shared widgets/tests/docs;
- harder rollback;
- higher risk of accidentally staging build artifacts, generated files or unrelated changes;
- Product/QA acceptance evidence becomes noisier.

### Option 3: Continue Planning Only

Recommendation: safe but blocks visible progress.

What it enables:

- more documentation, checklists and review planning.

Risk:

- UI implementation remains stalled;
- current rough MVP design remains unchanged.

## Recommended Approval Wording

Use this if you want the recommended path:

```text
Разрешаю выполнить repo-unblock split без push: при необходимости создать ветку `codex/repo-unblock-phase-7`, stage только явными путями/patch hunks, сделать отдельные commits для Phase 5 Slice C code, Phase 6 Slice A/Stabilization code, Phase 5/6 docs и Phase 7/7A/7B/7C planning docs. Не использовать `git add .`; build/cache/secrets/APK исключить.
```

Push requires a separate explicit instruction.

Phase 7A app-code requires a separate explicit handoff after split, for example:

```text
Phase 7A app-code authorized.
```

## Planned Repo Split Order

1. Phase 5 Slice C code.
2. Phase 6 Slice A/Stabilization code.
3. Phase 5/6 docs.
4. Phase 7/7A/7B/7C planning docs.

Before every future commit:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
```

After split:

- report local commit hashes;
- report `git status --short -uall`;
- report checks/scans;
- request separate approval for Phase 7A app-code or push/PR.

## Key Risks To Watch

Mixed hunk files:

- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`
- `test/widget_test.dart`

Shared widget ownership risks:

- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`

Generated-file risk:

- `lib/core/database/app_database.g.dart` must stay paired with `lib/core/database/app_database.dart` and only in the approved data commit.

## Required Checks After Approval

For code commit groups:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched Dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

Repo checks:

- no `git add .`;
- no staged `build/`;
- no staged screenshots/APK/AAB/IPA;
- no staged `.dart_tool/`, coverage, DB/sqlite/cache;
- no staged `.env*`, secrets, signing keys or provider configs;
- no unapproved platform permission/dependency changes.

QA evidence after split:

- clean or expected dirty tree;
- checks/scans green;
- Redmi baseline still available and ignored;
- no mixed hunks left in staged commits.

## Backend/Data Invariants

These must remain unchanged when Phase 7 app-code eventually starts:

- auth restore/logout/legal flow;
- protected routing;
- catalog public-field cache;
- generation create/poll/job statuses/assets;
- Result/Library lookup;
- no signed URL persistence;
- `availableCoins = coinBalance - reservedCoins`;
- reserve/charge/refund semantics;
- package cache and transaction history.

## P0 Blockers

Any of these blocks GO:

- no explicit approval;
- mixed dirty tree remains unresolved;
- ambiguous hunk split;
- `git add .`;
- forbidden artifacts/secrets staged;
- failed analyze/tests/scans;
- data/schema/storage/generated DB/backend/provider/billing/upload/permission change;
- live provider/billing/upload scope creep;
- missing Redmi evidence when required;
- Phase 7 app-code starts before repo/dirty-tree decision.

## Current Coordinator Decision

Current status:

- GO: repo-unblock split planning is ready.
- NO-GO: Phase 7 app-code.
- Required next action: explicit user approval for repo split without push, explicit approval to work on the mixed tree, or decision to remain planning-only.
