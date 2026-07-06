# Phase 7B Role Assignments

Date: 2026-07-04.

Status: planning-only assignments. No app-code implementation is authorized.

## Product Lead

Responsibilities:

- maintain Phase 7B P0/P1 scope;
- keep signed-in workflow focused on creation, catalog, result and library;
- prevent live-provider, upload, real billing and production-share claims;
- accept or reject the first implementation slice.

Review output expected:

- product acceptance checklist;
- approved copy boundaries;
- first-slice decision.

## UI UX

Responsibilities:

- define mobile-first screen hierarchy for Home, Create, Catalog, Template Detail, Result and Library;
- ensure Phase 7B uses Phase 7A tokens and primitives;
- define Redmi 7 visual acceptance;
- flag overlap, clipping, debug-list feel and missing CTA hierarchy.

Review output expected:

- screen-by-screen UI spec;
- screenshot checklist;
- fail conditions.

## Mobile Architecture

Responsibilities:

- keep Phase 7B inside presentation/shared widget boundaries;
- prevent data/domain/core/router/platform changes;
- define import hygiene and dependency constraints;
- approve slice boundaries before code starts.

Review output expected:

- allowed/forbidden file list;
- import scan requirements;
- architecture gate for each implementation slice.

## Mobile Implementation

Responsibilities:

- own any future Phase 7B app-code after Phase 7A and repo gate close;
- implement slices in order;
- preserve existing data/providers/navigation behavior;
- hand off touched files, checks and screenshots to reviewers.

Implementation remains blocked until:

- Phase 7A is implemented and reviewed;
- repo gate passes;
- old mixed dirty tree is resolved.

## QA Release

Responsibilities:

- define and run signed-in workflow smoke matrix;
- verify Redmi 7 screenshots;
- catch regressions in generation, catalog, result, library, pricing and profile routes;
- block release on failing checks or forbidden scope.

Review output expected:

- smoke script;
- screenshot evidence list;
- release gate status.

## Backend/Data

Responsibilities:

- confirm Phase 7B stays UI-only;
- protect API/schema/storage/billing/generation/upload contracts;
- review presentation imports and data-boundary risks.

Review output expected:

- data impact gate;
- forbidden backend/storage changes list.

## Repo GitHub

Responsibilities:

- keep Phase 7B planning docs separate from Phase 7A implementation;
- enforce no `git add .`;
- exclude artifacts/secrets/build outputs;
- ensure commit split before push/PR.

Review output expected:

- repo hygiene gate;
- commit split recommendation;
- push/PR hold status.

## Task Chat Logic

Responsibilities:

- confirm Phase 7B does not add task-agent/product-agent features;
- keep ownership clean;
- ensure handoffs between roles are complete;
- decide whether next slice can start after gates.

Review output expected:

- coordination gate;
- scope creep assessment;
- next-slice readiness note.
