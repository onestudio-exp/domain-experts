---
title: Cohort Retention Analysis
domain: framework
last_updated: 2026-04-29
---

# Cohort Retention

## Summary

Group customers by acquisition month (cohort), measure % active in months 1, 3, 6, 12, 18, 24. The shape of the curve is more diagnostic than the average retention number.

## Curve shapes & their meanings

| Shape | Description | Implication |
|---|---|---|
| Smile (rises after dip) | Activation problem solved by re-engagement | Investigate what triggered re-activation; codify it |
| Sharp cliff at month 1 | Onboarding fails to deliver value | Fix activation event (first cashback redemption) |
| Gentle decay | Healthy program | Optimise tail; cross-sell |
| Flat after early decay | Strong product-market fit | The "L-curve"; the holy grail |
| Step-function down | Tier expiry or feature change broke retention | Audit recent program changes |

## Definition of "active"

Active is **product-defined**, not arbitrary. For embedded loyalty, options:

- **Transacted in window** (most common) — at least 1 cashback-eligible transaction in the period.
- **Logged in via anchor app** — weak; anchor activity is not loyalty engagement.
- **Earned or redeemed** — stronger; isolates loyalty engagement.

Document the choice and never change it without re-baselining cohorts.

## Anchor-cohort vs natural cohort

For embedded loyalty, segment cohorts by **anchor-of-acquisition**. DAMAC residents and FAB Bank customers behave differently; combining them obscures both.

## Common mistakes

- Comparing cohort *averages* instead of curves. Same average can be dangerous decay vs healthy plateau.
- Truncating to 6 months on a long-tenure product. Loyalty programs need 24+ month curves to validate LTV assumptions.
- Treating reactivated users as same-cohort. They behave like new cohorts.

## Related files

- [rfm.md](rfm.md) · [churn.md](churn.md) · [ltv-cac.md](ltv-cac.md) · [reward-economics.md](reward-economics.md)
