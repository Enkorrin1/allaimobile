# Phase 9A - Store Purchase Foundation Assignments

Status: implementation in progress locally.

## Product Lead

- Use Apple In-App Purchase and Google Play Billing for mobile coin packages.
- Keep real purchases disabled until products and sandbox accounts are approved.

## Billing Architecture

- Define store request, receipt and purchase-state contracts.
- Require backend verification before entitlement or coin credit.

## Backend Data

- Implement idempotent `POST /v1/billing/purchases/verify` later.
- Return approved store product IDs as package metadata.

## iOS Android

- Prepare StoreKit and Play Billing adapters in the next slice.
- Do not add signing keys, service credentials or production products to source.

## UI UX

- Require explicit package selection.
- Expose Restore Purchases and clear no-charge failure copy.

## Security Compliance

- Never log receipt payloads.
- Never credit coins from an unverified mobile callback.

## QA Release

- Test fail-closed behavior and state transitions.
- Sandbox purchase tests remain a release gate after store setup.

