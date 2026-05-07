---
title: Churn Definitions & Root-Cause Framework
domain: framework
last_updated: 2026-04-29
---

# Churn

## Summary

Churn is the inverse of retention but the framing matters. For embedded loyalty there are three distinct churn flows: **end-user churn**, **anchor churn**, and **merchant churn**. Each has different causes and economics.

## End-user churn

**Definition:** zero qualifying transactions in N consecutive months (typical N = 3 for monthly programs, 12 for low-frequency).

**Top root causes:**
1. Cashback rate uncompetitive vs alternative wallets (open-loop cards, native rewards).
2. Redemption friction — too many steps, capped categories, opaque expiry.
3. Anchor app churn — if the resident leaves DAMAC, the loyalty churn is upstream.
4. Earn opportunities sparse — too few merchants in the user's geography or category preference.

**Counter-measures:** dynamic rate uplift for at-risk segment, simplified one-tap redemption, geo-density expansion in merchant signing.

## Anchor churn

**Definition:** anchor terminates the MSA or fails to renew at the multi-year point.

**Top root causes:**
1. Failed integration ROI — not enough end-user adoption.
2. Internal politics — a competing in-house initiative.
3. Cheaper / better competitor.
4. Strategic pivot at the anchor (e.g., bank acquired).

**Counter-measures:** quarterly business review with anchor showing measured uplift in their primary KPI (residents transacting, banked customer retention, etc.). Make the operator the anchor's loyalty team, not a vendor.

## Merchant churn

**Definition:** merchant pauses or terminates the participation agreement.

**Top root causes:**
1. Margin pressure — minimum 12% rule (Amos) excludes some categories.
2. Settlement friction — slow PSP, opaque reconciliation.
3. Volume below threshold — not enough redemptions to justify operational overhead.

**Counter-measures:** AI support agent (PIN retrieval, settlement queries) cuts friction; tiered margin requirement allows broader category mix at lower take.

## Common mistakes

- Reporting blended churn. The three flows have different causes and different fix budgets.
- Confusing dormancy with churn. A user who transacts every quarter looks churned in a 90-day window. Use rolling 12-month definitions for low-frequency categories.
- Treating churn as a marketing problem when it's a product / supply-side problem.

## Related files

- [cohort.md](cohort.md) · [rfm.md](rfm.md) · `domains/merchant-ops.md` · `domains/enterprise-gtm.md`
