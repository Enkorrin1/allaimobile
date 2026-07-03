# Active Sprint: Phase 5 Catalog, Templates, And Pricing Integration

Start date: 2026-07-02.

Goal: prepare backend-driven catalog, templates and pricing integration while keeping the mobile app safe in local/mock mode until backend endpoints are explicitly approved.

Reference files:

- `docs/DEVELOPMENT_PLAN.md`
- `docs/PHASE_1_SCAFFOLD_RESULT.md`
- `docs/PHASE_2_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_2_EXECUTION_BRIEF.md`
- `docs/PHASE_2_IMPLEMENTATION_RESULT.md`
- `docs/PHASE_2_REVIEW_FINDINGS.md`
- `docs/PHASE_2_POLISH_RESULT.md`
- `docs/PHASE_3_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_3_EXECUTION_BRIEF.md`
- `docs/PHASE_3_CONTRACT_REVIEW.md`
- `docs/PHASE_3_SLICE_A_RESULT.md`
- `docs/PHASE_3_SLICE_B_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_3_SLICE_B_EXECUTION_BRIEF.md`
- `docs/PHASE_3_SLICE_B_REVIEW_NOTES.md`
- `docs/PHASE_3_SLICE_B_RESULT.md`
- `docs/PHASE_4_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_4_EXECUTION_BRIEF.md`
- `docs/PHASE_4_CONTRACT_REVIEW.md`
- `docs/PHASE_4_SLICE_B_RESULT.md`
- `docs/PHASE_4_SLICE_B_REVIEW_NOTES.md`
- `docs/PHASE_5_ROLE_ASSIGNMENTS.md`
- `docs/PHASE_5_EXECUTION_BRIEF.md`
- `docs/PHASE_5_CONTRACT_REVIEW.md`
- `docs/PROJECT_SPEC.md`
- `docs/PRODUCT_REQUIREMENTS.md`
- `docs/MOBILE_ARCHITECTURE.md`
- `docs/UX_SCREENS.md`
- `docs/DATA_AND_API.md`
- `docs/QA_RELEASE.md`
- `docs/TASK_THREADS.md`

## Sprint Status

Status: Phase 5 catalog/templates/pricing contract collected; Slice B backend-ready boundary dispatched.

Completed phase: Phase 1 - Flutter App Scaffold.

Current phase: Phase 5 - Catalog, Templates, And Pricing Integration, Slice B backend-ready data boundary.

Next phase: Phase 5 Slice C UI state integration and Android QA gate.

Confirmed stack: Flutter + Dart, go_router, Riverpod, Dio, Drift/SQLite, flutter_secure_storage.

## Phase 1 Result

The Flutter project has been scaffolded in the workspace.

Verified locally:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- `D:\flutter\bin\flutter.bat build apk --debug`

Android debug artifact:

- `build\app\outputs\flutter-apk\app-debug.apk`

Notes:

- `D:\flutter` is a local junction to the Flutter SDK path without spaces.
- Android build used `GRADLE_USER_HOME=D:\GradleCache` to avoid filling the C drive.
- iOS cannot be verified on this Windows machine; it still requires macOS/Xcode or CI macOS runner.

## Phase 2 Owner Threads

- UI UX
- Mobile Implementation
- QA Release
- Product Lead
- Backend Data
- Mobile Architecture
- Repo GitHub

Detailed assignment: `docs/PHASE_2_ROLE_ASSIGNMENTS.md`.

Dispatch status:

- UI UX: assigned.
- Mobile Implementation: assigned.
- QA Release: assigned.
- Product Lead: assigned.
- Backend Data: assigned.
- Mobile Architecture: assigned.

Execution dispatch:

- Mobile Implementation: first code pass completed and pushed.
- UI UX: post-implementation review assigned.
- Product Lead: product decision review assigned.
- Backend Data: fixture/data contract review assigned.
- Mobile Architecture: code architecture review assigned.
- QA Release: smoke verification assigned.
- Repo GitHub: post-push readiness/CI review assigned.

Polish dispatch:

