---
title: Omar Source Registry
last_updated: 2026-05-14
---

# Source Registry — WhatsApp Business / KSA

Two-source-strict for empirical claims (pricing, dates, regulation article numbers, market share). Single-source acceptable for methodology references.

---

## Tier 1 — Meta primary sources

| Source | URL |
|---|---|
| Meta WhatsApp Business Platform docs | developers.facebook.com/docs/whatsapp |
| Meta WhatsApp Business Policy | business.whatsapp.com/policy |
| Meta WhatsApp Business pricing | developers.facebook.com/docs/whatsapp/pricing |
| Meta Cloud API reference | developers.facebook.com/docs/whatsapp/cloud-api |
| Meta WhatsApp Business commerce policy | business.whatsapp.com/policy/commerce |

## Tier 2 — KSA regulatory primary sources

| Source | URL |
|---|---|
| CITC (Communications, Space & Technology Commission) | citc.gov.sa |
| SDAIA (PDPL) | sdaia.gov.sa |
| Saudi Ministry of Commerce | mc.gov.sa |

## Tier 3 — Salla platform sources

| Source | URL |
|---|---|
| Salla Developer Docs | docs.salla.dev |
| Salla App Store | salla.sa/apps |

## Tier 4 — BSP primary sources (for competitor claims)

When stating a BSP's feature or pricing, cite the vendor's own primary page **and** corroborate.

| BSP | URL |
|---|---|
| Wati | wati.io |
| Unifonic | unifonic.com |
| Twilio (WhatsApp) | twilio.com/whatsapp |
| MessageBird / Bird | messagebird.com |
| Sinch | sinch.com |
| Infobip | infobip.com |

## Tier 5 — Press / industry analysts (use sparingly)

- Reuters, Bloomberg, Arab News (Saudi reporting on regulatory moves).
- Recurly, Chargebee subscription benchmarks — non-WhatsApp but signal channel-level patterns.

---

## Disagreement protocol

Two sources disagree >25% on a measurable figure:

1. Surface **both** with citations + dates.
2. Tier 1 (Meta primary) beats Tier 4 (BSP primary).
3. KSA-specific data (CITC) beats global pattern.

## Staleness

- Meta policy: re-verify every **60 days** (changes can happen quietly).
- Pricing model: re-verify every **30 days** (per-message pricing rollout is recent).
- KSA regulation: re-verify every **180 days**.

Mark every time-sensitive claim with `آخر تحقق: YYYY-MM-DD`. No date stamp → demote to `[NEEDS-RESEARCH]`.
