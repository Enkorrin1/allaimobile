# Phase 3 Execution Brief

Date: 2026-07-03.

## Objective

Replace static presentation-only fixtures with a typed mock product layer that can later point at the AllAI backend.

## Scope

Phase 3 should produce a working mock app, not a live integration.

Included:

- Typed domain/DTO models.
- Mock API/repository implementations.
- Riverpod providers/controllers.
- Deterministic generation job lifecycle.
- Local history metadata persistence when feasible.
- Tests for contracts and important state transitions.

Excluded:

- Real AllAI backend calls.
- Direct AI provider SDKs.
- Provider keys or secrets.
- Production auth.
- Production billing/IAP.
- Real file upload and media storage.
- Push notifications.

## Suggested Implementation Slices

### Slice A: Typed Mock Runtime

- Add model classes and JSON parsing.
- Add mock catalog, billing, generation, and history repositories.
- Wire Home, Tools, Generator, Library, Result Viewer, Pricing, and Profile to Riverpod providers while preserving the current UI.
- Add deterministic job creation and progress simulation in memory.
- Add tests for parsing and mock lifecycle.

Exit:

- App still passes existing navigation tests.
- Catalog and pricing are provider-backed.
- A mock job can be created and can reach completed or failed state.

### Slice B: Local Persistence

- Add Drift tables for catalog snapshot, jobs, assets, balance snapshot, and transactions.
- Persist mock history across restart.
- Add repository tests around save/load/update behavior.

Exit:

- App restart keeps mock generation history.
- Failed/completed jobs remain visible in Library.

### Slice C: Hardening

- Add insufficient-balance simulation.
- Add retry path for failed mock jobs.
- Add offline cached catalog/history behavior.
- Add QA smoke checklist and Android build verification.

Exit:

- Phase 3 exit criteria in `docs/DEVELOPMENT_PLAN.md` are satisfied.

## Structure Guidance

Prefer feature-first folders:

```text
lib/features/tools/domain/
lib/features/tools/data/
lib/features/generation_jobs/domain/
lib/features/generation_jobs/data/
lib/features/library/domain/
lib/features/library/data/
lib/features/billing/domain/
lib/features/billing/data/
lib/core/api/
lib/core/database/
```

Keep presentation widgets free to display UI-specific icons, colors, and localized labels, but keep domain models plain and backend-shaped.

Do not include provider routing keys in mobile models. If the UI needs provider wording, use public display metadata such as `providerLabel`.

## Verification

Required before coordinator review:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed .
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
```

Android manual smoke is still required before calling the app demo-ready.
