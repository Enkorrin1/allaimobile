# UX And Screens

## Navigation

Recommended bottom tabs:

1. Home
2. Create
3. Library
4. Studio
5. Profile

Secondary stacks:

- Auth stack: Welcome, Login, Registration, Password Reset.
- Generation stack: Model Detail, Template Detail, Generation Form, Job Status, Result Viewer.
- Pricing stack: Coins, Packages, Purchase Result, Transaction History.
- Settings stack: Account, Language, Notifications, Legal, Delete Account.

## Home

Purpose: fast entry into creation.

Content:

- Coin balance chip.
- Active job card if a generation is running.
- Quick scenario cards.
- Model/category shortcuts.
- Recent generations.
- Primary CTA: Create.

States:

- Empty: starter templates and examples.
- Loading: skeleton cards.
- Error: retry catalog.
- Active job: persistent progress card.

## Create

Purpose: central generation workspace.

Structure:

- Format switch: Photo, Video, Upscale, Avatars, Motion.
- Model selector.
- Template selector.
- Prompt/reference input.
- Upload area.
- Advanced settings drawer.
- Cost preview.
- Generate CTA.

UX rules:

- One primary form, not landing-page sections.
- Required inputs are shown before submit.
- Unsupported model settings are disabled with short explanation.
- Cost and balance are visible near submit.
- Long generation should offer "notify me" or background continuation.

## Model Catalog

Purpose: browse all AI models.

Content:

- Category filters.
- Search.
- Model cards.
- Model detail bottom sheet.
- Use Model CTA.

Model card fields:

- Name.
- Category.
- Supported inputs.
- Output type.
- Estimated cost.
- Availability.

## Template Detail

Purpose: start from a scenario.

Content:

- Preview media.
- Template description.
- What user gets.
- Required inputs.
- Default model.
- Estimated cost.
- Use Template CTA.

## Generation Status

Purpose: track long-running jobs.

Content:

- Status label.
- Progress when backend supports it.
- Prompt/model/template summary.
- Estimated wait when available.
- Cancel/retry actions when supported.
- Background continuation notice.

## Result Viewer

Purpose: inspect and reuse output.

Content:

- Fullscreen image/video preview.
- Actions: Save, Share, Repeat, Edit, Upscale, Use as Source.
- Metadata: model, date, cost, prompt.
- Compare source/result when relevant.

## Library

Purpose: history and reuse.

Content:

- Grid/list of generated assets.
- Filters by format and status.
- Search by prompt/template/model.
- Failed jobs tab.
- Open result and reuse settings.

## Studio

MVP:

- Social-ready workflow entry.
- Draft placeholders.
- Create asset from social template.

P1:

- TikTok/YouTube/Pinterest/Reels drafts.
- Multi-post planner.
- Export package.
- Direct publishing if approved and integrated.

## Pricing

Purpose: coin purchase and billing clarity.

Content:

- Balance.
- Coin packages.
- Package details.
- Restore purchases.
- Transaction history entry.

Store note:

- Digital coin packages inside iOS/Android apps likely require Apple/Google in-app purchase unless legal/product approves another compliant flow.

## Profile And Settings

Content:

- Account.
- Language.
- Notifications.
- Legal links.
- Support.
- Delete account.
- Logout.
