# Phase 7 Role Assignments: UI/UX Overhaul

Date: 2026-07-04.

Status: dispatched to role chats.

## Coordinator Decision

Phase 7 starts as a UI/UX overhaul because the current physical-device preview confirms the app still feels like a rough technical MVP. The goal is to make the product credible and mobile-native before stacking more feature complexity on top.

## Role Tasks

Product Lead:

- Define product acceptance for the redesigned mobile experience.
- Prioritize must-polish screens and flows.
- Separate P0 product polish from P1 visual nice-to-haves.

UI UX:

- Own the mobile UX/design direction.
- Audit current screens against the AllAI product source.
- Produce screen-by-screen specs for Welcome, Login/Register, Home, Create, Catalog/Templates, Result, Library, Pricing and Profile.
- Define empty/loading/error/disabled states and small-screen behavior.

Mobile Architecture:

- Define Flutter UI architecture for the redesign.
- Keep theme, tokens and shared widgets reusable.
- Prevent screen-level hardcoding and broad rewrites.
- Identify what can change safely without affecting data/auth/generation boundaries.

Mobile Implementation:

- Prepare implementation plan only until UI/Product/Architecture gates are collected.
- Identify touched files and suggested slice order.
- Preserve existing app behavior and tests.

QA Release:

- Use the connected Android phone as the primary smoke target where possible.
- Prepare UI regression matrix for auth, navigation, Create, generation, Result, Library, Pricing and Profile.
- Include small-screen layout checks.

Backend Data:

- Confirm no data/API changes are needed for visual redesign.
- Identify mock data gaps that block credible UI states.
- Keep live backend/provider/billing out of this phase.

Repo GitHub:

- Review asset/generated-file policy for visual work.
- Confirm commit split strategy because the tree is already mixed.
- Ensure screenshots/build artifacts are not staged.

Task Chat Logic:

- Verify one code owner for implementation.
- Keep Phase 7 separate from task-agent product scope.
- Prevent live provider/backend/billing/upload creep.

## Gates Before Code

- Product acceptance for redesigned flows.
- UI UX screen spec.
- Architecture shared-widget/theme plan.
- Implementation slice plan.
- QA smoke matrix.
- Repo commit-split warning acknowledged.

## Out Of Scope

- Real AI provider integrations.
- Real payment/IAP.
- Media permission changes.
- Upload/image-to-image activation.
- Commit/push without explicit user confirmation.
