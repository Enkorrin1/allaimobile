# Phase 7 UI/UX Overhaul Contract Review

Date: 2026-07-04.

Status: role planning gates collected; implementation is conditional until commit split/repo hygiene is handled.

## Decision

Phase 7 should start with a focused first implementation slice:

`Phase 7A: Design foundation + Welcome/Auth/App shell`.

This fixes the physical-device first impression first, then gives the rest of the app a reusable visual foundation. The first code slice must not redesign every screen at once.

## Product Gate

PASS.

P0 screens:

- Welcome/Auth.
- Home/App shell.
- Create.
- Catalog/Templates.
- Generation progress.
- Result Viewer.
- Library.
- Pricing.
- Profile/Settings.

Primary flow priority:

1. Welcome to auth to main app shell.
2. Create to quote/balance gate to progress to Result to Library.
3. Catalog/template to Create.
4. Insufficient balance to Pricing.
5. Profile/settings/logout.

Launch risk if rough UI remains: users may not trust generation, coins or account flows, and adding upload/image-to-image on top of rough UI would increase confusion.

## UI/UX Gate

PASS.

Design direction:

- Mobile-native studio, not an in-app landing page.
- Format-first creation.
- Visual scenario cards inspired by AllAI source: UGC, Cinema, Hook, Try-on, image/video studio.
- Media-first Result and Library.
- Dense but readable mobile screens.
- Small-screen target: 320-360dp Android devices.

First slice recommendation: design foundation, Welcome/Auth and App shell.

## Architecture Gate

PASS with constraints.

Start with theme/tokens/shared widgets before screen repaint:

- app theme, colors, typography, spacing, radii and state colors;
- shared button, card, chip, input, preview, media tile and state widgets;
- no random hardcoded colors/radii/shadows in individual screens.

Must not change:

- auth/session/router guard semantics;
- generation create/status/polling semantics;
- billing invariants;
- Drift schema/migrations;
- backend/live/provider/billing boundaries;
- upload/image-to-image activation;
- Android/iOS permissions.

## Mobile Implementation Gate

PASS for planning, code not started.

Recommended implementation order:

1. Design-system base.
2. App shell and bottom nav.
3. Welcome/Login/Register/Reset.
4. Home/Create.
5. Catalog/Templates.
6. Result/Library.
7. Pricing/Profile/Studio.
8. Android small-device polish.

Implementation must preserve current auth, catalog, generation, billing, result and library behavior.

## QA Gate

PASS for planning, device QA required after implementation.

Baseline device is now available: physical Redmi 7 connected and current app launched.

Must-pass after Phase 7A:

- `flutter analyze` PASS.
- `flutter test` PASS.
- Android physical-device smoke on Redmi 7.
- Welcome/Auth/App shell no overflow on small screen.
- No upload/provider/billing/permission creep.

Full Phase 7 smoke must cover auth, navigation, Create, generation, Result, Library, Pricing and Profile.

## Backend/Data Gate

PASS.

No API/schema changes are needed for visual redesign. Phase 7 should use existing repositories, DTOs and Drift cache. Presentation mappers or safe local visual fixtures are acceptable, but schema/live/API changes are not.

## Repo/GitHub Gate

CONDITIONAL.

Planning can continue, but Phase 7 code should not start on top of the current mixed dirty tree. Repo/GitHub recommends commit split first because the workspace already mixes Phase 5, Phase 6, Slice B planning and Phase 7 planning changes.

Constraints:

- do not stage with `git add .`;
- keep visual assets under an explicit `assets/...` policy and declare them in `pubspec.yaml` only after approval;
- do not stage screenshots or build artifacts such as `build/allai_phone_screen.png` or debug APKs;
- do not change generated Drift files for UI-only work;
- avoid new visual dependencies without Product/UI/Architecture approval;
- no commit/push without explicit user confirmation.

## Task Chat Logic Gate

PASS.

Coordination is clean:

- one code owner for implementation: Mobile Implementation;
- planning gates before code;
- no user-facing task-agent scope;
- no live provider/backend/billing/upload creep;
- no commit/push without explicit confirmation.

## Phase 7A Entry Criteria

- Repo/GitHub commit-split warning is acknowledged and repo hygiene is repeated before code.
- UI/UX screen spec remains accepted as the target for first slice.
- Mobile Implementation starts only with design foundation + Welcome/Auth/App shell.
- QA baseline device remains available for physical smoke.
