# Phase 6 Contract Review: Image Generation MVP

Date: 2026-07-03.

Status: planning gates collected. Phase 6 implementation is on HOLD until Phase 5 final QA closure is recorded.

## Decision

Phase 6 should start with a narrow Slice A:

**Prompt-only Image Generation Loop + mock polling**

This slice should deliver:

- auth-gated prompt-only image generation;
- image-capable model/template selection from catalog state;
- quote/cost preview based on catalog cost and `availableCoins`;
- job creation with coin reservation;
- visible queued/running/processing/completed/failed states;
- restart-safe active job persistence;
- completed result in Result Viewer and Library;
- failed job retry with preserved prompt/settings;
- refund/no-charge copy and balance consistency;
- no live backend, provider SDK, provider key, direct AI provider call, real billing or IAP.

Image upload / image-to-image/edit remains **P0 for closing Phase 6 overall**, but should be Slice B unless Product explicitly asks to merge it into Slice A. Slice A should still define upload interfaces so the architecture is not boxed in.

## Role Gate Summary

| Role | Gate | Key decision |
|---|---|---|
| Product Lead | PASS | Prompt-only is enough for first implementation slice; upload/edit is P0 for full Phase 6 closure. |
| Backend Data | PASS | Use upload/job/status/asset contracts; create and status polling must be separate; signed upload URL is runtime-only. |
| Mobile Architecture | CONDITIONAL PASS | Replace `createAndRunJob` UI path with data-source/repository boundary and polling controller; persist active jobs. |
| UI UX | PASS | Prompt-only flow, quote/reserve copy, progress states, Result Viewer image rendering, Library states and retry copy defined. |
| QA Release | PASS | Android smoke matrix defined for prompt-only, upload, polling, restart, result, Library, failed retry and security scans. |
| Repo GitHub | CONDITIONAL PASS | Existing dependencies cover Phase 6 basics; platform permission story and CI hardening remain P1/P0-before-live risks. |
| Task Chat Logic | CONDITIONAL PASS | One code owner, status in `ACTIVE_SPRINT`, no task-agent scope, no live provider/billing work. |
| Mobile Implementation | PLAN READY | First slice and file-level plan are ready, but no code starts until gates/QA closure allow it. |

## Product Acceptance

P0:

- User selects available image-capable model/template.
- Prompt is required; empty prompt blocks submit.
- Cost preview uses selected model/catalog cost.
- Generation is blocked if `availableCoins < cost`.
- Submit creates image job and reserves coins.
- Job states shown: `queued`, `running`, `processing`, `completed`, `failed`.
- Active job survives restart/background.
- Completed job opens Result Viewer with generated image.
- Completed result appears in Library/history.
- Failed job preserves prompt/settings and shows retry.

P1:

- Prompt improvement.
- Multiple variants/batch generation.
- Advanced settings beyond catalog basics.
- Saved prompts/styles.
- Generated image as source for another flow.
- Rich edit/upscale chaining.
- Push/notifications for completion.

## Backend/Data Contract

### Upload URL

```ts
POST /v1/assets/upload-url

request: {
  fileName: string;
  mimeType: "image/jpeg" | "image/png" | "image/webp";
  sizeBytes: number;
  role: "input";
  clientRequestId: string;
}

response: {
  asset: Asset;
  upload: {
    method: "PUT" | "POST";
    url: string;
    headers?: Record<string, string>;
    fields?: Record<string, string>;
    expiresAt: string;
  };
  maxSizeBytes: number;
}
```

`upload.url`, `headers` and `fields` are runtime-only and must not be stored in Drift or logs.

### Create Job

```ts
POST /v1/generation/jobs

request: {
  modelId: string;
  templateId?: string;
  prompt: string;
  inputAssetIds?: string[];
  settings: Record<string, unknown>;
  clientRequestId: string;
}

response: {
  job: GenerationJob;
  reservedCoins: number;
}
```

`clientRequestId` must be durable for idempotency and retry safety.

### Job Status

```ts
GET /v1/generation/jobs/:jobId

response: {
  job: GenerationJob;
  assets: Asset[];
  pollAfterMs?: number;
}
```

Statuses:

- `validating`
- `queued`
- `running`
- `processing`
- `completed`
- `failed`
- `canceled`
- `refunded`

Error codes:

- `insufficient_balance`
- `model_unavailable`
- `template_unavailable`
- `invalid_prompt`
- `invalid_asset`
- `asset_not_ready`
- `content_rejected`
- `rate_limited`
- `unauthorized`
- `job_not_found`
- `generation_failed`
- `network_unavailable`
- `backend_contract_violation`

