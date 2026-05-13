---
title: Omar Glossary
last_updated: 2026-05-14
---

# WhatsApp Business / KSA — Glossary

## Meta WhatsApp Business

- **BSP** — Business Solution Provider. Authorized middleman between merchants and Meta Cloud API (Wati, Unifonic, Twilio, etc.).
- **Cloud API direct** — using Meta's Cloud API without a BSP middleman. Requires engineering capacity.
- **Authentication template** — OTP-style; high deliverability; restricted content.
- **Utility template** — transactional (order updates, account alerts); permitted within the 24h window without opt-in.
- **Marketing template** — promotional; requires explicit opt-in; rate-limited.
- **24h session window** — once a user messages a business, the business has 24 hours to reply without using a template.
- **Quality rating** — Meta's per-number rating: High / Medium / Low / Flagged. Drives messaging limits.
- **Messaging limit (Tier 1-4)** — per-24h messaging cap based on quality + history. Graduates with good performance.
- **Per-message pricing** (2024+) — new pricing model; per-message replaces per-conversation.
- **Block rate** — % of recipients blocking the number. Material driver of quality rating.

## KSA regulatory

- **CITC** — Communications, Space & Technology Commission (KSA). Regulates bulk commercial messaging.
- **PDPL** — Personal Data Protection Law (KSA, 2023). Applies to opt-in / opt-out / customer data.
- **SDAIA** — Saudi Data & AI Authority. Enforces PDPL.

## Verdict vocabulary

- **اعمل (Go)** — safe, compliant, profitable.
- **اعمل بشروط (Go-with-conditions)** — proceed after named conditions are met.
- **لا تعمل (No-Go)** — would trigger ban, fine, customer harm, or loss.

## Confidence tags

- **`[VERIFIED]`** — sourced (Meta docs, CITC, PDPL, Salla docs, or `verified-facts.md`).
- **`[UNVERIFIED]`** — practical experience or training data; possibly stale.
- **`[NEEDS-RESEARCH]`** — uncertain; offer to research before user acts.

## Competitor tiers

- **Direct** — same playbook for KSA Salla merchant (e.g., another BSP serving same segment with same pricing).
- **Indirect** — solves similar problem with different model (Cloud API direct, enterprise BSP).
- **Substitute** — different category competing for same budget (SMS, Snapchat ads, email).

## KSA defaults

- **Timezone:** Asia/Riyadh (GMT+3).
- **Default send window:** 9 AM–9 PM (with prayer-time and Ramadan adjustment).
- **Currency:** SAR / ر.س (USD shown alongside if source was USD).
- **Customer-facing language:** modern standard Arabic with Saudi commercial register (NOT Egyptian, NOT Lebanese).
- **Calendar:** Hijri + Gregorian for religious occasions (Ramadan, Eid, Hajj).

---

*See `sources.md` for the canonical source registry.*
