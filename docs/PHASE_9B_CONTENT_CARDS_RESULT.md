# Phase 9B Content Cards Result

## Role Distribution

- Backend/Data: verify the new cards endpoint and define the mobile contract.
- Mobile Architecture: add remote/cards/cache boundaries without replacing the
  existing mock catalog runtime.
- UI UX: render backend cards through the existing premium Home card system and
  avoid empty video cards without posters.
- QA Release: cover parsing, cache fallback, Home smoke tests and analyzer.

## Implemented

- Added content-card domain models, API data source, cache data source,
  repository and Riverpod providers.
- Integrated `GET /content/cards?surface=mobile&locale=ru` behind
  `API_BASE_URL`.
- Cached the last valid cards manifest in `app_metadata`.
- Home now prefers remote `home`, `showcase` and `explore` sections when the
  feed is available, and falls back to local catalog sections otherwise.
- Card taps open the generator with the backend prompt template, format and
  normalized model slug.
- Cards without a usable poster are skipped to prevent blank visual tiles.
- Updated backend audit documentation with the observed endpoint, headers and
  response shape.

## Runtime

Use this dart define when running against the live backend:

```text
API_BASE_URL=https://api.allai.market/api/v1
```

If `API_BASE_URL` is empty, the content-card API stays disabled and the app uses
the current local catalog content. This keeps tests and offline development
stable.

## Verified

- `flutter analyze`
- `flutter test --no-pub --concurrency=1 test/content_cards_repository_test.dart test/phase7a_auth_shell_test.dart test/phase7b_signed_in_ui_test.dart`

