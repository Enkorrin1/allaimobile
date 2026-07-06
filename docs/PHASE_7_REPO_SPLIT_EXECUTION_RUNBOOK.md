# Phase 7 Repo Split Execution Runbook

Date: 2026-07-05.

Status: planning-only. This runbook is for future execution after explicit user approval. No git actions were performed while creating it.

## Purpose

This file defines the post-approval execution sequence for the repo-unblock split described in:

- `docs/PHASE_7_REPO_UNBLOCK_TASK_QUEUE.md`
- `docs/PHASE_7_REPO_PREFLIGHT_AUDIT.md`
- `docs/PHASE_7_REPO_SPLIT_FILE_MAP.md`

## Approval Gate

Do not run the execution steps until the user explicitly approves repo split actions.

Required approval should be concrete, for example:

```text
Разрешаю repo-unblock split без push: создать ветку codex/repo-unblock-phase-7, stage только явными путями/patch hunks, сделать отдельные commits для Phase 5 code, Phase 6 code, docs Phase 5/6 и docs Phase 7/7A/7B/7C; не использовать git add .; build/cache/secrets/APK исключить.
```

Push requires separate explicit approval.

## Role Gates

- Repo GitHub: owns branch, staging, commits and staged diff review.
- QA Release: owns command checks, artifact/secrets scan expectations and Android/Redmi evidence.
- Mobile Architecture: owns generated-file pairing, hunk-review policy and forbidden diff checks.
- Backend/Data: owns Phase 5/6 data invariants and data test requirements.
- Mobile Implementation: remains on HOLD until final handoff says `Phase 7A app-code authorized`.

## Step 0: Post-Approval Preflight

Run only after approval:

```powershell
git status --short --branch -uall
git remote -v
git diff --check
git diff --name-status
git diff --stat
```

Stop if:

- the branch/remote is unexpected;
- `git diff --check` fails;
- forbidden files appear;
- a new unknown dirty group appears.

## Step 1: Create Or Switch To Split Branch

Recommended branch:

```powershell
git switch -c codex/repo-unblock-phase-7
```

If the branch already exists, switch to it only after checking its state:

```powershell
git switch codex/repo-unblock-phase-7
git status --short --branch -uall
```

Do not push this branch without separate approval.

## Step 2: Phase 5 Code Commit

Stage only Phase 5 code files from `docs/PHASE_7_REPO_SPLIT_FILE_MAP.md`.

Expected file group:

- `lib/core/database/app_database.dart`
- `lib/core/database/app_database.g.dart`
- `lib/features/billing/data/billing_cache_data_source.dart`
- `lib/features/billing/data/billing_repository.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/billing/presentation/view_models/billing_copy.dart`
- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/view_models/catalog_ui_mappers.dart`
- `lib/features/studio/presentation/screens/studio_screen.dart`
- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/status_chip.dart`
- `test/phase5_catalog_pricing_boundary_test.dart`
- Phase 5-only hunks from `test/widget_test.dart`.

Required review before commit:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
git diff --cached -- test/widget_test.dart
```

Required checks:

```powershell
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
```

Data invariants to verify:

- `availableCoins = coinBalance - reservedCoins`;
- package refresh replaces stale packages;
- package metadata persists;
- pricing/package cache behavior remains mock-safe;
- no real billing/IAP activation.

Stop if:

- `app_database.g.dart` is staged without matching `app_database.dart`;
- Phase 6 or Phase 7 hunks appear;
- `test/widget_test.dart` cannot be safely hunk-assigned;
- checks fail.

Suggested commit message:

```text
feat: complete phase 5 catalog pricing polish
```

## Step 3: Phase 6 Code Commit

Stage only Phase 6 code files from `docs/PHASE_7_REPO_SPLIT_FILE_MAP.md`.

Expected file group:

- `lib/core/api/mock_allai_api.dart`
- `lib/features/generation_jobs/data/generation_repository.dart`
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`
- `lib/features/generation_jobs/data/generation_api_data_source.dart`
- `lib/features/generation_jobs/data/generation_data_providers.dart`
- `lib/features/generation_jobs/data/upload_api_data_source.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `test/phase3_contract_test.dart`
- `test/phase6_image_generation_test.dart`
- `test/result_viewer_stabilization_test.dart`
- Phase 6-only hunks from `test/widget_test.dart`.

Required review before commit:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
git diff --cached -- test/widget_test.dart
```

Required checks:

```powershell
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
```

Data/runtime invariants to verify:

- generation create/status split remains stable;
- active/completed/failed job persistence remains stable;
- failed generation releases reserve and does not charge;
- completed generation charges once;
- Result/Library asset lookup remains stable;
- upload skeleton remains live-disabled and runtime-only;
- no live provider/direct AI calls.

Stop if:

- Phase 5 database/billing hunks appear;
- Phase 7 planning/app-code appears;
- upload/provider/IAP/permission creep appears;
- checks fail.

