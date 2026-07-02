# Mobile Architecture

## Recommended Stack

- Flutter.
- Dart.
- Feature-first architecture with Clean Architecture-lite boundaries.
- go_router for navigation.
- Riverpod for state management and dependency injection.
- Dio for HTTP.
- Retrofit or OpenAPI-generated client when backend contracts are stable.
- Freezed + json_serializable for immutable models and JSON parsing.
- Drift/SQLite for local metadata, catalog snapshots, job history cache, and sync-ready records.
- flutter_secure_storage for auth tokens and sensitive local values.
- image_picker and file_picker for media inputs.
- cached_network_image for image previews.
- video_player for generated video playback.
- share_plus for native sharing.
- path_provider and permission_handler for file/cache/platform access.
- Firebase Cloud Messaging for push notifications when backend events are ready.
- in_app_purchase or RevenueCat for mobile coin purchases after billing policy is confirmed.
- Firebase Analytics or Amplitude for product analytics.
- Sentry or Firebase Crashlytics for crash reporting.

Why this stack:

- One Flutter codebase for Android and iOS.
- Strong mobile UI control and native-feeling performance.
- Mature packages for media, local storage, routing, payments, notifications, and platform permissions.
- Fits a media-heavy AI generation app better than a web-wrapper approach.
- Direct native escapes are still available through Swift/Kotlin only when packages are insufficient.

## Core Principle

The mobile app must never call AI providers directly.

Mobile app calls AllAI backend only. Backend owns:

- Provider API keys.
- Model/provider routing.
- Prompt and media moderation.
- Cost calculation.
- Coin reserve/final charge/refund.
- Queue dispatch.
- Provider retries/fallbacks.
- Asset storage.
- Billing and purchase verification.

## Layers

```text
Presentation
  -> Flutter screens/widgets
  -> Riverpod controllers/notifiers

Domain
  -> Entities
  -> Use cases
  -> Repository interfaces

Data
  -> Dio/Retrofit API clients
  -> DTOs and mappers
  -> Drift local database
  -> Secure storage
  -> Media/file services

Backend
  -> AllAI API
```

## Feature Modules

- `onboarding`: splash, first-run, legal/18+ gate.
- `auth`: login, registration, token refresh, logout.
- `home`: dashboard, active jobs, quick templates, recent results.
- `tools`: backend-driven model/tool catalog.
- `generator`: prompt/source/template/settings/cost flow.
- `generation_jobs`: job status, polling, active job persistence.
- `library`: history, saved results, prompt/settings reuse.
- `studio`: social drafts and publishing workflow.
- `billing`: coin balance, packages, purchase verification.
- `profile`: account, settings, legal, support.
- `core`: API, auth, storage, media, billing, analytics, errors.
- `shared`: widgets, constants, utils, theme.

## State Strategy

- Riverpod providers for dependency injection and app state.
- AsyncNotifier/Notifier for feature controllers.
- Dio interceptors for auth and request metadata.
- Drift for durable local metadata/history cache.
- flutter_secure_storage for auth tokens.
- File cache paths via path_provider.

## Offline Behavior

MVP:

- Cached catalog/history can be shown offline.
- New generation requires network.
- Failed submissions remain visible with retry.

Later:

- Sync outbox for draft and metadata changes.
- Conflict resolution for saved prompts/styles.

## Initial Repo Shape

```text
allaimobile/
  lib/
    main.dart
    app/
      app.dart
      router.dart
      theme/
      localization/
      config/
    core/
      api/
      auth/
      storage/
      media/
      billing/
      analytics/
      errors/
    features/
      onboarding/
      auth/
      home/
      tools/
      generator/
      studio/
      generation_jobs/
      library/
      billing/
      profile/
    shared/
      widgets/
      utils/
      constants/
  assets/
    images/
    icons/
  test/
  integration_test/
  docs/
  .env.example
  README.md
```
