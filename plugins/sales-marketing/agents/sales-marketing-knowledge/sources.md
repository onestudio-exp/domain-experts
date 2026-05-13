---
title: Abo Nawaf Source Registry
last_updated: 2026-05-14
---

# Source Registry — GCC/MENA B2B Revenue

Most of Abo Nawaf's domain knowledge is `[REGION-OPERATOR]` (uncited operator judgment). External sources are used to corroborate measurable claims (regulation, vendor pricing, market sizing).

---

## Tier 1 — Live code (reality-audit mode)

The venture's own codebase under `backend/`, `frontend/`, `docs/`, package manifests. Read before opining. Every claim must trace to `file:line`.

## Tier 2 — Regulatory primary sources

| Source | Domain | URL |
|---|---|---|
| KSA CITC | Commercial messaging | citc.gov.sa |
| SDAIA (KSA PDPL) | KSA data protection | sdaia.gov.sa |
| UAE Cabinet (PDPL) | UAE Federal PDPL | u.ae |
| Saudi Ministry of Commerce | KSA consumer protection | mc.gov.sa |

## Tier 3 — Vendor primary sources (for competitor claims)

| Vendor | URL |
|---|---|
| Outreach | outreach.io |
| Salesloft | salesloft.com |
| Apollo.io | apollo.io |
| ZoomInfo | zoominfo.com |
| Lusha | lusha.com |
| Cognism | cognism.com |
| People Data Labs | peopledatalabs.com |
| Coresignal | coresignal.com |
| Instantly | instantly.ai |
| Smartlead | smartlead.ai |
| HubSpot | hubspot.com |
| Salesforce | salesforce.com |

## Tier 4 — Analyst & industry research

| Source | Notes |
|---|---|
| Gartner Magic Quadrant (Sales Engagement) | Paywalled; cite by article + date |
| Forrester Wave (Sales Engagement) | Paywalled |
| LinkedIn State of Sales report | Annual; cite year |
| Outreach / Salesloft state-of-outbound reports | Vendor-published; treat as Inferred |

## Tier 5 — GCC/MENA market context

- LEAP (KSA tech conference) keynotes + reports.
- GITEX (UAE tech conference) reports.
- Saudi Vision 2030 sector-specific deep dives.
- Local press: Arab News, Gulf News, The National (cite by date).

---

## Disagreement protocol

Sources disagree >25% on a measurable figure:

1. Surface **both** with citations + dates.
2. Tier 1 (live code) is the truth for product reality.
3. Tier 2 (regulatory primary) is binding for compliance claims.
4. If same tier, mark `[NEEDS-VERIFICATION]`.

## Staleness

- Vendor pricing: re-verify every **30 days**.
- Regulatory: re-verify every **180 days**.
- Market reports: re-verify annually.
- `[OBSERVED-IN-CODE]` claims: re-verify before each audit — code changes.
