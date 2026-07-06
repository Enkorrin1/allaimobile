# Phase 7 Repo Preflight Audit

Date: 2026-07-05.

Status: read-only audit complete. No staging, commit, push or app-code edits were performed.

## Purpose

This file records the current repository snapshot and role review after running the read-only preflight commands from `docs/PHASE_7_REPO_UNBLOCK_TASK_QUEUE.md`.

## Read-Only Commands Run

```powershell
git status --short --branch -uall
git remote -v
git log --oneline -5
git diff --name-status
git diff --stat
git diff --check
git diff --stat -- docs/ACTIVE_SPRINT.md docs/README.md test/widget_test.dart
git ls-files | rg -n "(?i)(^|/)(build|\.dart_tool|\.gradle|Pods)(/|$)|\.(apk|aab|ipa|db|sqlite|jks|keystore)$|(^|/)(key\.properties|google-services\.json|GoogleService-Info\.plist)$"
```

An earlier broad artifact scan matched `android/app/build.gradle.kts`, `android/build.gradle.kts` and `android/settings.gradle.kts` because the pattern included the plain word `build`. The refined path-segment scan had no matches.

## Snapshot

- Branch: `main...origin/main`.
- Remote: `https://github.com/Enkorrin1/allaimobile.git`.
- Latest commits:
  - `991b404 docs: record phased delivery plan`
  - `c0b8e2b feat: add persisted mock runtime and auth flow`
  - `b584908 Initial Flutter app scaffold and static UI`
- `git diff --check`: PASS.
- Refined tracked artifact scan: no matches.
- Tracked diff: 24 files, 2180 insertions, 320 deletions.
- Mixed review files:
  - `docs/ACTIVE_SPRINT.md`: 523 changed lines.
  - `docs/README.md`: 44 changed lines.
  - `test/widget_test.dart`: 202 changed lines.

## Tracked Modified Files

Docs:

- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`

Core/data:

- `lib/core/api/mock_allai_api.dart`
- `lib/core/database/app_database.dart`
- `lib/core/database/app_database.g.dart`
- `lib/features/billing/data/billing_cache_data_source.dart`
- `lib/features/billing/data/billing_repository.dart`
- `lib/features/generation_jobs/data/generation_repository.dart`
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`

Presentation/shared:

- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/billing/presentation/view_models/billing_copy.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/features/studio/presentation/screens/studio_screen.dart`
- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/view_models/catalog_ui_mappers.dart`
- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`
- `lib/shared/widgets/status_chip.dart`

Tests:

- `test/phase3_contract_test.dart`
- `test/phase5_catalog_pricing_boundary_test.dart`
- `test/widget_test.dart`

## Notable Untracked Groups

Phase 5/6/7 planning docs:

- `docs/PHASE_5_*`
- `docs/PHASE_6_*`
- `docs/PHASE_7*`

Phase 6 code/tests:

- `lib/features/generation_jobs/data/generation_api_data_source.dart`
- `lib/features/generation_jobs/data/generation_data_providers.dart`
- `lib/features/generation_jobs/data/upload_api_data_source.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `test/phase6_image_generation_test.dart`
- `test/result_viewer_stabilization_test.dart`

## Diff Hotspots

- `lib/features/generator/presentation/screens/generator_screen.dart`: 332 insertions, 77 deletions.
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`: 173 insertions, 57 deletions.
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`: 138 insertions, 17 deletions.
- `lib/core/database/app_database.g.dart`: 231 insertions, 4 deletions.
- `test/widget_test.dart`: 190 insertions, 12 deletions.

## Role Review Conclusions

Repo GitHub:

- Preflight is clean enough for controlled repo-unblock split after explicit approval.
- One-shot commit is not acceptable.
- Split priority remains Phase 5 code, Phase 6 code, Phase 5/6 docs, then Phase 7 planning docs.
- Every staged group must be reviewed with `git diff --cached --name-status`, `git diff --cached --stat` and `git diff --cached --check`.

Mobile Architecture:

- Phase 7 app-code remains blocked.
- `app_database.dart` and `app_database.g.dart` must stay paired in the Phase 5 data commit.
- `test/widget_test.dart` is a P0 mixed-hunk risk.
- Phase 6 generation/result/library changes must not leak into Phase 7 UI work.

Backend/Data:

- Phase 5 data/cache changes and Phase 6 generation/upload-skeleton changes must be separated.
- `generation_api_data_source.dart`, `generation_data_providers.dart` and `upload_api_data_source.dart` belong to the Phase 6 group.
- Drift generated source is valid only with the matching schema/migration source and data tests.
- Required tests before data commit include analyze, full tests, Phase 5 catalog/pricing boundary tests, Phase 6 image generation tests and updated Phase 3 contract tests.

QA Release:

- QA status remains BLOCKED until split or explicit approval.
- `test/widget_test.dart` needs hunk review before QA can attribute regressions.
- Baseline Redmi evidence remains in `build/`, ignored and not staged.
- Untracked docs/code/tests must be assigned to a phase or left untracked intentionally.

Mobile Implementation:

- Mobile Implementation remains HOLD.
- Required handoff is a clear repo-unblock decision plus remaining dirty-file owner notes.
- Avoid `test/widget_test.dart`, shared widgets, core/data/generation/billing/tools/library/result files until split.
- Phase 7 app-code cannot start while target file overlap is unresolved.

## Current Blockers

- No explicit user approval for repo split/staging/commits.
- Dirty tree remains mixed across Phase 5, Phase 6 and Phase 7 docs.
- Mixed files need hunk-level review:
  - `docs/ACTIVE_SPRINT.md`
  - `docs/README.md`
  - `test/widget_test.dart`
- Shared widgets need phase ownership review:
  - `error_state.dart`
  - `status_chip.dart`
  - `media_asset_tile.dart`
  - `result_action_bar.dart`
- Phase 7 app-code is still blocked.

## Current Coordinator Decision

Read-only preflight passed the basic hygiene checks, but it does not unblock implementation. The next required action is explicit user approval for the repo split without push, or explicit approval to accept mixed-tree implementation risk.
