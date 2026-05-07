---
title: LTV / CAC for Embedded Loyalty
domain: framework
last_updated: 2026-04-29
---

# LTV / CAC

## Summary

Lifetime Value over Customer Acquisition Cost is the standard SaaS sustainability test. For embedded loyalty platforms the calculation differs from consumer apps because:

1. **CAC for end users is near zero** — distribution comes via the anchor app.
2. **CAC for anchors is large but rare** — long enterprise sales cycles, high contract value.
3. **LTV must be split** — operator LTV from SaaS fees + take rate, anchor LTV (for the anchor's own customer), merchant LTV.

## Formulae

Operator LTV per anchor:

```
LTV_anchor = (monthly_SaaS_floor + avg_monthly_take_rate_revenue) × expected_tenure_months − onboarding_cost
```

CAC per anchor:

```
CAC_anchor = sales_team_cost_to_close + integration_cost + legal/compliance_cost
```

Healthy ratio for an enterprise SaaS: LTV/CAC ≥ 3 with payback < 18 months. For loyalty-on-spend, payback can stretch to 24 months because take-rate revenue ramps with anchor user adoption.

## Operator LTV per end user (consumer)

```
LTV_user = avg_monthly_spend_through_program × take_rate × expected_active_months
```

For Amos with $10/mo merchant margin take per active user × 36 months expected tenure × ~10% take = **~$36 LTV per active resident**, against ~$0 CAC. The anchor-level economics dominate.

## Merchant LTV

```
LTV_merchant = avg_monthly_TPV × take_rate × expected_active_months − onboarding_cost − cost_to_serve_per_month
```

The 7x AI-support displacement (see `domains/merchant-ops.md`) directly improves merchant LTV by collapsing the cost-to-serve term.

## Common mistakes

- Reporting blended LTV/CAC without separating the three flows. Hides the fact that anchor economics carry the model.
- Using gross revenue instead of contribution margin. Cashback funded from operator margin is not revenue.
- Ignoring the regulatory moat as an LTV multiplier. Once a regulator-cleared model is bedded with anchor #1, anchor #2 onboarding cost drops sharply.

## Related files

- [reward-economics.md](reward-economics.md) · [cohort.md](cohort.md) · `domains/loyalty-economics.md` · `domains/enterprise-gtm.md`
