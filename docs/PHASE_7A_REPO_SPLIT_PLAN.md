# Phase 7A Repo Split Plan

Date: 2026-07-04.

Status: planning-only. No staging, commit or push performed.

## Why This Exists

Phase 7A app-code should not start while the working tree mixes Phase 5, Phase 6 and Phase 7 changes. This plan defines safe inspection and split groups before any UI redesign code is added.

## Current Problem

The working tree contains:

- tracked docs updates;
- untracked Phase 5 docs;
- untracked Phase 6 docs;
- untracked Phase 7 docs;
- modified Phase 5/6 source files;
- modified generated Drift source;
- modified tests;
- untracked Phase 6 data sources and preview widget.

Because several files were touched across multiple phases, `git add .` is unsafe.

## Split Groups

### Group 1: Phase 5 Slice C / Catalog Pricing Cleanup

Likely files:

- `docs/PHASE_5_SLICE_B_REVIEW_DISPATCH.md`
- `docs/PHASE_5_SLICE_B_REVIEW_NOTES.md`
- `docs/PHASE_5_SLICE_C_EXECUTION_BRIEF.md`
- `docs/PHASE_5_SLICE_C_QA_CLOSURE_DISPATCH.md`
- `docs/PHASE_5_SLICE_C_QA_CLOSURE_RESULT.md`
- `docs/PHASE_5_SLICE_C_RESULT.md`
- `docs/PHASE_5_SLICE_C_REVIEW_DISPATCH.md`
- `docs/PHASE_5_SLICE_C_REVIEW_NOTES.md`
- `lib/core/api/mock_allai_api.dart`
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
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/status_chip.dart`
- `test/phase3_contract_test.dart`
- `test/phase5_catalog_pricing_boundary_test.dart`

Risk: some shared widgets and tests may also include Phase 6 expectations. Inspect diffs before staging.

### Group 2: Phase 6 Image Generation / Slice A / Stabilization

Likely files:

- `docs/PHASE_6_CONTRACT_REVIEW.md`
- `docs/PHASE_6_EXECUTION_BRIEF.md`
- `docs/PHASE_6_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_6_SLICE_A_EXECUTION_BRIEF.md`
- `docs/PHASE_6_SLICE_A_RESULT.md`
- `docs/PHASE_6_SLICE_A_REVIEW_DISPATCH.md`
- `docs/PHASE_6_SLICE_A_REVIEW_NOTES.md`
- `docs/PHASE_6_SLICE_A_STABILIZATION_BRIEF.md`
- `docs/PHASE_6_SLICE_A_STABILIZATION_RESULT.md`
- `docs/PHASE_6_SLICE_B_CONTRACT_REVIEW.md`
- `docs/PHASE_6_SLICE_B_PLANNING_BRIEF.md`
- `docs/PHASE_6_SLICE_B_PLANNING_DISPATCH.md`
- `lib/features/generation_jobs/data/generation_api_data_source.dart`
- `lib/features/generation_jobs/data/generation_data_providers.dart`
- `lib/features/generation_jobs/data/generation_repository.dart`
- `lib/features/generation_jobs/data/upload_api_data_source.dart`
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `lib/shared/widgets/result_action_bar.dart`
- `test/phase6_image_generation_test.dart`
- `test/result_viewer_stabilization_test.dart`

Risk: `test/widget_test.dart` likely spans auth, pricing and generation. It needs manual hunk review before any split commit.

### Group 3: Phase 7 / Phase 7A Planning Docs

Likely files:

- `docs/PHASE_7_UI_UX_OVERHAUL_BRIEF.md`
- `docs/PHASE_7_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_7_CONTRACT_REVIEW.md`
- `docs/PHASE_7A_EXECUTION_BRIEF.md`
- `docs/PHASE_7A_PRE_IMPLEMENTATION_DISPATCH.md`
- `docs/PHASE_7A_PRE_IMPLEMENTATION_NOTES.md`
- `docs/PHASE_7A_REPO_SPLIT_PLAN.md`
- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`

Risk: `ACTIVE_SPRINT.md` and `README.md` also include Phase 5/6 doc index changes. If splitting commits strictly, these two files may need staged hunks rather than full-file staging.

### Group 4: Do Not Stage For Phase 7A UI-Only Work

- `build/...`
- `build/allai_phone_screen.png`
- APK files.
- Android/iOS permission files unless separately approved.
- `pubspec.yaml` unless a deliberate asset/dependency change is approved.
- generated database files for Phase 7A UI-only work.

## Inspection Commands

Read-only/safe inspection:

```powershell
git status --short -uall
git diff --name-only
git diff -- docs/ACTIVE_SPRINT.md docs/README.md
git diff -- test/widget_test.dart
git diff -- lib/core/database/app_database.dart lib/core/database/app_database.g.dart
```

Check that nothing is staged:

```powershell
git diff --cached --name-only
```

## Staging Rules

- Do not use `git add .`.
- Stage explicit files only.
- For `ACTIVE_SPRINT.md`, `README.md` and `test/widget_test.dart`, prefer hunk-level review/staging if commits must be split strictly.
- Do not stage build artifacts or phone screenshots.
- Do not stage Phase 7A code before the split decision is made.

## Coordinator Recommendation

Before starting Phase 7A code, ask the user for explicit approval to either:

1. perform a careful commit split for existing Phase 5/6/7 planning changes; or
2. proceed with Phase 7A code on the mixed dirty tree, accepting higher commit-risk.

The safer path is option 1.
