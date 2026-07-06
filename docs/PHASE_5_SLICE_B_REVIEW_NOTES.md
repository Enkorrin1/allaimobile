# Phase 5 Slice B Review Notes

Date: 2026-07-03.

Status: role review collected. Slice C can start as a mock-default P0 UI/data polish slice.

## Overall Gate Snapshot

- Product Lead: PASS.
- Backend Data: CONDITIONAL.
- Mobile Architecture: PASS.
- UI UX: CONDITIONAL.
- QA Release: PASS.
- Repo GitHub: CONDITIONAL.
- Task Chat Logic: PASS.
- Mobile Implementation: Slice C plan collected, no code edits.

Working decision: Slice C can start, as long as it stays mock-default and does not enable live backend, provider SDKs, direct AI provider calls or real billing/IAP.

## Product Lead

Verdict: PASS.

P0 blockers: none for starting Slice C.

Slice C can start.

Slice C acceptance:

- Signed-out users cannot access protected catalog/templates/create/pricing routes.
- Catalog loading, success, cached, empty, error and no-results states are visible.
- Search and category chips filter the model/template list.
- P0 categories are visible: Photo, Video, Upscale, Avatars, Motion.
- Unavailable model/template remains visible but cannot start generation.
- Template detail is repository-driven and shows title, category, required inputs, default model, output format, target aspect, prompt/settings and cost.
- Create settings are driven by model capabilities.
- Cost preview comes from selected catalog/pricing data.
- Insufficient balance copy shows required and available coins.
- Pricing shows coin balance, reserved coins, available coins and repository-driven packages.
- Purchase CTAs remain disabled until real billing is approved.
- Cached catalog/templates/pricing survive restart.
- No provider SDKs, provider keys, direct AI provider calls, live backend calls or real billing/IAP are added.

P1 follow-ups:

- Remove remaining demo/mock/backend wording outside Phase 5 surfaces.
- Add stale timestamp or updated-at copy for cached catalog/pricing.
- Add iOS verification later on macOS/CI.
- Add CI build_runner dirty-check and Android debug build.
- Replace Terms/Privacy placeholders before beta/release.

## Backend Data

Verdict: CONDITIONAL.

Mock-default Slice B passes backend/data guardrails. Live endpoint usage remains conditional.

P0 blockers before live backend:

- Live catalog/pricing calls remain blocked until backend URL and final contract are approved.
- Planned `/v1/billing/packages` response is `{ packages, updatedAt }`, while current mobile data source expects a raw list.
- `coin_packages` cache currently loses public fields `isAvailable`, `priceLabel` and `displayOrder`.
- Catalog sanitizer should validate non-empty `modes`, `templates` and `categories` before live use.

P1 follow-ups:

- Extend `CoinTransaction` domain with ledger fields already present in Drift.
- Surface `expiresAt` and `version` from catalog freshness metadata when needed.
- Validate `Template.requiredInputs` against a whitelist.
- Replace package set in cache transaction instead of upserting forever.
- Keep `storeProductId` blocked until real billing/IAP is approved.

Slice C recommendations:

- UI should use repository result state including cached state and refresh errors.
- Pricing CTA remains disabled.
- Create cost preview uses `availableCoins`, not only `coinBalance`.
- Add UI/tests for cached catalog fallback, packages unavailable, balance unavailable, empty catalog, unavailable model and package metadata restart behavior.

## Mobile Architecture

Verdict: PASS.

P0 blockers: none. Slice C can start.

P1 follow-ups:

- Rename `MockCatalogRepository` / `MockBillingRepository` before live wiring because they now orchestrate API plus cache.
- Move infrastructure provider wiring out of presentation providers before live wiring.
- Preserve `isAvailable`, `priceLabel` and `displayOrder` in package cache before live pricing.
- Make package cache refresh replace the set rather than only upserting.
- Add production-ready Dio behavior before real backend: non-empty base URL validation, timeouts, safe error mapping and auth interceptor without body/auth logging.

Boundary rules:

- Default runtime remains mock/cache.
- Live mode requires explicit approved config and backend URL.
- Dio stays inside live data sources.
- Drift stays inside cache data sources.
- UI reads only repository/provider state.
- Every backend payload is sanitized before Drift cache writes.
- Network/parse/backend contract errors must not overwrite valid cache.
- Real billing/IAP remains blocked.

## Repo GitHub

Verdict: CONDITIONAL.

Pushed state:

- Local and remote `main` match `991b404`.
- `main` is clean in the repo gate check.
- Commits `c0b8e2b` and `991b404` are present.
- Latest GitHub Actions CI on `991b404` succeeded.

P1 repo tasks:

- Add build_runner dirty-check to CI.
- Add Android debug build to CI.
- Extend `.gitignore` for future provider/platform key files.
- Enable branch protection for `main` with required CI.
- Keep real backend URLs/secrets blocked until approval.

## UI UX

Verdict: CONDITIONAL.

Slice B has the needed base states, but needs P0 polish before Phase 5 can close.

P0 blockers:

