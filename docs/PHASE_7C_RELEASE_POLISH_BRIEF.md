# Phase 7C Release Polish Brief

Date: 2026-07-05.

Status: planning-only. Phase 7C app-code is blocked until Phase 7A and Phase 7B are implemented/reviewed, QA smoke is accepted and the repo gate is resolved.

## Goal

Phase 7C is the final mobile UI polish and release-readiness pass after Phase 7A and Phase 7B.

It is not a feature expansion. It exists to make the app feel coherent, readable, accessible enough for MVP, and safe to smoke-test on a Redmi-class device.

## Entry Conditions

Phase 7C implementation can start only after:

- Phase 7A has no P0 review blockers;
- Phase 7B has no P0 review blockers;
- Redmi/small-screen smoke for previous slices is accepted or explicitly downgraded;
- repo split/dirty-tree gate is resolved;
- Mobile Implementation remains the only app-code owner.

## P0 Scope

- accessibility/tap targets;
- 320-360dp layout fit;
- keyboard safety;
- copy consistency;
- empty/error/loading/disabled states;
- no-overlap pass;
- Create/Result/Library edge states;
- release smoke readiness.

## P1 Scope

- Profile/Pricing/settings extra polish;
- subtle motion and feedback refinement;
- skeletons;
- refined thumbnails;
- hints/tooltips;
- broader tablet/dark-mode polish.

## Product Acceptance

The product is acceptable when:

- all P0 flows feel like one coherent product;
- screens are readable on Redmi-class devices;
- critical CTAs are reachable;
- no clipped text or silent no-op actions remain;
- mock states are honest;
- debug/static/internal copy is gone from user-facing UI;
- progress/loading does not feel frozen.

Forbidden scope:

- live providers;
- real billing/IAP;
- upload/image-to-image activation;
- media permissions;
- new feature creep;
- production share/download promises.

## UI Direction

Accessibility:

- readable contrast;
- 48dp tap targets;
- clear focus/pressed/disabled states;
- semantic labels for icon-only controls where applicable.

Small-screen polish:

- Redmi 7 / 320-360dp is the primary target;
- no horizontal overflow;
- CTA reachable;
- keyboard-safe forms;
- bottom nav labels fit;
- long Russian copy wraps cleanly.

Copy consistency:

- use consistent terms: `койны`, `генерация`, `референс`, `шаблон`, `сценарий`, `результат`;
- no raw backend/mock/static/debug wording;
- no unnecessary English in Russian UI.

States:

- empty states provide next action;
- error states include title, short explanation and recovery action;
- loading states provide context and avoid layout jump;
- disabled/soon states are explicit and not silent.

Motion and feedback:

- native pressed states;
- snackbars for placeholder actions;
- restrained progress feedback;
- no decorative animation noise.

Profile/Pricing/settings:

- quiet utility polish;
- balance, available/reserved and disabled purchases are clear;
- account, logout, legal/support are readable.

## Architecture Boundaries

Allowed:

- `lib/shared/widgets/*`;
- `lib/app/theme/*`;
- `lib/app/shell/app_shell.dart`;
- screens touched by Phase 7A/7B;
- optional `profile_screen.dart`;
- optional `pricing_screen.dart`;
- optional `settings_screen.dart` if it exists or is already in scope.

Forbidden:

- `lib/core/api`;
- `lib/core/network`;
- `lib/core/database`;
- `lib/core/storage`;
- `lib/features/*/data`;
- `lib/features/*/domain`;
- `lib/features/auth/data`;
- `lib/features/generation_jobs/data`;
- router redirects/routes;
- Drift schema/generated files;
- `android`;
- `ios`;
- `pubspec.yaml`.

Dependency constraints:

- no new packages;
- no new assets/fonts;
- no platform permissions;
- no live backend/provider SDK/direct AI calls;
- no billing/IAP;
- no upload activation;
- no platform save/share implementation unless separately approved.

