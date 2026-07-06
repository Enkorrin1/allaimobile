# Phase 7 Repo Unblock Task Queue

Date: 2026-07-05.

Status: planning-only. No staging, commit, push or app-code edits were authorized by this document.

## Purpose

Phase 7A, Phase 7B and Phase 7C app-code are blocked by a mixed dirty tree that includes Phase 5/6 code and tests plus Phase 7 planning docs. This file records the role-reviewed task queue for safely unblocking the repository before future UI implementation.

## Current Decision

The recommended path is a careful repo split without push, after explicit user approval. General instructions like "continue" or "do next" are not approval for staging, commit, push or mixed-tree app-code work.

Decision options:

1. Approve repo split/staging/commits without push.
2. Explicitly approve Phase 7 implementation on the mixed dirty tree.
3. Keep app-code on HOLD and continue planning only.

Recommended option: option 1.

## Required User Approval Wording

Before any repo split action, the user should approve in concrete terms similar to:

```text
Разрешаю repo-unblock split без push: при необходимости создать ветку, stage только явными путями/patch hunks, сделать отдельные commits для Phase 5, Phase 6, docs Phase 5/6 и docs Phase 7/7A; не использовать git add .; build/cache/secrets/APK исключить.
```

If push is also desired, it must be requested explicitly as a separate action.

## Role Assignments

- Repo GitHub: owns split/staging/commit guidance, preflight commands, staged review and artifact/secrets hygiene.
- Mobile Implementation: waits for repo gate closure, then owns future app-code only after a clear handoff.
- QA Release: owns pre/post split verification, scans and Android/Redmi evidence requirements.
- Mobile Architecture: owns phase boundaries, generated-file rules and architecture stop conditions.
- Backend/Data: owns data/generated-file grouping and data contract verification before data-related staging.
- Product Lead: owns the product decision between split, mixed-tree implementation or planning-only.
- Task Chat Logic: owns coordination rules, approval interpretation and final coordinator decision states.

## Read-Only Preflight Commands

These commands are safe to run before any approval because they do not stage or mutate git state:

```powershell
git status --short --branch -uall
git remote -v
git log --oneline -5
git diff --name-status
git diff --stat
git diff --check
git diff -- docs/ACTIVE_SPRINT.md docs/README.md test/widget_test.dart
git ls-files | rg -n '(?i)(build|\.dart_tool|\.gradle|Pods|\.apk|\.aab|\.ipa|\.db|\.sqlite|\.jks|\.keystore|key\.properties|google-services\.json|GoogleService-Info\.plist)'
```

## Recommended Split Order

1. Phase 5 Slice C code.
2. Phase 6 Slice A/Stabilization code.
3. Phase 5/6 docs rollup.
4. Phase 7/7A/7B/7C planning docs.
5. Phase 7A implementation only after the split is accepted.

Phase 7B and Phase 7C remain planning-only until Phase 7A is implemented and reviewed.

## Split Groups

Phase 5 group:

- catalog/pricing/cache UI-state changes;
- package metadata/cache/billing/catalog fixes;
- matching Phase 5 tests;
- matching Drift/generated files only if paired with schema changes.

Phase 6 group:

- prompt image generation loop;
- generation controller/repository/data-source;
- mock API and upload skeleton;
- Result/Library stabilization;
- generated preview/action widgets;
- matching Phase 6 tests.

Docs groups:

- Phase 5/6 docs separate from app-code;
- Phase 7/7A/7B/7C planning docs separate from Phase 5/6 docs and app-code.

## Hunk-Review Files

These files must not be staged whole-file unless the user approves an explicit rollup commit:

- `docs/ACTIVE_SPRINT.md`
- `docs/README.md`
- `test/widget_test.dart`

Shared widgets also need visual hunk review:

- `lib/shared/widgets/error_state.dart` is mainly Phase 5.
- `lib/shared/widgets/status_chip.dart` is mainly Phase 5.
- `lib/shared/widgets/media_asset_tile.dart` is mainly Phase 6.
- `lib/shared/widgets/result_action_bar.dart` is mainly Phase 6.

## Generated-File Rules

- Stage Drift generated source only with the matching schema/table change.
- If `app_database.dart` changes schema, table columns or migrations, `app_database.g.dart` must be reviewed and staged in the same data commit.
- Phase 7 UI-only work must not stage `app_database.g.dart`, schema changes, generated DB churn or platform build artifacts.

## Forbidden Actions

- Do not use `git add .`.
- Do not commit or push without explicit approval.
- Do not start Phase 7 app-code on the mixed tree without explicit mixed-tree approval.
- Do not run destructive git operations like reset/checkout to discard changes.
- Do not stage broad formatting churn.
- Do not "fix along the way" unrelated files.
- Do not add platform permissions, dependencies, provider config, billing/IAP, upload activation, live backend URLs or secrets.

## Forbidden Staged Items

- `build/`
- screenshots from `build/`
- APK/AAB/IPA
- `.dart_tool/`
- `coverage/`
- Android/iOS build/cache files
- DB/sqlite/cache files
- `.env` and `.env.*`
- `*.jks`, `*.keystore`, `key.properties`
- `*.p8`, `*.pem`, `*.key`, `*.mobileprovision`
- provider keys/config files
- `google-services.json`
- `GoogleService-Info.plist`

## Post-Split Verification

After explicit approval and after each future staged group, reviewers should run:

```powershell
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
D:\flutter\bin\dart.bat format --set-exit-if-changed <touched dart files>
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
rg -n --glob "lib/**/presentation/**" "Dio|AppDatabase|Drift|MockAllAiApi|image_picker|file_picker|dart:io" lib
rg -n "sk-|api[_-]?key|secret|providerKey|RevenueCat|IAP|OPENAI|replicate|stability|runway|fal\.ai" lib test pubspec.yaml android ios
```

QA should also preserve Android/Redmi evidence:

- `adb devices` shows `c7970e16 device`;
- `wm size` is `720x1520`;
- `wm density` is `320`;
- baseline screenshots remain ignored and not staged.

## Stop Conditions

Stop and return to the coordinator/user if any of these happen:

- there is no explicit user approval;
- a mixed hunk cannot be safely split;
- `git add .` is used or proposed;
- forbidden artifacts, screenshots, APKs, secrets or signing files appear in staged diff;
- Phase 7 docs enter Phase 5/6 code commits;
- generated DB files appear without matching approved schema changes;
- platform/dependency/provider/IAP/upload changes appear without separate approval;
- analyze/tests/scans fail;
- Android/Redmi evidence is unavailable when QA requires it;
- a future UI task requires router/auth/data/core/storage/database/API/platform changes.

## Mobile Implementation Entry Criteria

Future Phase 7A app-code can start only after:

- repo gate is closed as PASS, or the user explicitly approves mixed-tree implementation risk;
- current split groups and any remaining dirty files are documented;
- target Phase 7A allowed file set is confirmed;
- shared-widget and `test/widget_test.dart` risks are known;
- QA baseline screenshots are available;
- sole app-code ownership by Mobile Implementation is reconfirmed.

## Coordinator Decision States

- `PASS`: repo plan is approved and safe to start the next slice.
- `CONDITIONAL`: planning can continue, but app-code remains HOLD until explicit approval.
- `BLOCKED`: no approval, unsafe staging plan, unclear dirty tree, forbidden action required, or checks/scans fail.

## Current Coordinator Decision

Repo-unblock is implementation-ready as a plan, but not authorized as an action. The next required user decision is whether to approve the repo split without push, approve mixed-tree implementation risk, or keep the project in planning-only mode.
