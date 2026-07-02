# Codex Task Threads

This project uses the current chat as the coordinator. The user writes tasks here, then the coordinator distributes work to specialized Codex task threads and merges the results.

## Created Threads

- `AllAi - Product Lead` - `019f237f-2529-7cf3-a33e-d7e032a49550`
- `AllAi - Mobile Architecture` - `019f237f-409c-71d3-bfac-a34fa059127d`
- `AllAi - UI UX` - `019f237f-639a-7f61-83cd-9e718c52c572`
- `AllAi - Task Chat Logic` - `019f2386-95bc-7870-a607-9314c940c42b`
- `AllAi - Mobile Implementation` - `019f2387-32bd-7542-a7d1-1308f6f31689`
- `AllAi - Backend Data` - `019f2387-8b74-7670-a927-9cf891a69984`
- `AllAi - QA Release` - `019f2387-d2c1-71e3-9b8d-f76f0b1cbe38`
- `AllAi - Repo GitHub` - `019f2388-207f-7f12-a0d8-8e62c7919553`

## Responsibilities

Product Lead:

- Product vision.
- MVP scope.
- Backlog and priorities.
- Acceptance criteria.
- User scenarios.

Mobile Architecture:

- Stack decisions.
- App architecture.
- Module boundaries.
- Navigation/state.
- Integration boundaries.

UI UX:

- Screen map.
- Mobile flows.
- Visual/interaction states.
- Usability decisions.

Task Chat Logic:

- Role/handoff logic.
- Internal product assistant roles if exposed later.
- Job/handoff statuses.
- Role duplication prevention.

Mobile Implementation:

- Screens.
- Components.
- Navigation.
- Client logic.
- Implementation handoff to QA.

Backend Data:

- Domain models.
- API contracts.
- Storage and sync.
- Asset/history model.
- Privacy and billing boundaries.

QA Release:

- Acceptance criteria.
- Smoke tests.
- Edge cases.
- Store/release risks.

Repo GitHub:

- Git setup.
- Repository structure.
- README/.gitignore/.env.example.
- CI.
- First commit and PR preparation.

## Handoff Rules

- Current chat remains coordinator.
- Every implementation task should have one owner.
- Product defines what should exist.
- Architecture defines how modules fit.
- UI UX defines screen behavior.
- Backend Data defines contracts.
- Mobile Implementation changes files.
- QA Release verifies.
- Repo GitHub handles git/CI only after explicit instruction.
