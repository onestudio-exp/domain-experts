---
title: Shaheen Source Registry
last_updated: 2026-05-14
---

# Source Registry — Qatar Economy

Canonical sources by tier. The wiki cascade (Tier 1 → Tier 2 → Tier 3) is defined in §7 of the agent spec; this file is the portable source registry that bundles with the plugin.

---

## Tier 1 — Canonical wiki (per deployment)

The live wiki lives in the deployment at `.agent-db/wiki/`:

- `concepts/` — durable concepts (e.g. *qatar-economy-overview*, *qatar-hydrocarbon-sector*, *riyal-usd-peg*).
- `entities/` — organizations (e.g. *qatar-central-bank*, *qatar-energy*, *ministry-of-finance-qatar*, *national-planning-council*).
- `events/` — historical anchors (e.g. *2014-oil-price-crisis*, *2017-qatar-blockade*, *2024-red-sea-crisis*).
- `indicators/` — structured indicator pages (paired `.md` + `.yaml`).

Tier 1 is the **primary source**. Shaheen searches the smart-index first, before any external call.

## Tier 2 — Authoritative external sources

Used when the wiki is silent or stale, or when a specific authoritative claim is needed.

| Source | Domain | URL |
|---|---|---|
| Qatar Central Bank (QCB) | Monetary, banking supervision, peg | qcb.gov.qa |
| Planning & Statistics Authority (PSA) | Macro & demographic data | psa.gov.qa |
| Qatar Energy / QatarEnergy LNG | Hydrocarbon production, LNG | qatarenergy.qa, qatarenergylng.qa |
| Ministry of Finance Qatar | Fiscal, budget, debt | mof.gov.qa |
| Qatar Investment Authority (QIA) | Sovereign-wealth posture | qia.qa |
| IMF — Article IV (Qatar) | Annual macro mission concluding statements | imf.org/en/Countries/QAT |
| World Bank — Qatar | Economic updates | worldbank.org/en/country/qatar |
| Qatar Financial Centre (QFC) | Special-zone regulator | qfc.qa |

Each Tier 2 citation in a Sources block carries `*Tier 2 (Authoritative web; authority: <domain>)*`.

## Tier 3 — General web

Used only when both Tier 1 and Tier 2 are insufficient. Tier 3 citations require `Tier 3 needed` in the response signature.

Examples: Reuters, Bloomberg, Financial Times, CNBC, Al-Jazeera (English/Arabic), Asharq Al-Awsat, Reuters Eikon excerpts, IEA, BP Statistical Review.

Each Tier 3 citation carries `*Tier 3 (General web)*`.

## Cross-domain (use sparingly)

- Energy / LNG analytics: Energy Aspects, S&P Global Platts, Wood Mackenzie.
- Geopolitical: Eurasia Group, Crisis Group, ICG. Mark as Tier 3 unless cited authoritatively.
- Academic: Brookings Doha Center, Middle East Council on Global Affairs.

---

## Disagreement protocol

When sources conflict by >25% on a measurable figure:

1. Surface **both** with citations + dates.
2. **Tier precedence applies first** — Tier 1 wiki entry beats a Tier 2 source if recent enough.
3. If sources are same tier, surface both and mark the claim `❓ (*uncertain*)`.

## Staleness

Indicator readings older than the indicator's declared refresh cadence (e.g., monthly for CPI, daily for Brent) are flagged. Concept pages older than 12 months on fast-moving topics (hydrocarbon, GCC policy) trigger a re-verification prompt before use in a user-facing answer.
