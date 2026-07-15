# Phase 8C - Favorites Assignments

Status: implementation in progress locally.

## Product Lead

- Keep favorites limited to catalog models and templates.
- Store stable identifiers only; catalog remains the source of truth.

## UI UX

- Use a bookmark icon on detail screens.
- Show favorites as one compact, image-led Home rail.

## Mobile Architecture

- Own persisted state in a Riverpod controller behind the storage boundary.
- Keep the format compatible with future account synchronization.

## Mobile Implementation

- Add/remove model and template favorites.
- Restore favorites after app restart.
- Open saved catalog items from Home and prefill Create correctly.

## Backend Data

- Validate stored IDs against the current catalog at render time.
- Do not persist catalog payloads or provider-only data in favorites.

## Localization

- Add favorite labels to all generated locale contracts.

## QA Release

- Test persistence, malformed storage recovery and toggle behavior.
- Run analyzer, localization audit and the complete Flutter suite.