- Mobile Implementation: P0 polish completed locally.
- QA Release: final Android manual smoke assigned.
- UI UX: post-polish small-screen/copy review assigned.
- Mobile Architecture: post-polish boundary review assigned.
- Backend Data: Phase 3 contract prep assigned.
- Product Lead: Phase 3 acceptance decisions assigned.
- Repo GitHub: local-change/CI readiness watch assigned.

Phase 3 dispatch:

- Mobile Implementation: typed mock runtime code owner.
- Mobile Architecture: module and generated-model review.
- Backend Data: DTO/model contract checklist.
- QA Release: Phase 3 smoke and regression gate.
- UI UX: async state and job progress copy review.
- Product Lead: mock-mode product acceptance.
- Task Chat Logic: coordination risk review.

Slice A result:

- Mobile Implementation: complete.
- Coordinator verification: format/analyze/test/Android build passed.
- QA targeted re-smoke: Android Back on Result/Pricing/Settings passed.
- Previous secondary-route Back P0: closed.
- Remaining gate: Slice B persistence and extended Android smoke.

Slice B dispatch:

- Product Lead: persistence acceptance assigned.
- Mobile Architecture: Drift/database boundary review assigned.
- Backend Data: local schema and mapping checklist assigned.
- Mobile Implementation: Slice B code owner.
- QA Release: persistence smoke/gate assigned.
- UI UX: persisted history/restore states review assigned.
- Repo GitHub: generated files and CI readiness assigned.
- Task Chat Logic: coordination risk review assigned.

Slice B role gates:

- Product Lead: Slice B required for Phase 3 closure; completed/failed/in-progress jobs, billing, transactions, catalog, packages and assets must survive restart.
- Mobile Architecture: Drift must stay behind data/repository boundary; seed and job mutations must be idempotent/atomic.
- Backend Data: persist `app_metadata`, catalog snapshot, jobs, assets, billing snapshots, coin packages and coin transactions.
- UI UX: fresh install should show empty Library; failed/refunded and restored active jobs need user-facing copy.
- Repo GitHub: generated Drift source may be included; build/cache/APK/database artifacts must not be staged; CI needs future build_runner dirty-check.
- QA Release: Android persistence smoke waits for Mobile Implementation completion.

Slice B implementation result:

- Drift/SQLite database implemented with generated `app_database.g.dart`.
- Runtime app provider uses file-backed SQLite; tests override with in-memory SQLite.
- Fresh install Library history is empty while catalog, packages and balance are seeded.
- Completed, failed and in-progress mock jobs persist through API/repository reconstruction.
- Format, analyze, tests, diff-check and Android debug build passed locally.
- Product gate: accepted.
- Architecture gate: PASS with P1 follow-ups.
- Repo gate: PASS; SQLite runtime artifacts are ignored and generated Drift source remains includable.
- QA gate: Android smoke in progress; fresh install Library empty passed, completed job created, Result opened, force-stop/relaunch started, Library after restart reached for verification.

Phase 4 planning dispatch:

- Product Lead: auth/account acceptance.
- Backend Data: session/token/mock auth contract.
- Mobile Architecture: secure storage, auth state and routing boundary review.
- UI UX: auth screens, legal/18+, keyboard/error states.
- Mobile Implementation: code owner after gates are clear.
- QA Release: auth smoke and release gate.
- Repo GitHub: secrets/secure-storage/CI hygiene.
- Task Chat Logic: coordination and ownership check.

Phase 4 planning gates:

- Product Lead: app shell is auth-gated for MVP; no guest product mode; email/password only; password reset is mock success; logout preserves local mock history while clearing session.
- Backend Data: AuthUser, LegalConsent, AuthTokenPair and AuthSession contract accepted; tokens/session only in secure storage; no password persistence.
- Mobile Architecture: `core/auth` + `core/storage` boundary, Riverpod auth state and go_router redirect strategy accepted; no redirect before restore completes.
- UI UX: Welcome/Login/Register/Password Reset/Profile states defined; legal/18+ required; keyboard-safe forms required.
- Mobile Implementation: implementation plan ready; code starts after gates.
- QA Release: auth matrix ready for fresh install, login, wrong credentials, registration consent, restore, logout and secrets scan.
- Repo GitHub: no secrets/platform provider config; Phase 4 auth must be separate from existing Phase 2/3 local changes.
- Task Chat Logic: one app-code owner remains Mobile Implementation; auth/account must stay separate from future in-app task-agent design.

