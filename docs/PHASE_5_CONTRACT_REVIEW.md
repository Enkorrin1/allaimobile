# Phase 5 Contract Review: Catalog, Templates, And Pricing Integration

Date: 2026-07-03.

Status: planning gates collected. Slice B can start as a safe mock-default backend-ready boundary. Real backend calls remain blocked until backend URL/contracts are explicitly approved.

## Product Decisions

P0:

- Catalog must be repository/API-shaped, not UI-hardcoded.
- P0 categories: `Photo`, `Video`, `Upscale`, `Avatars`, `Motion`.
- Model cards show name, category, description, supported inputs, output type, availability and estimated coin cost.
- Model capabilities drive UI settings: aspect ratio, duration, quality, seed, negative prompt and reference strength.
- Unsupported settings are hidden or disabled with clear user copy.
- Templates show title, scenario/category, preview, required inputs, default model, default prompt/settings, output format, target aspect ratio and estimated cost.
- P0 templates: UGC, Product UGC Hook, Social Hook Cut, Beauty Hook, Try-On, Unboxing.
- Balance and packages are repository-driven.
- Pricing shows coins only. No real money/IAP until billing decision.
- Cost preview comes from catalog/pricing data, not screen constants.
- Unavailable models cannot start generation and show `Недоступно`, `Скоро` or a short reason.
- Empty/error/unavailable states must be user-facing and not blank.
- Auth-gated access remains.

Acceptable without real backend:

- mock adapter remains default;
- API interfaces/DTOs match planned catalog, balance and packages contracts;
- optional live adapter skeleton has no production URL or secrets;
- Drift stores sanitized catalog/packages/balance snapshots;
- tests prove mock/cache fallback behavior;
- UI uses repositories/providers only;
- no provider SDKs, provider keys, real billing or direct AI calls are added.

## Data Contract

`GET /v1/mobile/catalog` planned response:

```ts
{
  modes: GenerationMode[],
  models: AiModel[],
  templates: Template[],
  categories: CatalogCategory[],
  updatedAt: string,
  expiresAt?: string,
  version?: string
}
```

Public `AiModel` fields:

```ts
id, name, providerLabel?, category, description,
supportedInputs, supportedOutputs,
capabilities, isAvailable, availabilityReason?,
cost: { minCoins, maxCoins? }
```

Public `Template` fields:

```ts
id, title, category, description, previewUrl,
defaultModelId, defaultPrompt, requiredInputs,
outputFormat, targetAspectRatio?, isAvailable?, order?
```

Balance:

```http
GET /v1/billing/balance
```

```ts
{
  userId: string,
  coinBalance: number,
  reservedCoins: number,
  availableCoins: number,
  updatedAt: string
}
```

Packages:

```http
GET /v1/billing/packages
```

```ts
{
  packages: [{
    id, name, coinAmount, description,
    isHighlighted, isAvailable,
    priceLabel?, displayOrder?, storeProductId?
  }],
  updatedAt: string
}
```

Backend-only fields must never be sent to or stored by mobile:

- provider keys;
- provider routing params;
- provider API keys;
- provider endpoint URLs;
- fallback chains;
- internal cost/margin rules;
- moderation internals;
- billing secrets;
- IAP shared secrets.

## Cache Rules

- Catalog can stay as JSON snapshot in Drift, but only after DTO validation and public-field sanitization.
- Balance maps to `billing_snapshots` and must preserve `coinBalance`, `reservedCoins`, `availableCoins`.
- Packages map to `coin_packages`.
- Do not overwrite valid cache on network, parse or backend-contract errors.
- Validate before cache write: unique ids, valid enums, template `defaultModelId` exists, non-negative costs, unique package ids.
- Unknown enum/parse errors should map to safe repository errors and cache fallback, not raw `FormatException`.
- `availableCoins = coinBalance - reservedCoins` is an invariant.

Recommended error codes:

```text
catalog_unavailable
catalog_empty
catalog_parse_failed
catalog_cache_miss
catalog_stale
pricing_unavailable
balance_unavailable
packages_unavailable
network_unavailable
unauthorized
forbidden
rate_limited
server_error
backend_contract_violation
```

