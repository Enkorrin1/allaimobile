# AllAi Mobile App: Product Spec

## 1. Product Summary

AllAi Mobile App is a native-feeling Android/iOS application for creating AI photos, videos, upscales, avatars, motion clips, and social-ready creative assets from prompts, uploaded media, and ready-made templates.

The app should behave as the mobile product version of:

- https://allai.market/ru/landing
- https://allai.market/ru/generator
- https://allai.market/ru/pricing
- https://allai.market/ru/studio

Core promise: one mobile workspace for AI creation, from idea to generated asset to saved history and sharing.

## 2. Product Goals

P0 goals:

- Let users create AI images and AI videos from a prompt or uploaded source.
- Support all generation models exposed by the AllAi backend configuration.
- Provide ready-made creative scenarios and templates from the website.
- Show coin balance, generation price, job progress, and final result.
- Save all generations in history/library.
- Let users download and share generated assets.
- Keep AI/provider secrets on backend only, never in the mobile app.

P1 goals:

- Saved prompts, favorite models, favorite templates, and saved styles.
- Push notifications for long video jobs.
- Social Studio drafts for TikTok, YouTube Shorts, Pinterest, Reels.
- RU/EN localization.
- In-app purchase or approved payment flow for coin packages.

P2 goals:

- Team balances and spend limits.
- Scheduled publishing.
- Brand safety policies, audit logs, watermark/compliance mode.
- Advanced video editor/timeline.
- Community templates.

## 3. Target Users

- Creators who need fast social images/videos.
- E-commerce sellers who need product UGC, try-on, lifestyle, unboxing, and demo creatives.
- Agencies and marketers creating ads, reels, shorts, pins, and campaign variants.
- Casual users experimenting with cinematic portraits, avatars, motion, and effects.

## 4. Source Product Signals

From the public AllAi pages:

- Landing positions AllAi as one workflow for images, video, text, and voice.
- Landing advertises 28 AI models, 6 content formats, and publishing to 3 social networks.
- Generator page exposes content formats: Photo, Video, Upscale, Avatars, Motion.
- Generator page lists video models such as Kling, Seedance, Grok Video, Gemini Omni, Wan, Hailuo, Veo, Runway, and Sora.
- Pricing page uses coin packages and says coins do not expire.
- Pricing page references generators such as Nano Banana, Kling, Seedream, Grok Image, Topaz Upscale, Flux, and Wan 2.7 Image.
- Studio page focuses on social publishing workspace for Pinterest, YouTube, TikTok, and multi-post flows.

The mobile app should not hardcode the final model list. It should fetch model/catalog configuration from backend.

## 5. MVP Scope

### P0 Features

1. Authentication
   - Login.
   - Registration.
   - Password reset entry point.
   - Legal consent: privacy, terms, 18+ confirmation.

2. Home
   - Balance chip with coin count.
   - Quick start templates.
   - Recent generations.
   - Primary CTA: Create.
   - Model/category shortcuts: Photo, Video, Upscale, Avatars, Motion.

3. Model Catalog
   - Categories: Image, Video, Upscale, Avatar, Motion.
   - Model cards with name, short description, supported inputs, output type, estimated cost.
   - Search and category filter.
   - Backend-driven model availability.

4. Templates/Scenarios
   - UGC, Product UGC Hook, Social Hook Cut, Beauty Hook, Try-On, Unboxing, Cinema-style presets.
   - Template details: examples, required inputs, default prompt/settings, target format.

5. Generation Flow
   - Prompt input.
   - Prompt improvement action.
   - Upload image/product/reference.
   - Model selection.
   - Settings by model: aspect ratio, duration, quality, seed, reference strength when supported.
   - Coin cost preview before submit.
   - Submit generation job.

6. Job Status
   - Pending, queued, running, processing, completed, failed, canceled, refunded.
   - Progress when backend supports it.
   - Clear error message and retry action.
   - User can leave screen while job continues.

7. Result Viewer
   - Fullscreen preview.
   - Compare source/result when relevant.
   - Download.
   - Share.
   - Repeat.
   - Edit/upscale/use as video source.

8. Library/History
   - All previous generation jobs.
   - Filters: image/video/upscale/avatar/motion, success/failed.
   - Open result.
   - Reuse prompt/settings.

9. Coins/Pricing
   - Coin balance.
   - Package list from backend.
   - Insufficient balance state.
   - Purchase entry point.
   - Transaction history entry point.

