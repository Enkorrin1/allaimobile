# Phase 6 Slice A Result: Prompt-Only Image Generation Loop

Date: 2026-07-03.

Status: completed locally by Mobile Implementation. No commit or push performed.

## Behavior Implemented

- Prompt-only image generation now uses available image-capable catalog model/template selection.
- Prompt is required before submit; empty prompt shows `Добавьте описание изображения` and disables CTA.
- Quote uses selected model catalog cost and billing `availableCoins`.
- Insufficient balance blocks generation with `Недостаточно койнов: нужно {cost}, доступно {available}`.
- CTA copy is `Запустить генерацию`; loading copy is `Создаём задачу`.
- User-facing Phase 6 path creates a job first, then polls status separately; `createAndRunJob` is no longer used.
- Active jobs are persisted through the existing mock API/Drift job path before polling begins.
- Polling shows visible states: `Проверяем запрос`, `Задача в очереди`, `Генерируем изображение`, `Сохраняем результат`, `Готово`.
- Failed jobs preserve prompt/settings and show retry copy plus refund/no-charge copy.
- Result Viewer renders mock image assets through an image preview instead of only a placeholder icon.
- Library shows active/completed/failed generation items with status, model/template/date/cost and image preview where available.
- Upload API interfaces were shaped for future Slice B, but active upload/image-to-image UI remains disabled with user-facing copy.

## Touched Files

- `lib/core/api/mock_allai_api.dart`
- `lib/features/generation_jobs/data/generation_api_data_source.dart`
- `lib/features/generation_jobs/data/generation_data_providers.dart`
- `lib/features/generation_jobs/data/generation_repository.dart`
- `lib/features/generation_jobs/data/upload_api_data_source.dart`
- `lib/features/generation_jobs/presentation/providers/generation_job_providers.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- `lib/shared/widgets/result_action_bar.dart`
- `test/phase3_contract_test.dart`
- `test/phase6_image_generation_test.dart`
- `test/widget_test.dart`
- `docs/PHASE_6_SLICE_A_RESULT.md`

## Tests Added / Updated

- Added `test/phase6_image_generation_test.dart` for prompt-only create, polling success, failure/refund preservation and active job reconstruction.
- Updated Phase 3 generation tests to use explicit create + poll instead of `createAndRunJob`.
- Updated widget tests for prompt validation, insufficient available coins, failed retry copy, Result Viewer image rendering and existing navigation regressions.

## Checks

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .` - PASS, 87 files, 0 changed.
- `D:\flutter\bin\flutter.bat analyze` - PASS, no issues.
- `D:\flutter\bin\flutter.bat test` - PASS, 46/46.
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug` - PASS.
- APK: `build\app\outputs\flutter-apk\app-debug.apk`.

## Scans

- Source/test/pubspec scan for provider SDKs, secrets, direct provider URLs/calls and billing/IAP markers - PASS for Slice A changes.
- Expected pre-existing scan findings remain outside Slice A scope: Flutter/pubspec comments with documentation URLs, `Env.apiBaseUrl` default `https://allai.market`, existing `Dio` dependency/client, auth `Bearer` mock/test values, and pre-existing picker dependencies in `pubspec.yaml`.
- Presentation import scan for `Dio`, `AppDatabase`, Drift, picker/file APIs and `MockAllAiApi` - PASS, no matches.
- Legacy user-facing path scan for `createAndRunJob`, `advanceJob(` and `valueOrNull` - PASS, no matches.

## Blockers / Follow-Ups

- Full image upload/image-to-image remains Slice B; no broad media permissions were added.
- Save/share actions are still safe placeholders; production file/photo-save behavior needs a later platform permission gate.
- Phase 5 remaining Android smoke follow-up is still a QA/P1 item from the prior closure note.
- iOS/macOS verification remains untested on this Windows machine.
