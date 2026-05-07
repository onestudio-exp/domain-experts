---
title: UAE — CBUAE Retail Payment Services Regulation
domain: regulatory
last_updated: 2026-04-29
---

# CBUAE Retail Payment Services (RPS)

## Summary

Companion regulation to the SVF Regulation, the Retail Payment Services & Card Schemes Regulation governs entities that provide payment account information services, payment initiation, merchant acquiring, and related services. Loyalty platforms intersect with RPS principally through the PSP they contract with and through any account-information access (open finance).

## Where RPS touches loyalty operators

- **Merchant acquiring** is regulated. Loyalty operators don't acquire — the PSP does — but the contractual chain matters.
- **Payment initiation** triggered from inside a loyalty UX is regulated. If an Amos-style platform initiates an A2A payment for cashback redemption, the initiation must be performed by a licensed PSP.
- **Account information** access (open finance) is regulated and consent-bound (see [open-finance-mena.md](open-finance-mena.md)).

## How Amos sits within RPS

Amos contracts with Network International (a CBUAE-licensed retail payment services provider) to orchestrate the transaction flow. Amos does not directly provide regulated payment services; it provides a platform that overlays loyalty mechanics on top of NI-orchestrated transactions.

## Things that would push a loyalty operator into RPS scope

- Initiating payments from the user's bank account directly without a licensed intermediary.
- Holding merchant funds during settlement (vs immediate pass-through).
- Operating its own card programme.

## Related files

- [cbuae-svf.md](cbuae-svf.md) · [open-finance-mena.md](open-finance-mena.md) · `domains/embedded-fintech.md`
