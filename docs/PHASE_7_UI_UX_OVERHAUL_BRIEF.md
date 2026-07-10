# Phase 7 UI/UX Overhaul Brief

Date: 2026-07-04.

Status: planning and role dispatch.

## Why This Phase Exists

The current app is technically usable but visually reads as a rough engineering MVP. The first physical-device preview on Redmi 7 showed a sparse Welcome screen and unfinished product feel. Before adding more complex upload/image-to-image features, the app needs a proper mobile product layer.

## Design Brief

Redesign the AllAi mobile app into a polished, practical mobile product inspired by the current AllAi landing/product surface at `https://allai.market/ru/landing`, while keeping the app focused on real workflows instead of a marketing landing page.

The redesign must support full interactivity for the existing app flows:

- auth onboarding and account entry;
- Home/Studio entry;
- Create prompt-only generation;
- catalog/templates/tools;
- active generation progress;
- Result Viewer;
- Library/history;
- Pricing/coin balance;
- Profile/settings.

## Visual Direction

Use the AllAi source as product grounding:

- format-first creation flows;
- image and video AI generation;
- ready scenarios/templates;
- upload/source affordances for future work;
- studio-like creative controls;
- strong product imagery and preview surfaces.

Avoid the current sparse white prototype feel. The app should feel mobile-native, dense enough for repeated use, visually premium, and clear on small Android devices.

## Phase 7 Goals

- Replace the rough Welcome/Login/Register presentation with a credible AllAi mobile onboarding flow.
- Redesign app shell and bottom navigation so the main tasks are immediately legible.
- Make Create the primary production workflow, not a placeholder form.
- Make Catalog/Templates feel like selectable AI formats with visual cards and clear states.
- Make Library and Result Viewer feel like media/product history, not debug lists.
- Make Pricing/coins understandable without real billing/IAP.
- Introduce a consistent design system: colors, typography, spacing, cards, buttons, chips, empty/error/loading states and preview surfaces.
- Preserve current mock-default technical boundaries and tests.

## Non-Goals

- No live backend URL, provider SDK, provider key or direct AI provider call.
- No real billing/IAP.
- No upload/image-to-image activation in this phase unless explicitly approved after Slice B gates.
- No broad platform permission changes.
- No commit/push without explicit user confirmation.

## Acceptance Criteria

- The first screen no longer looks empty or unfinished on a real phone.
- Main app screens look like one coherent product.
- All current flows still work: login, navigation, catalog, create, generation progress, result, library, pricing and profile.
- Text fits on 320-360dp width without overlap.
- Buttons, chips and cards use consistent dimensions and states.
- Placeholder actions are either implemented or clearly disabled.
- Android physical-device smoke passes after implementation.
- `flutter analyze` and `flutter test` pass.

## Implementation Strategy

Do not start with random per-screen decoration. Start with a design-system pass, then update the highest-impact screens in slices:

1. Design audit and target screen spec.
2. Theme/tokens/shared widgets.
3. Welcome/auth redesign.
4. Home/Create/Catalog redesign.
5. Result/Library/Pricing/Profile redesign.
6. Device QA and polish.