## Suggested Implementation Slices

7C-01 Visual consistency:

- normalize spacing, radii, typography, chip/button/card states across shared widgets;
- avoid behavior/provider changes.

7C-02 Small Android polish:

- fix overflows/clipping on 320-360dp;
- keep CTAs reachable with keyboard;
- ensure bottom-nav labels fit;
- wrap long Russian copy.

7C-03 State polish:

- loading/empty/error/disabled/cached states;
- insufficient-balance state;
- active-job state;
- failed-job state;
- explicit placeholder/no-op feedback.

7C-04 Copy/localization cleanup:

- remove technical copy;
- keep RU-first UI;
- align button/status labels;
- preserve approved legal/auth wording.

7C-05 QA bugfix pass:

- targeted fixes from Redmi smoke only;
- no broad redesign;
- no new product scope.

## QA Planning

Smoke matrix:

- fresh launch;
- login/session restore;
- Home;
- Create;
- Tools / Template Detail;
- Result;
- Library;
- Pricing/Profile/Settings if touched;
- logout and back protection.

Small-screen checks:

- Redmi 7 `720x1520`, density `320`;
- no overflow;
- CTA visible;
- keyboard-safe forms;
- bottom nav labels fit.

Accessibility checks:

- tap targets >= 48dp;
- contrast readable;
- disabled states distinguishable;
- semantic labels for icon-only buttons;
- focus order is logical.

Screenshots:

- Welcome/Auth if impacted;
- Home;
- Create keyboard;
- Tools empty/error/loading;
- Template Detail;
- Result states;
- Library states;
- Pricing/Profile/Settings.

Release blockers:

- failing analyze/tests/scans/build;
- no Redmi smoke;
- accessibility P0 issue;
- clipped CTA/copy;
- raw exception;
- broken auth/nav/persistence;
- staged artifacts/secrets/APK;
- live backend/provider/IAP/upload/permission creep.

## Backend/Data Gate

Phase 7C can remain UI-only.

Allowed:

- labels;
- hints;
- semantics;
- button text;
- error descriptions;
- disabled-state copy;
- UI-only placeholders.

Forbidden:

- API/schema/storage changes;
- DTO/error-code/status enum changes for copy;
- cache fallback rule changes;
- fake persisted history in Drift;
- auth/session storage changes;
- package cache or billing invariant changes;
- IAP/provider config;
- signed URL persistence;
- upload activation.

## Repo Gate

Phase 7C code must not start before Phase 7A/7B and repo gates close.

Future commit split recommendation:

- `docs: plan phase 7c release polish`;
- `ui: final polish and accessibility`;
- `test: release readiness checks`;
- `ci: harden mobile checks` only with separate approval.

Forbidden staged artifacts:

- `build/`;
- screenshots from `build/`;
- APK/AAB/IPA;
- `.dart_tool/`;
- coverage;
- DB/sqlite/cache;
- `.env*`;
- signing keys/certs;
- provider configs;
- generated files without reason;
- platform permission/dependency changes without approval.

## Role Gate Summary

- Product Lead: accepted Phase 7C as P0 polish/release-readiness, not feature expansion.
- UI UX: accepted accessibility, small-screen, copy, state and visual release gates.
- Mobile Architecture: accepted UI-only boundaries and implementation blockers.
- Mobile Implementation: accepted likely files, slices, blockers and verification.
- QA Release: accepted smoke matrix, accessibility checks and release blockers.
- Backend/Data: PASS; Phase 7C can remain UI-only.
- Repo GitHub: code blocked until Phase 7A/7B and repo gates close.
- Task Chat Logic: planning-only accepted; implementation requires P0-free prior gates and clean ownership.

## Current Coordinator Decision

Phase 7C is planning-ready but implementation-blocked. Do not start Phase 7C app-code until Phase 7A and Phase 7B are complete, reviewed and safely separated in git.
