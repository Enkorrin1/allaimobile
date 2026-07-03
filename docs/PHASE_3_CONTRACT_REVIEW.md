# Phase 3 Contract Review

Date: 2026-07-03.

Status: Architecture, Backend/Data, Product, UI/UX, Repo/GitHub, and Task Chat Logic review received; QA and Mobile Implementation still in progress.

## P0 Decisions

1. Mobile domain must not include provider routing keys.
   - Use stable public model `id` values.
   - Use optional public `providerLabel` only if UI copy needs it.
   - Provider routing, provider credentials, and provider SDK configuration remain backend-only.

2. Phase 3 must stay fully mock.
   - Existing `DioClient` may remain as scaffold, but Phase 3 repositories must not perform live HTTP calls.
   - No provider SDKs, secrets, production auth, production billing, real upload, push, or analytics.

3. Drift is a Slice B boundary.
   - Screens and presentation providers must not import Drift tables, DAOs, or `AppDatabase`.
   - Repository/data layer owns persistence.

4. Domain models must stay UI-free.
   - No `IconData`, `Color`, localized labels, formatted dates, or formatted coin strings in domain/data models.

## Required Phase 3 Model Set

- `GenerationMode`
- `AiModel`
- `Template`
- `CatalogCategory`
- `CatalogResponse`
- `GenerationJob`
- `GenerationJobStatus`
- `CreateGenerationJobInput`
- `Asset`
- `BillingBalance`
- `CoinPackage`
- `CoinTransaction`

## Required Lowercase Ids

Modes:

- `photo`
- `video`
- `upscale`
- `avatar`
- `motion`

Model categories:

- `image`
- `video`
- `upscale`
- `avatar`
- `motion`

Job statuses:

- `draft`
- `validating`
- `queued`
- `running`
- `processing`
- `completed`
- `failed`
- `canceled`
- `refunded`

## Mock Runtime Rules

- Quote cost before job creation.
- Create reserves coins in mock billing state.
- Success path creates an output `Asset`.
- Failure path can be deterministic, for example prompt contains `fail`.
- Progress must be predictable for tests, for example `0 -> 15 -> 45 -> 80 -> 100`.
- Insufficient balance must be simulatable.
- Library should render from `GenerationJob + output Asset + catalog metadata`, not from presentation-only media cards as source of truth.

## Folder Guidance

Use feature-first folders:

```text
lib/features/tools/domain/
lib/features/tools/data/
lib/features/tools/presentation/providers/
lib/features/tools/presentation/view_models/

lib/features/generation_jobs/domain/
lib/features/generation_jobs/data/
lib/features/generation_jobs/presentation/providers/

lib/features/library/domain/
lib/features/library/data/
lib/features/library/presentation/providers/

lib/features/billing/domain/
lib/features/billing/data/
lib/features/billing/presentation/providers/
```

Keep shared infrastructure under:

```text
lib/core/api/
lib/core/database/
lib/core/storage/
```

## Implementation Guidance

- Slice A may use handwritten JSON parsing if generated files would make the first pass too large.
- If Freezed/json_serializable is deferred, document the reason and keep constructors/tests explicit.
- Billing balance should be the single source of truth for coin values.
- Secure storage remains an interface/stub until Phase 4 auth.
- Add tests for parsing, fixture integrity, mock job lifecycle, failed/refunded job, and insufficient balance.

## Product Acceptance Notes

- Phase 3 must type all five modes: `photo`, `video`, `upscale`, `avatar`, `motion`.
- Enabled in mock mode: `photo`, `video`, `upscale`.
- Enabled as demo/mock: `avatar`.
- `motion` should be `coming soon` or limited demo unless the owner explicitly confirms a full P0 mock lifecycle.
- Catalog must load through mock repository/Riverpod, not raw UI fixtures.
- Completed and failed jobs must appear in Library.
- Retry copy: `Повторить с теми же настройками`.
- Refund copy: `Генерация не завершилась. Койны возвращены на баланс.`
- Insufficient balance copy: `Недостаточно койнов для этой генерации`.
- Full Phase 3 closure requires history to survive restart. If Slice A stays in-memory, persistence remains an open Slice B gate.

## UI/UX Notes

- Preserve Phase 2 small-screen fixes while wiring async data.
- Replace remaining user-visible technical English where practical:
  - `mock-результат` -> `демо-результат`
  - `job` -> `задача`
  - `quote` -> `стоимость`
  - `backend` -> `сервер`
- Add job progress labels:
  - `В очереди`
  - `Генерируем`
  - `Сохраняем результат`
  - `Готово`
- Result Viewer needs pending/running/failed states, not only completed/not-found.
- Failed jobs should show refund/no-charge copy and retry action.

## Repo/CI Notes

- No commit or push without explicit user confirmation.
- Recommended commit split:
  - Phase 2 polish.
  - Phase 3 planning docs.
  - Phase 3 typed mock runtime.
  - Drift persistence if implemented separately.
- If Freezed/json_serializable/Drift generated files are introduced, either commit generated `*.freezed.dart`, `*.g.dart`, `*.drift.dart` files or update CI to run `dart run build_runner build --delete-conflicting-outputs`.
- Current CI does not run build_runner, so missing generated files would break analyze/test.
- Do not commit `.dart_tool`, `build`, APK/AAB/IPA, local DB files, signing files, or env secrets.

## Coordination Notes

- One code owner remains correct: Mobile Implementation.
- `docs/ACTIVE_SPRINT.md` is the live status surface.
- `docs/TASK_THREADS.md` remains the stable responsibility map.
- Future in-app task-agent/role-chat design stays out of Phase 3 implementation unless explicitly promoted.

## Pending

- QA manual Android smoke result.
- Mobile Implementation Slice A result.
- Product owner final confirmation for whether `motion` becomes full mock or remains coming soon.
- Product owner final confirmation on whether Slice A can be accepted before Slice B persistence.
