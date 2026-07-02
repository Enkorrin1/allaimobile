# Decisions And Open Questions

## Current Decisions

- Build mobile app for both Android and iOS.
- Use Flutter + Dart.
- Use go_router for navigation.
- Use Riverpod for state management and dependency injection.
- Use Dio for HTTP.
- Use Retrofit or OpenAPI-generated clients when backend contracts are stable.
- Use Freezed + json_serializable for typed immutable models and JSON parsing.
- Use Drift/SQLite for local metadata/history cache.
- Use flutter_secure_storage for auth tokens.
- Mobile app calls AllAI backend only.
- AI provider secrets stay backend-side only.
- Model list must be backend-driven, not hardcoded.
- Coin cost must be shown before generation.
- Long-running video jobs must not block the app.
- Generated assets must be saved in history.
- Download/share are MVP features.

## Open Product Questions

- Confirm exact backend API availability.
- Confirm final model list and per-model capabilities.
- Confirm launch countries and languages.
- Confirm whether Social Studio is MVP or P1.
- Confirm whether team accounts are needed in the first release.
- Confirm whether there are free starter coins.
- Confirm media retention and deletion policy.
- Confirm moderation policy and rejected-content UX.

## Open Billing Questions

- Are mobile coin purchases handled through Apple/Google in-app purchases?
- Are external payments allowed for any user segment?
- How are refunds handled when provider generation fails?
- Are coins reserved on submit or charged only after provider acceptance?

## Open Technical Questions

- Which backend endpoints already exist?
- Is there a current web model-catalog API that mobile can reuse?
- Are asset uploads direct-to-storage via signed URLs?
- Does backend support job progress or only status polling?
- Will backend send push/webhook events for completed jobs?
- Which analytics provider should be used?

## Open Compliance Questions

- What is the NSFW policy?
- What is the minors policy?
- Are face swap / likeness / celebrity requests allowed?
- Are political or deceptive generations allowed?
- Is user content public anywhere in MVP?
- What reporting/blocking flow is required if community/social features appear?