10. Profile/Settings
    - Account data.
    - Language.
    - Notifications.
    - Legal links.
    - Delete/logout entry points.

### Out Of MVP

- Direct publishing to social networks.
- Team accounts.
- Full timeline video editor.
- Advanced brand compliance.
- Public template marketplace.
- Offline generation.

## 6. Recommended Stack

### Mobile

- Flutter.
- Dart.
- go_router for navigation.
- Riverpod for state management and dependency injection.
- Dio for HTTP.
- Retrofit or OpenAPI-generated client when backend contracts are stable.
- Freezed + json_serializable for immutable models and JSON parsing.
- Drift/SQLite for local metadata/history cache.
- flutter_secure_storage for auth tokens.
- image_picker and file_picker for uploads.
- cached_network_image for image previews.
- video_player for generated video playback.
- share_plus for native sharing.
- path_provider and permission_handler for file/cache/platform access.
- Firebase Cloud Messaging for job completion notifications when backend push events are ready.
- in_app_purchase or RevenueCat for coin purchases after billing policy is confirmed.
- intl/flutter_localizations for localization.

Why Flutter:

- One codebase for Android and iOS.
- Strong native-feeling UI and performance for media-heavy workflows.
- Mature packages for media, storage, payments, notifications, analytics, and platform permissions.
- Clean path to Android/iOS release builds with Fastlane, Codemagic, GitHub Actions, or Flutter tooling.

### Backend Boundary

The mobile app must call AllAi backend only. It must not call Kling, Sora, Veo, Flux, Runway, OpenAI, Replicate, Fal, or any provider directly.

Backend responsibilities:

- Store provider API keys.
- Normalize model catalog.
- Validate inputs.
- Moderate prompts/assets.
- Calculate cost.
- Reserve and charge coins.
- Dispatch generation jobs.
- Store asset URLs.
- Send push events/webhooks.
- Handle billing, refunds, and audit.

### Repo

Recommended initial repo shape:

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
    PROJECT_SPEC.md
    API_CONTRACTS.md
    QA_CHECKLIST.md
  .env.example
  README.md
```

## 7. Architecture

### High-Level Layers

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
  -> AllAi API

Local Storage
  -> flutter_secure_storage for tokens
  -> Drift/SQLite for cached jobs/catalog/history
  -> File cache for downloaded previews
```

### Feature Modules

- onboarding: splash, first-run, legal/18+ gate.
- auth: login, registration, token refresh, logout.
- tools: models, categories, templates, model capabilities.
- generator: form builder, validation, job creation, polling, result actions.
- generation_jobs: job status, polling, active job persistence.
- library: history, saved results, prompt reuse.
- billing: coin balance, packages, purchase status.
- studio: future social drafts and publishing workflow.
- profile: account, settings, legal.

### State Strategy

- Riverpod providers for dependency injection and app state.
- AsyncNotifier/Notifier for feature controllers.
- Dio interceptors for auth and request metadata.
- Drift/SQLite for durable local metadata/history cache.
- flutter_secure_storage for auth secrets.

### Offline Strategy

MVP:

- App can show cached catalog/history when offline.
- New generation requires network.
- Failed submissions remain visible with retry.

Later:

- Outbox for queued actions.
- Sync conflict handling for drafts/saved prompts.

## 8. Core Screens

### Auth Stack

1. Welcome
   - Brand, short product promise, continue/login CTA.

2. Login
   - Email/password or available auth providers.
   - Forgot password.
   - Link to registration.

3. Registration
   - Email/password.
   - Legal consent and 18+ checkbox.

### Main Tabs

Recommended bottom tabs:

1. Home
2. Create
3. Library
4. Studio
5. Profile

### Home

Purpose: fast entry into creation.

Content:

- Coin balance.
- Continue latest job if active.
- Quick scenarios.
- Model shortcuts.
- Recent results.

States:

- Empty: show starter templates.
- Loading: skeleton cards.
- Error: retry catalog.
- Active job: persistent job card.

### Create

Purpose: central generation workspace.

Subsections:

- Format switch: Photo, Video, Upscale, Avatars, Motion.
- Model selector.
- Template selector.
- Prompt/reference input.
- Advanced settings drawer.
- Cost preview and generate CTA.

Important UX:

- Mobile first: one primary form, not a landing page.
- Keep prompt input sticky near CTA.
- Show required inputs before allowing submit.
- Show unsupported settings disabled with explanation.

### Model Catalog

Purpose: browse all AI models.

Content:

