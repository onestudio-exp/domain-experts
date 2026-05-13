---
title: Shaheen Glossary
last_updated: 2026-05-14
---

# Qatar Economy — Glossary

Domain vocabulary used by Shaheen. Wiki-page-internal glossary entries live in `.agent-db/wiki/concepts/` in the deployment — this file is the plugin-bundled portable subset.

---

## Macro & fiscal

- **QCB** — Qatar Central Bank. Monetary authority; runs the riyal peg.
- **PSA / NPC** — Planning & Statistics Authority / National Planning Council. Primary national statistics.
- **Non-oil GDP** — Qatar's GDP excluding hydrocarbon extraction. Decoupling progress signal.
- **Current account** — exports − imports + transfers. Heavily LNG-driven for Qatar.
- **Sovereign wealth** — Qatar Investment Authority (QIA) and adjacent vehicles.

## Hydrocarbon

- **North Field (NF)** — world's largest non-associated gas field, shared with Iran's South Pars. Qatar's economic spine.
- **NFE / NFS** — North Field Expansion / South. Brings LNG capacity from ~77 to 142 MTPA by 2030.
- **MTPA** — million tons per annum (LNG capacity unit).
- **JKM** — Japan/Korea Marker, Asian LNG benchmark price.
- **HH** — Henry Hub, US natural-gas benchmark.
- **JKM-HH spread** — the arbitrage signal that drives Qatari LNG export economics.
- **Brent** — North-Sea crude oil benchmark.

## Financial system

- **Riyal-USD peg** — QAR pegged at 3.64 to USD since 2001. Implies dollar-system monetary passthrough.
- **QFC** — Qatar Financial Centre. Special economic-zone regulator (separate from QCB).
- **QSE** — Qatar Stock Exchange.

## GCC dynamics

- **GCC** — Gulf Cooperation Council (Bahrain, Kuwait, Oman, Qatar, KSA, UAE).
- **Blockade (2017-2021)** — KSA/UAE/Bahrain/Egypt diplomatic and trade blockade of Qatar. Reshaped logistics; lifted 2021.

## Wiki internals

- **Tier 1** — canonical wiki knowledge: `.agent-db/wiki/concepts/`, `.agent-db/wiki/entities/`, `.agent-db/wiki/events/`.
- **Tier 2** — structured indicator data: `.agent-db/wiki/indicators/` (Markdown definition + YAML reading).
- **Tier 3** — authoritative web retrieval (Tier 3 cascade rule lives in §3 / §7 of the agent spec).
- **Wazari** — ministerial. (Cross-domain term; used in Iraqi K-12 by Fekri, not in Qatar context.)

## Confidence vocabulary (§2.2)

- **✅ confirmed** — primary source, recent, unambiguous.
- **📰 reported** — secondary source, plausible, not independently verified.
- **📊 estimated** — derived from analysis / modelling; state the assumption.
- **❓ uncertain** — sources conflict or evidence is thin.
- **🚫 not knowable** — Shaheen cannot answer (specific market prices, undisclosed positions, future political decisions).

## Signature markers (§2.1)

- **Tier 1** — canonical-only answer.
- **Tier 1+2** — canonical + indicator.
- **Tier 1 · gap flagged** — wiki gap acknowledged inline.
- **Tier 3 needed** — live retrieval required.
- **Out of scope** — refused per deflection rules.
- **Mixed scope** — partly answered, partly deflected.
- **Operational** — wiki maintenance / meta reply.

---

*Cite source + date when stating a measurable claim. See the deployment's `.agent-db/wiki/INDEX.md` for the live wiki tier index, and `reference/comparables/` for the bundled comparable profiles.*
