# Backend Content Sync

## Decision

AllAi backend is the single source of truth for product data shared by the
website, bots, Android and iOS. Each client renders that data using its own
native presentation layer.

The mobile application must not scrape the website or duplicate the website's
content manually. The website and mobile application consume the same stable
public IDs and published content records.

The shared part is the card content feed, not the website layout. Mobile owns
its screens, navigation, card components, spacing, typography and interactions.
The same content record may be rendered differently on web and mobile.

## Chosen Card Synchronization

The publisher creates a versioned card manifest and uploads referenced media to
Google Cloud Storage. Website and mobile read the same published manifest but
render it with their own UI.

```text
Content update
    -> upload versioned image/video to Google Cloud Storage
    -> validate card references
    -> publish manifest.json last
    -> website and mobile refresh the manifest
    -> each client renders its own card component
```

Example public manifest location:

```text
https://cdn.allai.market/content/cards/v1/manifest.json
```

The exact host may be a CDN in front of Google Cloud Storage. The manifest is a
published artifact; generation jobs, authentication and billing still use the
backend API.

```ts
type CardManifest = {
  schemaVersion: 1;
  contentVersion: string;
  publishedAt: string;
  cards: ContentCard[];
};

type ContentCard = {
  id: string;
  type: "template" | "effect" | "model" | "promo";
  surfaces: Array<"web" | "mobile">;
  title: Record<string, string>;
  subtitle?: Record<string, string>;
  media: {
    imageUrl: string;
    videoUrl?: string;
    thumbnailUrl?: string;
  };
  action: {
    type: "template" | "model" | "generator";
    targetId: string;
  };
  categoryId?: string;
  badge?: Record<string, string>;
  order: number;
  isEnabled: boolean;
  startsAt?: string;
  endsAt?: string;
};
```

`surfaces` allows one publication to contain shared cards plus web-only or
mobile-only cards. This avoids forcing the mobile application to reproduce all
website content.

### Refresh Rules

- Fetch the manifest on cold start and whenever the app returns to foreground.
- Support pull-to-refresh on content screens.
- Use `ETag` and `If-None-Match`; a `304` response keeps the current snapshot.
- Cache the last valid manifest locally for offline startup.
- Ignore unknown card types and invalid individual cards instead of breaking
  the whole screen.
- Keep manifest cache short, for example `no-cache` or `max-age=30`.
- Keep versioned media cache long, for example one year with `immutable`.

Publishing must be atomic: upload all new media first and replace the manifest
only after every referenced URL is ready. Never overwrite an existing image at
the same URL; publish a new versioned path to avoid stale CDN/mobile caches.

## What Updates Without An App Release

- AI models, formats and model capabilities.
- Model availability, maintenance state and user-facing availability reason.
- Coin prices and generation constraints.
- Templates, effects, presets and their default prompts/settings.
- Home collections, titles, ordering and featured items.
- Preview images, videos and other creative media.
- Promotional banners and paywall packages when allowed by store policy.
- Localized content for all supported locales.
- Feature flags and gradual rollout rules.

## What Requires An App Release

- Navigation and new screen types.
- New interactive controls unsupported by the current renderer.
- Design system, typography, animation and native interaction changes.
- New permissions, native SDKs or platform capabilities.
- Breaking API contract changes.

The backend may change content and composition, but it must not remotely ship
arbitrary UI code. Mobile owns the visual quality and accessibility of the UI.

## Shared Backend Shape

Use one domain backend and separate public client contracts when presentation
needs differ:

```text
Admin/CMS
    -> AllAi domain services and provider routing
        -> Web API
        -> Bot API
        -> Mobile API /v1/mobile/*
```

Models, templates, prices, jobs, assets and user balances are shared domain
entities. Mobile-specific home composition belongs to the mobile API contract,
not to provider integrations and not to website HTML.

## Google Cloud Storage Integration

Google Cloud Storage stores binary assets only. It is not the catalog database
and clients must not list bucket objects directly.

```text
Admin/CMS uploads media
    -> Backend creates an upload URL
    -> File is uploaded to Google Cloud Storage
    -> Backend validates the object and saves its metadata in the database
    -> Content version is published
    -> Website and mobile receive the same media record through the API
```

The database keeps the asset ID, object key, media type, dimensions, duration,
checksum, visibility and lifecycle state. Public API responses expose an HTTPS
delivery URL, never a service-account key or internal bucket credentials.

Recommended storage split:

- `public-content`: model thumbnails, template previews, Home creatives and
  other published marketing media. Deliver through Cloud CDN or another CDN
  using long cache headers and immutable versioned object names.
- `user-inputs`: private source images and videos. Upload through short-lived
  signed URLs created by the backend.
- `user-outputs`: private generated results. Read through short-lived signed
  URLs or an authenticated media endpoint.
- `staging-content`: unpublished CMS drafts and preview media.

Do not overwrite a published object at the same path. Upload a new version such
as `templates/mermaid/2026-07-14/preview.webp` and publish the new URL. This
prevents stale website, CDN and mobile caches from showing different files.