- Category chips in Tools look like filters but do not actually filter the catalog.
- Pricing must not show an insufficient-coins warning globally without a concrete quote.
- Generator must not fall back to the first template when the selected model has no available template.
- Insufficient balance copy must be exact: `Недостаточно койнов: нужно {cost}, доступно {available}`.

P1 follow-ups:

- Separate cached copy from refresh-error copy.
- Add transaction-history empty state: `Операций пока нет`.
- Bring Home and Studio closer to catalog loading/cached/error rules.
- Unify unavailable model/template visuals.
- Show model capabilities, limits and cost more explicitly in details.
- Add a visible `Сбросить фильтры` action for no-results states.

Slice C UI checklist:

- Make catalog filters interactive: `Все`, `Фото`, `Видео` and relevant categories/modes.
- Add reset flow for search and filters.
- Add Create quote block: model, template, cost, available balance and disabled reason.
- Check unavailable model/template entry points from Home, Tools, Detail, Studio and Generator.
- Finish Pricing loading, empty, error and cached states for packages/history.
- Remove remaining visible demo/technical copy.
- Smoke check 320-360dp layouts and prompt keyboard behavior.

Exact RU copy fixes:

- `Запустить демо-результат` -> `Запустить генерацию`
- `Недостаточно койнов для этой генерации` -> `Недостаточно койнов: нужно {cost}, доступно {available}`
- `Social Studio` -> `Студия соцконтента`
- `social assets` -> `ассеты для соцсетей`
- `captions` -> `подписи`
- `export-пакеты` / `Export package` -> `пакеты экспорта`
- `Social-ready шаблоны` -> `Шаблоны для соцсетей`
- `workflows появятся после MVP generation` -> `Сценарии появятся после MVP-генерации`
- `Demo` badge -> `Демо` or `Пример`
- `P0` badge in user UI -> `Основной` or `Рекомендуем`

## QA Release

Verdict: PASS for Phase 5 Slice B.

Commands run:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .` - PASS, 82 files, 0 changed.
- `D:\flutter\bin\flutter.bat analyze` - PASS.
- `D:\flutter\bin\flutter.bat test` - PASS, 38/38.
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug` - PASS.
- Secrets/provider/direct URL scans - PASS, no real secrets/provider SDK/direct provider URLs found.
- Presentation import scan - PASS, screens/widgets do not import `Dio`, Drift DB or `MockAllAiApi`.

P0 blockers: none for Slice B.

P1 follow-ups:

- Run Android emulator smoke after Slice C UI integration.
- Keep iOS/macOS verification as a separate gate.
- Before live backend: approved base URL, timeout/error mapping and no auth/body logging.
- Terms/Privacy URLs and billing/IAP decision remain beta/release blockers.
- CI should add Android debug build and build_runner dirty-check.

Slice C Android smoke matrix:

- Signed-out Catalog/Templates/Pricing redirects to Welcome/Login.
- Login to Catalog shows loading then success.
- Template detail shows correct DTO fields, cost and model.
- Empty catalog shows empty state plus retry.
- Catalog error shows error state plus retry, no infinite spinner.
- Cached catalog survives force-stop/relaunch.
- Unavailable model has disabled CTA and visible reason.
- Pricing/balance shows packages and balance while purchases remain disabled.
- Pricing empty/error shows safe state.
- Create cost preview uses catalog/pricing and insufficient balance blocks.
- Logout plus Android Back does not reveal protected shell.
- Logcat quick scan shows no tokens/secrets/provider endpoints.

## Task Chat Logic

Verdict: PASS.

Rules for Slice C:

- Mobile Implementation remains the only app-code owner.
- Product/UI UX define acceptance and copy; they do not edit app code.
- Backend Data and Architecture define data/boundary constraints; they do not edit app code.
- Repo GitHub does not commit or push without explicit approval.
- Do not mix catalog/templates/pricing with future task-chat or AI-agent roles.
- Any backend URL, provider SDK/key, direct AI call or billing/IAP request stops Slice C until explicit approval.

## Mobile Implementation Plan

No files changed and no git actions.

Likely Slice C files:

- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/screens/tool_detail_screen.dart`
- `lib/features/tools/presentation/screens/template_detail_screen.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/tools/presentation/view_models/catalog_ui_mappers.dart`
- `lib/features/billing/presentation/view_models/billing_copy.dart`
- `test/widget_test.dart`
- possible new `test/phase5_ui_state_test.dart`

Planned scope:

- Real category/mode filters.
- Better search reset and no-results state.
- Cached banner with retry/error context.
- More template/model detail fields.
- Disabled CTA for unavailable model/template.
- Capabilities-driven Create settings where scoped.
- Dynamic insufficient balance copy.
- Pricing package availability and disabled purchase copy.
- Additional widget/regression tests.

## Slice C Start Decision

Slice C should start now with two connected tracks owned by Mobile Implementation:

- P0 UI state polish from UI UX and Product.
- Narrow package cache metadata fix from Backend Data and Architecture, so pricing availability/order/copy survives restart before future live endpoints.

Still blocked:

- real backend URL;
- provider SDKs or provider keys;
- direct AI provider calls;
- real billing/IAP;
- commit/push without explicit user confirmation.
