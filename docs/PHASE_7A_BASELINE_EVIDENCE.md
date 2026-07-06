# Phase 7A Baseline Evidence

Date: 2026-07-04.

Status: baseline captured on physical Android device. No app-code changes, staging, commit or push performed.

## Device

- Device: Redmi 7.
- ADB serial: `c7970e16`.
- ADB state: `device`.
- Android: detected by Flutter earlier as Android 9 / API 28.
- Physical size: `720x1520`.
- Physical density: `320`.
- Current focused activity: `com.allai.allai_mobile/.MainActivity`.

## Captured Screenshots

Screenshots are stored under `build/` and must not be staged.

- Welcome baseline from earlier launch: `build/allai_phone_screen.png`.
- Signed-in shell baseline after wake/relaunch: `build/phase7a_baseline_welcome_awake.png`.
- Black/screen-off capture, not useful for design comparison: `build/phase7a_baseline_welcome.png`.

`git status --short` for these build screenshots is empty, so they are currently ignored by git.

## Observed Baseline

Welcome baseline:

- The app launches and shows the AllAI signed-out entry.
- The screen feels sparse and unfinished, which is the core Phase 7A first-impression problem.

Signed-in shell baseline:

- Bottom navigation is visible with five tabs.
- Current signed-in screen captured on `Студия`.
- The screen is functional but visually reads as rough MVP: large text blocks, simple list rows, limited hierarchy and weak media/product polish.

## Phase 7A Comparison Targets

After implementation, capture the same classes of screenshots:

- signed-out Welcome;
- Login with keyboard open;
- Register with legal/18+ controls;
- Password Reset success state;
- signed-in shell on a main tab;
- bottom navigation selected states.

## Baseline Role Micro-Gates

- UI UX: CONDITIONAL. Baseline confirms the first-impression problem; post-implementation comparison must focus on Welcome density, auth CTA hierarchy, bottom-nav selected states and shell hierarchy.
- QA Release: CONDITIONAL. Device evidence is sufficient for a before/after pass, but Phase 7A still needs post-change smoke on Redmi 7 for Welcome, Login keyboard, Register legal/18+, Reset success, signed-in shell and bottom-nav states.
- Repo GitHub: CONDITIONAL. Screenshots under `build/` are ignored by git; do not stage `build/`, APKs, screenshots, `.dart_tool/`, runtime DB/cache or secrets. Do not use `git add .`.
- Mobile Implementation: BLOCKED. Smallest allowed diff after approval is theme/tokens, shared primitives, `AppShell`, Welcome, Login, Register and Password Reset. Code stays on HOLD until commit split or explicit mixed-tree approval.

## Gate

Phase 7A code remains blocked until the user approves either:

1. a commit split for the mixed working tree; or
2. implementation on top of the mixed working tree.
