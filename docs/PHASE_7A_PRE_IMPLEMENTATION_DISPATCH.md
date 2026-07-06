# Phase 7A Pre-Implementation Dispatch

Date: 2026-07-04.

Status: dispatched. Code remains on HOLD until repo gate is resolved.

## Role Tasks

Product Lead:

- Confirm Phase 7A acceptance for first impression, auth and app shell.
- Decide what product claims may appear on Welcome without overpromising upload/live features.
- Keep P0/P1 boundary tight.

UI UX:

- Turn the Phase 7 screen spec into a narrower Phase 7A spec for Welcome/Auth/App shell only.
- Define exact content hierarchy, CTA labels, navigation labels and small-screen behavior.
- Call out what visual elements can be built without adding binary assets.

Mobile Architecture:

- Define the exact theme/token/shared-widget files for Phase 7A.
- Confirm must-not-touch files and import-scan rules.
- Keep shared primitives reusable for later Create/Catalog/Result work.

Mobile Implementation:

- Prepare an implementation-ready file plan, but do not edit files until repo gate is resolved.
- Identify the smallest code diff for design foundation + Welcome/Auth/App shell.
- Preserve existing auth validation, session restore, router redirects and tests.

QA Release:

- Prepare Phase 7A baseline and post-implementation smoke steps for Redmi 7.
- Include keyboard, small-screen, auth restore, login/register/reset/logout and bottom nav checks.
- Confirm screenshot capture path for before/after evidence.

Backend Data:

- Confirm Phase 7A needs no API/schema/data changes.
- Identify whether existing mock user/session/profile data is enough for polished auth/profile shell.

Repo GitHub:

- Produce exact commit split/staging guidance for the current mixed tree.
- Identify which files belong to Phase 7 planning docs.
- Identify which existing dirty files must be committed before Phase 7A code or left untouched.
- Do not stage, commit or push.

Task Chat Logic:

- Re-check coordination: one code owner, no task-agent scope, no live backend/provider/billing/upload creep, no commit/push.

## Next Coordinator Decision

After role responses:

1. If Repo gives a safe path, start Phase 7A implementation.
2. If Repo requires commit split first, ask the user for explicit commit/split approval before app-code edits.
3. If any role introduces live/upload/billing scope, keep Phase 7A blocked and revise the brief.
