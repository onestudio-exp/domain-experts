---
title: UAE — CBUAE Stored Value Facilities Regulation
domain: regulatory
last_updated: 2026-04-29
sources:
  - CBUAE Stored Value Facilities Regulation
  - Amos Network — Network International compliance confirmation, March 2026
---

# CBUAE Stored Value Facilities (SVF)

## Summary

The Central Bank of the United Arab Emirates regulates Stored Value Facilities — instruments holding prefunded balances redeemable for goods, services, or cash. Operating an SVF requires an SVF licence; operating a *discount commitment* funded from operator margin and routed through a licensed PSP does not.

This distinction is the heart of why Amos does not require a CBUAE licence — confirmed in writing by Network International (a UAE-licensed PSP) in March 2026.

## What triggers an SVF licence

- A user-controlled balance (wallet) accruing prefunded value.
- That value being redeemable for cash, transferable to another user, or transferable across an open network.
- The operator effectively holding customer money.

## What does NOT trigger an SVF licence

- A contractual cashback / discount commitment funded from the operator's own margin.
- Settlement orchestrated through a CBUAE-licensed PSP.
- Closed-loop reward redemption inside a defined merchant network with no transferability.

## Why the Amos / NI letter matters

- It is documented evidence to enterprise clients (banks, developers) that the model is compliant.
- It removes what was an existential operational risk (a platform that can't process payments has no business).
- It serves as a regulatory template for KSA, Egypt, and other expansion markets — the legal analysis can be reused.

## Conditions that would invalidate the precedent

If Amos changes its model to:

- Hold a user-controlled wallet balance,
- Allow user-to-user cashback transfer,
- Permit redemption to cash outside the merchant network,

it would likely cross into SVF territory and require a licence application.

## Operational implications

- **Settlement** must continue to flow through the licensed PSP (currently NI). A change of PSP requires fresh confirmation.
- **Discount commitment** must be funded from operator margin; cannot become a stored balance even temporarily by accounting treatment.
- **Marketing language** matters — calling the cashback a "wallet balance" can attract regulatory attention even when the underlying mechanic is compliant.

## Related files

- [cbuae-rps.md](cbuae-rps.md) · [open-finance-mena.md](open-finance-mena.md) · [kyc-aml.md](kyc-aml.md) · `case-studies/amos/regulatory-clearance.md`
