# Phase 3 Slice B Execution Brief

Date: 2026-07-03.

## Objective

Persist the Phase 3 Slice A mock runtime locally with Drift/SQLite so catalog, mock history, assets, billing state, and transactions can survive app restart.

## Included

- Drift database replacing `AppDatabasePlaceholder`.
- First schema version.
- Catalog snapshot persistence.
- Generation job persistence.
- Asset metadata persistence.
- Billing balance snapshot persistence.
- Coin transaction persistence.
- Repository wiring that keeps screens using repositories/providers, not database APIs directly.
- Tests for local save/load/update behavior.

## Excluded

- Live backend calls.
- Provider SDKs or provider routing keys.
- Production auth.
- Production billing/IAP.
- Real upload/download storage.
- Push notifications.
- Analytics/crash reporting.
- Commit/push.

## Suggested Slice B Shape

### Database

Use `lib/core/database/app_database.dart` as the entry point.

Recommended tables:

- `catalog_snapshots`
  - `id`
  - `catalog_json`
  - `updated_at`
- `generation_jobs`
  - `id`
  - `user_id`
  - `model_id`
  - `template_id`
  - `status`
  - `prompt`
  - `settings_json`
  - `input_asset_ids_json`
  - `output_asset_ids_json`
  - `cost_coins`
  - `progress`
  - `error_code`
  - `error_message`
  - `created_at`
  - `updated_at`
- `assets`
  - `id`
  - `type`
  - `role`
  - `url`
  - `thumbnail_url`
  - `width`
  - `height`
  - `duration_sec`
  - `mime_type`
  - `size_bytes`
  - `created_at`
- `billing_snapshots`
  - `user_id`
  - `coin_balance`
  - `reserved_coins`
  - `available_coins`
  - `updated_at`
- `coin_transactions`
  - `id`
  - `type`
  - `amount`
  - `title`
  - `related_job_id`
  - `balance_after`
  - `created_at`

### Repository Rules

- Repositories can depend on `AppDatabase`.
- Screens and presentation providers must not depend on Drift tables, DAOs, companions, or generated database files.
- On first run, seed mock catalog/history/billing once.
- On later runs, load from local database first.
- Job creation should persist job, output asset, balance change, and transaction records.
- Failed/refunded jobs must remain visible after restart.

### Generated Files

Drift normally generates `*.g.dart`.

Allowed for Slice B:

- `lib/core/database/app_database.g.dart`

Required if generated files are introduced:

- Run `dart run build_runner build --delete-conflicting-outputs`.
- Keep generated source files in the local change set.
- Do not commit generated caches or build outputs.
- Repo GitHub should recommend whether CI should run build_runner plus dirty-check.

### Testing

Add focused tests for:

- Database can open in memory.
- Seed writes catalog/jobs/assets/billing/transactions.
- Reconstructing repositories over the same database returns persisted history.
- Completed job survives repository reconstruction.
- Failed/refunded job survives repository reconstruction.
- Billing balance and transactions stay consistent.
- Domain models remain free of UI imports and provider routing keys.

## Verification

Required before coordinator review:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed .
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
```

Targeted Android smoke should verify app restart persistence if emulator/device is available.

## Acceptance

Slice B is accepted when:

- Automated checks pass.
- App still opens all key screens.
- Mock history survives app restart.
- Billing balance/transactions survive app restart.
- Failed and completed jobs remain visible in Library after restart.
- No live integrations, secrets, or provider SDKs are introduced.
- Any generated files and CI implications are documented.
