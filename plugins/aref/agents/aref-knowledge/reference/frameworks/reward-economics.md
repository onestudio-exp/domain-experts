---
title: Reward Economics — Earn / Burn / Breakage
domain: framework
last_updated: 2026-04-29
---

# Reward Economics

## Summary

Loyalty programs are accounting constructs. The earn rate, burn rate, breakage rate, and unit cost of reward determine the program's P&L impact. Get the formula right, you have a profitable engagement engine; get it wrong, you have an unmonitored liability.

## Earn

```
earn_value_per_transaction = transaction_value × earn_rate × tier_multiplier
```

For closed-loop **points** programs the earn is a deferred liability until burnt. For **cashback** discount-commitment programs (Amos), earn is recognised at the moment of merchant settlement and funded from operator margin — not a balance-sheet liability.

## Burn

```
burn_value = redeemed_units × redemption_unit_cost
```

Redemption unit cost depends on whether the reward is:

- Funded from merchant margin (Amos: ~free to operator beyond settlement friction).
- Funded by operator (loyalty marketing expense).
- Funded by partner (e.g., airline mileage co-issue agreements).

## Breakage

```
breakage_rate = unredeemed_units_expired / total_earned_units
```

Industry benchmark for points programs: 10–25% breakage. For cashback with 12-month redemption windows it can run 5–15%.

For Amos's discount-commitment model, breakage is operationally relevant (un-issued cashback never costs the operator) but is **not** a revenue line — there is no liability to release.

## Cost-of-reward unit economics

For a typical closed-loop reward:

```
cost_per_redeemed_$_of_reward = 1 ÷ (1 − breakage_rate − operator_subsidy_rate)
```

Programs reporting < $1 per $1 of reward are typically baking in breakage assumptions; this is acceptable IFRS treatment if disclosed.

## Embedded loyalty (cashback) economics

Amos-style:

```
operator_revenue_per_transaction = transaction_value × merchant_take_rate − cashback_to_user
```

Where cashback_to_user is the discount commitment; merchant_take_rate is the operator's % of merchant margin (≥10% in Amos's model).

## Common mistakes

- Treating breakage as forecastable revenue. Regulators and auditors don't allow it.
- Using "revenue" interchangeably with "TPV". TPV is volume; revenue is the take.
- Ignoring fraud as a structural cost. 0.5–2% of redemptions in mature programs.

## Related files

- [redemption-design.md](redemption-design.md) · [tier-design.md](tier-design.md) · [ltv-cac.md](ltv-cac.md) · `domains/loyalty-economics.md`
