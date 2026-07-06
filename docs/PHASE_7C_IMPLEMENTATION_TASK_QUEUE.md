# Phase 7C Implementation Task Queue

Date: 2026-07-05.

Status: planning-only. App-code implementation is on HOLD until Phase 7A, Phase 7B and the repo/dirty-tree gates are closed.

Goal: prepare the final mobile polish and release-readiness task queue after the Phase 7A auth/shell redesign and Phase 7B signed-in workflow redesign.

## Role Inputs Collected

- Product Lead: prioritize release blockers first: small-screen/accessibility, states, RU copy, visual consistency, QA bugfixes, release verification.
- UI UX: keep 7C as consistency/polish only; fail release on overflow, clipped copy, inaccessible controls, broken navigation or misleading feature claims.
- Mobile Architecture: keep changes inside theme, shared widgets and presentation screens; no data/domain/platform/dependency changes.
- Mobile Implementation: 7C can be implemented as narrow presentation slices after repo approval, with focused widget tests and scans.
- QA Release: require screenshots, accessibility matrix, full Redmi 7 smoke and release checks before marking 7C ready.

## Global Rules

- Do not start code before repo approval or explicit user approval for mixed-tree work.
- Do not add live provider SDKs, provider keys, direct AI calls, upload activation, real billing/IAP, permissions, platform save/share or new packages.
- Do not change `core/api`, `core/network`, `core/database`, `core/storage`, `features/*/data`, `features/*/domain`, router redirects/routes, Drift schema/generated files, `android`, `ios` or `pubspec.yaml`.
- Keep mock-default runtime and disabled placeholders honest in UI copy.
- Prefer presentation-only fixes in touched 7A/7B screens and shared widgets.

## Ticket 7C-01: Visual Consistency

Owner: Mobile Implementation. Reviewers: UI UX, Product Lead, Mobile Architecture, QA Release.

Scope:

- Align spacing, radii, typography, buttons, chips, cards, media previews and state components across auth and signed-in flows.
- Likely files after approval: `lib/app/theme/**`, `lib/shared/widgets/app_button.dart`, `app_card.dart`, `app_text_field.dart`, `status_chip.dart`, `empty_state.dart`, `error_state.dart`, `loading_state.dart`, `media_asset_tile.dart`, `template_card.dart`, `model_card.dart`, and presentation screens already touched in 7A/7B.

Acceptance:

- Welcome, auth, Home, Create, Catalog, Template Detail, Result, Library, Pricing and Profile feel like one product.
- No default Flutter remnants or one-off visual styles remain on P0 paths.
- Profile/Pricing remain quiet utility surfaces and do not claim real billing.

## Ticket 7C-02: Small-Screen And Accessibility Polish

Owner: Mobile Implementation. Reviewers: UI UX and QA Release.

Scope:

- Fix 320-360dp layout issues, tap targets, keyboard safety, focus order, semantics and contrast.
- Likely surfaces: auth screens, `app_shell.dart`, `home_screen.dart`, `generator_screen.dart`, `tools_screen.dart`, `template_detail_screen.dart`, `result_viewer_screen.dart`, `library_screen.dart`, `pricing_screen.dart`, `profile_screen.dart`.

Acceptance:

- Redmi 7 sized viewport has no overflow, overlap or clipped critical Russian copy.
- Primary CTAs stay reachable with keyboard open.
- Tap targets are at least 48dp for actionable controls.
- Icon-only buttons have semantic labels where practical.
- Disabled, focused, pressed and active states are visually clear.

## Ticket 7C-03: Empty, Error, Loading And Disabled State Polish

Owner: Mobile Implementation. Reviewers: Product Lead, UI UX, QA Release.

Scope:

- Polish empty/loading/error/disabled/active/completed/failed states for Home, Create, Tools, Template Detail, Result, Library, Pricing and Profile.
- Likely shared widgets: `loading_state.dart`, `error_state.dart`, `empty_state.dart`, `status_chip.dart`, `result_action_bar.dart`, `generated_asset_preview.dart`.

Acceptance:

- Every state explains what happened and what the user can do next.
- No raw exceptions, debug labels, backend/internal terms or silent no-op actions appear in UI.
- Active generation cannot look completed, failed generation cannot look active, and disabled placeholder actions clearly read as unavailable or soon.

## Ticket 7C-04: Russian Copy And Localization Cleanup

Owner: Product Lead for wording decisions, Mobile Implementation for later edits. Reviewers: UI UX and QA Release.

Scope:

- Clean presentation copy only.
- Use consistent terms: `койны`, `генерация`, `шаблон`, `референс`, `результат`.
- Remove mojibake, mixed RU/EN without reason, raw error codes, technical mock/live wording and provider/billing/upload overpromises.

Acceptance:

- P0 UI copy is Russian-first and consistent.
- Placeholder actions do not imply real provider, upload, download/share, billing or IAP support.
- Error and empty-state copy is user-facing and actionable.

## Ticket 7C-05: QA Bugfix Pass

Owner: Mobile Implementation. Reviewers: QA Release, Mobile Architecture, UI UX.

Scope:

- Fix only confirmed QA findings after 7A/7B and 7C polish checks.
- Keep bugfixes tied to the failing screen/state/control.

Acceptance:

- All P0 visual, accessibility and flow regressions from Redmi smoke are closed.
- No fix introduces new navigation, auth, generation, result, library, billing or layout regressions.
- No scope creep into live backend, provider SDKs, upload, billing/IAP or platform permissions.

## Ticket 7C-06: Release Verification

Owner: QA Release. Support: Mobile Implementation and Repo GitHub.

Required checks after code approval and implementation:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

Screenshot pack:

- Welcome.
- Login with keyboard.
- Home.
- Create ready state and Create with keyboard.
- Tools states.
- Template Detail.
- Result active, completed and failed.
- Library states.
- Pricing.
- Profile and Settings.

Smoke matrix:

- Fresh install.
- Login.
- Session restore.
- Bottom navigation.
- Create job.
- Result.
- Library.
- Tools and Template Detail.
- Pricing/Profile.
- Logout and back protection.

Accessibility matrix:

- Contrast sanity.
- Font scaling sanity.
- Focus order.
- Semantic labels.
- Disabled state clarity.
- Keyboard-safe forms.
- Scroll reachability on Redmi 7.

## Current Coordinator Decision

7C is ready as a planned task queue, but not ready for implementation. The next implementation-unblocking action is still the repo decision: either perform the careful commit split or get explicit user approval to work on the mixed dirty tree.