Phase 4 Slice B dispatch:

- Mobile Implementation: assigned as sole code owner for mock auth runtime and auth UI/route/profile wiring.
- Product Lead: will review implemented auth/account behavior after Mobile Implementation handoff.
- Backend Data: will review implemented DTO/storage/error contract after Mobile Implementation handoff.
- Mobile Architecture: will review auth boundary, provider wiring and router redirects after implementation.
- UI UX: will review auth screens, copy, legal/18+ and keyboard behavior after implementation.
- QA Release: will run auth smoke after build passes.
- Repo GitHub: will run repo hygiene/secrets/generated-file review after implementation.
- Task Chat Logic: will review coordination boundaries if auth/account work starts to overlap with future task-agent design.

Phase 4 Slice B implementation result:

- Auth-gated app shell implemented for MVP.
- Mock email/password auth implemented with secure storage session wrapper.
- Welcome, Login, Register, Password Reset and Profile account/logout flows wired.
- Registration requires legal consent and 18+ confirmation.
- Router uses stable auth-state refresh and protected-route redirects.
- Wrong credentials do not create a session.
- Logout clears secure session and returns to Welcome/Login while preserving local mock history.
- Phase 3 persistence/navigation tests remain covered in the signed-in test harness.
- Verification reported by Mobile Implementation: format check PASS, analyze PASS, tests PASS 29/29, Android debug build PASS, source-only secrets scan PASS.
- Remaining gates: Product, Backend Data, Architecture, UI UX, QA Release, Repo GitHub and Task Chat Logic review.

Phase 4 Slice B review gates:

- Product Lead: accepted from product perspective; Terms/Privacy placeholders remain release risk.
- Backend Data: PASS with P1 follow-ups; no P0 data/storage blockers.
- Mobile Architecture: PASS with P1 follow-ups; no P0 architecture blockers.
- UI UX: initial conditional pass; requested P0 polish was completed and re-smoked.
- Task Chat Logic: coordination gate clean.
- Repo GitHub: PASS with P1 follow-ups; commit/push remains HOLD.
- QA Release: final Android auth smoke PASS on polished APK.

Phase 4 Slice B P0 polish:

- Mobile Implementation completed login/reset validation, user-facing copy cleanup, scroll-safe Welcome, tappable Terms/Privacy placeholders, tests and APK rebuild.
- Verification reported by Mobile Implementation after polish: format check PASS, analyze PASS, tests PASS 32/32, Android debug build PASS.
- QA Release final targeted Android auth smoke: PASS.

Phase 4 Slice B remaining risks:

- Terms/Privacy placeholders must become approved URLs/screens before beta/release.
- iOS/macOS verification remains untested on this Windows machine.
- Legal link tap/accessibility polish is P1.
- Commit/push requires explicit user confirmation and careful commit split.
- CI should add build_runner dirty-check and Android debug build.
- Live backend auth, OAuth and account deletion remain out of scope without explicit approval.

Phase 5 planning dispatch:

- Product Lead: catalog/templates/pricing product acceptance and P0 behavior.
- Backend Data: API DTO/cache/error contract for catalog, templates, balance and packages.
- Mobile Architecture: mock/live/cache repository boundary and config strategy.
- UI UX: catalog/template/pricing states, disabled/unavailable model copy and small-screen behavior.
- Mobile Implementation: planning only until gates are clear; no app-code edits for Phase 5 yet.
- QA Release: Phase 5 QA matrix and Android smoke plan.
- Repo GitHub: env/secrets/generated-code/CI/commit-split readiness.
- Task Chat Logic: coordination and scope separation.

Phase 5 planning gates:

