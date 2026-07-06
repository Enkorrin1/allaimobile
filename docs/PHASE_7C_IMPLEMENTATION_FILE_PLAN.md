# Phase 7C Implementation File Plan

Date: 2026-07-05.

Status: planning-only. Phase 7C app-code is blocked until Phase 7A, Phase 7B and repo gates are closed.

## Purpose

This file turns the Phase 7C release polish queue into a concrete file-level plan for the final UI polish pass.

Phase 7C goal: make the app release-smoke-ready on a Redmi-class device without expanding product scope or changing backend/data/runtime behavior.

## Start Preconditions

Phase 7C code can start only after all of these are true:

- Phase 7A has no P0 blockers.
- Phase 7B has no P0 blockers.
- Repo split/dirty-tree gate is closed.
- QA smoke for prior slices is accepted or explicitly downgraded.
- Coordinator states: `Phase 7C app-code authorized`.
- Fresh `git status --short -uall` is clean or contains only explicitly approved 7C planning docs.
- Mobile Implementation is the sole app-code owner.

Recommended future branch:

- `codex/phase-7c-release-polish`

## Product Priority Order

P0 order:

1. Small-screen/accessibility.
2. Empty/error/loading/disabled state polish.
3. Russian copy cleanup.
4. Visual consistency.
5. QA bugfix pass.
6. Release verification.

Implementation note:

- Visual consistency should support each P0 fix, not turn into a broad redesign.
- 7C is release-readiness, not feature work.

## Copy Source Of Truth

Use consistent Russian terms:

- `койны`
- `генерация`
- `шаблон`
- `референс`
- `результат`
- `скоро` for honest unavailable placeholder actions where needed.

Remove:

- mojibake;
- raw backend/debug/internal wording;
- `mock`, `static`, `slice`, `internal` in user-facing UI;
- mixed Russian/English without product reason;
- technical exception text.

Forbidden claims:

- live provider availability;
- real upload/image-to-image;
- real billing/IAP;
- real purchases or store billing;
- real email delivery;
- production download/share;
- social publishing;
- production account deletion;
- guaranteed generation speed/quality;
- guaranteed refunds.

## Slice 7C-01: Small-Screen And Accessibility Polish

Likely files:

- `lib/app/shell/app_shell.dart`
- touched auth screens from Phase 7A
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/screens/template_detail_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/profile/presentation/screens/profile_screen.dart`

Checks:

- 320-360dp layout fit;
- no horizontal overflow;
- no clipped critical copy;
- CTA reachable;
- keyboard-safe forms;
- bottom nav labels fit;
- tap targets at least 48dp;
- readable contrast;
- semantic labels for icon-only actions where practical;
- disabled/focused/pressed/selected states clear.

Stop conditions:

- hidden CTA/errors;
- tiny controls;
- unreadable contrast;
- accessibility P0;
- need for router/data/platform changes.

## Slice 7C-02: State Polish

Likely files:

- `lib/shared/widgets/loading_state.dart`
- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/empty_state.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/shared/widgets/result_action_bar.dart`
- `lib/shared/widgets/generated_asset_preview.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/result_viewer/presentation/screens/result_viewer_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`

State targets:

- empty;
- loading;
- error;
- disabled;
- cached;
- active;
- completed;
- failed;
- insufficient balance;
- unavailable/soon placeholders.

Rules:

- UI can change state presentation only.
- Do not change provider ownership, repository contracts, status enums, data/cache semantics, billing invariants or generation polling.
- Every state should explain what happened and what the user can do next.
- Placeholder/no-op actions must be visibly disabled or return safe feedback.

Stop conditions:

- active result looks completed;
- failed result looks active;
- insufficient balance does not block;
- raw exceptions appear;
- silent no-op on a critical action.

## Slice 7C-03: Copy Cleanup

Likely files:

- touched presentation screens from Phase 7A and Phase 7B;
- presentation view-model/copy helpers;
- shared widgets with user-facing labels.

Rules:

- Copy cleanup stays in presentation/view-model layers.
- Do not change domain/backend error codes.
- Do not add new wire statuses or fake persisted history for copy.
- Keep mock/default runtime honest.

Acceptance:

- P0 UI is Russian-first;
- terms are consistent;
- disabled and unavailable actions are honest;
- no provider/billing/upload overpromises.

## Slice 7C-04: Visual Consistency

Likely files:

