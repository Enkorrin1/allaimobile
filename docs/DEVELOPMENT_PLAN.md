# Development Plan

This roadmap describes the staged path from empty repository to final AllAi Mobile App product.

Snapshot date: 2026-07-02.

## Phase 0: Product Lock And Repo Foundation

Goal: freeze the initial product direction and prepare the repository for safe development.

Owner threads:

- Product Lead
- Mobile Architecture
- Repo GitHub
- QA Release

Work:

- Confirm MVP scope from `PRODUCT_REQUIREMENTS.md`.
- Confirm technical decisions from `MOBILE_ARCHITECTURE.md`.
- Confirm open questions from `DECISIONS_AND_OPEN_QUESTIONS.md`.
- Initialize git only after explicit approval.
- Add `README.md`, `.gitignore`, `.env.example`, and docs.
- Create initial CI skeleton.
- Decide app identifiers, bundle names, and environments.

Deliverables:

- Project docs committed.
- Repo connected to `https://github.com/Enkorrin1/allaimobile`.
- Foundation CI exists.
- `.env.example` documents public mobile config only.

Exit criteria:

- Repository can be cloned by another developer.
- Project direction, stack, and MVP are clear.
- No secrets are present in repository.

## Phase 1: Flutter App Scaffold

Goal: create a runnable Android/iOS app shell.

Owner threads:

- Mobile Implementation
- Mobile Architecture
- QA Release

Work:

- Scaffold Flutter + Dart app.
- Add go_router navigation.
- Add base theme, typography, spacing, colors.
- Add app config for development/staging/production.
- Add analysis, formatting, and unit test setup.
- Add base folders from `REPO_SETUP.md`.
- Add placeholder tabs: Home, Create, Library, Studio, Profile.

Deliverables:

- App starts locally.
- Main tab navigation works.
- CI runs analyze/format/test.

Exit criteria:

- Android debug build opens.
- iOS preview path is documented.
- No blank screens.
- Navigation between tabs works.

## Phase 2: Design System And Static UI

Goal: implement the mobile UI skeleton before backend integration.

Owner threads:

- UI UX
- Mobile Implementation
- QA Release

Work:

- Build shared components: buttons, cards, inputs, chips, tabs, sheets, loaders, empty states, error states.
- Implement Home screen with mock balance, scenarios, recent generations.
- Implement Create screen with format switch, model selector, prompt input, upload placeholder, settings area, cost preview.
- Implement Catalog and Template Detail screens with mock data.
- Implement Library grid/list with mock history.
- Implement Pricing and Profile placeholders.
- Implement Result Viewer mock screen for image/video.

Deliverables:

- App can be demoed without backend.
- All MVP screens exist.
- UX states exist: empty, loading, error, success, active job.

Exit criteria:

- Small-screen layout is usable.
- Keyboard does not break prompt input.
- Text and buttons fit without overlap.
- QA smoke passes for navigation and static states.

## Phase 3: Typed Data Layer And Mock Backend

Goal: make the app behave like a real product without live backend dependency.

Owner threads:

- Backend Data
- Mobile Architecture
- Mobile Implementation
- QA Release

Work:

- Add Dart domain models from `DATA_AND_API.md`.
- Add Freezed/json_serializable models for catalog, jobs, assets, balance, pricing.
- Add API client interface.
- Add mock API adapter.
- Add Riverpod providers and async controllers.
- Add SQLite cache for catalog/history metadata.
- Add flutter_secure_storage auth-token abstraction.
- Add deterministic mock generation jobs with status transitions.

Deliverables:

- Catalog loads through typed mock API.
- Generation jobs can be created through mock API.
- Mock jobs move through queued/running/completed/failed.
- History persists locally.

Exit criteria:

- App restart keeps mock history.
- Job status screen updates correctly.
- Insufficient balance state can be simulated.
- No direct provider SDKs or secrets are added.

## Phase 4: Auth And Account MVP

Goal: connect or mock real user identity flow according to backend readiness.

Owner threads:

- Backend Data
- Mobile Implementation
- QA Release

Work:

- Implement Welcome, Login, Registration, Password Reset entry.
- Add legal consent and 18+ confirmation.
- Store tokens in flutter_secure_storage.
- Add auth session restore.
- Add logout.
- Add account settings placeholder.

Backend dependency:

- Auth endpoints or approved mock contract.

Deliverables:

- User can login/register in dev environment or mock environment.
- Auth state controls access to main app.

