# Backend API Audit - 2026-07-15

Source: `https://api.allai.market/swagger/index.html#/`

Swagger document: `https://api.allai.market/swagger/doc.json`

API base path: `https://api.allai.market/api/v1`

## Available For Mobile

- Email sign-up, sign-in, password management, refresh and sign-out.
- Google identity-token authentication.
- Current model catalog through `GET /models`.
- Authenticated multipart upload through `POST /uploads`.
- Generation creation, history, item lookup and SSE status stream.
- User profile and coin balance.
- Coin package list and existing web payment checkout methods.
- Notifications with SSE updates.
- Pinterest, TikTok and YouTube account/publishing endpoints.
- Prompt enhancement and its pricing.

The live `GET /api/v1/models` request returned 34 models during this audit. Its
actual payload already contains stable `slug`, `name`, `type`, pricing rules,
formats, dynamic params and `promptMaxChars`. This endpoint should be the source
of truth for generator capabilities rather than a hardcoded mobile list.

## Content Card Integration

The backend now exposes a public read-only endpoint:

```http
GET /api/v1/content/cards?surface=mobile&locale=ru
```

It returns card metadata and Google Storage media URLs. Mobile renders the
records with its own Flutter UI. Website may request `surface=web` or use the
same records with a different renderer.

Observed response headers include:

- `Cache-Control: public, max-age=300, stale-while-revalidate=86400`.
- `ETag: "content-2026-07-15.2-mobile-ru-home.showcase.explore"`.

Observed top-level fields are `version`, `surface`, `locale` and `sections`.
Observed sections include `home`, `showcase` and `explore`.

Required response metadata:

- `schemaVersion`, `contentVersion`, `publishedAt` and cache validators.
- Stable card ID, type, localized title/subtitle and display order.
- `imageUrl`, optional `videoUrl` and thumbnail URL.
- Action type plus stable model/template target ID.
- Category, badge, enabled state and optional publication dates.
- Surface targeting for shared, web-only or mobile-only records.

The endpoint may serve a backend-generated manifest stored in Google Cloud
Storage/CDN. The manifest should be published only after all versioned media is
available.

## Contract Gaps

### Swagger Does Not Match Live Models

The documented `ModelInfo` contains `cost`, but the live response uses a nested
`pricing` object with `kind`, `base`, `unitParam`, `unitDefault` and `matrix`.
The live response also contains `slug` and `promptMaxChars`, which are absent
from the documented schema.

The OpenAPI document must be regenerated from the current server models before
mobile client generation. Until then, mobile should use reviewed fixtures and a
manual DTO rather than treating Swagger as authoritative.

### Generation Request Schema Is Ambiguous

Swagger describes `CreateGenerationReq.params` as `integer[]`, while `/models`
publishes named heterogeneous parameters such as strings, booleans, integers
and URL arrays. The generation request needs a documented object/map schema and
real request examples for image, video, avatar, upscale and motion use cases.

### Model Presentation Metadata Is Missing

`GET /models` supplies generation capabilities but not presentation metadata
such as thumbnail, description, display order, badge, availability reason or
mobile category beyond broad `image`/`video` types. These belong either in the
content-card feed or in additive public model fields.

### Apple Authentication Is Missing

Google authentication exists as `POST /auth/google`, but no Apple identity-token
endpoint is documented. iOS requires a backend endpoint such as
`POST /auth/apple` that verifies Apple credentials and returns the same AllAi
session contract.

### Refresh Transport Is Undocumented

`POST /auth/refresh` has no documented request body, cookie requirement or
security declaration. Mobile needs an explicit refresh-token transport and
rotation/revocation policy. Tokens must be compatible with secure device
storage, not depend solely on browser cookie behavior.

### Upload Is Not Optimized For Mobile Video

`POST /uploads` proxies multipart files through the API and documents a 20 MB
limit. This may be acceptable for images but is restrictive for source videos.
Prefer a signed/resumable Google Storage upload flow for larger files, followed
by backend finalization that returns a stable asset ID.

### Store Billing Is Missing

Existing Stripe, YooKassa and crypto checkouts are web payment methods. Mobile
coin purchases need App Store and Google Play product mapping plus backend
receipt verification and idempotent crediting. Web checkout must not replace
native in-app purchase where store policy requires IAP.

### Cache Validators Are Missing

The observed `/models` response did not include `ETag` or `Cache-Control`.
Catalog and card responses should expose version/cache metadata so clients can
refresh frequently without downloading unchanged payloads.

## Recommended Integration Order

1. Backend regenerates and approves the OpenAPI contract.
2. Backend adds the content-card feed backed by current Storage media.
3. Mobile connects read-only `/models`, cards and package endpoints with cache.
4. Mobile connects email/Google auth after refresh-token behavior is defined.
5. Backend adds Apple auth and mobile store purchase verification.
6. Mobile connects uploads, generation creation, SSE progress and history using
   backend-provided integration fixtures and a staging account.

## Required Backend Handoff

- Correct current OpenAPI JSON.
- Example card response and actual Google Storage/CDN URL rules.
- Example generation requests for every model family.
- Refresh-token transport, lifetime and rotation rules.
- Staging account and low-cost test model.
- Apple Sign-In plan.
- App Store and Google Play purchase verification plan.
- Error response schema and stable error codes.
