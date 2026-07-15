# Phase 8B Language Switcher Assignments

## Goal

Connect the already generated 12 launch locales to a user-facing language switcher that persists on the device.

## Agent Split

- Product Lead: confirm the launch language list remains `en`, `ru`, `es`, `fr`, `de`, `pt`, `it`, `tr`, `ar`, `hi`, `zh`, `ja`; default is system language.
- UI UX: keep Settings language control compact, readable, and consistent with the dark AllAi UI.
- Mobile Architecture: store only the selected locale code through the existing storage abstraction; avoid adding a new package.
- Mobile Implementation: wire locale state into `MaterialApp.router`, Settings UI, and generated localization copy.
- QA Release: verify language switch changes visible UI text and survives provider rebuilds.
- Repo GitHub: keep this separate from native OAuth, billing, provider SDKs, and release credentials.

## Scope

- Add persisted app locale state.
- Add Settings language picker.
- Support system language fallback.
- Add tests for switching to Russian from Settings.

## Out Of Scope

- Native OS language picker integration.
- Server-side profile language sync.
- Native review of every translation string.
- Store metadata localization.
