---
title: KYC / AML for MENA Loyalty / Cashback
domain: regulatory
last_updated: 2026-04-29
---

# KYC / AML — MENA Loyalty Programs

## Summary

Even in a "no SVF licence required" model, loyalty / cashback operators interact with anti-money-laundering and counter-financing-of-terrorism (AML/CFT) regulations. The GCC follows MENAFATF / FATF standards; UAE specifically operates under Federal Decree-Law No. 20 of 2018 and CBUAE AML/CFT regulations.

## When a loyalty operator's KYC obligations activate

1. **Withdrawal to bank account above threshold** — typical UAE threshold AED 55,000 cumulative annually for high-risk indicators.
2. **Cross-border merchant acceptance** — cashback redeemed in a different jurisdiction.
3. **User-to-user transferability** — pushes the model toward remittance.
4. **Sanctioned-jurisdiction touchpoints** — any merchant or user with exposure to sanctioned countries.

## Practical KYC workflow for an Amos-style operator

- **Tier 1 (low-risk)** — anchor-passed identity. Anchor (e.g. DAMAC) has KYC'd the user; operator inherits with documented anchor warranty.
- **Tier 2 (mid-risk)** — direct identity verification triggered at first redemption above small threshold (e.g., AED 1,000).
- **Tier 3 (high-risk)** — full documented identity + sanctions screening + source-of-funds (rare in cashback context but possible at scale).

## Merchant-side AML

- Merchants must be screened for sanctions and adverse media.
- Cash-intensive merchants (gold, jewellery) carry additional ongoing monitoring obligations.
- Merchant onboarding documents (trade licence, ownership) feed UBO (Ultimate Beneficial Owner) checks.

## Reporting obligations

- Suspicious transaction reports filed via the UAE FIU's GoAML system.
- Annual AML/CFT compliance attestation.
- Internal MLRO (Money-Laundering Reporting Officer) appointment is best practice even when not mandatory.

## What changes with open finance

- Stronger first-party KYC inheritance from licensed PSPs.
- More automatable sanctions screening through aggregated account data.
- New risks: account-linked fraud, mule accounts using cashback as a layering tool.

## Related files

- [cbuae-svf.md](cbuae-svf.md) · [cbuae-rps.md](cbuae-rps.md) · [ksa-sama.md](ksa-sama.md) · `domains/data-personalisation.md`
