# Phase 6 Execution Brief: Image Generation MVP

Date: 2026-07-03.

Status: planning-only. No implementation starts until role gates are collected and Phase 5 QA closure is recorded.

## Objective

Implement the first end-to-end image generation loop in a backend-ready way while keeping the local mock runtime safe by default.

The target loop:

1. User selects an image-capable model/template.
2. User enters a prompt and optional image input.
3. App shows quote/cost and available balance.
4. App creates a generation job.
5. App tracks queued/running/processing/completed/failed states.
6. Completed job opens Result Viewer with generated image.
7. Result is saved to Library and can be shared/downloaded.
8. Failed job keeps prompt/settings and shows retry/refund/no-charge copy.

## In Scope

- Prompt-only image generation flow.
- Image upload/source input contract.
- Mock upload and mock image-generation adapter.
- Backend-ready interfaces for upload/job/status/asset access.
- Polling/state controller with bounded retry/backoff.
- Active job persistence through app restart.
- Completed/failed image job persistence in Library.
- Result Viewer image states and basic share/download hooks.
- Tests for quote, creation, polling, success, failure and restart behavior.

## Out Of Scope

- Real backend URL/credentials.
- Direct provider SDKs or provider API calls from mobile.
- Video generation.
- Real billing/IAP or store purchase flow.
- Push notifications.
- Social publishing.
- Full editor/timeline.
- Task-chat/AI-agent user-facing roles.

## Required Planning Gates

- Product: P0 acceptance and allowed mock-mode behavior.
- Backend Data: API/data/cache/error contract.
- Mobile Architecture: boundaries, polling, persistence and provider isolation.
- UI UX: states/copy/small-screen behavior.
- QA Release: Android smoke and regression matrix.
- Repo GitHub: dependency/platform/CI/secrets hygiene.
- Task Chat Logic: ownership and scope separation.
- Mobile Implementation: implementation plan only.

## Acceptance Direction

Implementation should be accepted only if:

- mock-default runtime works without live endpoints;
- UI uses repository/provider state, not direct API/cache/database imports;
- no secrets or provider routing fields are stored in mobile/cache/logs;
- insufficient balance blocks job creation based on `availableCoins`;
- active jobs survive restart or restore into a clear user-facing state;
- completed jobs show image output in Result Viewer and Library;
- failed jobs do not lose prompt/settings and show retry path;
- no real billing/provider/live backend work is added without explicit approval;
- format, analyze, tests, Android debug build and source scans pass.

## Open Questions For Role Gates

- Is prompt-only image generation enough for Phase 6 P0, or must image-to-image upload be included in the same implementation slice?
- What exact job statuses should mobile poll and display?
- When are coins reserved, charged, released or refunded?
- What image asset fields are guaranteed: URL, thumbnail, dimensions, mime type, expiry?
- Should share/download be local mock hooks or real platform share/download in Phase 6?
- How should generation behave if auth expires while a job is active?
- What is the maximum polling duration and fallback copy?
- Which Android/iOS permissions are required for image picking and saving?
