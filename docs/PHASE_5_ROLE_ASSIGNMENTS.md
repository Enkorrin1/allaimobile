# Phase 5 Role Assignments: Catalog, Templates, And Pricing Integration

Date: 2026-07-03.

## Goal

Start Phase 5: backend-driven catalog, templates and pricing integration.

This phase moves the app from a fully local mock product runtime toward a backend-shaped integration boundary for:

- model catalog;
- categories and capabilities;
- templates/scenarios;
- balance and coin packages;
- pricing/error/empty states.

Until real backend endpoints and credentials are explicitly approved, Phase 5 must stay safe:

- no production API base URL unless explicitly provided;
- no provider SDKs or provider keys;
- no direct calls to AI providers;
- no real billing/IAP;
- no commit or push without explicit user confirmation.

## Phase Boundary

Allowed:

- API contract review for catalog/templates/pricing.
- DTO/domain mapping review.
- Mock/live adapter boundary planning.
- Public config placeholders only.
- UI states for loading, empty, unavailable, offline/cache and pricing errors.
- Tests for catalog/template/pricing repository behavior.
- CI/repo hygiene planning.

Not allowed without explicit approval:

- Real backend credentials.
- Production API endpoint setup.
- OAuth/provider SDKs.
- Direct mobile calls to AI providers.
- Real purchases, IAP, RevenueCat or store billing setup.
- Persisting provider routing keys in Drift or source.
- Commit or push.

## Product Lead

Define product acceptance:

- Which catalog categories are P0: Photo, Video, Upscale, Avatars, Motion.
- Required model card information.
- Required template/scenario information.
- Pricing package display rules.
- Empty/unavailable model behavior.
- Whether backend catalog can be partially unavailable while app still shows cached/mock data.
- What Phase 5 can close without a real backend endpoint.

## Backend Data

Produce API/data contract:

- `GET /v1/mobile/catalog` response shape.
- Balance/packages response shape.
- Template/category/model capability DTOs.
- Cache semantics and seed/update rules.
- Public vs backend-only fields.
- Error codes and retry behavior.
- Migration path from current Drift catalog snapshot to backend catalog cache.

## Mobile Architecture

Review architecture:

- Repository boundary between mock API, future Dio client and Drift cache.
- Environment/config strategy without secrets.
- Offline/cache-first vs network-first policy.
- Provider ownership and Riverpod state.
- How to avoid leaking provider routing keys.
- Test strategy for mock/live adapter switching.

## UI UX

Define UI states and copy:

- Catalog loading/empty/error/cached states.
- Model card and model detail bottom sheet.
- Template grid/detail states.
- Pricing/balance/package states.
- Disabled/unavailable model copy.
- Insufficient balance entry copy.
- Small-screen and filter/search behavior.

## Mobile Implementation

Code owner after gates are clear:

- Do not edit app code until Product/Data/Architecture/UI/QA/Repo gates are collected.
- Prepare implementation plan for backend-ready catalog/pricing boundary.
- Keep fully mock/dev unless real backend config is approved.
- Preserve existing Phase 3/4 tests and auth gating.

## QA Release

Prepare QA gate:

- Catalog loading/error/empty/cached states.
- Template detail launch path.
- Pricing packages and balance display.
- Auth-gated access to catalog/pricing.
- No direct provider SDKs or secrets.
- Android smoke plan after implementation.

## Repo GitHub

Repo/CI scope:

- Ensure API config/env placeholders are safe.
- Check `.gitignore` for backend/env/key files.
- Recommend CI additions for generated code and Android build.
- Recommend commit split for Phase 5 separate from Phase 2/3/4 changes.
- Keep commit/push blocked until explicit confirmation.

## Task Chat Logic

Coordination:

- Keep Phase 5 catalog/pricing integration separate from future in-app task-agent design.
- Track live status in `docs/ACTIVE_SPRINT.md`.
- Keep one app-code owner for any implementation slice.
