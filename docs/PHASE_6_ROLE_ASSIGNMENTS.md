# Phase 6 Role Assignments: Image Generation MVP

Date: 2026-07-03.

Status: planning dispatched after Phase 5 Slice C role gates. Phase 5 final QA closure is still pending Android emulator smoke or QA closure note, so Phase 6 is planning-only for now.

## Phase Goal

Ship the first real value loop for AI image creation:

- prompt-only image generation;
- image upload for image-to-image/edit;
- signed upload flow;
- generation job creation through backend contract;
- job status polling;
- generated image rendering in Result Viewer;
- completed job saved to Library;
- failed job retry path;
- image download/share.

## Boundaries

- No app-code edits during Phase 6 planning.
- No real backend URL or credentials without explicit approval.
- No provider SDKs/keys in mobile.
- No direct AI provider calls from mobile.
- No real billing/IAP changes.
- Current mock runtime remains default.
- One future app-code owner: Mobile Implementation.
- Phase 5 QA closure must be recorded before Phase 6 implementation starts.

## Role Tasks

### Product Lead

Define product acceptance for Image Generation MVP:

- P0 user journeys: prompt-only, optional image input, retry failed job, view result, save to Library, share/download.
- P0/P1 model/template scope for image generation.
- Coin reserve/charge/refund behavior visible to user.
- What is acceptable in mock mode if backend generation endpoints are not available.
- Product blockers before implementation.

### Backend Data

Define API/data contract:

- upload URL request/response;
- create image generation job request/response;
- job status polling response;
- asset URL/access contract;
- prompt/image input fields;
- job lifecycle and error codes;
- coin reservation/charge/refund mapping;
- cache/persistence rules for active/completed/failed jobs;
- public-only fields and backend-only fields.

### Mobile Architecture

Define implementation architecture:

- repository/data source boundaries for upload, generation job and asset access;
- mock/live switching with mock default;
- polling controller and cancellation/backoff strategy;
- persistence for active jobs and result assets;
- image file picker/upload boundary;
- Result Viewer and Library integration boundaries;
- provider isolation, no direct SDK/provider calls.

### UI UX

Define mobile UX states and copy:

- Create image prompt flow;
- image upload/source preview flow;
- quote/cost/reserve UI;
- active job/progress states;
- failure, retry and refund/no-charge copy;
- Result Viewer image actions: save, share, download, use as source;
- Library cards for active/completed/failed image jobs;
- keyboard/small-screen behavior.

### QA Release

Prepare QA matrix:

- Android smoke for prompt-only image generation;
- image upload flow;
- active polling/progress;
- force-stop/relaunch while job is active;
- completed Result Viewer and Library persistence;
- failed job retry/refund/no-charge behavior;
- no secrets/provider SDK/direct provider calls;
- auth-gated access and Phase 3/4/5 regression coverage.

### Repo GitHub

Review repo/release hygiene:

- generated files and build artifacts;
- image picker/upload dependencies if proposed;
- platform permission/config risk for Android/iOS;
- secrets/env/backend config risk;
- CI gaps: build_runner dirty-check, Android build, potential widget/integration smoke;
- commit split recommendation for Phase 6.

### Task Chat Logic

Review coordination:

- keep one app-code owner;
- keep image generation separate from future task-agent/chat design;
- keep live provider/billing work blocked without approval;
- define handoff order from planning to implementation;
- identify overlap risks with catalog/templates/pricing and Library.

### Mobile Implementation

Planning only until gates are collected:

- inspect current generation, Result Viewer and Library code;
- produce implementation plan and file-level task breakdown;
- list tests needed;
- do not edit files yet.
