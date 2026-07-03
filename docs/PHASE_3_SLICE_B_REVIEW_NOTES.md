# Phase 3 Slice B Review Notes

Дата: 2026-07-03.

## Статус

Slice B: Drift/SQLite persistence dispatched and in implementation.

Mobile Implementation is the only code owner for this slice. Other role chats provide gates and acceptance criteria only.

## P0 Gate

- Slice B is required before Phase 3 can be closed.
- UI screens, widgets, view models and presentation providers must not import Drift, `AppDatabase`, tables, companions, or generated database files directly.
- Local seed must be idempotent. Fresh install/reset seeds catalog, pricing packages and starter billing state, but user Library history should stay empty unless demo examples are clearly separated from user history.
- Persist catalog snapshot, generation jobs, assets, billing snapshot, coin packages and coin transactions.
- Completed, failed/refunded and in-progress jobs must survive app restart/repository reconstruction.
- In-progress jobs with `queued`, `running` or `processing` status should continue mock lifecycle from saved status/progress after restart.
- Runtime IDs must not collide after restart.
- Job create/complete/fail/refund must be atomic across job, asset, billing and transaction records.
- Failed/refunded jobs remain visible and should use user-facing copy, for example: `Генерация не удалась. Коины возвращены автоматически.`
- No provider routing keys, secrets, live backend, provider SDKs, auth, billing/IAP, upload, push or analytics are allowed in Slice B.
- Generated Drift source files are allowed in local changes. Build/cache/APK/database artifacts must not be staged.

## Data Checklist

- `app_metadata`: seed/version flags.
- `catalog_snapshots`: one stable catalog JSON snapshot.
- `generation_jobs`: backend-shaped job metadata and status/progress.
- `assets`: input/output asset metadata, linked to jobs where possible.
- `billing_snapshots`: balance, reserved coins and available coins.
- `coin_packages`: mock pricing package data.
- `coin_transactions`: charges, refunds, demo grants and related job ids.

## QA Acceptance

- Format, analyze, tests and Android debug build pass.
- Repository reconstruction test proves persisted catalog/history/billing survives.
- Completed job remains in Library and Result Viewer after restart.
- Failed/refunded job remains visible after restart with refund state.
- In-progress job remains active after restart and continues mock progress.
- Balance and transactions before/after restart are consistent.
- Back-stack regressions from Slice A remain closed.
- Android smoke should run only after Mobile Implementation finishes Slice B.

## Repo Notes

- Do not commit or push without explicit user confirmation.
- Current dirty tree mixes Phase 2 polish, Phase 3 Slice A and Slice B docs/code. Recommended future split: polish, Slice A, Slice B, CI/build-runner.
- Current CI does not run build_runner or Android build. If generated Drift files are used, include generated source and later add CI dirty-check.
