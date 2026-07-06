# Phase 6 Slice A Review Notes

Date: 2026-07-04.

Scope reviewed: prompt-only image generation loop, mock-default create/status polling, Result Viewer, Library history, failed retry/refund copy, upload skeleton, repo hygiene and coordination boundaries.

## Gate Summary

- Product Lead: PASS.
- Backend Data: PASS.
- Task Chat Logic: PASS.
- Repo GitHub: CONDITIONAL PASS.
- Mobile Architecture: CONDITIONAL.
- UI UX: CONDITIONAL with UI P0 blockers.
- QA Release: in progress; final gate paused until stabilization patch.

## QA Partial Evidence

- Emulator and debug APK were available.
- Fresh signed-out Welcome state passed.
- Mock login opened the protected app shell.
- Auth-gated Create was reachable.
- Prompt-only mode and upload-deferred copy were visible.
- Empty prompt copy was visible.
- CTA was disabled for empty prompt.
- Prompt submit, progress, Result Viewer and Library smoke were intentionally paused after the UI P0 blockers were reported.

## Accepted

- Prompt-only Slice A product acceptance is valid.
- Empty prompt blocks the CTA and shows user-facing copy.
- Quote uses selected model cost and `availableCoins`.
- Insufficient balance copy is present.
- Create and status polling are separated.
- Mock runtime remains default.
- Live generation and upload data sources fail closed.
- No provider SDKs, provider keys, direct provider calls, live billing/IAP or broad media permissions were added.
- Result Viewer renders completed image assets.
- Library lists active, completed and failed jobs.
- Failed jobs keep retry context and refund/no-charge copy.
- Upload/image-to-image remains deferred to Slice B.

## P0 Blockers

1. Result Viewer must not present active/queued/running jobs as completed results.
2. Library active job navigation by job id must open a progress/state view, not completed result UI.
3. Placeholder actions such as save/share/repeat/source/improve must not be silent no-ops. They must be disabled with clear "coming soon" affordance or provide safe visible feedback.

## P1 Follow-Ups

- Fix mojibake in Phase 6 result documentation during a docs cleanup pass.
- Use indeterminate progress when backend progress is unknown.
- Replace mixed English/Russian prompt hints with RU-only examples.
- Replace copy equivalent to "next slice" with user-facing "next update".
- Replace 1px mock image placeholder with a clearer mock thumbnail.
- Move Library/Result away from mock-bound repository wiring before live/Slice B upload.
- Add explicit `GenerationCacheDataSource` and app-wide active-job lifecycle policy before live.
- Persist client request id for idempotent live create retries.
- Reduce provider invalidation to create, terminal status and billing-affecting transitions before live.
- Add Android debug build and build_runner dirty-check to CI later.
- Keep commit split: Phase 5 Slice C, Phase 6 docs, Phase 6 Slice A implementation, later CI/permissions.

## Decision

Do not start upload/image-to-image Slice B yet.

Next coordinator step is Phase 6 Slice A Stabilization: close UI P0 blockers first, then rerun format/analyze/tests/Android build and QA re-smoke.

## Stabilization Acceptance

- Completed job: preview plus safe completed actions only.
- Active job: progress/status state, no completed-result preview/actions.
- Failed job: retry plus refund/no-charge copy, no save/share actions.
- Unknown progress: indeterminate loader.
- Result route may accept either an asset id or job id, provided the state is resolved safely.
- Silent no-op buttons are not allowed.
- Presentation screens stay free of data clients, database, picker/file APIs and mock API internals.
