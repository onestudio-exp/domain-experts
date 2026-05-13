---
title: Shaheen Knowledge Index
last_updated: 2026-05-14
---

# Shaheen Knowledge Base Index

Plugin-default KB for Shaheen. The Qatar-economy wiki cascade (Tier 1 concepts/entities/events + Tier 2 indicators) is the live KB the agent maintains — see §7 (Knowledge architecture) and §8 (Project / wiki structure) in `shaheen.md` for the canonical wiki layout. This INDEX covers the **plugin-bundled reference scaffolding** that travels with the agent into any deployment.

```
shaheen-knowledge/
├── playbooks/           ← reusable analytical templates
├── reference/
│   ├── regulatory/      ← QCB, ZATCA-equivalent, GCC financial regulation
│   ├── frameworks/      ← analytical frameworks (LNG market, hydrocarbon cycles, GCC peg)
│   ├── comparables/     ← peer systems (IMF Article IV, WB updates, sovereign-fund advisors)
│   └── indicators/      ← indicator definitions (Brent, JKM, GPR Index, Qatar CPI, etc.)
├── decisions/           ← structured decision log
└── INDEX.md             ← this file
```

A **Tier 1 wiki** (the live Qatar-economy knowledge base — concepts, entities, events, indicators) lives in the consuming project at `.agent-db/wiki/` per §8 of the agent spec — it is **not** shipped with the plugin and must be populated by the venture team (via the bundled `ingest-source` skill).

---

## `playbooks/`

| File | Purpose | Status |
|---|---|---|
| `playbooks/wiki-cascade-answer.md` | Step-by-step Tier 1 → Tier 2 → Tier 3 answer procedure. | scaffold |
| `playbooks/bilingual-rendering.md` | When to lead Arabic vs English; unit-symbol handling; first-mention acronym gloss. | scaffold |
| `playbooks/citation-discipline.md` | Footnote + Sources block + confidence-token mechanics. | scaffold |
| `playbooks/escalation-handoff.md` | The six escalation triggers and the handoff card schema. | scaffold |

## `reference/regulatory/`

| File | Topic | Status |
|---|---|---|
| `reference/regulatory/qcb.md` | Qatar Central Bank — mandate, supervisory perimeter, recent rules. | scaffold |
| `reference/regulatory/qatar-fiscal.md` | Public-finance framework, sovereign-wealth governance. | scaffold |
| `reference/regulatory/gcc-financial-integration.md` | GCC payments, currency-peg coordination. | scaffold |

## `reference/frameworks/`

| File | Topic | Status |
|---|---|---|
| `reference/frameworks/lng-market-structure.md` | JKM-HH spread, contract structure, North Field economics. | scaffold |
| `reference/frameworks/hydrocarbon-cycle.md` | Oil-price cycles and Qatar's exposure. | scaffold |
| `reference/frameworks/gcc-peg-mechanics.md` | Riyal-USD peg, dollar-system passthrough. | scaffold |
| `reference/frameworks/early-warning-windows.md` | Lead-time decomposition (leading / coincident / lagging indicators). | scaffold |

## `reference/comparables/`

| File | Comparable | Notes |
|---|---|---|
| `reference/comparables/imf-article-iv.md` | IMF Article IV (Qatar) annual missions. |
| `reference/comparables/world-bank-qatar.md` | World Bank Qatar Economic Updates. |
| `reference/comparables/qatar-energy.md` | QatarEnergy / QatarEnergy LNG (primary hydrocarbon authority). |
| `reference/comparables/sovereign-advisory.md` | Eurasia Group, Energy Aspects, S&P Platts — comparable analyst output. |
| `reference/comparables/live-data-vendors.md` | Reuters Eikon, Bloomberg Terminal — Tier 3 live-data comparables. |

## `reference/indicators/`

Stub for indicator-definition pages. The live indicator pages (with current YAML readings and update procedures) live in the deployment's `.agent-db/wiki/indicators/` per §8 of the agent spec.

| File | Indicator | Status |
|---|---|---|
| `reference/indicators/brent-crude.md` | Brent crude — definition, sources, refresh cadence. | scaffold |
| `reference/indicators/jkm-hh-spread.md` | JKM–Henry Hub spread — definition, why it matters for Qatar LNG. | scaffold |
| `reference/indicators/qatar-cpi.md` | Qatar CPI — definition, sources, baseline. | scaffold |
| `reference/indicators/qatar-non-oil-gdp.md` | Qatar non-oil GDP — definition, sources, why decoupling matters. | scaffold |
| `reference/indicators/gpr-index.md` | Geopolitical Risk Index (Caldara & Iacoviello) — definition, use. | scaffold |

## `decisions/`

Plugin default empty; consuming projects accumulate their own.
