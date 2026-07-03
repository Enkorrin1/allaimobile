# Data And API

## Storage Rules

- Auth tokens: flutter_secure_storage only.
- Local metadata/cache: SQLite.
- Downloaded previews/assets: FileSystem cache and MediaLibrary save flow.
- Provider API keys: backend only.
- Secrets: never in repository, mobile bundle, SQLite, logs, or analytics.

## Domain Models

```ts
type User = {
  id: string;
  email: string;
  displayName?: string;
  locale: "ru" | "en";
  coinBalance: number;
  createdAt: string;
};
```

```ts
type AiModel = {
  id: string;
  name: string;
  providerLabel?: string;
  category: "image" | "video" | "upscale" | "avatar" | "motion";
  description: string;
  supportedInputs: Array<"prompt" | "image" | "video" | "reference">;
  supportedOutputs: Array<"image" | "video">;
  capabilities: {
    aspectRatios?: string[];
    durations?: number[];
    qualityLevels?: string[];
    seed?: boolean;
    negativePrompt?: boolean;
    referenceStrength?: boolean;
  };
  isAvailable: boolean;
  cost: {
    minCoins: number;
    maxCoins?: number;
  };
};
```

Important mobile boundary:

- `providerLabel` is public display metadata only.
- Mobile must not receive or store provider routing keys, provider credentials, or provider SDK configuration.
- Backend owns provider routing behind stable public `id` values.

```ts
type Template = {
  id: string;
  title: string;
  category: "ugc" | "cinema" | "try_on" | "unboxing" | "beauty" | "social_hook";
  description: string;
  previewUrl: string;
  defaultModelId: string;
  defaultPrompt: string;
  requiredInputs: Array<"prompt" | "product_image" | "person_image" | "reference_image">;
  outputFormat: "image" | "video";
  targetAspectRatio?: "9:16" | "1:1" | "16:9" | "4:5";
};
```

```ts
type GenerationJob = {
  id: string;
  userId: string;
  modelId: string;
  templateId?: string;
  status:
    | "draft"
    | "validating"
    | "queued"
    | "running"
    | "processing"
    | "completed"
    | "failed"
    | "canceled"
    | "refunded";
  prompt: string;
  inputAssetIds: string[];
  outputAssetIds: string[];
  settings: Record<string, unknown>;
  costCoins: number;
  progress?: number;
  errorCode?: string;
  errorMessage?: string;
  createdAt: string;
  updatedAt: string;
};
```

```ts
type Asset = {
  id: string;
  type: "image" | "video";
  role: "input" | "output" | "thumbnail";
  url: string;
  thumbnailUrl?: string;
  width?: number;
  height?: number;
  durationSec?: number;
  mimeType: string;
  sizeBytes?: number;
  createdAt: string;
};
```

## Job Lifecycle

```text
draft
  -> validating
  -> queued
  -> running
  -> processing
  -> completed
```

Any non-final state can move to:

```text
failed
canceled
refunded
```

Rules:

- Cost is shown before submit.
- Backend reserves coins on job creation.
- Backend finalizes charge only according to billing/provider acceptance policy.
- If provider fails before usable output, job must expose failed/refunded or failed/no-charge state.
- Mobile must never assume success from submit alone.

## API Contracts

Catalog:

```http
GET /v1/mobile/catalog
```

```ts
type CatalogResponse = {
  models: AiModel[];
  templates: Template[];
  categories: Array<{ id: string; title: string; order: number }>;
  updatedAt: string;
};
```

Create upload URL:

```http
POST /v1/assets/upload-url
```

```ts
type CreateUploadUrlRequest = {
  fileName: string;
  mimeType: string;
  sizeBytes: number;
  role: "input";
};
```

Create generation job:

```http
POST /v1/generation/jobs
```

```ts
type CreateGenerationJobRequest = {
  modelId: string;
  templateId?: string;
  prompt: string;
  inputAssetIds?: string[];
  settings: Record<string, unknown>;
  clientRequestId: string;
};

type CreateGenerationJobResponse = {
  job: GenerationJob;
  reservedCoins: number;
};
```

Read generation job:

```http
GET /v1/generation/jobs/:jobId
```

```ts
type GenerationJobResponse = {
  job: GenerationJob;
  assets: Asset[];
};
```

History:

```http
GET /v1/generation/jobs?cursor=...&type=image|video|upscale|avatar|motion
```

Billing:

```http
GET /v1/billing/balance
GET /v1/billing/packages
POST /v1/billing/purchases/verify
```
