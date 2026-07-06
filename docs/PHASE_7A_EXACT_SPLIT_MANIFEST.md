# Phase 7A Exact Split Manifest

Date: 2026-07-04.

Status: exact read-only manifest from current `git status`. No staging, commit, push or app-code edits performed.

## Purpose

This file maps the current dirty tree into explicit split groups before Phase 7A UI implementation. It exists so the repo split can be approved and performed deliberately, without `git add .` and without mixing Phase 5, Phase 6 and Phase 7/7A work.

## Current Dirty Tree Summary

Tracked docs:

- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`

Tracked source and tests:

- `lib/core/api/mock_allai_api.dart`
- `lib/core/database/app_database.dart`
- `lib/core/database/app_database.g.dart`
- `lib/features/billing/data/billing_cache_data_source.dart`
- `lib/features/billing/data/billing_repository.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/billing/presentation/view_models/billing_copy.dart`
- `lib/features/generation_jobs/data/generation_repository.dart`
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`
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
- `test/phase3_contract_test.dart`
- `test/phase5_catalog_pricing_boundary_test.dart`
- `test/widget_test.dart`

Untracked docs:

- `docs/PHASE_5_*`
- `docs/PHASE_6_*`
- `docs/PHASE_7_*`
- `docs/PHASE_7A_*`

Untracked source and tests:

- `lib/features/generation_jobs/data/generation_api_data_source.dart`
- `lib/features/generation_jobs/data/generation_data_providers.dart`
- `lib/features/generation_jobs/data/upload_api_data_source.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `test/phase6_image_generation_test.dart`
- `test/result_viewer_stabilization_test.dart`

## Split Group 1: Phase 5 Slice C Code

Suggested commit message:

```text
feat: polish catalog pricing states
```

Candidate paths:

- `lib/core/database/app_database.dart`
- `lib/core/database/app_database.g.dart`
- `lib/features/billing/data/billing_cache_data_source.dart`
- `lib/features/billing/data/billing_repository.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/billing/presentation/view_models/billing_copy.dart`
- `lib/features/studio/presentation/screens/studio_screen.dart`
- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/view_models/catalog_ui_mappers.dart`
- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/status_chip.dart`
- `test/phase5_catalog_pricing_boundary_test.dart`
- Phase 5 hunks only from `test/widget_test.dart`

Review notes:

- Stage `app_database.dart` and `app_database.g.dart` together, never one without checking the other.
- `error_state.dart` and `status_chip.dart` are shared widgets, so visually review hunks before including them in Phase 5.

## Split Group 2: Phase 6 Slice A / Stabilization Code

Suggested commit message:

```text
feat: add prompt image generation loop
```

Candidate paths:

- `lib/core/api/mock_allai_api.dart`
- `lib/features/generation_jobs/data/generation_api_data_source.dart`
- `lib/features/generation_jobs/data/generation_data_providers.dart`
- `lib/features/generation_jobs/data/generation_repository.dart`
- `lib/features/generation_jobs/data/upload_api_data_source.dart`
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`
- `test/phase3_contract_test.dart`
- `test/phase6_image_generation_test.dart`
- `test/result_viewer_stabilization_test.dart`
- Phase 6 hunks only from `test/widget_test.dart`

Review notes:

- `media_asset_tile.dart` and `result_action_bar.dart` are shared widgets, so visually review hunks before including them in Phase 6.
- `upload_api_data_source.dart` is interface/planning code only; do not treat it as upload/image-to-image activation.

## Split Group 3: Phase 5/6 Docs

Suggested commit message:

```text
docs: record phase 5 and phase 6 gates
```

Candidate paths:

- `docs/PHASE_5_*`
- `docs/PHASE_6_*`
- Phase 5/6 hunks only from `docs/ACTIVE_SPRINT.md`
- Phase 5/6 hunks only from `docs/README.md`

Review notes:

- If hunk-level staging is too noisy, use a separate docs-rollup commit after the Phase 5 and Phase 6 code commits.

## Split Group 4: Phase 7 / Phase 7A Docs

Suggested commit message:

```text
docs: plan phase 7 ui overhaul
```

Candidate paths:

- `docs/PHASE_7_*`
- `docs/PHASE_7A_*`
- Phase 7/7A hunks only from `docs/ACTIVE_SPRINT.md`
- Phase 7/7A hunks only from `docs/README.md`

Review notes:

- This group includes baseline, decision packet, repo split plan, execution handoff and this exact split manifest.

## Mandatory Hunk Review

Do not stage these whole-file unless the intent is an explicit rollup commit:

- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`
- `test/widget_test.dart`

Visually inspect these shared widget files before staging:

- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`

## Phase 7A Implementation Unblock Criteria

Before Mobile Implementation starts Phase 7A UI code:

- Phase 5/6 source and test changes are committed or explicitly removed from the dirty tree.
- Phase 5/6 docs are committed or explicitly accepted as remaining docs-only dirty state.
- `test/widget_test.dart` has no unresolved Phase 5/6 hunks mixed with future Phase 7A changes.
- `docs/ACTIVE_SPRINT.md` and `docs/README.md` have no unresolved mixed hunks unless intentionally left as docs-rollup.
- The working tree is clean or dirty only with explicitly approved Phase 7/7A docs.

## Expected Phase 7A Touch Set After Approval

After repo approval, Mobile Implementation expects to touch only:

- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_typography.dart`
- `lib/app/theme/app_theme.dart`
- `lib/app/shell/app_shell.dart`
- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_text_field.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/features/auth/presentation/screens/auth_welcome_screen.dart`
- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/screens/register_screen.dart`
- `lib/features/auth/presentation/screens/password_reset_screen.dart`
- `test/widget_test.dart` or new `test/phase7a_auth_shell_test.dart`

## Stop Conditions

Stop immediately if:

- `build/`, `.dart_tool/`, APK/AAB/IPA, DB/sqlite/cache, `.env*`, keys/certs or provider config are staged.
- `git add .` is used.
- Whole-file staging is used for mandatory hunk-review files without explicit rollup intent.
- Phase 7 docs enter a code commit.
- Phase 5/6 app-code remains dirty when Phase 7A implementation is about to start.
- Drift generated source is staged without reviewing the matching schema source.
- Platform permissions, provider SDK, IAP, dependency or asset changes appear without separate approval.

## Role Review Status

- Repo GitHub: complete. Exact split groups and stop conditions confirmed.
- Mobile Implementation: complete. Phase 7A remains blocked until Phase 5/6 app-code and test hunks are clean/committed or explicitly approved.
- QA Release: complete as CONDITIONAL. Before Phase 7A code, Phase 5/6 source, tests and docs must be clean/committed, Phase 7/7A docs must be split or explicitly accepted, analyze/tests/scans must pass, Redmi 7 evidence must be available, and artifacts/secrets/platform changes must not be staged.