## Architecture Contract

Default runtime remains mock.

P0:

- Do not enable live backend by default.
- Do not cache raw backend catalog JSON before sanitizing public fields.
- Do not add provider key, provider routing field, API key or secret to domain, fixtures, Drift, Riverpod, logs or tests.
- Presentation must not import `Dio`, `AppDatabase`, Drift tables or `MockAllAiApi`.

Recommended boundary:

```text
catalogRepositoryProvider
  -> CatalogRepository
    -> CatalogApiDataSource mock/live
    -> CatalogCacheDataSource Drift

billingRepositoryProvider
  -> BillingRepository
    -> BillingApiDataSource mock/live
    -> BillingCacheDataSource Drift
```

Repository owns cache strategy:

- cache-first display;
- refresh from remote only if live mode is explicitly enabled;
- remote error shows cached data plus refresh error state where possible.

Dio/live adapter:

- skeleton only unless backend URL is approved;
- fail-closed when `API_BASE_URL` is empty;
- no body/auth logging;
- timeouts and error mapping required before live use.

## UX Contract

P0 states:

- catalog loading: `Загружаем каталог...`;
- cached state: show saved data and `Показываем сохранённые данные`;
- catalog empty: `Каталог пока пуст` + `Обновить`;
- catalog error: `Не удалось обновить каталог. Проверьте подключение или попробуйте позже.`;
- no search results: `Ничего не найдено` + `Сбросить фильтры`;
- unavailable model: card visible, CTA disabled, reason shown;
- pricing/packages loading, empty and error states;
- balance unavailable state;
- package purchase CTA disabled while real billing is unavailable: `Покупки будут подключены позже`;
- insufficient balance copy: `Недостаточно койнов: нужно 240, доступно 120`;
- search and category chips must actually filter the list;
- small screens must avoid horizontal overflow for chips, status badges and package cards.

Replace technical user copy:

- `Mock repository вернул ошибку` -> `Не удалось загрузить данные`;
- `static catalog item` -> `Такого инструмента нет в каталоге`;
- `capabilities` -> `возможности модели`;
- `Demo packages` -> `Пакеты`;
- `Пакеты показаны для демо` -> `Покупки пока отключены в этой сборке`.

## QA Gate

After implementation:

- signed-out users cannot access catalog/templates/pricing;
- loading/success/empty/error/cached states work;
- template detail opens and matches DTO;
- unavailable models/templates disable generation;
- balance/packages show safe states and no IAP;
- catalog/templates/pricing survive restart from cache;
- Create cost preview uses catalog/pricing data;
- no provider SDKs, secrets or direct provider calls;
- Phase 3/4 auth, persistence and navigation regressions remain closed.

Required checks:

- `D:\flutter\bin\dart.bat format --set-exit-if-changed .`
- `D:\flutter\bin\flutter.bat analyze`
- `D:\flutter\bin\flutter.bat test`
- `$env:GRADLE_USER_HOME='D:\GradleCache'; D:\flutter\bin\flutter.bat build apk --debug`

## Repo Gate

Repo planning gate: PASS with P1 follow-ups.

- `API_BASE_URL` is empty/default safe.
- No real provider/API secrets found in planning.
- Commit/push remains HOLD.
- Dirty tree must be split by phase before commit.
- CI should add build_runner dirty-check and Android debug build.
- `.gitignore` should later cover `google-services.json`, `GoogleService-Info.plist`, `*.p8`, `*.pem`, `*.key` before OAuth/Firebase/App Store key work.

## Implementation Dispatch

Next task: Phase 5 Slice B - Backend-Ready Catalog/Pricing Boundary.

Allowed:

- introduce API/cache data source boundaries;
- keep mock default;
- add fail-closed live skeleton only if no URL/secrets are introduced;
- sanitize catalog before cache write;
- enrich repository/provider state for cached/error/empty states;
- improve user-facing catalog/pricing copy;
- add tests.

Blocked:

- real backend URL;
- provider SDKs/keys;
- direct AI provider calls;
- real billing/IAP;
- commit/push.
