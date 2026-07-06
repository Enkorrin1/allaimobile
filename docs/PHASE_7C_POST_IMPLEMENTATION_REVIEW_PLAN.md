# Phase 7C Post-Implementation Review Plan

Date: 2026-07-05.

Status: planning-only. Phase 7C app-code remains blocked until Phase 7A, Phase 7B and repo gates are closed.

## Purpose

This file defines the review gates that must run after a future Phase 7C final release-polish implementation.

## Review Owners

- Product Lead: final product acceptance, claims, P0/P1 release scope and sign-off.
- UI UX: visual consistency, accessibility, small-screen polish and screenshot evidence.
- Mobile Architecture: UI-only boundary, forbidden diffs, imports, dependencies and state ownership.
- Backend/Data: no API/schema/storage/data-layer changes and no misleading backend claims.
- Mobile Implementation: implementation handoff, touched-file summary, evidence bundle and QA fix ownership.
- QA Release: commands, Redmi 7 smoke, screenshot/video evidence, accessibility matrix and PASS/FAIL.
- Repo GitHub: branch/commit split, staging hygiene, generated/artifact checks and CI expectations.
- Task Chat Logic: ownership boundaries, handoff quality and final coordinator decision rules.

## Product Gate

Product Lead must review:

- Welcome, Auth and App Shell still feel coherent after final polish.
- Home, Create, Catalog/Templates, Result, Library, Pricing and Profile are understandable on Redmi-class screens.
- Empty, error, loading, disabled, active, completed and failed states are clear and honest.
- RU copy is consistent, without mojibake, raw internal wording or mixed tone.
- Mock boundaries are honest: no live provider, real upload, real billing/IAP or real email delivery claims.
- P0 flows feel release-ready: login, session restore, create, result, library, pricing/profile and logout.

Product P0 blockers:

- text overlap or clipped critical copy;
- CTA hidden offscreen or by keyboard;
- broken auth/navigation/generation/result/library flow;
- unavailable actions look enabled;
- active, failed and completed generation states are confused;
- pricing looks like real purchase/IAP;
- reset promises real email delivery;
- silent no-op actions on critical controls;
- unreadable contrast or unclear disabled state.

Accepted P1 follow-ups:

- subtle motion polish;
- richer thumbnails;
- extra helper text;
- cosmetic Profile/Pricing refinements;
- tablet and dark-mode refinement;
- advanced filters.

Final product sign-off requires:

- QA has no open P0;
- release scans pass;
- key screenshots are present;
- product copy and mock/live claims are honest;
- role gates are PASS or only P1/P2 conditional.

## UI UX Gate

UI UX must review:

- Welcome, Login, Register and Reset: hierarchy, keyboard safety, legal/18+, validation and CTA reachability.
- App Shell: bottom navigation, active state, spacing and screen-to-screen consistency.
- Home and Create: balance, active job, format-first creation, prompt/source/quote/CTA and disabled reasons.
- Catalog and Template Detail: filters/search, cards, unavailable states, preview-first detail, cost and required inputs.
- Result and Library: active/completed/failed states, media preview, progress, action chips, retry/refund and thumbnails.
- Pricing, Profile and Settings: balance, available/reserved coins, disabled purchases, account/legal/support/logout.
- Shared visual system: spacing, radii, typography, buttons, chips, cards, state widgets and tap targets.

Required screenshots:

- Welcome.
- Login with keyboard.
- Register consent.
- Reset success.
- Home.
- Create ready and Create with keyboard.
- Catalog.
- Template Detail.
- Result active.
- Result completed.
- Result failed.
- Library states.
- Pricing.
- Profile and Settings.

UI P0 blockers:

- missing, black or wrong-state screenshots;
- clipped Russian labels;
- CTA hidden by keyboard;
- action chips overflow;
- tiny controls below 48dp;
- second design language appears;
- state cards are too tall for Redmi 7;
- blank state, raw error, fake progress or silent no-op appears.

## Architecture Gate

Mobile Architecture must review:

- changes are limited to UI polish in theme, shared widgets and presentation screens;
- screens use existing providers/controllers and do not gain business logic;
- state ownership is unchanged for auth, generation, billing, catalog and library flows;
- presentation/shared imports stay clean;
- no new dependencies, assets, fonts, permissions, provider SDKs or platform wiring were introduced.

Allowed areas:

- `lib/app/theme/*`
- `lib/app/shell/*`
- `lib/shared/widgets/*`
- touched auth presentation screens
- Home/Create/Tools/Template Detail/Result/Library presentation screens
- optional Pricing/Profile/Settings presentation screens
- focused tests for changed UI states.

Forbidden areas:

- `lib/core/api/*`
- `lib/core/network/*`
- `lib/core/database/*`
- `lib/core/storage/*`
- `lib/features/*/data/*`
- `lib/features/*/domain/*`
- `lib/features/auth/data/*`
- `lib/features/generation_jobs/data/*`
- `lib/app/router/*`
- `pubspec.yaml`
- `android/*`
- `ios/*`
- Drift schema or generated database files.

Required scans:

