# Phase 6 Slice A Execution Brief: Prompt-Only Image Generation Loop

Date: 2026-07-03.

Status: dispatched to Mobile Implementation.

## Goal

Implement the first image generation value loop in mock-default mode:

1. User selects an available image-capable model/template.
2. User enters a prompt.
3. App shows cost and available balance.
4. App creates a generation job.
5. App shows visible queued/running/processing/completed/failed states through polling.
6. Active job is persisted and can recover after reconstruction/restart.
7. Completed job opens Result Viewer with image output.
8. Completed job appears in Library.
9. Failed job keeps prompt/settings and offers retry with refund/no-charge copy.

## Scope

In:

- prompt-only image generation;
- mock-default generation API boundary;
- fail-closed live generation/upload skeletons without URL or credentials;
- create job separated from status polling;
- active job persistence through existing Drift jobs/assets where possible;
- Result Viewer image/thumbnail rendering for mock image assets;
- Library active/completed/failed image job states;
- retry path for failed prompt-only jobs;
- tests for repository/controller/widget/persistence boundaries;
- source scans for secrets/provider SDK/direct provider calls.

Out:

- real backend URL or credentials;
- direct provider SDKs/keys/calls;
- real billing/IAP;
- image upload/image-to-image/edit implementation;
- broad Android/iOS media permissions;
- push notifications;
- social publishing;
- task-chat/agent user-facing features.

## Required Implementation Rules

- Preserve current local uncommitted Phase 5 Slice C changes and docs.
- Do not commit or push.
- Do not add live backend config.
- Do not add provider SDKs or provider keys.
- Do not add real billing/IAP.
- Presentation screens/widgets must not import `Dio`, `AppDatabase`, Drift, picker/file APIs or `MockAllAiApi`.
- `createAndRunJob` must not remain the user-facing Phase 6 path.
- Job creation and status polling must be separate operations.
- Active jobs must be persisted before polling begins.
- Network/parse/mock errors must keep the last valid job state where possible.
- Upload interfaces may be shaped for future Slice B, but upload UI should remain hidden or disabled with user-facing copy.

## Suggested File Areas

- `lib/features/generation_jobs/domain/generation_job_models.dart`
- `lib/features/generation_jobs/data/generation_repository.dart`
- `lib/features/generation_jobs/data/generation_api_data_source.dart`
- `lib/features/generation_jobs/data/mock_generation_api_data_source.dart`
- `lib/features/generation_jobs/data/disabled_live_generation_api_data_source.dart`
- `lib/features/generation_jobs/data/generation_cache_data_source.dart`
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/features/library/data/library_repository.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/core/api/mock_allai_api.dart`
- tests under `test/`

Only add new files where they reduce coupling or match existing feature boundaries.

## UX Copy

- Empty prompt: `Добавьте описание изображения`.
- CTA: `Запустить генерацию`.
- Loading: `Создаём задачу`.
- Cost: `Стоимость: {cost} койнов`.
- Balance: `Доступно: {available}`.
- Reserve: `Коины зарезервируются при запуске. Если генерация не завершится, мы вернём их автоматически.`
- Insufficient: `Недостаточно койнов: нужно {cost}, доступно {available}`.
- Progress:
  - `Проверяем запрос`
  - `Задача в очереди`
  - `Генерируем изображение`
  - `Сохраняем результат`
  - `Готово`
- Failure: `Генерация не завершилась. Настройки сохранены.`
- Refund: `Коины возвращены на баланс.`
- No charge: `Списание не выполнено.`
- Retry: `Повторить с теми же настройками`.
- Edit prompt: `Изменить промпт`.

## Tests And Checks

Add or update tests for:

- prompt validation blocks empty prompt;
- insufficient `availableCoins` blocks job creation;
- create job reserves coins;
- polling progresses through non-terminal states and stops on terminal state;
- failed job releases/refunds coins and preserves prompt/settings;
- active job survives repository/controller reconstruction;
- completed job appears in Result Viewer and Library;
- failed job retry path is visible;
- presentation import scan remains clean.

Required commands after implementation:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug`
- source scans for provider SDKs, secrets, direct provider URLs/calls and billing/IAP markers.

## Handoff Result Required

Mobile Implementation should return:

- touched files;
- behavior implemented;
- tests added/updated;
- command results;
- source scan results;
- Android build result;
- remaining blockers/follow-ups;
- explicit confirmation that no commit/push was performed.
