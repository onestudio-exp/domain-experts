---
title: Data & Personalisation in Loyalty
domain: data-personalisation
last_updated: 2026-04-29
---

# Data & Personalisation

## Summary

Embedded loyalty platforms sit on first-party transaction data inside an anchor's app. This is rare and valuable in a privacy-first world. Used well it drives personalised rewards, targeted offers, churn prediction, and second-order revenue (insights products). Used poorly it triggers regulatory complaints and anchor termination.

## Data sources available

- **Transaction events** — merchant, category, amount, time, channel.
- **Anchor-app behavioural events** — sessions, screens, push notification engagement.
- **Customer profile** (anchor-shared, scoped) — tier, tenure, household size for residents, balance band for banked.
- **Merchant settlement data** — cashback flows, redemption patterns.

## Use-cases ordered by value

1. **At-risk prediction** — flag users on a churn trajectory; trigger uplift cashback offers.
2. **Personalised earn rates** — dynamic bonus on the categories the user actually shops.
3. **Personalised burn nudges** — push the right merchant at the right time of day.
4. **Anchor reporting** — quarterly business-value dashboard for the anchor's own retention narrative.
5. **Aggregate insights** — anonymised category trends sold back to merchants or used in Amos's own positioning.

## Consent & data residency

- **First-party basis for analytics** is acceptable in UAE / KSA. Marketing communications still need consent.
- **Data residency** — bank anchors require in-region hosting. UAE Personal Data Protection Law (Federal Decree-Law No. 45 of 2021) sets the baseline.
- **Anchor-tenant separation** — DAMAC's data must not be queryable by FAB Bank's stack. The multi-tenant boundary is the privacy contract.

## Personalisation that works

- **Category-aware boosts** — "5% extra at fine dining this weekend" sent to users who transacted in fine dining in the last 90 days.
- **Geo-aware nudges** — push notification when a user is within 500m of a participating merchant.
- **Decay-aware re-engagement** — when activity drops 60% from baseline, trigger re-activation flow.

## Personalisation that backfires

- Communications outside cadence consent.
- Visible profiling ("we noticed you visit X gym").
- Dynamic pricing that exposes a user paying more than another for identical reward.

## Related files

- `frameworks/rfm.md` · `frameworks/cohort.md` · `regulatory/kyc-aml.md` · `regulatory/open-finance-mena.md`
