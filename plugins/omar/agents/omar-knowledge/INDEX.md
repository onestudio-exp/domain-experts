---
title: Omar Knowledge Index
last_updated: 2026-05-14
---

# Omar Knowledge Base Index

Plugin-default KB for Omar — WhatsApp Business marketing for KSA Salla merchants.

```
omar-knowledge/
├── meta-platform/      ← Meta WhatsApp Business policies, templates, pricing, quality
├── ksa-market/         ← CITC, PDPL, KSA consumer behavior on WhatsApp, timing
├── salla-context/      ← KSA Salla merchant patterns, use-cases, integration
├── competitors/        ← Unifonic, Wati, Twilio, MessageBird, Cloud API
├── campaigns/          ← cart-abandon, order updates, re-engagement, segmentation
├── playbooks/          ← style, citation, confidence, escalation patterns
├── decisions/          ← structured decision log
├── glossary.md
├── sources.md
└── INDEX.md            ← this file
```

## `meta-platform/`

| File | Topic | Status |
|---|---|---|
| `meta-platform/template-categories.md` | Authentication / Utility / Marketing classification rules | scaffold |
| `meta-platform/24h-window.md` | The 24-hour session window — what triggers it, what extends it | scaffold |
| `meta-platform/quality-rating.md` | Quality rating mechanics (High / Medium / Low / Flagged) | scaffold |
| `meta-platform/messaging-limits.md` | Tier 1-4 messaging limits and graduation rules | scaffold |
| `meta-platform/pricing-model.md` | Per-message pricing model (2024+) and per-conversation legacy | scaffold |
| `meta-platform/template-approval.md` | Template submission, approval, rejection patterns | scaffold |

## `ksa-market/`

| File | Topic | Status |
|---|---|---|
| `ksa-market/citc-bulk-messaging.md` | CITC regulation on bulk commercial messaging to KSA numbers | scaffold |
| `ksa-market/pdpl-consent.md` | KSA PDPL applicability to opt-in / opt-out and gift-customer data | scaffold |
| `ksa-market/consumer-behavior.md` | KSA consumer patterns on WhatsApp — read rates, response windows | scaffold |
| `ksa-market/timing-window.md` | 9am–9pm default; Hijri-aware (Ramadan, Hajj, Eid); prayer-time windows | scaffold |

## `salla-context/`

| File | Topic | Status |
|---|---|---|
| `salla-context/merchant-personas.md` | Common KSA Salla merchant profiles and use-cases | scaffold |
| `salla-context/event-to-message.md` | Mapping Salla events (order placed, abandoned, fulfilled) to WhatsApp messages | scaffold |

## `competitors/`

| File | BSP | Tier |
|---|---|---|
| `competitors/wati.md` | Wati | Direct |
| `competitors/unifonic.md` | Unifonic | Direct (KSA-anchored) |
| `competitors/twilio.md` | Twilio | Indirect (enterprise-first) |
| `competitors/messagebird.md` | MessageBird / Bird | Indirect |
| `competitors/cloud-api-direct.md` | Meta Cloud API direct | Indirect |
| `competitors/sinch-infobip.md` | Sinch / Infobip | Indirect (enterprise) |

## `campaigns/`

| File | Campaign type | Status |
|---|---|---|
| `campaigns/cart-abandon.md` | Cart-abandonment templates, timing, classification | scaffold |
| `campaigns/order-updates.md` | Order placed / fulfilled / delivered (utility templates) | scaffold |
| `campaigns/re-engagement.md` | Re-engaging dormant customers (marketing template + opt-in) | scaffold |
| `campaigns/segmentation.md` | Audience segmentation for KSA merchants | scaffold |
| `campaigns/lifecycle-flows.md` | First-purchase → repeat → at-risk → lapsed lifecycle | scaffold |

## `playbooks/`

| File | Purpose | Status |
|---|---|---|
| `playbooks/three-line-refusal.md` | The strict 3-line refusal pattern (cap, no bullets, no citations after) | scaffold |
| `playbooks/template-classification-decision.md` | How to classify a draft template Utility vs Marketing | scaffold |
| `playbooks/opt-in-validation.md` | Pre-flight checks on opt-in coverage before any campaign | scaffold |

## `decisions/`

Plugin default empty; consuming projects accumulate their own.
