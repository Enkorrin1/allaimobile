# Repository Setup

Current known state:

- Workspace: `D:\Project\AllAi Mobile App`
- GitHub repository: https://github.com/Enkorrin1/allaimobile
- Local workspace started empty.
- Local workspace was not a git repository at the time of initial inspection.
- Final mobile stack: Flutter + Dart.

## Recommended Structure

```text
allaimobile/
  lib/
    main.dart
    app/
      app.dart
      router.dart
      theme/
      localization/
      config/
    core/
      api/
      auth/
      storage/
      media/
      billing/
      analytics/
      errors/
    features/
      onboarding/
      auth/
      home/
      tools/
      generator/
      studio/
      generation_jobs/
      library/
      billing/
      profile/
    shared/
      widgets/
      utils/
      constants/
  assets/
    images/
    icons/
  test/
  integration_test/
  docs/
  .github/
    workflows/
  .env.example
  README.md
  pubspec.yaml
  analysis_options.yaml
```

## Files To Add Early

- `README.md`
- `.gitignore`
- `.env.example`
- `analysis_options.yaml`
- `.github/workflows/ci.yml`
- `docs/PROJECT_SPEC.md`
- `docs/*`
- Flutter app scaffold files after stack initialization.

## .env.example Variables

```dotenv
APP_ENV=development
API_BASE_URL=
WEB_BASE_URL=https://allai.market
SENTRY_DSN=
ANALYTICS_KEY=
```

Do not put provider API keys in mobile env files.

## Never Commit

- `.env`
- `.env.local`
- Provider API keys.
- Auth tokens.
- Apple/Google signing secrets.
- Android keystores: `*.jks`, `*.keystore`, `key.properties`.
- iOS certificates/profiles: `*.p12`, `*.mobileprovision`.
- `.dart_tool`
- `.flutter-plugins`
- `.flutter-plugins-dependencies`
- `build`
- `.gradle`
- `ios/Pods`
- DerivedData.
- Private user media.
- Production logs with prompts/media/provider responses.

## First Commit Order

1. Create docs and setup files.
2. Initialize git only when explicitly requested.
3. Add remote only after verifying local state.
4. Commit docs/setup foundation.
5. Scaffold Flutter app in a separate commit.
6. Push only after explicit approval.

Commands when approved:

```powershell
git init
git branch -M main
git remote add origin https://github.com/Enkorrin1/allaimobile.git
git status --short
git add README.md .gitignore .env.example docs
git diff --cached --stat
git commit -m "Initial project documentation"
git push -u origin main
```

## CI Plan

Initial CI:

- Install Flutter.
- Run `flutter pub get` when `pubspec.yaml` exists.
- Run `flutter analyze`.
- Run `flutter test`.
- Run format check with `dart format --set-exit-if-changed .`.

Later CI:

- Android debug/release build.
- iOS build through macOS runner or Codemagic/Fastlane.
- Integration tests where feasible.
- Secret scan.
