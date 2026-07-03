# Phase 3 Slice B Role Assignments

Date: 2026-07-03.

Phase: Typed Data Layer And Mock Backend.

Slice: B - Drift/SQLite Persistence.

Goal: make the typed mock runtime durable across app restart by persisting catalog snapshots, generation jobs, assets, billing snapshots, and coin transactions locally.

## Coordination Rules

- Coordinator chat owns merge decisions and final acceptance.
- Mobile Implementation is the only role allowed to edit app code for Slice B.
- Other role chats provide contracts, review, QA gates, and repo guidance only.
- No git commit or push without explicit user confirmation.
- Work starts from the current dirty local tree that already contains Phase 2 polish and Phase 3 Slice A.
- Keep Slice B fully mock/offline. Do not add live backend calls, provider SDKs, production auth, production billing, upload, push, analytics, secrets, or credentials.

## Product Lead

Owner of product acceptance for persistence.

Tasks:

- Confirm what must survive app restart in mock mode:
  - completed jobs;
  - failed jobs;
  - output asset metadata;
  - billing balance;
  - coin transactions;
  - catalog snapshot.
- Confirm whether in-progress jobs should restore as active, completed, failed, or paused in Slice B.
- Define acceptable empty-state behavior after first install and after local database reset.

Deliverable:

- Product acceptance checklist for Slice B persistence.

## Mobile Architecture

Owner of persistence boundaries.

Tasks:

- Review Drift/SQLite table and DAO boundaries.
- Confirm that presentation screens/providers do not import Drift tables, DAOs, generated database files, or `AppDatabase` directly.
- Confirm whether generated Drift files should be committed and whether CI needs build_runner.
- Review migration/versioning strategy for first schema.

Deliverable:

- Architecture gate with P0 blockers, table/module guidance, and migration guidance.

## Backend Data

Owner of local schema and data mapping truth.

Tasks:

- Define required local tables and fields for:
  - catalog snapshot;
  - generation jobs;
  - assets;
  - billing balance snapshot;
  - coin transactions.
- Define JSON fields versus normalized fields.
- Confirm id stability, timestamps, enum values, and relationship rules.
- Define seed/sync semantics for mock mode.

Deliverable:

- Drift/SQLite schema checklist and mapping rules.

## Mobile Implementation

Code owner for Slice B.

Tasks:

- Replace `AppDatabasePlaceholder` with a real Drift database.
- Add tables/DAOs or equivalent Drift access methods for catalog, jobs, assets, billing, and transactions.
- Add database provider(s) in the data/core layer, not presentation.
- Wire repositories so mock history/billing/catalog survive app restart.
- Seed initial mock data safely on first run without duplicating rows.
- Keep all existing Slice A behavior working.
- Add tests for save/load/update, restart-style repository reconstruction, and migration/schema sanity.
- Run format, analyze, test, and Android debug build.
- Do not commit or push.

Deliverable:

- Local code changes only, with check results and remaining blockers.

## QA Release

Owner of verification.

Tasks:

- Prepare and, if possible, run Android persistence smoke:
  - launch app;
  - create/complete mock job;
  - kill/restart app;
  - confirm Library still shows job/result;
  - confirm billing/transactions remain consistent;
  - confirm failed job remains visible.
- Re-run targeted Back-stack regression if navigation code changes.
- Confirm no real backend/provider/billing/auth/upload/push integration was introduced.

Deliverable:

- QA gate result for Slice B persistence.

## UI UX

Owner of persistence-facing UX states.

Tasks:

- Review Library/history after restart.
- Review empty state on fresh install and after no persisted jobs.
- Review failed-job persistence copy, retry affordance, and transaction/refund wording.
- Check that loading/restoring local data does not create confusing flicker.

Deliverable:

- UI/UX findings for persisted history and local restore states.

## Repo GitHub

Owner of repo and CI hygiene.

Tasks:

- Review generated Drift files policy.
- If generated files are added, recommend commit inclusion and CI dirty-check/build_runner strategy.
- Confirm no generated caches, local databases, APKs, build outputs, signing files, or env files are staged.
- Recommend commit split after Slice B is verified.

Deliverable:

- Repo/CI readiness note.

## Task Chat Logic

Owner of coordination boundaries.

Tasks:

- Confirm Slice B is still one code-owner work.
- Track handoff risk between persistence, product acceptance, and QA.
- Keep future in-app task-agent/role-chat design separate from persistence implementation.

Deliverable:

- Coordination note if ownership overlap appears.
