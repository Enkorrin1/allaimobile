# Phase 2 Review Findings

Date: 2026-07-03.

Status: role review collected.

## Overall Verdict

Phase 2 static/mock UI is implemented and pushed, but Phase 2 is not closed yet.

Automated checks passed before the first push:

- Format.
- Analyze.
- Widget tests.
- Android debug build.

Remaining gate:

- Phase 2 polish pass.
- Android manual smoke on a small device/emulator.
- Final review of visible RU copy, keyboard behavior, and layout overflow.

## P0 Polish Items

1. RU-first visible copy.
   Replace visible English labels in the main app shell and screens where practical for Phase 2:
   - Tabs.
   - Headers.
   - Buttons.
   - Result actions.
   - Statuses.
   - Form labels.
   - Empty/error/loading labels.

2. Library small-screen layout.
   Review `LibraryScreen` single-column behavior. Avoid card overflow by using a list layout or safer aspect ratio.

3. Create keyboard safety.
   Make `Create/Generator` safer with keyboard:
   - enough bottom padding;
   - prompt remains visible;
   - cost preview and main action remain reachable through scroll.

4. Compact balance chip.
   Add a compact balance variant for constrained app bar/header usage, keeping full balance copy in Pricing/Profile.

5. Route constants cleanup.
   Replace remaining literal route strings with `AppRoutes`.

6. App shell placement.
   Move `AppShell` out of `lib/shared/widgets` into an app-level folder because it depends on `go_router` navigation shell.

7. QA-visible states.
   Ensure at least one clear static example exists for empty, loading, error, disabled, and insufficient balance states.

## P1 / Phase 3 Handoff Items

- Split demo fixtures from future domain models.
- Add typed models for `GenerationMode`, `AiModel`, `Template`, `GenerationJob`, `Asset`, `BillingBalance`, `CoinPackage`, and `CoinTransaction`.
- Add repositories for catalog, generation, assets, and billing in Phase 3.
- Keep domain models free of `IconData`, `Color`, and formatted labels.
- Use lowercase enum-like ids and statuses: `photo`, `video`, `upscale`, `avatar`, `motion`, `running`, `completed`, `failed`.
- Decide whether Motion is available P0 mock or a disabled/coming-soon state.
- Keep real provider names backend-driven; demo names are acceptable until catalog integration.

## QA Gate

Before closing Phase 2:

- Run Android emulator/device smoke.
- Check primary tabs.
- Check `/tools`, `/tools/:toolId`, `/templates/:templateId`, `/result/:assetId`, `/pricing`, `/settings`.
- Check Android back behavior on secondary routes.
- Check Create with keyboard.
- Check small-screen layout, especially Library, Result actions, Pricing packages, and long Russian copy.
- Confirm no real API, auth, billing, upload, provider SDK, polling, or persistence was added.

## Role Summary

- UI UX: conditional pass; main fixes are RU-first copy, Library layout, keyboard Create, compact balance, visible states.
- Mobile Architecture: pass with P1 cleanup; no API/storage/billing side effects found.
- QA Release: automated gate passed; Android manual smoke remains required.
- Product Lead: product-ready for Phase 3 with conditional pass.
- Backend Data: fixtures work for UI, but are not ready as Phase 3 contract source.
- Repo GitHub: first push and CI readiness look good; branch protection should be configured later.
