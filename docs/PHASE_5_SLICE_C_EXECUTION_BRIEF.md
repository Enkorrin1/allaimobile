# Phase 5 Slice C Execution Brief: UI State Integration And Android QA Gate

Date: 2026-07-03.

Status: dispatched to Mobile Implementation.

## Goal

Close Phase 5 UI/QA blockers after the backend-ready catalog/pricing boundary.

Slice C stays mock-default. It must not enable live backend calls, provider SDKs, provider keys, direct AI provider calls or real billing/IAP.

## Owner

Mobile Implementation is the only app-code owner.

All other roles review after implementation handoff.

## Inputs

- `docs/PHASE_5_CONTRACT_REVIEW.md`
- `docs/PHASE_5_SLICE_B_RESULT.md`
- `docs/PHASE_5_SLICE_B_REVIEW_NOTES.md`

## P0 Implementation Scope

### Catalog / Tools

- Make category chips actually filter catalog items.
- Add selected state for filters.
- Include a clear `Все` option.
- Add search plus filter reset.
- Add no-results state with `Ничего не найдено` and `Сбросить фильтры`.

### Generator / Create

- Do not fall back to the first template if the selected model has no available template.
- Disable CTA when model/template is unavailable or no valid template is available.
- Show disabled reason.
- Use `availableCoins` for affordability checks.
- Show exact insufficient-balance copy: `Недостаточно койнов: нужно {cost}, доступно {available}`.
- Keep cost preview driven by catalog/pricing data.

### Pricing

- Remove global insufficient-coins warning when no concrete generation quote exists.
- Keep purchase CTAs disabled while real billing/IAP is blocked.
- Preserve package metadata through cache/restart where scoped:
  - `isAvailable`
  - `priceLabel`
  - `displayOrder`
- Sort packages by `displayOrder` when available.
- Show package unavailable state if `isAvailable == false`.
- Add or keep safe loading, empty, error and cached states.
- Add empty transaction-history state: `Операций пока нет`.

### Copy Cleanup

Apply visible copy fixes where present:

- `Запустить демо-результат` -> `Запустить генерацию`
- `Недостаточно койнов для этой генерации` -> `Недостаточно койнов: нужно {cost}, доступно {available}`
- `Social Studio` -> `Студия соцконтента`
- `social assets` -> `ассеты для соцсетей`
- `captions` -> `подписи`
- `export-пакеты` / `Export package` -> `пакеты экспорта`
- `Social-ready шаблоны` -> `Шаблоны для соцсетей`
- `workflows появятся после MVP generation` -> `Сценарии появятся после MVP-генерации`
- `Demo` badge -> `Демо` or `Пример`
- `P0` badge in user UI -> `Основной` or `Рекомендуем`

## Allowed Data Changes

Narrow changes are allowed only for package metadata persistence and tests.

Allowed:

- Extend Drift package cache if needed.
- Regenerate Drift generated code if schema changes.
- Update repository/cache tests.
- Support planned package response envelope if it can be done without live backend config.

Blocked:

- real backend URL;
- credentials or secrets;
- provider SDKs or direct provider calls;
- real billing/IAP setup;
- production store product integration;
- broad data-layer refactor outside the listed P0 scope.

## Likely Files

- `lib/core/database/app_database.dart`
- `lib/core/database/app_database.g.dart`
- `lib/features/billing/data/billing_cache_data_source.dart`
- `lib/features/billing/data/billing_repository.dart`
- `lib/features/billing/presentation/screens/pricing_screen.dart`
- `lib/features/billing/presentation/view_models/billing_copy.dart`
- `lib/features/generator/presentation/screens/generator_screen.dart`
- `lib/features/tools/presentation/screens/tools_screen.dart`
- `lib/features/tools/presentation/screens/tool_detail_screen.dart`
- `lib/features/tools/presentation/screens/template_detail_screen.dart`
- `lib/features/tools/presentation/view_models/catalog_ui_mappers.dart`
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/studio/presentation/screens/studio_screen.dart`
- `test/phase5_catalog_pricing_boundary_test.dart`
- `test/widget_test.dart`
- optional new `test/phase5_ui_state_test.dart`
- `docs/PHASE_5_SLICE_C_RESULT.md`

## Required Tests

Add or update tests for:

- Tools category filter changes visible results.
- Search plus filter reset works.
- No-results state shows reset action.
- Unavailable model/template cannot create a job.
- Generator does not fall back to the first template for an invalid selection.
- Insufficient balance uses `availableCoins` and exact copy.
- Pricing does not show global insufficient-balance warning without a quote.
- Package metadata `isAvailable`, `priceLabel`, `displayOrder` survives cache/restart.
- Package cards respect unavailable packages and display order.
- Existing Phase 3/4 auth, persistence and navigation tests remain green.

## Required Checks

Run:

```powershell
D:\flutter\bin\dart.bat format --set-exit-if-changed .
D:\flutter\bin\flutter.bat analyze
D:\flutter\bin\flutter.bat test
$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug
```

Run read-only scans:

```powershell
rg -n --glob 'lib/**' --glob 'test/**' --glob 'pubspec.yaml' "sk-|api[_-]?key|secret|client_secret|Authorization: Bearer|providerKey|providerSecret|RevenueCat|IAP|OPENAI|GOOGLE_API_KEY" .
rg -n --glob 'lib/**/presentation/**' "Dio|AppDatabase|Drift|MockAllAiApi" lib
```

## Result Handoff

Create `docs/PHASE_5_SLICE_C_RESULT.md` with:

- touched files;
- behavior changed;
- tests added/updated;
- commands and scan results;
- Android debug APK result;
- blockers and follow-ups.

Do not commit or push.
