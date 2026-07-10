# Phase 8 Localization Result

## Role Split

- Mill: i18n audit, hardcoded string inventory, RTL/layout risk scan.
- Laplace: European launch locale package for `en`, `ru`, `es`, `fr`, `de`, `pt`, `it`, `tr`.
- Aristotle: RTL and Asia locale package for `ar`, `hi`, `zh`, `ja`.

## Implemented

- Added Flutter gen-l10n configuration with 12 launch locales:
  `en`, `ru`, `es`, `fr`, `de`, `pt`, `it`, `tr`, `ar`, `hi`, `zh`, `ja`.
- Added ARB locale files and generated typed `AppLocalizations`.
- Wired localization delegates and supported locales into `MaterialApp.router`.
- Localized the first core user path:
  onboarding, login, registration, password reset, bottom navigation,
  create sheet, Home, generator composer, Projects, Profile, Settings, and Pricing.
- Added repeatable tooling:
  `tooling/generate_l10n_seed.py` and `tooling/audit_l10n.py`.

## Content Policy

Catalog/model/template names and descriptions remain source-driven. They should keep loading from the catalog/API/storage layer so AllAi content can follow allai.market without app releases.

## Verification

- `flutter analyze` passed.
- `python tooling/audit_l10n.py` passed: 12 ARB files, 171 messages.
- `flutter test --concurrency=1` passed via a temporary `F:` Flutter SDK mapping because the local Flutter SDK path contains a space.

## Blocked

- `flutter build apk --debug` is blocked by local disk space: drive `C:` reports `0` free bytes, and Gradle cannot download/write dependencies to `C:\Users\egorc\.gradle`.

## Follow-Up

- Add an in-app language switcher and persist selected locale.
- Expand localization to tools/template/result detail screens.
- Native-review high-impact legal, billing, and Arabic RTL strings before store release.