Suggested commit message:

```text
feat: add phase 6 mock generation flow
```

## Step 4: Phase 5/6 Docs Commit

Stage only Phase 5 and Phase 6 docs.

Expected file group:

- `docs/PHASE_5_*`
- `docs/PHASE_6_*`
- Phase 5/6 hunks from `docs/ACTIVE_SPRINT.md`
- Phase 5/6 hunks from `docs/README.md`

Required review before commit:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
git diff --cached -- docs/ACTIVE_SPRINT.md docs/README.md
```

Stop if:

- app-code appears in the docs commit;
- Phase 7 docs appear unintentionally;
- `ACTIVE_SPRINT.md` or `README.md` is staged whole-file without an explicit docs-rollup strategy.

Suggested commit message:

```text
docs: record phase 5 and phase 6 delivery
```

## Step 5: Phase 7 Planning Docs Commit

Stage only Phase 7 planning docs.

Expected file group:

- `docs/PHASE_7_UI_UX_OVERHAUL_BRIEF.md`
- `docs/PHASE_7_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_7_CONTRACT_REVIEW.md`
- `docs/PHASE_7A_*`
- `docs/PHASE_7B_*`
- `docs/PHASE_7C_*`
- `docs/PHASE_7_REPO_UNBLOCK_TASK_QUEUE.md`
- `docs/PHASE_7_REPO_PREFLIGHT_AUDIT.md`
- `docs/PHASE_7_REPO_SPLIT_FILE_MAP.md`
- `docs/PHASE_7_REPO_SPLIT_EXECUTION_RUNBOOK.md`
- Phase 7+ hunks from `docs/ACTIVE_SPRINT.md`
- Phase 7+ hunks from `docs/README.md`

Required review before commit:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
git diff --cached -- docs/ACTIVE_SPRINT.md docs/README.md
```

Stop if:

- app-code, tests, generated files, screenshots or build artifacts appear;
- Phase 5/6 docs appear unintentionally;
- hunk ownership is unclear.

Suggested commit message:

```text
docs: plan phase 7 mobile redesign
```

## Step 6: After Each Commit

Run:

```powershell
git status --short -uall
git log -1 --oneline --name-status
```

Confirm that remaining dirty files belong only to the next planned group.

## Step 7: Final Post-Split Verification

Run:

```powershell
git status --short -uall
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

QA Android/Redmi readiness:

- `adb devices` should show `c7970e16 device`;
- device size should remain `720x1520`;
- density should remain `320`;
- baseline screenshots under `build/` must stay ignored and not staged.

## Hunk-Review Policy

Prefer explicit whole-file staging only for files that belong cleanly to one group.

For mixed files:

- `test/widget_test.dart`
- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`
- shared widgets touched by both Phase 5 and Phase 6

Use patch/hunk staging only when the hunk owner is clear. If interactive hunk staging is risky or unclear, stop and request a separate approval for either:

- a docs rollup commit;
- a whole-file strategy for a specific file;
- leaving that file dirty until a later cleanup.

## Forbidden During Split

- Do not use `git add .`.
- Do not edit app-code during the split.
- Do not push without separate approval.
- Do not stage build artifacts, APK/AAB/IPA, screenshots, `.dart_tool`, coverage, DB/cache files, `.env*`, signing files, provider configs or platform permission changes.
- Do not add dependencies or platform files without separate approval.
- Do not mix Phase 7 app-code into the repo-unblock split.
- Do not run destructive git commands to discard changes.

## Mobile Implementation Handoff

Phase 7A app-code can start only if the handoff includes:

- fresh `git status --short -uall`;
- split commit list;
- remaining dirty-file list;
- forbidden file list;
- QA baseline screenshot paths;
- UI acceptance checklist;
- owner note for any still-dirty shared/test file;
- explicit statement: `Phase 7A app-code authorized`.

Allowed Phase 7A files after handoff:

- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_typography.dart`
- `lib/app/theme/app_theme.dart`
- `lib/app/shell/app_shell.dart`
- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_text_field.dart`
- auth welcome/login/register/password reset screens.

Conditional Phase 7A files:

- `lib/shared/widgets/status_chip.dart`, only if clean or explicitly released;
- `test/widget_test.dart`, only if Phase 5/6 hunks are clean or committed.

Preferred new Phase 7A test:

- `test/phase7a_auth_shell_test.dart`

Forbidden for Phase 7A without separate approval:

- `lib/core/**`
- `lib/app/router/**`
- auth data/domain/session storage
- generation/billing/tools/library/result data/provider layers
- Drift/generated database files
- `pubspec.yaml`
- `android/**`
- `ios/**`

## Current Coordinator Decision

The execution runbook is ready for future use, but no execution is authorized yet. Current state remains planning-only until the user explicitly approves repo split actions.
