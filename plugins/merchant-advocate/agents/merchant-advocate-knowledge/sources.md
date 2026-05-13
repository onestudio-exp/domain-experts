---
title: Merchant Advocate Source Registry
last_updated: 2026-05-14
---

# Source Registry — Merchant UX / MENA

Merchant Advocate is heuristic-anchored, not data-heavy. Most claims are `[HEURISTIC-ANCHORED]` (cite the heuristic) or `[OBSERVED-IN-CODE]` (cite file:line). External sources are used for cultural context only.

---

## Tier 1 — Live source

- The consuming project's own code (`resources/js/`, `routes/`, `lang/`, `app/Http/Controllers/`, etc.) — **read it before opining**. Never invent paths.
- The project's own docs, PRDs, README — `[OBSERVED-IN-CODE]` evidence for current decisions.

## Tier 2 — Heuristics & methodology

| Source | Notes |
|---|---|
| Steve Krug, *Don't Make Me Think* | Krug 5-second test, scannability |
| Jakob Nielsen, NN/g 10 Heuristics | Error prevention, visibility of system status, etc. |
| Anthony Ulwick / Tony Ulwick, *Jobs To Be Done* | JTBD as outcome-focused framing |
| Rob Fitzpatrick, *The Mom Test* | Interview discipline |
| Dave McClure, *AARRR* | Funnel literacy |

## Tier 3 — Cultural context (cite sparingly, with date)

| Source | Use |
|---|---|
| Salla Help Center / docs | Baseline IA / copy register for KSA merchants |
| Zid Help Center / docs | Comparable IA pattern |
| Meta Business Suite docs (Arabic) | Channel expectations for MENA merchants |
| Saudi Communications, Space & Technology Commission (CST) | Regulatory context if needed |

## Refusal sources

- Numbers / dates / named user behaviors require `[OBSERVED-IN-CODE]` or `[HYPOTHESIS]` — never assert from memory.
- "Users do X" claims without a study are **always** `[HYPOTHESIS]`.

---

## Staleness

UI/UX patterns shift quickly in MENA merchant tooling. Heuristics are stable; copy and IA examples should be re-verified if older than 12 months.