- Category filters.
- Model cards.
- Model detail bottom sheet.
- "Use model" CTA.

### Template Detail

Purpose: start from a scenario.

Content:

- Preview media.
- What you get.
- Required inputs.
- Default model.
- Estimated cost.
- CTA: Use template.

### Generation Status

Purpose: job progress.

Content:

- Job state.
- Model/template.
- Prompt.
- Estimated wait.
- Cancel/retry when available.
- Push notification suggestion for long video jobs.

### Result Viewer

Purpose: inspect and act on output.

Content:

- Fullscreen image/video preview.
- Actions: save, share, repeat, edit, upscale, use as source.
- Metadata: model, cost, date, prompt.

### Library

Purpose: history and reuse.

Content:

- Grid/list of generated assets.
- Filters.
- Search by prompt/template/model.
- Failed jobs tab.

### Studio

MVP:

- Draft placeholder for social content workflow.
- Create social-ready asset from template.
- Save caption/draft locally or via backend if available.

P1:

- TikTok/YouTube/Pinterest/Reels drafts.
- Multi-post planner.
- Export package.

### Pricing

Purpose: coin purchase.

Content:

- Balance.
- Packages.
- Benefits.
- Purchase state.
- Restore purchases.

Important:

- For mobile stores, digital coin purchases likely require Apple/Google in-app purchase unless legally reviewed and approved otherwise.

### Profile/Settings

Content:

- Account.
- Language.
- Notifications.
- Legal links.
- Support.
- Delete account.
- Logout.

## 9. Domain Model

### User

```ts
type User = {
  id: string;
  email: string;
  displayName?: string;
  locale: "ru" | "en";
  coinBalance: number;
  createdAt: string;
};
```

### Model

```ts
type AiModel = {
  id: string;
  name: string;
  providerLabel?: string;
  category: "image" | "video" | "upscale" | "avatar" | "motion";
  description: string;
  supportedInputs: Array<"prompt" | "image" | "video" | "reference">;
  supportedOutputs: Array<"image" | "video">;
  capabilities: {
    aspectRatios?: string[];
    durations?: number[];
    qualityLevels?: string[];
    seed?: boolean;
    negativePrompt?: boolean;
    referenceStrength?: boolean;
  };
  isAvailable: boolean;
  cost: {
    minCoins: number;
    maxCoins?: number;
  };
};
```

Mobile receives public model metadata only. Provider routing keys, credentials, SDK configuration, and fallback logic remain backend-only.

### Template

```ts
type Template = {
  id: string;
  title: string;
  category: "ugc" | "cinema" | "try_on" | "unboxing" | "beauty" | "social_hook";
  description: string;
  previewUrl: string;
  defaultModelId: string;
  defaultPrompt: string;
  requiredInputs: Array<"prompt" | "product_image" | "person_image" | "reference_image">;
  outputFormat: "image" | "video";
  targetAspectRatio?: "9:16" | "1:1" | "16:9" | "4:5";
};
```

### Generation Job

```ts
type GenerationJob = {
  id: string;
  userId: string;
  modelId: string;
  templateId?: string;
  status:
    | "draft"
    | "validating"
    | "queued"
    | "running"
    | "processing"
    | "completed"
    | "failed"
    | "canceled"
    | "refunded";
  prompt: string;
  inputAssetIds: string[];
  outputAssetIds: string[];
  settings: Record<string, unknown>;
  costCoins: number;
  progress?: number;
  errorCode?: string;
  errorMessage?: string;
  createdAt: string;
  updatedAt: string;
};
```

### Asset

```ts
type Asset = {
  id: string;
  type: "image" | "video";
  role: "input" | "output" | "thumbnail";
  url: string;
  thumbnailUrl?: string;
  width?: number;
  height?: number;
  durationSec?: number;
  mimeType: string;
  sizeBytes?: number;
  createdAt: string;
};
```

## 10. API Contracts

### Catalog

```http
GET /v1/mobile/catalog
```

Returns:

```ts
type CatalogResponse = {
  models: AiModel[];
  templates: Template[];
  categories: Array<{ id: string; title: string; order: number }>;
  updatedAt: string;
};
```

### Create Upload

```http
POST /v1/assets/upload-url
```

Request:

```ts
type CreateUploadUrlRequest = {
  fileName: string;
  mimeType: string;
  sizeBytes: number;
  role: "input";
};
```

### Create Generation Job

```http
POST /v1/generation/jobs
```

Request:

