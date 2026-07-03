# Phase 5 Execution Brief: Catalog, Templates, And Pricing Integration

Date: 2026-07-03.

## Objective

Prepare and implement a backend-ready catalog/templates/pricing integration path while keeping the app safe in the current local/mock environment.

Phase 5 should make these surfaces backend-shaped:

- model catalog;
- templates/scenarios;
- model capabilities/settings;
- balance;
- coin packages;
- pricing and unavailable/empty/error states.

The current app already has a typed mock runtime and Drift persistence. Phase 5 must build on that foundation instead of hardcoding UI-only data again.

## Implementation Slices

### Slice A: Contract And Gate

No app code edits except docs.

- Product acceptance for catalog/templates/pricing behavior.
- Backend/Data API and cache contract.
- Architecture review of mock/live/cache boundary.
- UI/UX review of states and copy.
- QA test matrix.
- Repo/security/CI readiness review.

### Slice B: Backend-Ready Data Boundary

Code owner: Mobile Implementation, after Slice A gates.

Allowed only if gates are clear:

- API interface for catalog/templates/pricing.
- DTO/domain mapping cleanup where needed.
- Mock adapter remains default.
- Optional live adapter skeleton without production endpoint or secrets.
- Repository cache strategy using existing Drift catalog/packages/billing tables.
- Tests for adapter/repository reconstruction and fallback behavior.

Not allowed:

- Calling real backend without approved base URL and backend contract.
- Adding provider SDKs or provider credentials.
- Adding real billing/IAP.

### Slice C: UI State Integration

- Catalog loading, cached, empty and error states.
- Template detail states from backend-shaped data.
- Pricing loading/error/empty/package states.
- Model unavailable/disabled behavior.
- Cost preview remains driven by catalog/pricing rules.

### Slice D: Verification

Required local checks:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug`

Required gate checks:

- No provider keys or provider SDKs in app.
- No backend secrets in source/docs/tests/logs.
- Catalog/templates/pricing still work after app restart.
- Auth-gated routes still protect catalog/pricing.
- Empty/error/unavailable states are user-facing.
- Existing Phase 3/4 tests stay green.

## Acceptance

Phase 5 is complete when:

- Product accepts catalog/templates/pricing behavior.
- Backend/Data accepts DTO/cache/API contract.
- Architecture confirms repository/cache/mock-live boundaries.
- UI/UX confirms mobile states and copy.
- QA passes Android smoke.
- Repo confirms no secrets/provider SDKs and commit split readiness.

## Open Decisions

- Is there an approved backend base URL for dev/staging?
- Is `GET /v1/mobile/catalog` available now, or should Slice B stay mock-only with live adapter skeleton?
- Are balance/packages endpoints available now?
- What exact model/template fields are guaranteed by backend?
- Should catalog be network-first with cache fallback, or cache-first with background refresh?
- Should pricing packages be hidden, disabled or shown as demo when backend billing is unavailable?
- What final Terms/Privacy URLs should replace Phase 4 placeholders before beta/release?
