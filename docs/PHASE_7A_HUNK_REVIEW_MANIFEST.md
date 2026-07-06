# Phase 7A Hunk Review Manifest

Date: 2026-07-04.

Status: read-only diff review. No staging, commit, push or app-code edits performed.

## Purpose

This file documents the files that must not be staged as whole-file during the repo split before Phase 7A implementation. It is based on read-only diffs of the mixed dirty tree.

## Must Not Stage Whole-File

These files mix multiple phases and require hunk review or an explicit rollup commit:

- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`
- `test/widget_test.dart`

## Docs Rollup Files

### `docs/ACTIVE_SPRINT.md`

Observed diff:

- adds Phase 5 Slice B/C result, review and QA closure history;
- adds Phase 6 planning, Slice A, stabilization and Slice B planning/contract history;
- adds Phase 7 and Phase 7A planning, baseline, decision, repo split and exact split status;
- updates sprint status from Phase 5 Slice B to Phase 7 UI/UX overhaul;
- updates coordinator action list from item 22 through item 78.

Recommended handling:

- If strict split is required, stage Phase 5/6/7 hunks separately.
- If that is too noisy, create a separate docs-rollup commit after code commits.
- Do not include this file in a Phase 5 or Phase 6 code commit as whole-file.

### `docs/README.md`

Observed diff:

- adds doc index entries for Phase 5 Slice B/C;
- adds Phase 6 planning, Slice A, stabilization and Slice B docs;
- adds Phase 7 and Phase 7A docs, including decision packet, execution handoff and exact split manifest.

Recommended handling:

- Prefer docs-rollup commit after code commits.
- If split strictly, stage Phase 5/6/7 index hunks separately.
- Do not include whole-file in code commits.

## Mixed Test File

### `test/widget_test.dart`

Observed Phase 5 hunks:

- pricing copy changed from `Стоимость: от 80 койнов` to `Стоимость: 80 койнов`;
- Tools category filter test added;
- low-balance billing helper added;
- insufficient balance test checks `Недостаточно койнов: нужно 80, доступно 10`;
- some Studio RU-copy assertions updated.

Observed Phase 6 hunks:

- generation imports added;
- optional database and generation polling overrides added to the test harness;
- empty-prompt validation test added;
- failed image job retry/refund test added;
- create/run/result viewer test switched from demo result to real mock generation flow;
- generated preview assertion added;
- snackbar feedback assertion added for save;
- active result route test added;
- back-from-result flow switched to prompt generation.

Recommended handling:

- Stage only Phase 5 hunks with the Phase 5 Slice C code commit.
- Stage only Phase 6 hunks with the Phase 6 Slice A/Stabilization code commit.
- Avoid adding Phase 7A tests to this file until Phase 5/6 hunks are committed or explicitly approved.
- Prefer a new `test/phase7a_auth_shell_test.dart` for Phase 7A auth/shell coverage after repo approval.

## Shared Widget Review

### `lib/shared/widgets/error_state.dart`

Observed diff:

- adds configurable `actionLabel` and `actionIcon`;
- keeps retry action default compatible with existing `Повторить` and refresh icon behavior.

Likely split group:

- Phase 5 Slice C code.

Review note:

- Safe only if usages remain compatible and defaults preserve old behavior.

### `lib/shared/widgets/status_chip.dart`

Observed diff:

- adds `selected` and `onPressed`;
- renders `FilterChip` when interactive;
- adjusts selected colors and borders.

Likely split group:

- Phase 5 Slice C code.

Phase 7A risk:

- `status_chip.dart` is also in the expected Phase 7A touch set, so Phase 7A must not edit it until this Phase 5 hunk is committed or explicitly approved as mixed-tree work.

### `lib/shared/widgets/media_asset_tile.dart`

Observed diff:

- adds optional `preview`;
- renders preview instead of icon when available;
- expands failed-status icon detection.

Likely split group:

- Phase 6 Slice A/Stabilization code.

Review note:

- The mojibake `РћС€РёР±РєР°` fallback should be treated as an existing encoding compatibility patch, not new Phase 7A UI text.

### `lib/shared/widgets/result_action_bar.dart`

Observed diff:

- adds snackbar feedback for save/share/repeat;
- replaces unavailable edit/improve actions with disabled soon states;
- adds enabled/disabled support inside the private chip.

Likely split group:

- Phase 6 Slice A/Stabilization code.

Review note:

- This is Result Viewer stabilization scope, not Phase 7A auth/shell scope.

## Commit Strategy

Recommended safest path:

1. Commit Phase 5 Slice C code with Phase 5 hunks only.
2. Commit Phase 6 Slice A/Stabilization code with Phase 6 hunks only.
3. Prefer a docs-rollup commit for `docs/ACTIVE_SPRINT.md` and `docs/README.md` if strict hunk staging is too noisy.
4. Commit Phase 7/7A planning docs.
5. Start Phase 7A implementation only after the split is clean or explicit mixed-tree approval is given.

Repo recommendation:

- Do not over-optimize docs hunk splitting if it becomes brittle.
- Use hunk-review for `test/widget_test.dart`.
- Use a docs-rollup commit with an honest message, for example `docs: record phase delivery gates`, if `ACTIVE_SPRINT.md` and `README.md` are mostly project-memory updates.

## Phase 7A Test Strategy

Because `test/widget_test.dart` is already mixed, Phase 7A should prefer a new file:

- `test/phase7a_auth_shell_test.dart`

Use `test/widget_test.dart` for Phase 7A only if Phase 5/6 hunks are already committed or if the user explicitly approves working in the mixed file.

Mobile Implementation recommendation:

- Do not touch `test/widget_test.dart` for Phase 7A unless existing expectations must change.
- Do not touch `status_chip.dart` for Phase 7A until its Phase 5 hunk is committed or explicit mixed-tree approval is given.
- Prefer implementing Phase 7A polish through theme and new/clean primitives first.

QA recommendation:

- Treat mixed hunks in `test/widget_test.dart` or shared widgets as a Phase 7A start blocker.
- Require `flutter analyze`, `flutter test`, scans and Redmi 7 baseline evidence before Phase 7A app-code starts.
- Block if artifacts, secrets, platform permissions, generated DB or provider/billing/upload/live-backend scope appears in staged changes.

## Current Blocker

Phase 7A app-code remains blocked until:

- split commits are approved and performed without push; or
- the user explicitly approves implementation on top of the mixed dirty tree.

No code should start while `status_chip.dart` and `test/widget_test.dart` still contain unresolved Phase 5/6 changes and are also expected Phase 7A touch points.

## Role Review Status

- Repo GitHub: complete. Safest strategy is two code commits plus docs-rollup if docs hunk staging is too noisy; never use `git add .`.
- Mobile Implementation: complete. New `test/phase7a_auth_shell_test.dart` is safer than editing mixed `test/widget_test.dart`; avoid `status_chip.dart` until clean or approved.
- QA Release: complete as CONDITIONAL. Mixed hunks in tests/shared widgets block Phase 7A code start unless split/committed or explicitly approved.
