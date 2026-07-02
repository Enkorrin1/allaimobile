# Product Requirements

## Vision

AllAI Mobile App is the Android/iOS product version of AllAI Market: a native mobile workspace for generating AI photos, videos, upscales, avatars, motion clips, and social-ready creative assets.

The product promise is simple: user starts with a prompt, source image/video, or ready-made template, then receives a generated asset, keeps it in history, and can download, share, edit, upscale, or reuse it.

## Target Users

- Creators producing social content.
- E-commerce sellers producing product photos, UGC hooks, try-on, unboxing, and ad variants.
- Agencies and marketers producing campaign creatives.
- Casual users experimenting with AI images, avatars, and videos.

## MVP Scope

P0:

- Auth: login, registration, password reset entry point, legal consent, 18+ confirmation.
- Home: balance, quick templates, recent generations, create entry point.
- Model catalog: Photo, Video, Upscale, Avatars, Motion.
- Templates: UGC, Beauty Hook, Try-On, Unboxing, Product UGC Hook, Social Hook Cut.
- Generation: text-to-image, image-to-image/edit, upscale, text-to-video, image-to-video.
- Job status: pending, queued, running, processing, completed, failed, canceled, refunded.
- Library/history: all jobs and assets, filters, reuse prompt/settings.
- Result viewer: preview, download, share, repeat, edit/upscale/use as source.
- Coins/pricing: balance, cost preview, insufficient-balance gate, package entry point.
- Profile/settings: account, language, notifications, legal, logout.
- Basic moderation and clear error handling.

P1:

- Favorite models and templates.
- Saved prompts and saved styles.
- Batch variations.
- Push notifications for long video jobs.
- RU/EN localization.
- Social Studio drafts for TikTok, YouTube Shorts, Pinterest, and Reels.
- Advanced model settings: aspect ratio, duration, quality, seed, reference strength.

P2:

- Team balances and limits.
- Scheduled publishing.
- Brand safety policies and audit logs.
- Watermark/compliance mode.
- Advanced video timeline editor.
- Community templates.

## User Scenarios

1. New user registers, accepts legal terms, sees starter templates, and creates the first asset.
2. Creator selects UGC/Reels/TikTok template, uploads product image, and receives 9:16 video.
3. E-commerce user uploads product and generates lifestyle/try-on/product photo.
4. User writes prompt, chooses image model, receives several image variants.
5. User uploads image and turns it into video through a video model.
6. User upscales or edits a generated result.
7. User opens history, repeats a previous prompt, downloads or shares the asset.
8. User has insufficient coins and opens pricing before generating.

## MVP Acceptance Criteria

- User can register/login and accept legal terms.
- Catalog loads from backend and shows current model availability.
- User can create at least one image job and one video job through backend.
- Cost in coins is shown before generation.
- Insufficient balance blocks job creation.
- Uploaded media is validated for size, type, and required input role.
- Long-running jobs do not block the app.
- Result is saved in history and available after app restart.
- Result can be downloaded/shared through native share/save flows.
- Failed jobs show understandable error and retry/refund state.
- Provider secrets are not present in the mobile code or repository.
