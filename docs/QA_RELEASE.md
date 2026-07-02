# QA And Release

## MVP Acceptance Checklist

- App launches on Android and iOS without crash.
- User can register and login.
- Legal consent and 18+ confirmation are captured.
- Catalog loads from backend.
- User can create image generation job.
- User can create video generation job.
- Uploaded media is validated before submit.
- Coin cost is shown before submit.
- Insufficient balance blocks generation before job creation.
- Job status updates from queued/running to completed/failed.
- Long-running job survives app background/foreground.
- Completed result is saved in history.
- Result can be downloaded or shared.
- Failed generation shows understandable error and retry/refund state.
- Tokens are not stored in plain text.
- Provider secrets are not present in mobile app or repository.

## Smoke Tests

Auth:

- Launch app.
- Register new user.
- Login existing user.
- Wrong password error.
- Logout.

Catalog:

- Catalog loading state.
- Catalog success state.
- Catalog error state.
- Empty catalog state.
- Model detail opens.

Generation:

- Text-to-image generation.
- Image-to-image generation.
- Text-to-video generation.
- Image-to-video generation.
- Upscale existing image.
- Unsupported input blocked before submit.
- Insufficient balance blocked before submit.
- Job failure shows safe error.
- Retry failed job.
- App restart with active job.

Library:

- Completed result appears in history.
- Failed job appears with status.
- Reuse prompt/settings.
- Download result.
- Share result.

Mobile:

- Keyboard does not cover prompt input.
- Long prompt wraps correctly.
- Long generated response/status text does not break layout.
- Small screen layout works.
- Background/foreground does not lose active job.

## Edge Cases

- Empty prompt.
- Prompt too long.
- Unsupported media type.
- Large image/video upload.
- Network loss during upload.
- Network loss during polling.
- Provider timeout.
- Backend returns model unavailable.
- Backend returns cost changed.
- Job completes while app is closed.
- Asset URL expires.
- User logs out during active job.

## Store And Compliance Risks

- Digital coins may require Apple/Google in-app purchase.
- AI-generated content must follow platform policies.
- User-generated uploads require moderation, reporting/deletion policy, and privacy clarity.
- Account deletion should be available.
- Privacy labels and data collection disclosures must match actual analytics/storage.
- NSFW, minors, face manipulation, celebrity/public figure, political/deceptive content require strict policy decisions.

## Release Gate

Block release if any of these are true:

- Crash on launch.
- User cannot submit generation.
- Coin balance/cost logic is wrong.
- Result history is lost after restart.
- Jobs from different users are visible together.
- Provider/API secrets are in app bundle or repository.
- Network/API failure looks like infinite loading.
- Download/share does not work on target platform.
