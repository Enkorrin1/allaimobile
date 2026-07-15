# Phase 8E - Saved Prompts Assignments

Status: implementation in progress locally.

## Product Lead

- Approve saved prompts as a Phase 8 creative workflow feature.
- Limit the local list to 20 recent unique prompts.

## UI UX

- Place prompt saving next to suggestion chips in the composer.
- Use compact chips with explicit remove controls.

## Mobile Architecture

- Keep prompt persistence in a dedicated Riverpod controller.
- Store category/model context with each prompt for future sync.

## Mobile Implementation

- Save, restore, select, deduplicate and remove prompts.
- Restore the original model when it is available in the current format.

## Privacy Data

- Keep prompt text on device in secure storage.
- Do not log, upload or include saved prompts in analytics.

## Localization

- Add save/remove/confirmation copy to all locale contracts.

## QA Release

- Test persistence, deduplication, list limit and malformed storage recovery.
- Run analyzer, localization audit and the complete Flutter suite.

