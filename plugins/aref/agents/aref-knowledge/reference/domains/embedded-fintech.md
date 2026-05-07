---
title: Embedded Fintech — Cashback & Payments
domain: embedded-fintech
last_updated: 2026-04-29
---

# Embedded Fintech for Loyalty

## Summary

Embedded fintech is fintech delivered inside a non-financial product (rent app, supermarket app, residential app). For loyalty platforms it means surfacing earn / redeem mechanics through someone else's UX, riding on a licensed payment provider's rails rather than holding a licence.

## Core architectural choices

### 1. Stored Value vs Discount Commitment

The decisive regulatory distinction:

- **Stored Value Facility (SVF)** — operator holds prefunded user balances. Triggers a CBUAE / SAMA / CBE licence. Capital, audit, trust account requirements.
- **Discount Commitment** — operator promises a refund / discount funded from its own margin via a licensed PSP. No prefunded balance. No SVF licence required. (See `regulatory/cbuae-svf.md` for the Amos / Network International precedent.)

### 2. Payment rail selection

- **Card-linked offers** — user links a card; operator receives transaction events from the network and rebates at settlement. Visa / Mastercard partner programs (e.g., Augeo, Cardlytics) provide the data feed.
- **Account-to-account via open finance** — UAE Open Finance and KSA Open Banking permit consented account access for loyalty / cashback flows.
- **In-app payments** — anchor app handles payment; operator receives webhook events and posts cashback.

### 3. Settlement model

- **Operator-pays-first** — user gets cashback at transaction time; operator collects from merchant on T+30. Higher working capital, better UX.
- **Merchant-pays-first** — cashback released only after merchant settlement clears. Lower working capital, longer-feeling UX.

## KYC / AML touchpoints

Even in discount-commitment models, these triggers create KYC obligations:

- Withdrawal to bank account above a threshold.
- Transferability to another user.
- Cumulative cashback above MENAFATF reporting threshold.
- Cross-border merchant network.

## Why "no licence required" is conditional, not absolute

The Amos / NI letter is a precedent for the *current model*. Two changes would break it:

- Adding a wallet balance the user controls = SVF.
- Allowing user-to-user transfer of cashback = potentially money remittance.

## Related files

- `regulatory/cbuae-svf.md` · `regulatory/cbuae-rps.md` · `regulatory/open-finance-mena.md` · [loyalty-economics.md](loyalty-economics.md) · `case-studies/amos/regulatory-clearance.md`