Exit criteria:

- Tokens are never stored in plain text.
- Logout clears session.
- Wrong credentials show safe error.
- Session survives app restart.

## Phase 5: Catalog, Templates, And Pricing Integration

Goal: connect backend-driven product configuration.

Owner threads:

- Backend Data
- Mobile Implementation
- Product Lead
- QA Release

Work:

- Connect `GET /v1/mobile/catalog`.
- Render backend models, categories, templates, capabilities, availability.
- Add model detail bottom sheet.
- Add template detail flow.
- Connect balance and package endpoints.
- Add model setting UI based on capabilities.
- Add frontend fallback for empty/unavailable models.

Backend dependency:

- Catalog endpoint.
- Balance endpoint.
- Pricing/packages endpoint.

Deliverables:

- App displays real model catalog.
- Model list is not hardcoded.
- Cost preview comes from backend/catalog rules.

Exit criteria:

- Catalog loading/error/empty states pass QA.
- Disabled/unavailable models cannot be submitted.
- Cost and balance are visible before generation.

## Phase 6: Image Generation MVP

Goal: ship the first real value loop for AI image creation.

Owner threads:

- Mobile Implementation
- Backend Data
- QA Release
- Product Lead

Work:

- Implement prompt-only image generation.
- Implement image upload for image-to-image/edit flows.
- Add signed upload flow.
- Create generation job through backend.
- Poll job status.
- Render generated image in Result Viewer.
- Save completed job to Library.
- Implement retry for failed jobs.
- Implement download/share for images.

Backend dependency:

- Upload URL endpoint.
- Image generation job endpoint.
- Job status endpoint.
- Asset URL access.

Deliverables:

- User can create, view, save, download, and share generated image.

Exit criteria:

- Happy path works on Android.
- iOS path is verified or documented if no iOS device is available.
- Failed image job does not lose user prompt.
- Coin reserve/charge/refund behavior is visible and correct.

## Phase 7: Video Generation MVP

Goal: support long-running AI video generation.

Owner threads:

- Mobile Implementation
- Backend Data
- QA Release
- Product Lead

Work:

- Implement text-to-video generation.
- Implement image-to-video generation.
- Add duration/aspect settings where supported.
- Add video job polling.
- Add active job persistence across app restart.
- Add video Result Viewer.
- Add save/share/download for video.
- Add optional push notification registration for completed jobs.

Backend dependency:

- Video-capable job endpoint.
- Status/progress endpoint.
- Video asset delivery.
- Optional push event integration.

Deliverables:

- User can create, monitor, view, save, and share generated video.

Exit criteria:

- Long job survives background/foreground.
- App does not freeze during polling.
- Failed/timeout provider states are understandable.
- Video playback works on target devices.

## Phase 8: Library, Reuse, And Creative Workflow Polish

Goal: turn generation from one-off action into repeatable workflow.

Owner threads:

- UI UX
- Mobile Implementation
- Backend Data
- QA Release

Work:

- Add history filters: image, video, upscale, avatar, motion, failed.
- Add search by prompt/model/template if backend supports it.
- Add repeat generation.
- Add edit/upscale/use-as-source actions.
- Add saved prompts/styles if approved for P1.
- Add favorites for models/templates.
- Improve active job cards and recent results on Home.

Deliverables:

- Library becomes useful as the user's creative workspace.

Exit criteria:

- User can repeat a previous generation.
- User can reuse an output as input for another generation.
- History is stable after restart and logout/login.

## Phase 9: Billing, Coins, And Store Compliance

Goal: make paid usage production-safe.

Owner threads:

- Backend Data
- Product Lead
- QA Release
- Repo GitHub

Work:

- Decide Apple/Google IAP vs approved external billing strategy.
- Implement coin package purchase flow.
- Implement restore purchases.
- Implement purchase verification backend contract.
- Add transaction history.
- Add insufficient-balance paywall.
- Add refund/no-charge UX for failed provider jobs.
- Validate App Store and Google Play policy requirements.

Deliverables:

- User can buy or obtain coins through compliant flow.
- Generation charging behavior is clear.

Exit criteria:

- No generation starts without balance.
- Failed jobs have correct charge/refund state.
- Store review risks are documented.
- Test purchases work in sandbox.

## Phase 10: Social Studio P1

Goal: bring mobile closer to the website studio promise.

Owner threads:

- Product Lead
- UI UX
- Mobile Implementation
- Backend Data
- QA Release