```powershell
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

Architecture P0 blockers:

- data/domain/core/router/platform changes without approval;
- direct API/cache/provider imports in UI;
- new packages, assets or permissions;
- live backend/provider SDK/direct AI calls;
- real billing/IAP;
- upload/image-to-image activation;
- enabled no-op critical actions;
- auth/create/result/library/pricing behavior regression.

## Backend/Data Gate

Backend/Data must confirm:

- no API contracts, DTO/domain models, repositories, data sources, sanitizers, Drift schema, generated DB or secure storage changed;
- auth/session restore and logout behavior are unchanged;
- catalog cache fallback and sanitization are unchanged;
- generation create/poll/status/assets behavior is unchanged;
- billing balance, packages and transactions are unchanged;
- upload/source/use-as-source stays disabled or placeholder-only;
- copy does not claim real payments, real upload, provider availability, signed URL persistence, social publishing, guaranteed refunds or real email delivery.

Data P0 blockers:

- API/schema/storage/data-source mutation;
- generated DB churn;
- live/provider/billing/upload/permission addition;
- backend-only field exposure;
- active/completed/failed job persistence regression;
- Result/Library lookup regression;
- release copy that misrepresents unavailable backend, billing or upload capabilities.

## Mobile Implementation Handoff

Mobile Implementation must provide:

- scope summary and confirmation that Phase 7C stayed UI-only;
- touched-file list grouped by theme, shell, shared widgets, screens and tests;
- before/after notes for meaningful UI/state/copy changes;
- command results for format, analyze, tests, debug build and scans;
- screenshot/video evidence path list;
- known blockers and accepted P1/P2 follow-ups;
- reviewer handoff list.

Fix rules after QA findings:

- fix only confirmed defects in related touched UI files;
- keep broad redesign churn out of the bugfix pass;
- never revert unrelated Phase 5/6/7A/7B work;
- do not use destructive git commands;
- pause and escalate if a finding requires auth/session/router/data persistence or platform/dependency/schema changes.

## QA Gate

QA Release must run:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
```

Additional QA checks:

- secrets/provider/direct-call scan;
- IAP/upload/permission scan;
- presentation import scan;
- dependency/platform diff scan;
- artifact/staging hygiene check through Repo GitHub.

Redmi 7 setup:

- `adb devices` shows `c7970e16 device`;
- `wm size` shows `720x1520`;
- `wm density` shows `320`;
- fresh install;
- `pm clear`;
- launch app.

Smoke matrix:

- Welcome.
- Login.
- Register.
- Reset.
- Session restore.
- Home.
- Create prompt job.
- Result.
- Library.
- Tools and Template Detail.
- Pricing/Profile/Settings.
- Logout and back protection.

Accessibility matrix:

- tap targets are at least 48dp;
- contrast is readable;
- icon buttons have labels where practical;
- disabled states are clear;
- focus and scroll order are sane;
- font scaling is acceptable for critical flows;
- no clipped RU copy;
- keyboard-safe forms.

Video evidence:

- one continuous Redmi 7 capture covering login, Home, Create, Result, Library and logout.

QA PASS criteria:

- all commands and scans pass;
- Redmi 7 smoke passes;
- screenshot and video evidence exists;
- no P0 or release-blocking P1 remains.

QA FAIL criteria:

- failing checks;
- no physical smoke/evidence;
- clipped CTA or critical copy;
- accessibility P0;
- broken auth/navigation/generation/persistence;
- raw errors/debug/mojibake;
- backend/provider/IAP/upload/permission creep.

## Repo Gate

Repo GitHub must review:

- `git status --short -uall`;
- `git diff --cached --name-status`;
- `git diff --cached --stat`;
- `git diff --cached --check`;
- staged scope matches Phase 7C only;
- Phase 7C is not mixed with unresolved Phase 5/6/7A/7B hunks.

Recommended future branch:

- `codex/phase-7c-release-polish`

Recommended future commit split:

- `docs: plan phase 7c release polish`;
- `ui: final release polish`;
- `test: add release readiness coverage`;
- `ci: harden mobile checks`, only if CI changes are explicitly approved.

Forbidden staged items:

- `build/`;
- screenshots from `build/`;
- APK/AAB/IPA;
- `.dart_tool/`;
- `coverage/`;
- database/cache files;
- `.env` and `.env.*`;
- `*.jks`, `*.keystore`, `key.properties`;
- `*.p8`, `*.pem`, `*.key`, `*.mobileprovision`;
- `google-services.json`;
- `GoogleService-Info.plist`;
- generated DB files unless paired with approved schema/model changes.

Repo P0 blockers:

- mixed dirty tree unresolved;
- `git add .` usage;
- forbidden artifacts staged;
- secrets/signing files staged;
- platform permissions or dependency changes without approval;
- failing checks;
- missing QA smoke evidence;
- push or PR attempted without explicit user approval.

## Task Chat Logic Gate

Task Chat Logic must confirm:

- Mobile Implementation remained the only app-code owner;
- Product, UI UX, Architecture, Backend/Data, QA, Repo and Task Chat Logic stayed as gate/review owners;
- no user-facing task-agent/chat features were added;
- no prompt-master orchestration, handoff UI or new agent/workflow entities were introduced;
- implementation result includes scope, touched files, evidence, blockers and reviewer list.

Final coordinator decision rules:

- `PASS`: all role gates are P0-free and QA evidence is complete.
- `CONDITIONAL`: only P1/P2 polish remains and it is documented.
- `BLOCKED`: repo gate unresolved, P0 UX/regression/security issue, ownership violation or forbidden scope creep.

## Current Coordinator Decision

This review plan is ready for future Phase 7C implementation. It does not authorize code. Phase 7C implementation remains blocked until Phase 7A, Phase 7B and the repo/dirty-tree gates are closed.
