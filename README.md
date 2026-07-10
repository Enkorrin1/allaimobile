# AllAi Mobile App

Flutter Android/iOS app for AllAi Studio: AI image, video, upscale, avatar, motion, template, library, and coin-based generation workflows.

## Stack

- Flutter + Dart
- go_router
- Riverpod
- Dio
- Freezed + json_serializable
- Drift/SQLite
- flutter_secure_storage

## Requirements

- Flutter stable
- Dart from Flutter SDK
- Android Studio + Android SDK for Android builds
- Xcode/macOS for iOS builds

Current verified local environment:

- Flutter 3.44.1
- Dart 3.12.1
- Android SDK 36.1.0

## Setup

```powershell
flutter pub get
```

## Run

```powershell
flutter run
```

For Android:

```powershell
flutter devices
flutter run -d <android-device-id>
```

## Checks

```powershell
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
```

On this Windows workstation, Android builds were verified with:

```powershell
$env:GRADLE_USER_HOME='D:\GradleCache'
D:\flutter\bin\flutter.bat build apk --debug
```

The debug APK is generated at:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

## Project Structure

- `lib/app` - app root, router, theme, configuration.
- `lib/core` - network, storage, database, errors, platform services.
- `lib/features` - feature-first screens and later domain/data layers.
- `lib/shared` - reusable widgets and utilities.
- `docs` - project memory, product spec, architecture, roadmap, sprint docs.

## Security

The mobile app calls AllAi backend only. Do not add direct AI provider SDKs or provider API keys to the app.

Never commit:

- `.env` or real environment files
- provider API keys
- auth tokens
- Android keystores
- iOS certificates/provisioning profiles
- private user media
- production logs with prompts, media URLs, or provider responses
