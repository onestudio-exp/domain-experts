---
title: Open Finance & Open Banking — UAE / KSA / Egypt
domain: regulatory
last_updated: 2026-04-29
---

# Open Finance / Open Banking — MENA

## Summary

Open finance frameworks across MENA enable consent-based access to consumer financial data, payment initiation, and account aggregation. For loyalty platforms this matters in three specific ways:

1. **Cashback-on-spend** can be powered by direct account access rather than card rails.
2. **Loyalty data portability** between programs becomes possible.
3. **Settlement** can flow account-to-account at lower cost than card rails.

## Country state (as of 2026 Q1, refresh recommended quarterly)

| Country | Framework | Status |
|---|---|---|
| UAE | CBUAE Open Finance Regulation | Issued 2024; phased adoption underway |
| KSA | SAMA Open Banking Framework | Phase 1 (account information) live; Phase 2 (payment initiation) progressing |
| Egypt | CBE has issued open-banking guidelines | Earlier-stage; partnership-led adoption |
| Bahrain | Bahrain Open Banking Framework | Live since 2018; most mature in region |

## Implications for an Amos-style platform

- **Lean Technologies** (Amos's payouts partner) is migrating its APIs to comply with CBUAE Open Finance; this is the pattern other PSPs will follow.
- **Account-aggregation-based loyalty** could allow the operator to credit cashback directly to a user-chosen bank account, bypassing card rails entirely. This is a strategic option but a new regulatory perimeter.
- **Cross-platform loyalty data** — open finance creates the technical possibility for a user to port their loyalty status across operators. Whether regulators force this is an open question.

## Risks

- Regulatory change risk during rollout (Amos has already absorbed Lean Technologies API churn).
- Consent UX complexity — users expect frictionless rewards; consented account access adds steps.
- Liability allocation between PSP, anchor, operator when an account-initiated payment fails or is mis-routed.

## Related files

- [cbuae-svf.md](cbuae-svf.md) · [cbuae-rps.md](cbuae-rps.md) · [ksa-sama.md](ksa-sama.md) · `domains/embedded-fintech.md`
