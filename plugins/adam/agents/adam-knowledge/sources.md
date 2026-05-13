---
title: Adam Source Registry
last_updated: 2026-05-14
---

# Source Registry — Competitive Intelligence

Adam's primary tools are `WebSearch` and `WebFetch`. Every `[CONFIRMED]` claim must trace to a retrieved URL or document. This file lists the canonical source classes Adam draws from.

---

## Tier 1 — Vendor primary sources

The vendor's own marketing/pricing/feature page. Useful for **what they claim** to offer. Always corroborate with a Tier 2 (review) source before stating as `[CONFIRMED]` for a competitor.

## Tier 2 — Third-party review aggregators (Mode B Customer Voice — REQUIRED)

| Source | URL | Use |
|---|---|---|
| G2 | g2.com | SaaS reviews; primary Customer Voice source |
| Capterra | capterra.com | SaaS reviews; secondary |
| Trustpilot | trustpilot.com | Consumer-product reviews |
| Reddit | reddit.com | Long-form user discussion; verbatim quotes available |
| App Stores (iOS/Google Play) | apps.apple.com / play.google.com | Mobile app reviews |

**Rejected for Customer Voice:** vendor testimonial pages, vendor case studies, vendor marketing copy.

## Tier 3 — Funded-company / signal databases

| Source | Use |
|---|---|
| Crunchbase | Funding rounds, headcount, founding date |
| CB Insights | Market sizing, competitive landscape reports |
| PitchBook | Funded-company database (paywalled) |
| Owler | Competitor signals |
| SimilarWeb | Web traffic comparisons |
| Sensor Tower | Mobile app installs / rankings |
| LinkedIn | Headcount, hiring signals |

## Tier 4 — Press / analyst

| Source | Use |
|---|---|
| TechCrunch, The Information, Forbes | Funding rounds, deal-level coverage |
| The Verge, Wired | Product launches, feature ships |
| Industry-specific outlets | Domain-specific (EdSurge for EdTech, MedCity for HealthTech, etc.) |

## Tier 5 — Domain-specific authorities

Apply per the **hybrid-domain-expert** lens. Examples:

- **SaaS** — Bessemer Cloud Index, OpenView SaaS Benchmarks
- **E-commerce** — Statista, eMarketer, Shopify Trends
- **B2B Sales** — Gartner Magic Quadrant, Forrester Wave
- **HR & Talent** — Josh Bersin Research, Sapient Insights
- **EdTech** — HolonIQ, EdSurge research

## Independence Test sources

Sources that exist *only* in `examples.md`, `reports/`, or `.adam/knowledge/<product-slug>/` — never in contract files. Anchored to placeholders (`<Product>`, `<Competitor>`).

---

## Disagreement protocol

Two sources disagree >25% on a measurable figure:

1. Surface both with citations + dates.
2. Tier 1 (vendor primary) beats Tier 4 (press) for self-described features.
3. Tier 2 (reviews) beats Tier 1 (vendor) for usage reality.
4. If same tier, mark `[INFERRED]` and add to §8 Unknowns.

## Staleness

- Vendor pricing pages: re-verify every **30 days**.
- Review aggregator volume / sentiment: re-verify every **60 days**.
- Funded-company round data: re-verify every **180 days**.

Mode B reports flag staleness in §8 if the latest customer voice quote is >12 months old.
