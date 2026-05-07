---
title: Redemption Design
domain: framework
last_updated: 2026-04-29
---

# Redemption Design

## Summary

The earn side of a loyalty program builds liability and engagement; the burn side produces felt value. Redemption UX is where most programs fail — users earn enthusiastically, redeem rarely, churn quietly.

## The three redemption qualities

1. **Friction** — number of taps, confirmations, KYC steps from intent-to-redeem to value-received.
2. **Eligibility transparency** — does the user know in advance what they can redeem on, where, and when?
3. **Burn-to-value clarity** — does the user know *what* they're getting in money terms? Vague "1000 points = a meal" descriptions kill burn.

## Patterns that work

- **Auto-burn at point of sale.** Cashback applied directly at checkout (Bilt's tap-to-pay) removes the redemption decision entirely.
- **Single-tap mobile redemption.** With the anchor app already installed, redemption can be 1 tap on a bottom-sheet UI.
- **Always-redeemable categories.** A small set of universally redeemable categories (groceries, fuel, telecom top-up) anchors expectations.

## Patterns that fail

- **Redemption marketplace with 200 items and no filter.** Decision fatigue → no burn.
- **Tier-gated redemption.** "You need Gold to redeem this" punishes new users.
- **Expiring offers without notice.** Trust corrosive.
- **Different redemption rate vs earn rate.** Earning at 5% but redeeming at 4% effective is a hidden liability that shocks users when they do the math.

## Fraud surface

- Account takeover redemptions are the #1 fraud vector in mature programs.
- Bot-driven sign-up + low-friction redemption = fraud factory.
- 2FA on redemption events above a threshold is industry standard.

## Embedded loyalty considerations

- Redemption inside the partner app keeps the operator invisible — good for white-label, bad for direct user trust building.
- Cross-merchant redemption (DAMAC resident burns at a Pizza Express in Marina) is the network value; designing for it from day one prevents merchant-silo fragmentation.

## Related files

- [reward-economics.md](reward-economics.md) · [tier-design.md](tier-design.md) · `domains/merchant-ops.md` · `regulatory/kyc-aml.md`
