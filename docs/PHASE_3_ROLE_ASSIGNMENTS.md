# Phase 3 Role Assignments

Date: 2026-07-03.

Phase: Typed Data Layer And Mock Backend.

Goal: make the app behave like a real product through typed models, repositories, Riverpod state, mock API adapters, and local persistence, without depending on a live backend.

## Coordination Rules

- Coordinator chat owns merging and final decisions.
- Mobile Implementation is the only code-change owner for this phase.
- Other role chats provide review, contracts, acceptance criteria, and QA gates.
- No real provider SDKs, provider keys, billing credentials, auth credentials, or production secrets may be added.
- No git commit or push until the user explicitly confirms.

## Product Lead

Owner of Phase 3 user outcomes and acceptance.

Tasks:

- Confirm the product behavior for catalog loading, prompt creation, job progress, completed result, failed result, history, and insufficient balance.
- Define the exact MVP success path for photo generation and video generation in mock mode.
- Decide which modes are enabled, disabled, or coming soon in Phase 3 mock behavior.
- Confirm acceptance wording for balance reserve, cost display, failure/refund messaging, and retry.

Deliverable:

- Product acceptance notes for Phase 3 and any blocking product decisions.

## Mobile Architecture

Owner of module boundaries and technical shape.

Tasks:

- Review the proposed typed data layer structure.
- Confirm where catalog, generation jobs, assets, billing, API adapters, Drift database, and secure storage belong.
- Check generated model strategy with Freezed/json_serializable and Drift tables.
- Guard against UI-only data leaking into domain models, especially `IconData`, `Color`, and formatted copy.

Deliverable:

- Architecture review and any required changes before implementation is considered complete.

## Backend Data

Owner of mobile-facing contracts and mock data truth.

Tasks:

- Convert `docs/DATA_AND_API.md` into implementation-ready DTO/model requirements.
- Define mock catalog response, generation job lifecycle, billing balance/packages, and asset records.
- Confirm enum-like ids and statuses use stable lowercase values.
- Define which fields are required now and which can remain optional until live backend integration.

Deliverable:

- Phase 3 data contract checklist for implementation and tests.

## Mobile Implementation

Code owner for Phase 3.

Tasks:

- Add typed Dart models for catalog, templates, generation jobs, assets, billing balance, coin packages, and coin transactions.
- Add mock API/repository layer for catalog, generation, assets/history, and billing.
- Add Riverpod providers/controllers so key screens load from repositories instead of raw presentation fixtures.
- Add deterministic mock generation jobs with queued/running/completed/failed states.
- Add local persistence for mock history metadata with Drift/SQLite if feasible in this slice; otherwise document a smaller Slice A and leave Drift for Slice B.
- Keep all existing visible screens usable while replacing data plumbing.
- Add tests for model parsing, mock job lifecycle, and basic provider/screen behavior.

Deliverable:

- Local code changes only, with format/analyze/test and Android debug build results.

## QA Release

Owner of verification.

Tasks:

- Run or prepare final Phase 2 Android manual smoke.
- Create Phase 3 smoke checklist for catalog loading, job creation, progress, history persistence, failed job, insufficient balance, and offline cached history.
- Verify that no provider SDKs, secrets, live billing, live auth, or production backend assumptions were introduced.

Deliverable:

- QA gate result with pass/fail/blocker notes.

## UI UX

Owner of interaction quality during data-layer changes.

Tasks:

- Check that async states still have proper loading, empty, error, disabled, and insufficient-balance states.
- Review job progress and result states for understandable Russian copy.
- Check small-screen layout after data becomes dynamic.

Deliverable:

- UI/UX review with P0 fixes, P1 improvements, and copy notes.

## Repo GitHub

Owner of repository hygiene only.

Tasks:

- Track local change scope.
- Do not commit or push without explicit user confirmation.
- Recommend commit split when Phase 3 is ready.
- Confirm CI readiness for generated files and build_runner outputs.

Deliverable:

- Git/CI readiness note.

## Task Chat Logic

Owner of coordination model.

Tasks:

- Keep role ownership clear and avoid duplicate code owners.
- Suggest future in-app task-chat/agent orchestration only as product design notes, not implementation in Phase 3 unless explicitly requested.

Deliverable:

- Coordination note if role overlap or workflow risk appears.