### Billing Mapping

- Create job: reserve coins, `reservedCoins += costCoins`.
- Completed: finalize charge, `coinBalance -= costCoins`, release reserve.
- Failed before usable output: release reserve; no charge or explicit refund.
- Insufficient balance: no job, no reservation, no transaction.

## Architecture Rules

P0:

- Mock runtime remains default.
- Live data sources are fail-closed without approved URL/config.
- Presentation does not import `MockAllAiApi`, `AppDatabase`, Drift, `Dio`, picker or file APIs.
- `createAndRunJob` must not be the Phase 6 UI path.
- Create job and polling/status refresh are separate.
- Active job is persisted to Drift immediately after creation.
- Result Viewer and Library read job/assets through repository/cache boundary.

Recommended boundaries:

```text
lib/core/media/
  media_picker_service.dart
  asset_file_service.dart

lib/features/generation_jobs/data/
  generation_api_data_source.dart
  mock_generation_api_data_source.dart
  disabled_live_generation_api_data_source.dart
  generation_cache_data_source.dart
  generation_repository.dart
  upload_api_data_source.dart
  mock_upload_api_data_source.dart
  disabled_live_upload_api_data_source.dart
  upload_repository.dart

lib/features/generation_jobs/presentation/providers/
  generation_job_controller.dart
  active_jobs_provider.dart
  result_providers.dart
```

Polling:

- bounded backoff, e.g. `2s -> 3s -> 5s -> 8s -> 13s`, cap 15-30 seconds;
- stop on terminal/dispose/logout;
- resume non-terminal jobs after restart;
- network/parse errors keep last valid job and show paused/stale/retry state.

## UI/UX Requirements

Prompt-only flow:

- `Фото` is the first default generation mode.
- Empty prompt copy: `Добавьте описание изображения`.
- CTA: `Запустить генерацию`.
- Loading: `Создаём задачу`.

Quote/reserve:

- `Стоимость: {cost} койнов`
- `Доступно: {available}`
- `Коины зарезервируются при запуске. Если генерация не завершится, мы вернём их автоматически.`
- `Недостаточно койнов: нужно {cost}, доступно {available}`

Progress:

- `Проверяем запрос`
- `Задача в очереди`
- `Генерируем изображение`
- `Сохраняем результат`
- `Готово`

Failure/retry:

- `Генерация не завершилась. Настройки сохранены.`
- `Коины возвращены на баланс.`
- `Списание не выполнено.`
- `Повторить с теми же настройками`
- `Изменить промпт`

Result Viewer:

- render real image/thumbnail, not icon placeholder;
- actions: `Сохранить`, `Поделиться`, `Повторить`, `Использовать как источник`;
- future edit/upscale actions hidden or disabled with `Скоро`.

Library:

- show thumbnail, status, model/template, date and cost;
- active cards show progress/status;
- failed cards show retry and refund/no-charge copy;
- no visible `mock`, `GenerationJob`, `Asset` or backend wording.

## QA Matrix

Required checks after implementation:

- prompt-only image generation happy path;
- empty/long prompt validation;
- insufficient balance blocks before job creation;
- job creation shows queued/running/processing/completed/failed without infinite loading;
- active job survives force-stop/relaunch or restores into a clear state;
- completed result opens Result Viewer and persists in Library after restart;
- failed job keeps prompt/settings and retry path;
- balance remains consistent after success/failure;
- auth gate remains enforced;
- source/log/APK scans show no secrets/provider endpoints/direct provider calls;
- Phase 3/4/5 regressions remain green.

Required commands:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug`
- source scans for secrets/provider SDK/direct provider URLs/billing markers.

## Repo / Platform Risks

- `image_picker`, `file_picker`, `dio`, `path_provider`, `share_plus`, `cached_network_image` already exist.
- Android release `main` manifest currently needs review for `INTERNET` before live backend/upload.
- iOS needs `NSPhotoLibraryUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryAddUsageDescription` before picker/camera/save-to-photos release behavior.
- CI still needs build_runner dirty-check, Android debug build and secret scan.
- Do not stage build/cache/APK/local DB/env/signing artifacts.
- Keep Phase 5 Slice C and Phase 6 planning/implementation in separate commits.

## Implementation HOLD Conditions

Do not start Phase 6 app-code implementation until:

- Phase 5 final QA closure is recorded.
- Coordinator dispatches Phase 6 Slice A explicitly to Mobile Implementation.
- No real backend/provider/billing scope has been added without approval.
- Current uncommitted Phase 5 Slice C changes are understood and not mixed accidentally with Phase 6 implementation.
