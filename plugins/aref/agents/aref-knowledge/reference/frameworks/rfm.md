---
title: RFM Segmentation
domain: framework
last_updated: 2026-04-29
sources:
  - Hughes, Arthur M., Strategic Database Marketing (1994) — origin of RFM
---

# RFM — Recency, Frequency, Monetary

## Summary

RFM segments customers on three axes derived from transaction history. It is the simplest, most defensible segmentation for any loyalty program with at least 6 months of transaction data. It does not require ML, only SQL.

## The three axes

- **Recency (R)** — days since most recent transaction. Lower = better.
- **Frequency (F)** — count of transactions in a defined window (typically 90 or 365 days).
- **Monetary (M)** — sum of transaction value in the same window.

Each axis is bucketed 1–5 (quintiles). A customer's RFM score is a 3-digit composite, e.g. `5-5-5` (Champion) or `1-1-1` (Lost).

## Standard segments (de-facto industry naming)

| RFM band | Segment | Treatment |
|---|---|---|
| 5-5-5, 5-4-5, 4-5-5 | Champions | VIP tier, exclusive perks, advocacy programs |
| 5-3-5, 4-4-4 | Loyal customers | Cross-sell, tier upgrades |
| 4-2-3, 5-2-3 | Potential loyalists | Onboarding nudges, second-purchase incentives |
| 3-3-3 | At Risk | Win-back cashback boost, personalised offers |
| 2-2-2 | About to churn | Aggressive reactivation; flag for analysis |
| 1-1-1, 1-2-1 | Lost / Hibernating | Low-cost re-engagement only; do not over-invest |

## Why it works for embedded loyalty

- Anchor apps already capture every transaction with first-party data — no consent gymnastics.
- The RFM matrix maps directly to cashback rules: increase rate for At-Risk, cap rate for Champions (already loyal, no need to bribe).
- It is interpretable to non-technical stakeholders, which matters for enterprise client governance.

## Common mistakes

- Using global quintiles instead of category-specific. A Champion in fine dining is not the same TPV as a Champion in groceries.
- Conflating frequency with intent. Daily commuters using a fuel rebate are frequent but indifferent — frequency without monetary diversity is fragile loyalty.
- Failing to refresh. RFM scores must rebuild monthly; a Champion three months stale is often already At-Risk.

## Implications for merchant-funded loyalty

The platform should expose an RFM API per anchor tenant so the anchor's marketing team can target campaigns through the partner app. This is product, not just analytics — Bilt wraps RFM into its automated push-notification engine.

## Related files

- [cohort.md](cohort.md) · [churn.md](churn.md) · [ltv-cac.md](ltv-cac.md) · [reward-economics.md](reward-economics.md)
