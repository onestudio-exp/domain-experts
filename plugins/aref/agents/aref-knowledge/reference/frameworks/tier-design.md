---
title: Loyalty Tier Design
domain: framework
last_updated: 2026-04-29
---

# Tier Design

## Summary

Tiers (Bronze → Silver → Gold → Platinum) gate progressively richer benefits behind activity thresholds. They drive both retention (sunk cost) and incremental spend (status push). Designing tiers is partly economic and partly psychological.

## Economics of a tier

For each tier, determine:

- **Entry threshold** (annualised spend or transaction count)
- **Maintenance threshold** (often 70-80% of entry to encourage push for upgrade)
- **Decay rule** (annual reset, rolling 12 months, soft expiry)
- **Marginal cost of perks** (incremental cashback rate, exclusive offers, fee waivers)
- **Expected uplift** (the spend increase from a customer pushing to next tier)

The break-even test:

```
incremental_perk_cost_per_user < incremental_spend_uplift × take_rate
```

## Psychological structure

- **Three to five tiers maximum.** Six+ feels Byzantine.
- **Aspirational top tier accessible to ≤3% of users.** Status only works if scarce.
- **Visible progress bar.** Removed bars destroyed Starwood SPG conversion; restored bars rebuilt it.
- **Soft landings.** A user who *just* falls below maintenance feels punished; offer one-grace-period.

## Embedded loyalty considerations

- Tiers should align with the anchor's existing customer segments. DAMAC's tower-vs-villa split is a natural tiering anchor; banks already have Premier / Wealth tiers.
- Multi-anchor users (a DAMAC resident who is also a FAB Bank customer) need a unified status view to avoid feeling demoted in either silo.

## Common mistakes

- Tier benefits that are hard to use (concierge that nobody calls).
- Threshold inflation year-over-year that quietly shrinks the top tier.
- Failing to publish the threshold transparently — users gaming what they can see is fine; users guessing is churn.

## Related files

- [reward-economics.md](reward-economics.md) · [redemption-design.md](redemption-design.md) · [gamification.md](gamification.md)
