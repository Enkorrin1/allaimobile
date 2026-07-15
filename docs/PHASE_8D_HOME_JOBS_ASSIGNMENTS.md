# Phase 8D - Home Jobs Assignments

Status: implementation in progress locally.

## Product Lead

- Separate work in progress from completed creative results.
- Keep Home limited to three active jobs and three recent results.

## UI UX

- Use compact progress cards rather than media cards for unfinished jobs.
- Preserve the image-led hierarchy for completed results.

## Mobile Architecture

- Derive Home sections from typed generation history in one view-model.
- Keep Result Viewer as the single job/result destination.

## Mobile Implementation

- Add active job rail with progress and prompt context.
- Exclude active, failed and canceled jobs from recent results.
- Sort both sections by the latest update time.

## Backend Data

- Use backend-shaped status, progress and updatedAt fields.
- Avoid introducing a separate Home jobs cache.

## Localization

- Add active-job section and progress copy to all locale contracts.

## QA Release

- Test classification, sorting and section limits.
- Run analyzer, localization audit and the complete Flutter suite.