Work:

- Implement Studio tab as social draft workspace.
- Add social-ready templates for TikTok, YouTube Shorts, Pinterest, Reels.
- Save captions/drafts.
- Add export package.
- Add multi-post concept if backend supports it.
- Defer direct publishing unless platform integrations are ready.

Deliverables:

- User can create and organize social-ready assets and drafts.

Exit criteria:

- Studio works without direct social publishing.
- Draft data is saved and recoverable.
- Export/share flows work.

## Phase 11: Localization, Analytics, And Production Hardening

Goal: make the app ready for external beta.

Owner threads:

- Mobile Implementation
- QA Release
- Product Lead
- Backend Data

Work:

- Add RU/EN localization.
- Add analytics events from `PROJECT_SPEC.md`.
- Ensure logs do not include raw prompts/media/secrets.
- Add crash reporting if approved.
- Add rate-limit and maintenance/error states.
- Add account deletion path.
- Add privacy/legal screens.
- Add accessibility pass.
- Add performance pass for image/video-heavy screens.

Deliverables:

- External beta candidate.

Exit criteria:

- Analytics events are validated.
- No sensitive content is logged.
- Legal/account deletion paths exist.
- App remains responsive with media-heavy library.

## Phase 12: Beta Release

Goal: test with real users before store launch.

Owner threads:

- QA Release
- Product Lead
- Repo GitHub
- Mobile Implementation

Work:

- Prepare Flutter Android preview builds.
- Run internal Android smoke.
- Run iOS TestFlight smoke if Apple setup is available.
- Collect beta feedback.
- Fix P0/P1 bugs.
- Freeze MVP scope.
- Prepare store metadata, screenshots, descriptions, privacy labels.

Deliverables:

- TestFlight/internal testing build.
- Beta feedback list.
- Launch bug backlog.

Exit criteria:

- No release-gate blockers from `QA_RELEASE.md`.
- Core generation works on real devices.
- Payment/compliance flow is approved or disabled for launch.

## Phase 13: Store Launch

Goal: publish a stable production version.

Owner threads:

- QA Release
- Repo GitHub
- Product Lead
- Mobile Implementation

Work:

- Create release builds.
- Complete App Store Connect and Google Play Console metadata.
- Submit for review.
- Monitor crashes, generation failures, purchase failures, and feedback.
- Prepare hotfix path.

Deliverables:

- Production Android release.
- Production iOS release.
- Launch monitoring checklist.

Exit criteria:

- App is available to target users.
- Monitoring and support flow are ready.
- Critical bug hotfix path exists.

## Phase 14: Final Product Expansion

Goal: reach the full product vision beyond MVP.

Owner threads:

- Product Lead
- UI UX
- Mobile Architecture
- Backend Data
- Mobile Implementation
- QA Release

Work:

- Add full Social Studio publishing integrations.
- Add team accounts and spend controls.
- Add advanced video editor/timeline.
- Add brand safety/compliance modes.
- Add scheduled publishing.
- Add community templates if approved.
- Add advanced analytics for creative performance.
- Add deeper prompt/style memory.

Deliverables:

- Mobile app reaches parity with the AllAi product vision, not just MVP.

Exit criteria:

- Users can create, manage, publish/export, and reuse creative assets in a full mobile workflow.
- Paid usage is stable.
- Store compliance remains clean.
- Product metrics show retention and repeat generation usage.

## Recommended Build Order

1. Docs and repo foundation.
2. Flutter scaffold.
3. Static UI with mock data.
4. Typed data layer and mock backend.
5. Auth.
6. Catalog/templates/pricing.
7. Image generation.
8. Video generation.
9. Library/reuse.
10. Billing/IAP.
11. Studio.
12. Localization/analytics/hardening.
13. Beta.
14. Store launch.
15. Post-launch expansion.

## Critical Dependencies

- Backend catalog API.
- Backend upload and asset storage.
- Backend generation queue.
- Backend coin/billing rules.
- Mobile billing compliance decision.
- Moderation policy.
- App Store and Google Play accounts.
- iOS testing path.

## Biggest Risks

- Coin purchases may be blocked if store billing is not compliant.
- Provider failure/refund rules can create user trust issues.
- Video generation latency can make the app feel broken without good status UX.
- Hardcoded model lists will drift from web/backend.
- Direct provider calls from mobile would leak secrets and must be avoided.
- App Store/Google Play review can reject weak AI-generated-content policy flows.
