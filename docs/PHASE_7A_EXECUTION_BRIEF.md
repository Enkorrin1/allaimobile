# Phase 7A Execution Brief

Date: 2026-07-04.

Status: pre-implementation dispatch. App-code implementation is on HOLD until repo hygiene/commit split is handled or explicitly approved.

## Goal

Fix the first visible product impression and establish a reusable design foundation without changing the working app behavior.

Phase 7A scope:

- Design tokens/theme foundation.
- Shared UI primitives used by multiple screens.
- App shell and bottom navigation polish.
- Welcome/Login/Register/Password Reset redesign.
- Physical Android smoke on Redmi-class small screen.

## Why This Slice Comes First

The first device preview showed that the app launches and works, but the Welcome screen feels sparse and unfinished. Phase 7A addresses the highest-trust surface first and creates a foundation for later Create/Catalog/Result/Library redesign slices.

## In Scope

- `AppTheme` refinement: color, typography, spacing, radii and state colors.
- Shared widgets: buttons, cards, chips, text fields, status/empty/loading/error states and media preview surfaces where needed for auth/shell.
- App shell: bottom navigation state, spacing, labels/icons and small-screen tap targets.
- Welcome screen: product-like first screen with AllAi creative-studio framing and clear auth CTAs.
- Login/Register/Password Reset: compact, keyboard-safe, polished forms with clear validation and legal/18+ copy.
- Widget tests for existing auth/navigation behavior where affected.

## Out Of Scope

- Real backend URL, provider SDKs/keys or direct provider calls.
- Real billing/IAP.
- Upload/image-to-image activation.
- Android/iOS permission changes.
- Drift schema or generated database changes.
- Broad Create/Catalog/Result/Library/Pricing redesign, except shared primitives they consume naturally.
- Commit/push without explicit user confirmation.

## Hard Repo Gate

Current working tree is mixed across Phase 5, Phase 6 and Phase 7. Before app-code edits start, Repo/GitHub must provide a safe split/staging plan or the coordinator must get explicit user approval to proceed despite mixed changes.

No `git add .`.

## Verification For Phase 7A

- `dart format` on touched Dart files.
- `flutter analyze`.
- `flutter test`.
- Android install/launch smoke on connected Redmi 7.
- Screenshots for Welcome and signed-in shell after implementation.
- Source scan: no provider SDKs, secrets, IAP or permission changes.
- Presentation import scan for touched screens: no `Dio`, `AppDatabase`, `MockAllAiApi`, picker/file APIs.

## Acceptance

- Welcome no longer looks empty or unfinished on Redmi 7.
- Auth screens look coherent with the app and remain keyboard-safe.
- Bottom navigation feels intentional and readable on 320-360dp width.
- Existing auth/session/navigation behavior remains unchanged.
- No live/backend/billing/upload/platform-permission creep.
