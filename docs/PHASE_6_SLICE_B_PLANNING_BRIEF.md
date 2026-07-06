# Phase 6 Slice B Planning Brief

Date: 2026-07-04.

Status: planning-only dispatch. No app-code edits until Phase 6 Slice A QA re-smoke returns PASS or CONDITIONAL with no P0 blockers.

## Goal

Prepare the next implementation slice for source image upload and image-to-image generation while preserving the mock-default runtime and safe provider boundaries.

## Candidate Scope

- Source image selection UI for image generation.
- Local preview, remove/replace source image and clear permission/error states.
- Upload API contract and client-side repository boundary.
- Runtime-only signed upload URL handling.
- Image-to-image create job request shape with source asset reference.
- Result Viewer action path for "use as source" only after the action is properly wired.
- Library/Result repository boundary cleanup required before live-adjacent upload work.

## Required Pre-Implementation Decisions

- Media permission strategy for Android and iOS.
- Whether Slice B uses mock-only local source image metadata or a mock upload asset path.
- Asset URL expiry and refresh policy.
- Idempotency policy for upload and create-job retry.
- Whether `GenerationCacheDataSource` is introduced before upload UI.
- Whether Library/Result moves away from direct mock bridge before upload implementation.
- QA matrix for picker permission denied, cancel, invalid file, large file, upload failure, retry, restart and failed generation.

## Hard Boundaries

- No real backend URL or credentials.
- No provider SDKs, provider keys or direct AI provider calls from mobile.
- No real billing/IAP.
- No platform permission changes until Repo, QA, Architecture and Product approve the exact Android/iOS changes.
- No signed upload URL persistence.
- No commit or push without explicit user confirmation and commit split.

## Role Assignments

- Product Lead: define Slice B product acceptance and P0/P1 scope.
- Backend Data: define upload, source asset, image-to-image create job and asset expiry contracts.
- Mobile Architecture: define cache/repository/lifecycle boundaries and permission gate rules.
- UI UX: define mobile source-image flow, permission/error/cancel states and Result "use as source" behavior.
- QA Release: prepare upload/image-to-image smoke matrix; continue Slice A re-smoke first.
- Repo GitHub: review dependency, permission, generated-file and commit-split risks.
- Task Chat Logic: verify ownership and prevent task-agent/live-provider/billing scope creep.
- Mobile Implementation: planning only; no app-code edits until gates are complete.

## Entry Criteria For Implementation

- Slice A stabilization QA re-smoke is PASS or CONDITIONAL with no P0.
- Product/Data/Architecture/UI/QA/Repo planning gates are collected.
- Media permission diff is approved before any platform file changes.
- Commit split strategy is confirmed.
