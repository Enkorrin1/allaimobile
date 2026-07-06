# Phase 7 Sprint Board

Date: 2026-07-06.

Status: planning-only board. Phase 7 app-code remains on hold until the repo/dirty-tree gate is explicitly approved and completed.

## Current Decision

Role consensus:

- Repo unblock split: READY after explicit user approval.
- Phase 7A app-code: BLOCKED until repo unblock completes.
- Phase 7B app-code: BLOCKED until Phase 7A passes review with no P0 issues.
- Phase 7C app-code: BLOCKED until Phase 7B passes review with no P0 issues.
- Push/PR: HOLD until local split, checks and QA evidence are reviewed separately.

The next executable user decision is still:

```text
Разрешаю выполнить repo-unblock split без push: при необходимости создать ветку `codex/repo-unblock-phase-7`, stage только явными путями/patch hunks, сделать отдельные commits для Phase 5 Slice C code, Phase 6 Slice A/Stabilization code, Phase 5/6 docs и Phase 7/7A/7B/7C planning docs. Не использовать `git add .`; build/cache/secrets/APK исключить.
```

This approval authorizes only local repo split and verification. It does not authorize push/PR or Phase 7 app-code.

## Board

| ID | Task | Owner | Status | Depends On | Done When |
| --- | --- | --- | --- | --- | --- |
| P7-R0 | Approve repo-unblock path | User + Coordinator | BLOCKED | User explicit approval | Approval text or equivalent explicit command is given |
| P7-R1 | Read-only repo preflight refresh | Repo GitHub | READY AFTER P7-R0 | P7-R0 | Status, diff, artifact and secret checks reviewed |
| P7-R2 | Create/switch repo branch | Repo GitHub | READY AFTER P7-R0 | P7-R0 | `codex/repo-unblock-phase-7` is active or existing branch is confirmed |
| P7-R3 | Split Phase 5 Slice C code commit | Repo GitHub | BLOCKED | P7-R0, P7-R1, P7-R2 | Staged diff reviewed, no forbidden files, commit created |
| P7-R4 | Split Phase 6 code commit | Repo GitHub | BLOCKED | P7-R3 | Drift/generated pairing checked, commit created |
| P7-R5 | Split Phase 5/6 docs commit | Repo GitHub | BLOCKED | P7-R4 | Docs staged by explicit path or hunk, commit created |
| P7-R6 | Split Phase 7 planning docs commit | Repo GitHub | BLOCKED | P7-R5 | Phase 7 docs staged by explicit path or hunk, commit created |
| P7-R7 | Post-split verification | Repo GitHub + QA Release + Architecture + Backend/Data | BLOCKED | P7-R6 | Diff clean enough for Phase 7A start, checks pass or documented |
| P7-A0 | Authorize Phase 7A app-code | User + Coordinator | BLOCKED | P7-R7 | Explicit Phase 7A implementation approval is given |
| P7-A1 | Theme tokens and shared UI foundation | Mobile Implementation + UI UX | BLOCKED | P7-A0 | App theme and primitives match Phase 7A file plan |
| P7-A2 | AppShell and bottom navigation redesign | Mobile Implementation + Architecture | BLOCKED | P7-A1 | Auth-gated shell works without route/session regression |
| P7-A3 | Welcome/Login/Register/Reset redesign | Mobile Implementation + Product + UI UX | BLOCKED | P7-A1 | Auth screens fit Redmi 7, keyboard-safe, copy approved |
| P7-A4 | Phase 7A tests, scans and Redmi smoke | QA Release + Mobile Implementation | BLOCKED | P7-A2, P7-A3 | Analyze/tests/scans plus physical-device evidence completed |
| P7-A5 | Phase 7A review gate | Product + UI UX + Architecture + Backend/Data + QA + Repo + Task Chat Logic | BLOCKED | P7-A4 | PASS or CONDITIONAL with no P0 blockers |
| P7-B0 | Authorize Phase 7B signed-in redesign | User + Coordinator | BLOCKED | P7-A5 | Explicit 7B start decision is given |
| P7-B1 | Home + Create first signed-in slice | Mobile Implementation + UI UX | BLOCKED | P7-B0 | Home dashboard and Create flow visually redesigned |
| P7-B2 | Tools/Catalog + Template Detail slice | Mobile Implementation + Product + UI UX | BLOCKED | P7-B1 | Catalog filters/cards/detail states fit small screens |
| P7-B3 | Result Viewer + Library slice | Mobile Implementation + QA Release | BLOCKED | P7-B2 | Active/completed/failed result states and library routes preserved |
| P7-B4 | Optional Profile/Pricing consistency polish | Mobile Implementation + Backend/Data | PLANNED | P7-B3 | Only if needed for visual consistency, no billing behavior drift |
| P7-B5 | Phase 7B tests, scans and Redmi smoke | QA Release + Repo GitHub | BLOCKED | P7-B3 | Signed-in workflow evidence and repo hygiene pass |
| P7-B6 | Phase 7B review gate | Product + UI UX + Architecture + Backend/Data + QA + Repo + Task Chat Logic | BLOCKED | P7-B5 | PASS or CONDITIONAL with no P0 blockers |
| P7-C0 | Authorize Phase 7C release polish | User + Coordinator | BLOCKED | P7-B6 | Explicit 7C start decision is given |
| P7-C1 | Small-screen and accessibility polish | Mobile Implementation + UI UX + QA | BLOCKED | P7-C0 | 320-360dp, text scale and tap-target issues are closed |
| P7-C2 | State and Russian copy cleanup | Product + Mobile Implementation + QA | BLOCKED | P7-C1 | Empty/error/loading/disabled states and terms are consistent |
| P7-C3 | Visual consistency and QA bugfix pass | Mobile Implementation + UI UX + Architecture | BLOCKED | P7-C2 | No second design language or behavior drift |
| P7-C4 | Final release-readiness verification | QA Release + Repo GitHub + Coordinator | BLOCKED | P7-C3 | Full checks, screenshots and final repo hygiene complete |

