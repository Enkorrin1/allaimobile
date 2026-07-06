# Phase 6 Slice B Contract Review

Date: 2026-07-04.

Status: planning gates collected; implementation is BLOCKED until the Slice A Android QA re-smoke can run on a working emulator/device and returns PASS or CONDITIONAL with no P0.

## Decision

Slice B may continue as planning and contract work only.

Do not start app-code implementation for upload/image-to-image yet. The preview P0 was fixed locally and verified by automated checks, but QA could not repeat the Android smoke because the local environment has no available Android device or AVD.

## Slice A QA Dependency

Latest QA result after the preview fix: BLOCKED by environment.

Evidence from QA:

- Fresh debug APK exists at `build\app\outputs\flutter-apk\app-debug.apk`.
- `adb devices` returned no connected device.
- `D:\AndroidSDK\emulator\emulator.exe` exists, but `-list-avds` returned no AVD.
- `flutter emulators` timed out.
- Restarting the ADB server did not restore a device.

Not yet re-smoked after the preview fix:

- prompt-only success to completed Result preview without decompression exception;
- Result action snackbar behavior;
- Library completed card opens the completed preview;
- failed retry/refund path.

## Role Gates

Product Lead: PASS for planning. Slice B P0 is one source image for image-to-image, source preview/remove/replace, permission trust copy, quote/reserve/no-charge behavior, generation failure refund/no-charge copy and Result "use as source" for completed images only.

Backend/Data: PASS for planning. Upload/source contracts are defined around typed upload requests, runtime-only signed upload targets, upload completion semantics, asset expiry/refresh, public-only cache fields and idempotent upload/create retry.

Mobile Architecture: BLOCKED for implementation. First code sub-slice must introduce `GenerationCacheDataSource` and a neutral Library/Result repository boundary before upload UI. Signed upload URLs must never be persisted. Media picker/file APIs must stay behind a media service.

UI UX: PASS for planning. Source image UX covers picker entry, cancel, permission denied, invalid/large file, preview, remove/replace, active upload, quote/reserve states, failed upload/generation and small-screen wrapping.

QA Release: planning matrix is ready, but implementation gate is blocked by the Slice A Android environment blocker. QA must repeat Slice A smoke on a working device before Slice B code starts.

Repo GitHub: CONDITIONAL. Existing dependencies are enough for planning, but platform permission changes need an approved diff. Dirty tree is mixed and must be split before any commit. No `git add .` for this scope.

Task Chat Logic: CONDITIONAL. Coordination is clean for planning, but implementation must keep one code owner, avoid user-facing task-agent scope and prevent live provider/backend/billing creep.

Mobile Implementation: planning only. Likely implementation path and file areas are identified, but no code should start until entry criteria are met.

## Entry Criteria For Slice B Implementation

- Slice A repeat Android smoke returns PASS or CONDITIONAL with no P0.
- Product/Data/Architecture/UI/QA/Repo planning gates stay documented.
- `GenerationCacheDataSource` and neutral Library/Result repository boundary are accepted as the first implementation sub-slice.
- Media permission diff for Android/iOS is approved before touching platform files.
- Upload/source asset contract keeps signed upload URL, headers and fields runtime-only.
- `clientRequestId` strategy is durable enough for upload and create-job idempotency.
- Commit split is confirmed before staging or committing.

## First Implementation Order After Unblock

1. Boundary cleanup: introduce `GenerationCacheDataSource` and move Library/Result reads away from direct mock bridge.
2. Upload/source domain models plus mock-default `UploadRepository` and fail-closed live skeleton.
3. Media service and validation boundary, still without platform permission changes until approved.
4. Source image UI: select, preview, remove, replace, cancel and error states.
5. Image-to-image create request using one `inputAssetId` and existing mock polling lifecycle.
6. Library/Result source-aware states and failed retry/refund copy.
7. Result "use as source" only when it is fully wired for completed image assets.

## Hard Boundaries

- No real backend URL or credentials.
- No provider SDKs, provider keys or direct AI provider calls from mobile.
- No real billing/IAP.
- No signed upload URL persistence in Drift, secure storage, fixtures, logs or analytics.
- No platform media permissions until the exact diff is approved.
- No commit or push without explicit user confirmation.
