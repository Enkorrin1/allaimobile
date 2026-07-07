# Phase 7E Visual Reference Redesign Result

Date: 2026-07-07.

Status: implemented locally on `codex/phase-7b-signed-in-redesign`.

Gate: CONDITIONAL PASS. Automated checks, debug APK build and Android emulator smoke for Welcome/Login/Home pass; final physical-device smoke and repo split remain open.

## Trigger

Phase 7E was started after direct user correction that the Phase 7 UI still looked too rough and utilitarian.

The new visual target is the user-provided AI Video reference set:

- `docs/assets/phase7e-visual-references/onboarding-image-to-video.png`
- `docs/assets/phase7e-visual-references/rating-review-overlay.png`
- `docs/assets/phase7e-visual-references/trial-paywall-start-creating.png`
- `docs/assets/phase7e-visual-references/home-videos-top.png`
- `docs/assets/phase7e-visual-references/home-effects-scroll-a.png`
- `docs/assets/phase7e-visual-references/home-effects-scroll-b.png`
- `docs/assets/phase7e-visual-references/home-create-magic.png`

## Product Direction

Phase 7E establishes the next visual baseline:

- black app background;
- acid-lime primary CTA and PRO/balance accents;
- large media-first hero areas;
- image-led poster/effect cards;
- bold white titles with short consumer copy;
- compact top controls with menu and PRO/balance pill;
- custom bottom navigation with central plus action;
- onboarding and pricing screens that sell the result through visuals rather than explanations.

The explicit goal is to remove the sparse engineering MVP/dashboard feel and move the local mock MVP toward a consumer AI photo/video creator app.

## Scope

Implemented scope:

- app-wide dark theme lock;
- neon visual tokens;
- shared `NeonMediaCard`, `NeonPillButton` and `NeonSectionHeader`;
- custom Home / Create / Projects bottom shell;
- reference-style onboarding;
- reference-style Home/Videos catalog with hero, rails and effect cards;
- reference-style Pricing/paywall screen with demo-safe purchase boundary;
- media-first Projects/Library screen;
- widget tests updated for the new visual baseline;
- saved reference screenshots under `docs/assets/phase7e-visual-references/`.

Out of scope and not implemented:

- live provider/backend integration;
- upload/image-to-image activation;
- real payments, IAP or RevenueCat;
- new platform permissions;
- data/domain/schema/router/platform changes;
- new provider keys, secrets or live API endpoints;
- iOS verification on this Windows machine.

## Changed Files

Runtime UI and theme:

- `lib/app/allai_app.dart`
- `lib/app/shell/app_shell.dart`
- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_theme.dart`
- `lib/features/auth/presentation/screens/auth_welcome_screen.dart`
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/library/presentation/screens/library_screen.dart`
- `lib/shared/widgets/neon_media_card.dart`

Tests:

- `test/phase7a_auth_shell_test.dart`
- `test/phase7b_signed_in_ui_test.dart`
- `test/phase7c_release_polish_test.dart`
- `test/widget_test.dart`

Documentation and reference assets:

- `docs/PHASE_7E_VISUAL_REFERENCE_REDESIGN_RESULT.md`
- `docs/PHASE_7E_POST_IMPLEMENTATION_REVIEW_NOTES.md`
- `docs/assets/phase7e-visual-references/*.png`
- `docs/README.md`
- `docs/ACTIVE_SPRINT.md`

## Behavior Preserved

The implementation keeps existing runtime behavior:

- auth/session/router behavior unchanged;
- login/register/reset flows still run against mock auth;
- central plus uses the existing Create branch;
- catalog/generation/library data contracts untouched;
- pricing remains demo-only and does not start a platform payment flow;
- no upload/image-to-image provider path was enabled;
- no platform permissions were added.

## Verification

Commands run:

```powershell
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test test\phase7a_auth_shell_test.dart
D:\flutter\bin\flutter.bat test test\phase7b_signed_in_ui_test.dart
D:\flutter\bin\flutter.bat test test\phase7c_release_polish_test.dart
D:\flutter\bin\flutter.bat test test\widget_test.dart
D:\flutter\bin\flutter.bat test --concurrency=1
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
git diff --check
adb -s emulator-5554 install -r build\app\outputs\flutter-apk\app-debug.apk
adb -s emulator-5554 shell am start -n com.allai.allai_mobile/.MainActivity
adb -s emulator-5554 exec-out uiautomator dump /dev/tty
```

Results:

- `flutter analyze`: PASS.
- Phase 7A targeted tests: PASS, 5/5.
- Phase 7B targeted tests: PASS, 4/4.
- Phase 7C targeted tests: PASS, 3/3.
- `test/widget_test.dart`: PASS, 25/25.
- full serial `flutter test --concurrency=1`: PASS, 62/62.
- debug APK build: PASS, `build\app\outputs\flutter-apk\app-debug.apk`.
- presentation forbidden import scan: PASS, no matches.
- source/platform secret/provider/payment/upload scan: PASS, no matches.
- `git diff --check`: PASS.
- Android emulator install and launch: PASS.
- Android emulator smoke: PASS for Welcome -> Login -> Home first viewport.

Android smoke evidence:

- Welcome shows `Image to Video`, `Continue`, `I already have an account`.
- Login accepts the demo account and returns to the signed-in shell.
- Home first viewport shows `Videos`, balance pill, menu, `Mermaid`, `Try Now`, `Most Popular`, `Crazy Effects`, `Home`, central plus and `Projects`.
- Post-build Home screenshot captured at `C:\Users\egorc\AppData\Local\Temp\allai_phase7e_smoke\post_build_home.png`.

Known test environment note:

- Drift still emits a non-fatal multiple-database-instance warning during tests. The suite passes and this is unchanged from prior local test behavior.

## Remaining Risks

- Physical Android device smoke is still recommended because emulator evidence does not fully replace Redmi-class screen and touch testing.
- Image cards use remote image URLs with gradient fallbacks. A future asset pass should add curated local or generated media assets for offline-perfect visuals.
- Phase 7E sits on top of an already mixed Phase 7B/7C dirty working tree; commit/push needs explicit staging and hunk review.
- iOS is not verified on this Windows machine.

## Decision

Phase 7E is ready as the new visual baseline for the local/mock MVP. It substantially changes the first impression toward the user-provided AI Video references while preserving existing mock behavior and integration boundaries.

Final release/PR readiness remains conditional on physical-device smoke and repo split/staging decisions.
