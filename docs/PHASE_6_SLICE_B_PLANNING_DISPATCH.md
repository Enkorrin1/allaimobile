# Phase 6 Slice B Planning Dispatch

Date: 2026-07-04.

Status: dispatched to role chats as planning-only work.

Reference: `docs/PHASE_6_SLICE_B_PLANNING_BRIEF.md`.

## Global Rule

No app-code edits, no platform permission changes, no dependency changes, no commit and no push during planning. Slice B implementation is blocked until Phase 6 Slice A stabilization QA closes with PASS or CONDITIONAL with no P0 blockers.

## Assignments

### Product Lead

Define product acceptance for source image upload and image-to-image:

- P0/P1 scope.
- Source preview, remove and replace behavior.
- Permission and trust copy.
- Quote, reserve and refund behavior.
- Result "use as source" behavior.
- Explicit out-of-scope items for Slice B.

### Backend Data

Define data/API contracts:

- Typed upload request and response.
- Runtime-only signed URL handling.
- Source asset and output asset fields.
- Image-to-image create-job request shape.
- Upload completion semantics.
- Expiry/refresh policy.
- Idempotency for upload/create retry.
- Public-only cache fields and failure/refund semantics.

### Mobile Architecture

Define implementation entry gates:

- `GenerationCacheDataSource` boundary.
- Neutral Library/Result repository boundary.
- Upload repository/data-source boundary.
- Active job lifecycle and polling backoff.
- Client request id persistence and idempotency.
- Android/iOS media permission gate.
- No live/provider/billing creep.

### UI UX

Define mobile UX states:

- Picker entry.
- Permission denied.
- Picker cancel.
- Invalid or large file.
- Source preview.
- Remove/replace.
- Reference strength if needed.
- Quote/reserve states.
- Upload/progress states.
- Failed upload/generation.
- Result "use as source".
- Small-screen constraints.

### QA Release

Finish Slice A stabilization re-smoke first, then prepare Slice B QA matrix:

- Permission denied.
- Picker cancel.
- Invalid or large file.
- Upload failure/retry.
- Source preview/remove/replace.
- Image-to-image success.
- Failed generation/refund.
- Restart/persistence.
- No live/provider/billing creep.

### Repo GitHub

Review repo and platform risks:

- Existing picker dependencies.
- Android/iOS permission diff policy.
- Build artifacts and generated files.
- CI needs.
- Commit split before Slice B.
- No secrets/provider SDK/IAP.

### Task Chat Logic

Verify coordination boundaries:

- One code owner.
- Planning-only until Slice A QA closes.
- No task-agent/chat user-facing scope.
- No live provider/backend/billing scope.
- Media permission gate required.
- No commit/push.

### Mobile Implementation

Return implementation plan only:

- Likely files.
- Order of work.
- Tests needed.
- Boundary risks.
- Dependency and permission assumptions.
- Blockers.

## Expected Coordinator Output

After role replies are collected, create a Slice B contract review doc and decide whether the next implementation slice is:

1. Architecture/data boundary cleanup first.
2. Source image picker/upload mock path.
3. Result "use as source" flow.