## Role Lanes

Product Lead:

- Owns product milestones, release claims and P0 product blockers.
- Reviews Phase 7A auth/shell, Phase 7B signed-in workflow and Phase 7C copy/state polish.

UI UX:

- Owns design acceptance, screen hierarchy, mobile fit and visual consistency.
- Requires Redmi 7 evidence for auth, shell, Home, Create, Catalog, Result, Library and optional Pricing/Profile.

Mobile Architecture:

- Owns route/session/state boundaries and forbidden-scope scans.
- Stops any router, provider, platform, dependency, schema, billing or upload creep outside approved slice scope.

Backend/Data:

- Owns data/API/storage guardrails only.
- Checks that auth, catalog, generation, result/library and billing semantics are unchanged during visual polish.

Mobile Implementation:

- Owns app-code only after the relevant gate is explicitly opened.
- First action after repo unblock is read-only status confirmation, then Phase 7A theme/foundation work.

QA Release:

- Owns automated checks, physical Redmi 7 smoke, screenshots and release evidence hygiene.
- Screenshots/APK/build artifacts must remain ignored and unstaged.

Repo GitHub:

- Owns branch, staging, commits, artifact/secret scans and later push/PR readiness.
- Must stage by explicit path or hunk, never with `git add .`.

Task Chat Logic:

- Owns coordination rules, decision states and role boundaries.
- Confirms Phase 7 is visual/product polish, not a new task-agent/chat feature.

## Stop Rules

Stop and return to the coordinator if any of these happen:

- User has not explicitly approved repo split, but staging/commit/app-code is requested.
- A task requires `git add .`, destructive git reset/checkout or broad cleanup of unrelated dirty files.
- A staged diff contains build/cache/APK/AAB/IPA/screenshots/db/env/secrets/keys/certs.
- Phase 7 app-code touches backend/provider SDKs, real billing/IAP, upload/permissions, platform config, Drift schema or generated database files.
- Auth/session/navigation/generation/billing/library behavior changes without an approved implementation gate.
- Redmi 7 evidence is missing for the relevant slice.
- Any P0 issue remains open at a review gate.

## Decision States

- PASS: dependency cleared and the next task can start.
- CONDITIONAL: review/planning can continue, but app-code or release remains on hold.
- BLOCKED: explicit approval is missing, repo state is unsafe, P0 issue exists, ownership is violated or scope has crept.
- HOLD: no action until a separate user decision is made.

## Next Action

Ask the user for the repo-unblock approval wording above. After approval, execute only the repo split runbook, verify it, and then request a separate Phase 7A app-code start decision.