- `lib/app/theme/*`
- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_text_field.dart`
- `lib/shared/widgets/status_chip.dart`
- `lib/shared/widgets/empty_state.dart`
- `lib/shared/widgets/error_state.dart`
- `lib/shared/widgets/loading_state.dart`
- `lib/shared/widgets/model_card.dart`
- `lib/shared/widgets/template_card.dart`
- `lib/shared/widgets/media_asset_tile.dart`
- screens already touched in Phase 7A/7B.

Rules:

- Align typography, spacing, radii, button/chip/card states and media preview surfaces.
- Keep changes backward-compatible for shared widget callers.
- Do not create a new visual language outside 7A foundation.
- Do not use broad rewrites to fix local polish issues.

Acceptance:

- Welcome/Auth/Home/Create/Catalog/Result/Library/Pricing/Profile feel like one app;
- no default Flutter roughness dominates;
- disabled/loading/error states are visually consistent.

## Slice 7C-05: QA Bugfix Pass

Scope:

- Fix only confirmed QA/Redmi findings after 7A/7B/7C polish checks.
- Keep fixes tied to failing screen/state/control.
- No broad redesign, no new features and no data/router/platform changes.

Required mapping:

- each code change maps to a QA finding;
- each QA finding is PASS, downgraded with reason, or left as BLOCKED.

Stop conditions:

- bugfix requires data/domain/core/router/platform/dependency changes;
- a fix introduces new layout or behavior regressions;
- QA finding implies a product-scope expansion.

## Slice 7C-06: Release Verification

Required commands after future implementation:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched Dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

Additional review:

- changed-file review showing no Drift/API/storage/generated DB/platform permission changes;
- dependency/platform diff scan;
- staged artifact/secrets scan through Repo GitHub.

## Redmi 7 Evidence

Device target:

- serial `c7970e16`;
- size `720x1520`;
- density `320`.

Screenshots:

- Welcome/Auth if touched.
- Home.
- Create keyboard/ready.
- Tools states.
- Template Detail.
- Result active.
- Result completed.
- Result failed.
- Library states.
- Pricing.
- Profile.
- Settings if touched.

Video evidence:

- one continuous Redmi 7 walkthrough: login -> Home -> Create -> progress -> Result -> Library -> Tools/Detail -> Pricing/Profile -> logout.

Smoke matrix:

- fresh install;
- login;
- session restore;
- bottom navigation;
- Create job;
- Result;
- Library;
- Tools and Template Detail;
- Pricing/Profile/Settings if touched;
- logout and back protection.

Performance feel:

- smooth enough tab switching;
- scroll feels stable;
- progress/loading states do not appear stuck;
- no jarring layout shifts.

## Allowed Modules

Allowed:

- `lib/app/theme/*`
- `lib/app/shell/app_shell.dart`
- `lib/shared/widgets/*`
- auth presentation screens touched in Phase 7A
- Home/Create/Tools/Template Detail/Result/Library presentation screens touched in Phase 7B
- optional `lib/features/profile/presentation/screens/profile_screen.dart`
- optional `lib/features/billing/presentation/screens/pricing_screen.dart`
- optional settings presentation screen if already exists and is in scope
- focused tests for changed states/screens.

## Forbidden Modules And Changes

Do not touch without separate approval:

- `lib/core/*`
- `lib/app/router/*`
- `lib/features/*/data/*`
- `lib/features/*/domain/*`
- `lib/features/auth/data/*`
- `lib/features/auth/domain/*`
- `lib/features/auth/presentation/providers/*`
- `lib/features/generation_jobs/data/*`
- `lib/features/generation_jobs/domain/*`
- Drift/generated database files
- `pubspec.yaml`
- `android/*`
- `ios/*`

Forbidden scope:

- new packages, fonts, binary assets or permissions;
- live backend URL/env config;
- provider SDKs or direct AI calls;
- real billing/IAP;
- upload/image-to-image activation;
- picker/file APIs;
- storage/schema/session behavior changes;
- platform save/share implementation.

## File-Risk List

High-risk files requiring careful diff review:

- `test/widget_test.dart`
- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`
- shared widgets used across many screens;
- `lib/app/theme/app_theme.dart`;
- `lib/app/shell/app_shell.dart`;
- `lib/shared/widgets/status_chip.dart`;
- `lib/shared/widgets/result_action_bar.dart`;
- `lib/shared/widgets/generated_asset_preview.dart`.

## Presentation Boundary Rules

Touched presentation/shared code must not import:

- `Dio`
- `AppDatabase`
- `Drift`
- `MockAllAiApi`
- secure storage
- raw data sources
- `image_picker`
- `file_picker`
- `dart:io`
- provider SDK/payment/IAP libraries.

UI may change only state presentation. It must not change provider ownership, repository contracts, auth redirects/session restore, generation create/poll/retry, billing reserve/charge/refund, catalog fallback or pricing/cache behavior.

## Test Plan

Preferred new file:

- `test/phase7c_release_polish_test.dart`

Avoid unless clean or explicitly approved:

- `test/widget_test.dart`

Suggested coverage:

- no-overflow sanity for critical small-screen surfaces where practical;
- disabled placeholder actions are not enabled;
- empty/error/loading state copy is visible;
- active/completed/failed Result states are distinct;
- Pricing disabled packages do not look like real purchases;
- key Russian terms appear consistently where tested.

## Repo Expectations

Future branch:

- `codex/phase-7c-release-polish`

Future commit split:

- `docs: plan phase 7c release polish`
- `ui: final polish accessibility copy`
- `test: release readiness coverage`
- `ci: harden mobile checks`, only with separate approval.

Before each future commit:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
```

Do not stage:

- `build/`
- screenshots from `build/`
- APK/AAB/IPA
- `.dart_tool/`
- coverage
- DB/sqlite/cache files
- `.env*`
- signing keys/certs
- provider configs
- generated files unrelated to approved schema/model changes.

## Handoff Evidence

Mobile Implementation must provide:

- changed files grouped by polish slice;
- QA findings mapped to fixes;
- test/check output summary;
- import/secret scan summary;
- Redmi screenshots/video paths;
- APK result if built;
- remaining blockers;
- accepted P1/P2 follow-ups;
- review handoff to Product/UI/Architecture/Data/QA/Repo.

## P0 Stop Conditions

Stop if:

- Phase 7A/7B/repo gates are not closed;
- Phase 7C app-code authorization is missing;
- a forbidden file must be changed;
- data/domain/core/router/platform/dependency changes are needed;
- upload/live/billing/provider behavior is requested;
- enabled no-op critical actions appear;
- tests/analyze/scans fail;
- auth/navigation/generation/result/library/persistence regresses;
- Redmi 7 has clipped critical UI, hidden CTA, overflow, unreadable controls or accessibility P0;
- raw technical errors or mojibake remain visible.

## Current Coordinator Decision

This file plan is ready for future Phase 7C implementation after Phase 7A, Phase 7B and repo gates close. It does not authorize code. Phase 7C remains HOLD.
