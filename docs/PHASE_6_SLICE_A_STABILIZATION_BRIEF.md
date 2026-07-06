# Phase 6 Slice A Stabilization Brief

Date: 2026-07-04.

Owner: Mobile Implementation.

Reviewers: UI UX, Mobile Architecture, QA Release, Repo GitHub if file scope changes materially.

## Goal

Close Slice A review blockers without expanding scope into upload/image-to-image, live backend, provider SDKs or production billing.

## Required Fixes

1. Result Viewer active-state rendering:
   - queued/running/active jobs show a progress/status card;
   - completed-only preview and actions are hidden or disabled until a completed asset is available;
   - failed jobs show retry/refund/no-charge copy and do not look like completed results.

2. Library active-card route:
   - active cards may navigate by job id;
   - Result Viewer must resolve job id safely and render the active progress state;
   - no route should imply that an active job already has a completed asset.

3. Placeholder actions:
   - save/share/repeat/source/improve actions must not be silent no-ops;
   - use disabled controls with "Soon" copy or show a safe local snackbar/feedback;
   - no platform permissions or real share/download integration in this slice.

## State Matrix

- Completed: image preview, metadata and only safe completed actions.
- Active/queued/running/processing: progress/status state, optional "open later" or Library navigation, no save/share/source/improve actions.
- Failed: preserved prompt/settings, retry action and refund/no-charge copy, no result-only actions.
- Canceled/refunded if present: terminal explanatory state, no result-only actions.

## Optional Safe Polish

- Indeterminate progress for unknown progress values.
- RU-only prompt hint.
- Copy polish from "next slice" wording to "next update" wording.
- Clearer mock thumbnail if it stays local and does not add dependencies.

## Boundaries

- No upload/image-to-image activation.
- No Android/iOS media permission changes.
- No live backend URL, credentials, provider SDKs, provider keys or direct AI provider calls.
- No real billing/IAP.
- Keep presentation imports free of data-layer clients, Drift database, picker/file APIs and mock API internals.
- No commit or push.

## Architecture Acceptance

- The existing route can keep its current path, but its parameter should be treated as `assetOrJobId` if needed.
- Temporary Library-to-mock bridge is acceptable for this stabilization only if screens remain clean.
- No new polling loop may be introduced from widget `build()` without cancellation guard.
- No Drift schema or generated database changes for this stabilization.

## Verification Required

- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- Android debug build when the patch changes UI/runtime behavior.
- Source scans for provider SDKs, IAP markers, broad media permissions and presentation import hygiene.
- QA re-smoke for active job progress, completed result, failed retry/refund, empty prompt, Library active/completed/failed and auth-gated routes.

## Dispatch Status

- Mobile Implementation: implementation assigned.
- UI UX: acceptance checklist assigned.
- Mobile Architecture: minimal boundary checklist assigned.
- QA Release: final gate paused and re-smoke checklist assigned.
