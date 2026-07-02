# Phase 0 Role Outputs

Start date: 2026-07-02.

Status: role outputs received; ready for Phase 1 approval.

## Important Resolution

Mobile stack conflict was found during Phase 0.

Earlier docs referenced Expo/React Native, but the final stack decision is:

- Flutter.
- Dart.
- go_router.
- Riverpod.
- Dio.
- Freezed + json_serializable.
- Drift/SQLite.
- flutter_secure_storage.

Project docs were updated to remove the Expo/React Native foundation.

## Product Lead Output

Status: received.

Key points:

- MVP is a native Android/iOS AllAI studio for AI photo, video, upscale, avatars, motion, and social-ready assets.
- P0 includes auth, Home, Catalog, Templates, Generation, Job Status, Result Viewer, Library, Coins/Pricing, Profile/Settings, moderation and clear errors.
- Out of MVP: direct social publishing, team accounts, full video timeline editor, community templates, advanced brand compliance, offline generation.

P0 user stories:

- Register/login and accept legal/18+.
- View coin balance.
- Browse model catalog by category.
- Use templates and see required inputs/cost.
- Generate image from prompt.
- Generate image from source image.
- Upscale image.
- Generate video from prompt.
- Generate video from image.
- Track long-running generation.
- View, download, share, repeat, and reuse result.
- Open history/library.
- Block generation on insufficient balance.
- Retry/refund state on failed generation.

Open product decisions:

- Confirm final P0 scope.
- Confirm Social Studio MVP vs P1.
- Confirm billing model.
- Confirm first locales.
- Confirm auth providers.
- Confirm backend endpoint readiness.
- Confirm moderation and retention policies.
- Confirm app identifiers.

## Mobile Architecture Output

Status: received.

Key points:

- Raised stack conflict and confirmed Flutter as final stack.
- Recommended Flutter + Dart + feature-first Clean Architecture-lite.
- Recommended go_router, Riverpod, Dio, Retrofit/OpenAPI client, Freezed, json_serializable, Drift/SQLite, flutter_secure_storage.
- Confirmed mobile app must never call AI providers directly.
- Suggested feature structure:
  - onboarding
  - auth
  - home
  - tools
  - generator
  - studio
  - generation_jobs
  - library
  - billing
  - profile

Guardrails:

- No direct AI provider SDKs in mobile.
- No secrets/API keys in mobile.
- Model catalog must be backend-driven.
- Generated media should not be stored as base64 in state.
- Jobs must survive background/restart.
- Billing/credits require backend ledger/status.

## UI UX Output

Status: received.

UX principles:

- App, not landing page.
- Home is a creative dashboard, not a marketing hero.
- Create is the central workspace.
- Model catalog is backend-driven.
- Balance and cost are visible before generation.
- Long-running generation does not block the app.
- Result viewer is media-first.
- Every screen supports empty/loading/error/success/active-job states.
- Small-screen first: prompt input, keyboard, CTA, and tab labels must work cleanly.

Scaffold screens:

- Auth/Welcome.
- Auth/Login.
- Home.
- Create/Generator.
- Library.
- Studio.
- Profile.

Phase 2 screens:

- Model Catalog.
- Model Detail.
- Template Detail.
- Generation Status.
- Result Viewer.
- Pricing/Coins.
- Settings.

## Backend Data Output

Status: received.

Critical backend/API dependencies:

- Catalog endpoint.
- Auth/session endpoint.
- Cost preview/quote endpoint.
- Signed upload flow.
- Generation job create/read/list/cancel.
- Billing balance/packages/purchase verification.
- History source of truth.
- Moderation policy and error taxonomy.

Mock contract for Phase 1-3:

- API client interface with catalog, me, balance, packages, upload, quote, create job, get job, list jobs, cancel job.
- Mock catalog with image/video/upscale/avatar/motion examples.
- Mock balance default.
- Deterministic quote costs.
- Mock job lifecycle through queued/running/processing/completed.
- Failure mode when prompt contains a trigger word.
- History stored locally and restored after restart.

