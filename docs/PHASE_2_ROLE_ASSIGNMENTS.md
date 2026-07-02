# Phase 2 Role Assignments

Date: 2026-07-02.

Phase: Design System And Static UI.

Goal: make the app demoable with static/mock data before backend integration.

## UI UX

Owns the mobile screen composition and interaction states.

Tasks:

- Refine the visual hierarchy for Home, Create, Library, Studio, Pricing, Profile, and Result Viewer.
- Define component states for loading, empty, error, success, disabled, active generation, and insufficient coins.
- Specify mobile-safe behavior for prompt input, media upload placeholders, filters, model selection, and cost preview.
- Confirm text density and Russian-first copy for MVP screens.

Deliverables:

- Screen-by-screen UI handoff notes.
- Component state checklist.
- Copy notes for primary actions and empty states.

## Mobile Implementation

Owns Flutter implementation of the static UI shell.

Tasks:

- Build reusable design primitives in `lib/shared/widgets`.
- Expand theme tokens in `lib/app/theme`.
- Implement static/mock Home screen.
- Implement static/mock Create screen with mode switch, prompt, settings, upload placeholder, model selector, and cost preview.
- Add Catalog/Templates and Template Detail routes with mock data.
- Implement Library grid/list mock history.
- Implement Result Viewer mock screen for image/video output.
- Add Pricing/Profile placeholders aligned with the product scope.
- Keep feature structure compatible with later typed data and backend integration.

Deliverables:

- Runnable static UI in Flutter.
- Widget/navigation tests for key routes and tabs.
- Updated README/docs if commands or structure change.

## QA Release

Owns Phase 2 verification.

Tasks:

- Prepare smoke checklist for static UI navigation.
- Verify small-screen layout constraints.
- Verify keyboard behavior on Create prompt input.
- Check empty/error/loading state coverage.
- Re-run format, analyze, test, and Android debug build.

Deliverables:

- Phase 2 smoke result.
- Blocker list before moving to typed mock data.

## Product Lead

Owns scope discipline and user-flow priority.

Tasks:

- Confirm which generation modes are P0 in static UI.
- Confirm pricing/coins copy for mock state.
- Confirm which templates/categories must appear first.
- Keep Phase 2 focused on UI skeleton, not backend expansion.

Deliverables:

- P0/P1 screen priority notes.
- Open product decisions for Phase 3.

## Backend Data

Owns future mock-data compatibility.

Tasks:

- Review static mock entities needed for Phase 2 screens.
- Confirm fields for generation modes, models, templates, jobs, assets, balances, and transactions.
- Mark what can be hardcoded now and what must become typed fixtures in Phase 3.

Deliverables:

- Mock entity checklist.
- Phase 3 data-layer handoff notes.

## Mobile Architecture

Owns architecture fit and technical guardrails.

Tasks:

- Review routes and feature boundaries before Phase 2 grows.
- Ensure static UI does not hardwire backend assumptions into widgets.
- Define where fixtures should live before Phase 3.
- Keep Riverpod providers thin until typed data layer is introduced.

Deliverables:

- Architecture review notes.
- Any refactor tasks required before Phase 3.

## Acceptance Criteria

- App starts into a polished static mobile shell.
- Main tab navigation and secondary routes work.
- All MVP screen placeholders are replaced with realistic static/mock UI.
- UI remains usable on small Android screens.
- No real provider secrets, direct AI provider SDKs, or production billing logic are introduced.
- Format, analyze, tests, and Android debug build pass.