- Product Lead: P0 catalog categories are Photo, Video, Upscale, Avatars and Motion; catalog/templates/pricing must be repository-driven; real endpoints are not required if mock/default API-shaped boundary and cache fallback are implemented.
- Backend Data: catalog can remain JSON snapshot only after DTO validation/sanitization; billing domain must preserve available/reserved balance; provider/internal fields must never reach mobile/cache.
- Mobile Architecture: PASS if Slice B introduces mock/live/cache boundary, keeps mock default, fails closed without API URL and prevents raw backend catalog from reaching Drift.
- UI UX: P0 states defined for loading, cached, empty, error, unavailable model, pricing/packages and insufficient balance; technical copy must be replaced.
- Mobile Implementation: implementation plan ready; current code can reuse existing Drift tables, but repository/API boundaries need separation.
- QA Release: QA matrix ready for auth-gated catalog/templates/pricing, restart cache persistence, no secrets/provider SDKs and Android smoke.
- Repo GitHub: planning gate PASS; commit/push HOLD; dirty tree must be split; CI needs build_runner and Android build hardening.
- Task Chat Logic: coordination clean; one app-code owner remains Mobile Implementation; Phase 5 must stay separate from task-agent design, live providers and live billing.

Phase 5 Slice B dispatch:

- Mobile Implementation: assigned as sole app-code owner.
- Product/Data/Architecture/UI/QA/Repo/Task Chat Logic: review after implementation handoff.
- Scope: backend-ready catalog/pricing boundary, sanitized cache, mock-default runtime, richer provider/UI states and tests.
- Out of scope: real backend URL, provider SDKs/keys, direct provider calls, real billing/IAP, commit/push.

Phase 5 boundaries:

- No real backend base URL or credentials without explicit approval.
- No provider SDKs or provider keys in mobile.
- No direct AI provider calls from mobile.
- No real billing/IAP setup.
- No commit or push without explicit confirmation.
- Current mock runtime remains default until backend contract is approved.

## Phase 2 Exit Criteria

Phase 2 is complete when:

- All MVP shell screens exist with polished static/mock UI.
- Main tabs and secondary routes work without blank states.
- Shared design primitives cover buttons, fields, cards, chips, loaders, empty states, error states, and bottom sheets.
- Home, Create, Catalog/Templates, Library, Result Viewer, Pricing, and Profile screens are present.
- Small-screen layouts fit without text overlap.
- Prompt input remains usable with the keyboard.
- Static navigation smoke tests pass.
- No real provider keys or direct provider SDKs are added to the mobile app.

## Commands Requiring Explicit User Confirmation

- Further `git commit`
- Further `git push`
- Any real backend/API credential setup.
- Any production billing/IAP setup.

## Next Coordinator Actions

1. Collect role review outputs. Status: complete.
2. Convert review findings into a Phase 2 polish task list. Status: complete.
3. Implement only required polish fixes. Status: complete.
4. Re-run format, analyze, test, and Android debug build. Status: complete.
5. Dispatch Phase 3 typed mock runtime work. Status: complete.
6. Collect final QA/UI/architecture responses. Status: complete for Slice A.
7. Document Phase 3 Slice A result. Status: complete.
8. Decide whether to commit/push local changes. Status: waiting for explicit user confirmation.
9. Start Phase 3 Slice B persistence. Status: dispatched.
10. Collect Slice B role outputs. Status: complete.
11. Collect Slice B implementation result. Status: complete.
12. Collect final Slice B QA/Architecture/Repo/Product gates. Status: Product/Architecture/Repo complete; QA Android smoke in progress.
13. Dispatch Phase 4 Auth And Account MVP planning. Status: complete.
14. Collect Phase 4 role planning gates. Status: complete.
15. Document Phase 4 contract review. Status: complete.
16. Dispatch Phase 4 Slice B mock auth runtime. Status: complete.
17. Collect Phase 4 Slice B implementation result. Status: complete.
18. Run Phase 4 auth QA and repo hygiene gates. Status: dispatched.
19. Collect Phase 4 role review results. Status: complete.
20. Apply Phase 4 Slice B UI P0 polish. Status: complete.
21. Re-run final Phase 4 Android auth smoke on polished APK. Status: complete.
22. Decide next: git commit split/CI hardening or next product slice. Status: user requested next stage.
23. Dispatch Phase 5 catalog/templates/pricing planning. Status: complete.
24. Collect Phase 5 role planning outputs. Status: complete.
25. Document Phase 5 contract review. Status: complete.
26. Dispatch Phase 5 Slice B backend-ready boundary implementation. Status: complete.
27. Collect Phase 5 Slice B implementation result. Status: pending.
