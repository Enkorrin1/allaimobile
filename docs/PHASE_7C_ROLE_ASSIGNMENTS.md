# Phase 7C Role Assignments

Date: 2026-07-05.

Status: planning-only assignments. No app-code implementation is authorized.

## Product Lead

Responsibilities:

- define P0/P1 polish scope;
- prevent feature creep;
- accept release-readiness from product perspective;
- verify user-facing copy does not overpromise live capabilities.

Expected output:

- product acceptance checklist;
- release-risk list.

## UI UX

Responsibilities:

- own visual polish criteria;
- audit accessibility, small-screen fit and copy consistency;
- define screenshot requirements;
- flag overflow, clipping, contrast and tap-target issues.

Expected output:

- visual release gate;
- screenshot checklist;
- P0 visual issues.

## Mobile Architecture

Responsibilities:

- keep Phase 7C UI-only;
- prevent data/domain/router/platform changes;
- enforce shared-state component boundaries;
- define import, dependency and platform scans.

Expected output:

- allowed/forbidden file list;
- scan requirements;
- architecture gate.

## Mobile Implementation

Responsibilities:

- own future Phase 7C app-code only after prior gates close;
- implement focused polish slices;
- avoid broad redesign or feature expansion;
- hand off touched files, checks and screenshots.

Expected output:

- implementation handoff;
- verification result;
- known residual risks.

## QA Release

Responsibilities:

- own release-readiness smoke;
- verify Redmi 7 screenshots;
- check accessibility/tap-target risks;
- catch regressions in auth, navigation, generation, result, library and billing/profile surfaces.

Expected output:

- smoke result;
- screenshots;
- release blocker list.

## Backend/Data

Responsibilities:

- confirm no API/schema/storage changes;
- protect billing/generation/upload/catalog/auth/session contracts;
- review UI-only copy/state changes for data-boundary risk.

Expected output:

- data no-impact gate;
- forbidden backend change list.

## Repo GitHub

Responsibilities:

- keep Phase 7C planning/code separated from previous phases;
- enforce commit split;
- exclude artifacts/secrets/build outputs;
- keep push/PR on hold until explicit approval.

Expected output:

- repo hygiene gate;
- commit split note;
- push/PR hold status.

## Task Chat Logic

Responsibilities:

- keep role ownership clean;
- confirm no task-agent features are added;
- verify handoffs are complete;
- decide next-slice readiness after gates.

Expected output:

- coordination gate;
- scope creep assessment;
- next-slice readiness note.
