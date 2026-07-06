# Phase 7 Repo Split File Map

Date: 2026-07-05.

Status: planning-only. This file maps the current dirty tree into future split groups. It does not authorize staging, commits, push or app-code work.

## Purpose

The current working tree mixes Phase 5, Phase 6 and Phase 7 planning changes. This file records the role-reviewed file-to-group map to use after explicit user approval for repo-unblock split.

## Current Split Principle

- Split by phase and ownership, not by staging convenience.
- Keep app-code commits separate from docs commits unless an explicit rollup is approved.
- Use explicit paths or reviewed patch hunks only.
- Do not use `git add .`.
- Phase 7 app-code remains blocked until repo split approval closes or the user explicitly approves mixed-tree implementation risk.

## Group A: Phase 5 Code

Intended commit purpose: catalog, templates, pricing, package metadata, billing cache and Phase 5 UI-state polish.

Files:

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

Rules:

- `app_database.dart` and `app_database.g.dart` must be staged together if schema/table/migration hunks are staged.
- `app_database.g.dart` must not enter Phase 6 or Phase 7 commits.
- `error_state.dart` and `status_chip.dart` require hunk review if they include non-Phase-5 changes.
- If `lib/features/billing/domain/billing_models.dart` appears in a future diff, include it here only for package metadata/balance/package cache hunks.

Required verification after future staging:

- `git diff --cached --name-status`
- `git diff --cached --stat`
- `git diff --cached --check`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- Targeted Phase 5 catalog/pricing boundary tests.

## Group B: Phase 6 Code

Intended commit purpose: prompt-only generation loop, generation data boundaries, Result/Library stabilization and upload skeleton planning support.

Files:

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

Rules:

- `generation_api_data_source.dart`, `generation_data_providers.dart` and `upload_api_data_source.dart` belong to Phase 6, not Phase 5 or Phase 7.
- `media_asset_tile.dart` and `result_action_bar.dart` require hunk review if they include non-Phase-6 changes.
- If `lib/features/generation_jobs/domain/generation_job_models.dart` or `lib/features/library/data/library_repository.dart` appear in a future diff, include them here only for generation/status/assets/cache hunks.
- Do not include `app_database.g.dart` unless a future schema hunk is explicitly reviewed and approved for this phase, which is currently not expected.

Required verification after future staging:

- `git diff --cached --name-status`
- `git diff --cached --stat`
- `git diff --cached --check`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- Targeted Phase 6 generation/result/library tests.
- Provider/secrets/upload/permission scan.

## Group C: Phase 5/6 Docs

Intended commit purpose: historical and review documentation for Phase 5 and Phase 6.

Files:

- `docs/PHASE_5_*`
- `docs/PHASE_6_*`
- Phase 5/6 hunks from `docs/ACTIVE_SPRINT.md`
- Phase 5/6 hunks from `docs/README.md`

Rules:

- Prefer docs-only commits after corresponding code split groups.
- Do not mix with app-code unless an explicit rollup is approved.
- `docs/ACTIVE_SPRINT.md` and `docs/README.md` must be hunk-reviewed or included only in an explicit docs rollup.

## Group D: Phase 7 Planning Docs

Intended commit purpose: Phase 7, 7A, 7B and 7C planning, review gates and repo-unblock docs.

Files:

- `docs/PHASE_7_UI_UX_OVERHAUL_BRIEF.md`
- `docs/PHASE_7_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_7_CONTRACT_REVIEW.md`
- `docs/PHASE_7A_*`
- `docs/PHASE_7B_*`
- `docs/PHASE_7C_*`
- `docs/PHASE_7_REPO_UNBLOCK_TASK_QUEUE.md`
- `docs/PHASE_7_REPO_PREFLIGHT_AUDIT.md`
- `docs/PHASE_7_REPO_SPLIT_FILE_MAP.md`
- Phase 7+ hunks from `docs/ACTIVE_SPRINT.md`
- Phase 7+ hunks from `docs/README.md`

Rules:

- Docs-only.
- Do not pull app-code, tests, generated files, screenshots or build artifacts into this group.
- Phase 7 app-code remains HOLD even after this docs group is mapped.

## Hunk-Review Only

These files must not be whole-file staged unless an explicit rollup commit is approved:

- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`
- `test/widget_test.dart`

Shared widgets requiring ownership review before staging:

- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`

Rule of thumb:

- Phase 5 assertions or UI-state/cost/pricing/catalog hunks go to Phase 5.
- Phase 6 generation/result/library/progress/media hunks go to Phase 6.
- Phase 7 planning docs hunks go to Phase 7 docs only.
- If a hunk cannot be confidently assigned, stop and ask for review.

## Leave Untracked Or HOLD

Never stage without a separate explicit approval:

- `build/`
- screenshots under `build/`
- APK/AAB/IPA
- `.dart_tool/`
- coverage
- DB/sqlite/cache files
- `.env` and `.env.*`
- signing keys/certs
- provider configs
- platform permission changes
- dependency changes in `pubspec.yaml`
- `android/` or `ios/` changes, unless explicitly approved
- Phase 7A/7B/7C app-code before repo gate closure.

## Future Phase 7A Entry Handoff

Mobile Implementation can start Phase 7A app-code only after a handoff includes:

- fresh `git status --short -uall`;
- split commit list or explicit mixed-tree approval;
- remaining dirty-file list;
- owner notes for shared widgets and tests;
- confirmed allowed Phase 7A files;
- forbidden file list;
- explicit statement: `Phase 7A app-code authorized`.

Preferred Phase 7A test path after split:

- create a new focused `test/phase7a_auth_shell_test.dart`;
- avoid `test/widget_test.dart` until Phase 5/6 hunks are clean or committed.

## Stop Conditions

Stop before staging or implementation if:

- user approval is missing;
- `git add .` is proposed;
- mixed hunks cannot be safely split;
- `app_database.dart` and `app_database.g.dart` are mismatched;
- Phase 7 docs pull in app-code;
- generated DB files appear outside the approved Phase 5 data group;
- build artifacts, screenshots, APKs, secrets, signing files or provider configs appear staged;
- platform/dependency/provider/IAP/upload changes appear without approval;
- analyze/tests/scans fail after staging.

## Current Coordinator Decision

The file map is ready for future repo-unblock execution after explicit approval. It does not authorize the split itself. Until approval, Phase 7 app-code remains HOLD.