The mobile application sends asset IDs to generation endpoints. It must not
send arbitrary bucket object paths and must not infer authorization from a URL.

### Asset Record

```ts
type ContentAsset = {
  id: string;
  mediaType: "image" | "video";
  deliveryUrl: string;
  thumbnailUrl?: string;
  width?: number;
  height?: number;
  durationSec?: number;
  mimeType: string;
  checksum: string;
  visibility: "public" | "private";
  version: string;
};
```

Public creative URLs may be cached for a long time because their paths are
versioned. Private signed URLs must not be persisted as permanent asset
identity; mobile persists the asset ID and requests a fresh URL when needed.

## Minimum Mobile Endpoints

### Bootstrap

```http
GET /v1/mobile/bootstrap?locale=ru&platform=ios&appVersion=1.0.0
If-None-Match: "bootstrap-version"
```

```ts
type MobileBootstrapResponse = {
  schemaVersion: 1;
  contentVersion: string;
  updatedAt: string;
  expiresAt: string;
  minimumAppVersion?: string;
  recommendedAppVersion?: string;
  catalog: CatalogResponse;
  home: HomeFeed;
  featureFlags: Record<string, boolean>;
};
```

The server should support `ETag` and `304 Not Modified`. Mobile stores the last
valid sanitized snapshot and continues to work from cache if refresh fails.

### Home Feed

```ts
type HomeFeed = {
  sections: HomeSection[];
};

type HomeSection = {
  id: string;
  type: "hero" | "portrait_rail" | "landscape_rail" | "model_rail";
  title?: string;
  subtitle?: string;
  order: number;
  isEnabled: boolean;
  items: HomeItem[];
};

type HomeItem = {
  id: string;
  title: string;
  subtitle?: string;
  media: {
    imageUrl: string;
    videoUrl?: string;
    thumbnailUrl?: string;
  };
  action:
    | { type: "template"; targetId: string }
    | { type: "model"; targetId: string }
    | { type: "generator"; format: string };
  badge?: string;
  order: number;
};
```

Only known section and action types are rendered. Unknown types are ignored so
an older app does not crash after the backend publishes a newer content type.

### Catalog

The existing contract remains:

```http
GET /v1/mobile/catalog
```

It supplies formats, public model metadata, capabilities, cost, availability,
templates and categories. Provider credentials, routing, fallback chains and
internal provider model names never reach mobile.

## Stable ID Rules

- Public `modelId`, `templateId`, `sectionId` and package IDs are immutable.
- A provider migration happens behind the same public ID where behavior remains
  compatible.
- Removed items are disabled first; IDs are not immediately reused.
- Templates may only reference models present in the same published snapshot.
- Media URLs must use HTTPS and a CDN suitable for mobile image/video delivery.

## Localization

The request sends a BCP 47 locale. Backend returns localized content with this
fallback order:

```text
requested locale -> language base -> English -> server default
```

App chrome such as buttons, errors and settings remains in ARB files and ships
with the application. Backend owns localization of dynamic model descriptions,
collections, banners, template copy and promotional content.

## Publishing Workflow

1. Content manager edits a draft in the shared admin/CMS.
2. Backend validates references, media, prices and locale fallbacks.
3. Draft is previewed for web, bot and mobile clients.
4. Publish creates an immutable `contentVersion`.
5. Clients receive the version on the next refresh and cache it.
6. Rollback republishes the previous valid version.

Production publishing should support scheduled activation and an emergency
disable switch for a model, template or creative.

## Compatibility And Safety

- Additive fields are allowed within `schemaVersion: 1`.
- Removing, renaming or changing field meaning requires a new schema version.
- Backend can use `minimumAppVersion` only for genuinely incompatible releases.
- Mobile validates and sanitizes every response before caching it.
- Last known good content is retained when a new response is invalid.
- Authentication, generation, billing and asset URLs remain separate contracts.
- App Store and Google Play purchases are credited only after backend receipt
  verification.

## Current Mobile Readiness

Already present:

- Repository/API/cache boundary for catalog data.
- Sanitization of public catalog fields and reference validation.
- Cached fallback and stable public model/template IDs.
- Backend-ready generation, history and billing contract documents.

Still required after backend agreement:

- Production API base URL and authentication rules.
- Live Dio/Retrofit or generated OpenAPI adapter.
- Bootstrap/home-feed DTOs and renderer.
- Replace hardcoded Home collection IDs with server sections.
- Contract fixtures and integration tests from real backend JSON.
- Staging environment and test accounts.

## Backend Handoff Checklist

Backend should provide:

- Staging base URL and OpenAPI specification or JSON examples.
- Auth scheme and token refresh contract.
- Current catalog response fixture.
- Generation upload/job/history contracts and error codes.
- Mobile bootstrap/home-feed response fixture.
- CDN URL rules and asset lifetime policy.
- Catalog cache TTL, ETag behavior and publishing ownership.
- Supported locales and fallback language.
- Store package/product ID mapping and receipt verification contract.
- Staging user plus a model that can generate a low-cost test result.