```ts
type CreateGenerationJobRequest = {
  modelId: string;
  templateId?: string;
  prompt: string;
  inputAssetIds?: string[];
  settings: Record<string, unknown>;
  clientRequestId: string;
};
```

Response:

```ts
type CreateGenerationJobResponse = {
  job: GenerationJob;
  reservedCoins: number;
};
```

### Read Job

```http
GET /v1/generation/jobs/:jobId
```

Returns:

```ts
type GenerationJobResponse = {
  job: GenerationJob;
  assets: Asset[];
};
```

### History

```http
GET /v1/generation/jobs?cursor=...&type=image|video|upscale|avatar|motion
```

### Balance And Pricing

```http
GET /v1/billing/balance
GET /v1/billing/packages
POST /v1/billing/purchases/verify
```

## 11. Job Lifecycle

```text
draft
  -> validating
  -> queued
  -> running
  -> processing
  -> completed

Any non-final state can become:
  -> failed
  -> canceled
  -> refunded
```

Rules:

- Cost is shown before submit.
- Backend reserves coins on job creation.
- Coins are finalized only when provider accepts the job or according to billing policy.
- If provider fails before usable output, job should become failed/refunded or failed/no_charge.
- Mobile UI must never assume provider success from submit alone.

## 12. Safety, Privacy, And Compliance

Must-have:

- API keys stay server-side.
- Auth tokens stored in flutter_secure_storage.
- Uploaded media is private by default.
- User can delete account and request asset deletion.
- Prompt/media moderation before provider dispatch.
- App must handle AI-generated content policy requirements.
- Report/block flow if public/community content appears later.
- Store billing for digital coins must be reviewed for Apple/Google IAP compliance.

Sensitive cases:

- NSFW.
- Minors.
- Celebrity/public figure likeness.
- Political/deceptive content.
- Brand/logo misuse.
- Face swap/identity manipulation.

## 13. Analytics

Events:

- app_open
- signup_start/signup_complete
- login_success/login_failed
- catalog_view
- model_view
- template_view
- generation_start
- generation_success
- generation_failed
- generation_retry
- result_download
- result_share
- pricing_view
- purchase_start
- purchase_success
- purchase_failed

Each event should include non-sensitive metadata:

- modelId
- templateId
- contentType
- status
- costCoins
- durationMs
- errorCode

Do not log raw prompts, private uploaded images, secrets, or provider responses with sensitive data.

## 14. QA Acceptance

MVP is acceptable when:

- App launches on Android and iOS.
- User can login/register.
- Catalog loads from backend.
- User can create image job and video job.
- Long-running job survives app background/foreground.
- Result is saved in history.
- Result can be downloaded/shared.
- Insufficient coin balance blocks generation before submit.
- Failed generation shows understandable error and retry/refund status.
- Tokens are not stored in plain text.
- No provider secrets are present in mobile app bundle or repository.

Smoke tests:

- Auth happy path.
- Auth wrong password.
- Catalog empty/error.
- Image prompt generation.
- Image upload generation.
- Video prompt generation.
- Video image-to-video generation.
- Upscale existing image.
- Insufficient balance.
- Job failure.
- App restart with active job.
- Download/share result.
- Logout.

## 15. Implementation Milestones

Milestone 1: Foundation

- Initialize Flutter app.
- Add Dart routing, theme, linting/analyzer configuration.
- Add auth shell and tab navigation.
- Add mocked catalog and generation screens.

Milestone 2: Core UI

- Home.
- Create flow.
- Model catalog.
- Template details.
- Status/result screens.
- Library.
- Pricing/profile placeholders.

Milestone 3: Backend Integration

- Auth API.
- Catalog API.
- Upload API.
- Generation job API.
- Polling and local cache.
- Balance/pricing API.

Milestone 4: Mobile Polish

- Push notifications for job done.
- Media download/share.
- Error states.
- Localization RU/EN.
- QA smoke pass on Android/iOS.

Milestone 5: Store Readiness

- IAP/payment decision.
- Privacy and legal flows.
- Store metadata.
- Build pipelines.
- Release checklist.

## 16. Open Decisions

- Confirm exact backend API availability.
- Confirm final list of models and per-model capabilities.
- Confirm whether mobile coin purchases use Apple/Google IAP.
- Confirm launch countries and languages.
- Confirm whether Social Studio is MVP or P1.
- Confirm whether app needs team accounts in first release.
- Confirm media retention/deletion policy.
- Confirm moderation policy and rejected-content UX.