Billing decisions:

- IAP/Play Billing vs allowed external billing.
- Starter coins.
- Reserve/capture/refund policy.
- Immutable backend ledger.
- Chargeback/refund behavior.
- Whether pricing is hidden until store compliance is ready.

Upload decisions:

- Signed URL vs backend upload.
- Max size by media type.
- Allowed MIME types.
- Complete upload contract.
- Signed URL TTL.
- Asset retention/deletion policy.
- Generated assets private by default.

## QA Release Output

Status: Flutter-corrected output received.

Useful retained points:

- Phase gates must block secrets, launch crashes, broken navigation, missing CI, missing iOS path, and unresolved billing/moderation risks.
- First shell smoke must verify app launch, tabs, no blank screen, no crash, basic tests, env safety.

Flutter Phase 0/1 gates:

- Confirm Flutter + Dart stack before scaffold.
- Choose Flutter SDK version/channel or FVM policy.
- Confirm Android SDK/minSdk/targetSdk and iOS minimum deployment target.
- Confirm Android applicationId and iOS bundleId.
- Prepare Flutter `.gitignore`, `.env.example`, and CI.
- After scaffold, verify `flutter pub get`, `flutter analyze`, `flutter test`, Android run, iOS path documentation, no blank screens, no committed secrets/signing files.

Flutter-specific blockers:

- Flutter SDK version not fixed.
- `flutter doctor` has Android blocker.
- Android debug run/build fails.
- iOS path is not documented.
- `flutter analyze` or basic tests fail.
- Secrets, keystores, certificates, provisioning profiles, or real env files are committed.
- App identifiers are not agreed before scaffold.
- CI for Flutter checks is missing.

## Repo GitHub Output

Status: Flutter-corrected output received.

Useful retained points:

- Git init, remote, commit, and push require explicit user confirmation.
- Foundation files needed before first commit: root README, `.gitignore`, `.env.example`, CI, docs.
- First scaffold should be a separate commit after foundation.

Flutter repo plan:

- `.gitignore` must cover `.dart_tool`, `.flutter-plugins`, `.flutter-plugins-dependencies`, `.pub-cache`, `.pub`, `build`, `coverage`, Android `.gradle`, `local.properties`, keystores, iOS Pods, Xcode user data, certificates/profiles, env files, IDE and OS files.
- README commands: `flutter pub get`, `flutter run`, `flutter analyze`, `flutter test`.
- `.env.example` may include `APP_ENV`, `API_BASE_URL`, `WEB_BASE_URL`, `SENTRY_DSN`, `ANALYTICS_KEY`, but no provider secrets.
- GitHub Actions should use Flutter stable and run `flutter pub get`, `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test` when `pubspec.yaml` exists.
- First commit: repository foundation.
- Second commit: Flutter scaffold.
- `git init`, remote, commit, push, `flutter create`, `flutter pub get`, dependency install, signing setup all require explicit confirmation.

## Mobile Implementation Output

Status: Flutter-corrected output received.

Flutter scaffold plan:

- Run `flutter doctor -v`.
- Scaffold with `flutter create --platforms=android,ios --org com.allai --project-name allai_mobile .`.
- Add dependencies: go_router, flutter_riverpod, dio, Freezed/json_serializable, Drift/SQLite, flutter_secure_storage, image_picker, file_picker, video_player, cached_network_image, share_plus.
- Use feature-first structure under `lib/app`, `lib/core`, `lib/features`, and `lib/shared`.
- Create placeholder screens for Auth, Home, Generator, Library, Studio, Profile.
- Use go_router bottom navigation shell, preferably `StatefulShellRoute.indexedStack`.
- Verify with `flutter pub get`, `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test`, Android run/build.

Detailed plan saved in `docs/FLUTTER_SCAFFOLD_PLAN.md`.
