---
title: Membary Source Registry
last_updated: 2026-05-14
---

# Source Registry — Membership Commerce

Source-tag discipline is built into Membary's Validation Layer (see agent file). Every Confirmed item carries one of: `[source: user msg]`, `[source: Salla docs]`, `[source: verified behavior]`, `[source: cited example]`, `[source: prior decision in this thread]`.

---

## Tier 1 — Host-platform primary sources

| Source | Domain | URL |
|---|---|---|
| Salla Developer Docs | Salla APIs, webhooks, scopes, App Store policy | docs.salla.dev |
| Salla App Store | Competitor landscape, install counts, ratings | salla.sa/apps |
| Zid Developer Docs | Comparable host platform | docs.zid.sa |

## Tier 2 — Comparable membership programs (primary sources)

| Source | URL | Notes |
|---|---|---|
| Amazon Prime | amazon.com/amazonprime | Pricing-anchor benchmark; vary by geo |
| Sephora Beauty Insider | sephora.com/beauty/beauty-insider | Birthday-gift archetype |
| Starbucks Rewards | starbucks.com/rewards | F&B recurring-purchase anchor |
| Walmart+ | walmart.com/plus | Retail paid-membership comp |
| Costco | costco.com | Original membership-warehouse model |
| Bonat | bonat.io | KSA loyalty incumbent |
| MAF SHARE | sharerewards.com | Coalition loyalty (UAE) |

## Tier 3 — Regulatory & policy sources

| Source | Jurisdiction | URL |
|---|---|---|
| Saudi Ministry of Commerce | KSA consumer protection | mc.gov.sa |
| KSA SDAIA (PDPL) | KSA data protection | sdaia.gov.sa |
| UAE Ministry of Economy | UAE consumer protection (Federal Decree-Law 15/2020) | moec.gov.ae |
| US FTC | Click-to-Cancel rule | ftc.gov |
| Meta WhatsApp Business Policy | Messaging policy worldwide | business.whatsapp.com/policy |
| ZATCA | KSA e-invoicing (Phase 2) | zatca.gov.sa |

## Tier 4 — Academic & analyst (corroboration only)

- Loyalty research: BCG, McKinsey, Bain loyalty reports — paywalled; cite by article + date when used.
- Subscription commerce: Recurly, Chargebee, Zuora industry reports — vendor-published; treat as Inferred unless an independent source corroborates.

---

## Disagreement protocol

Two independent sources disagree >25% on a measurable figure:

1. Surface **both** with citations + dates.
2. Tier 1 host-platform docs beat Tier 2 if recent.
3. If same tier, mark `Unknown` and add to *What Must Be Verified*.

## Staleness

Per Membary's Maintenance Rules section, apply freshness windows:

- **30 days** — active competitor pricing.
- **90 days** — Salla platform behavior, API changes.
- **180 days** — stable regulation references.

Always tag with `[as of YYYY-QX, re-verify in N days]`.
