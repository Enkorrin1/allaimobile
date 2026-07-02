# Flutter Scaffold Plan

Phase: Phase 1 - Flutter App Scaffold.

Status: executed successfully.

Result: see `docs/PHASE_1_SCAFFOLD_RESULT.md`.

## Goal

Create a runnable Flutter app shell in the current workspace while preserving `docs/`.

The scaffold must establish:

- Flutter + Dart app.
- go_router navigation.
- Riverpod foundation.
- Base theme.
- Placeholder screens.
- Android runnable path.
- iOS build/run path documentation.
- Analyzer/test/format checks.

## Preconditions

- Confirm Flutter SDK stable version or FVM policy.
- Confirm Android debug path works on the machine.
- Confirm app identifiers:
  - Android application id.
  - iOS bundle id.
  - App display name.
- Confirm no git/push actions without explicit approval.

## Scaffold Commands

Run from workspace root:

```powershell
cd "D:\Project\AllAi Mobile App"

flutter doctor -v
Get-ChildItem -Force

flutter create --platforms=android,ios --org com.allai --project-name allai_mobile .
```

Do not use `--overwrite`.

Before scaffold, verify Flutter will not overwrite existing project memory in `docs/`.

## Dependencies

Runtime dependencies:

```powershell
flutter pub add go_router flutter_riverpod dio
flutter pub add freezed_annotation json_annotation
flutter pub add drift sqlite3_flutter_libs path_provider path
flutter pub add flutter_secure_storage
flutter pub add image_picker file_picker
flutter pub add video_player cached_network_image share_plus
```

Development dependencies:

```powershell
flutter pub add --dev build_runner freezed json_serializable drift_dev
```

Code generation:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## Target Structure

```text
lib/
  main.dart
  app/
    allai_app.dart
    router/
      app_router.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_spacing.dart
      app_typography.dart
  core/
    config/
      env.dart
    network/
      dio_client.dart
    storage/
      secure_storage.dart
    database/
      app_database.dart
    errors/
      app_exception.dart
    utils/
  features/
    auth/
      presentation/screens/
    home/
      presentation/screens/
    generator/
      presentation/screens/
    library/
      presentation/screens/
    studio/
      presentation/screens/
    profile/
      presentation/screens/
  shared/
    widgets/
      app_scaffold.dart
      app_button.dart
      app_text_field.dart
      empty_state.dart
      placeholder_card.dart
      status_chip.dart
```

## Placeholder Screens

- `AuthWelcomeScreen`
- `LoginPlaceholderScreen`
- `HomeScreen`
- `GeneratorScreen`
- `LibraryScreen`
- `StudioScreen`
- `ProfileScreen`

Navigation:

- Auth stack separate from main app.
- Main app uses 5 tabs:
  - Home
  - Create/Generator
  - Library
  - Studio
  - Profile
- Prefer `StatefulShellRoute.indexedStack` so tab state is not reset during tab switching.

## Verification Commands

```powershell
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter devices
flutter run -d <android-device-id>
flutter build apk --debug
```

Manual smoke:

- App starts without blank screen.
- Five tabs are visible.
- Tab switching works.
- Auth placeholder opens as separate route.
- Android debug build succeeds.
- No direct AI/provider SDKs or provider keys exist in mobile app.

## Risks

Windows:

- Paths with spaces must be quoted.
- Flutter SDK and Android SDK must be in PATH.
- Long paths and Gradle cache can fail.

Android:

- Android Studio, SDK, emulator image, and virtualization are required.
- Media permissions need later QA.

iOS:

- iOS cannot be built locally on Windows.
- Need Mac/Xcode/CocoaPods, Codemagic, GitHub macOS runner, or another iOS build path.

Flutter SDK:

- Version should be fixed before team development.
- Package minimum SDK constraints can shift.

Identifiers:

- `--project-name allai_mobile` is a technical project name.
- Final ids should be confirmed separately, for example:
  - Android: `com.allai.mobile`
  - iOS: `com.allai.mobile`

Codegen:

- Freezed/json_serializable/Drift require `build_runner` discipline.
- Generated files should be intentionally committed unless project policy says otherwise.
