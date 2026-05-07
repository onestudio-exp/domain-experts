---
title: Aref Knowledge Index
last_updated: 2026-05-06
---

# Aref Knowledge Base Index

This is the master index of canonical, human-curated knowledge for Aref. Vector-DB chunks complement these files with transient research.

The KB is organised in **three tiers**:

```
knowledge/
├── my-venture/        ← Tier 1: the user's own venture (lived workspace)
├── playbooks/         ← Tier 2: reusable templates the user adapts
├── reference/         ← Tier 3: independent benchmark + regulatory + framework material
├── decisions/         ← structured decision log
├── digests/           ← generated weekly market-intel digests
├── glossary.md        ← domain terminology
├── sources.md         ← canonical source registry with retrieval dates
└── INDEX.md           ← this file
```

---

## Tier 1 — `my-venture/` (the user's own venture)

The user's evolving venture brief + the formal project documentation suite. Aref helps populate and update these — they represent the working hypothesis at any given point in time.

### 1.1 Working hypothesis + scaffolds

| File | Purpose |
|---|---|
| [my-venture/venture-brief.md](my-venture/venture-brief.md) | Single source of truth for the venture working hypothesis. Updated continuously. **Differentiation axis LOCKED 2026-05-06.** |
| [my-venture/model-canvas.md](my-venture/model-canvas.md) | Value proposition, segments, channels, revenue, cost structure, key resources, partners. |
| [my-venture/target-segment.md](my-venture/target-segment.md) | Anchor candidates, merchant categories, end-consumer profile. |
| [my-venture/economics.md](my-venture/economics.md) | Unit economics: MDR, cashback rate, take-rate, settlement timing, CAC, LTV. |
| [my-venture/gtm.md](my-venture/gtm.md) | Anchor sales motion, merchant onboarding, regulatory path. |
| [my-venture/roadmap.md](my-venture/roadmap.md) | Milestones, MVP scope, expansion sequence. |
| [my-venture/sow-v1.md](my-venture/sow-v1.md) | Statement of Work v1 — CTO-grade build scope, 8 modules, 3 phases, team scaling, risks (688 lines). |

### 1.2 Project documentation suite (`my-venture/docs/`)

Formal project documents authored 2026-05-06 covering the full spec lifecycle from Discovery → Vision → Specification → Design. Navigation guide: [my-venture/docs/README.md](my-venture/docs/README.md).

**Discovery cluster** ([`my-venture/docs/01-discovery/`](my-venture/docs/01-discovery/)):
- [01-project-charter.md](my-venture/docs/01-discovery/01-project-charter.md) — formal authorisation, sponsors, scope, objectives, constraints
- [02-problem-statement.md](my-venture/docs/01-discovery/02-problem-statement.md) — two-sided sparsity, JTBD framings, why-now
- [03-as-is-to-be-analysis.md](my-venture/docs/01-discovery/03-as-is-to-be-analysis.md) — current vs future state per actor, gap analysis
- [04-problem-framing.md](my-venture/docs/01-discovery/04-problem-framing.md) — 5 reframing lenses, 5 Whys, decision criteria, hidden assumptions
- [05-competitive-analysis.md](my-venture/docs/01-discovery/05-competitive-analysis.md) — 4 layers (direct/telco/coalition/bank+RED), positioning canvas, differentiation strategy
- [06-feasibility-notes.md](my-venture/docs/01-discovery/06-feasibility-notes.md) — 6-dimension feasibility, 5 killer assumptions, 9 gating decisions

**Vision/Scope cluster** ([`my-venture/docs/02-vision-scope/`](my-venture/docs/02-vision-scope/)):
- [07-product-vision.md](my-venture/docs/02-vision-scope/07-product-vision.md) — 5-year vision, 5 strategic pillars, north-star metric, anti-vision
- [08-mvp-scope.md](my-venture/docs/02-vision-scope/08-mvp-scope.md) — MVP definition, P0 features by module, launch acceptance criteria, exit gates

**Specification cluster** ([`my-venture/docs/03-specification/`](my-venture/docs/03-specification/)):
- [09-prd.md](my-venture/docs/03-specification/09-prd.md) — Product Requirements Document, personas, user stories per actor, NFRs
- [10-sow-refresh.md](my-venture/docs/03-specification/10-sow-refresh.md) — Delta v1.1 over `sow-v1.md` (locked decisions, KSA elevation, MSA template, killer assumptions)
- [11-srs.md](my-venture/docs/03-specification/11-srs.md) — Software Requirements Specification (IEEE 830 adapted), FR + NFR + IR with traceability
- [12-use-case-diagrams.md](my-venture/docs/03-specification/12-use-case-diagrams.md) — UML use cases, Mermaid diagrams, detailed UC specs

**Design cluster** ([`my-venture/docs/04-design/`](my-venture/docs/04-design/)):
- [13-user-journey-map.md](my-venture/docs/04-design/13-user-journey-map.md) — Anchor / merchant / consumer / ops / counsel journeys with metrics, moments-of-truth
- [14-flow-diagrams.md](my-venture/docs/04-design/14-flow-diagrams.md) — User / business-logic / data / integration / error flows in Mermaid

These files are SCAFFOLD on first use — Aref guides the user through discovery (`/aref-discover`) and design sessions to fill them in. **As of 2026-05-06, the project documentation suite (14 docs across 4 clusters) is drafted from the Discovery + Vision + Spec + Design exercise.**

---

## Tier 2 — `playbooks/` (reusable templates)

Applicable templates the user can adapt for their venture. Independent of any single comparable.

| File | Purpose |
|---|---|
| [playbooks/anchor-sales-playbook.md](playbooks/anchor-sales-playbook.md) | Discovery → MOU → MSA → integration → go-live for anchor enterprise clients. |
| [playbooks/merchant-onboarding-playbook.md](playbooks/merchant-onboarding-playbook.md) | Pipeline → KYC → contract → integration → activation for merchant network. |
| [playbooks/mdr-design-framework.md](playbooks/mdr-design-framework.md) | How to set MDR, cashback rate, settlement timing, take rate per merchant tier. |
| [playbooks/regulatory-navigation.md](playbooks/regulatory-navigation.md) | Decision tree: do you need a licence? Operate via PSP? Engage which regulator? |
| [playbooks/cashback-economics.md](playbooks/cashback-economics.md) | Earn/burn ratios, breakage, liability, sensitivity tables. |
| [playbooks/cohort-retention-playbook.md](playbooks/cohort-retention-playbook.md) | How to instrument and read cohort retention from day-0. |

These are SCAFFOLD on first use — Aref builds them in collaboration with the user as questions surface.

---

## Tier 3 — `reference/` (independent benchmark + frameworks + regulation)

Material independent of any single venture. Used as benchmarks, framework references, and regulatory primers.

### Reference frameworks (`reference/frameworks/`)

| File | Topic |
|---|---|
| [reference/frameworks/rfm.md](reference/frameworks/rfm.md) | RFM segmentation (Recency / Frequency / Monetary) |
| [reference/frameworks/ltv-cac.md](reference/frameworks/ltv-cac.md) | Lifetime value vs customer acquisition cost |
| [reference/frameworks/cohort.md](reference/frameworks/cohort.md) | Cohort retention analysis |
| [reference/frameworks/churn.md](reference/frameworks/churn.md) | Churn definitions and root-cause framework |
| [reference/frameworks/nps.md](reference/frameworks/nps.md) | NPS — what it does and doesn't tell you |
| [reference/frameworks/gamification.md](reference/frameworks/gamification.md) | Game mechanics in loyalty (points, tiers, badges, streaks) |
| [reference/frameworks/tier-design.md](reference/frameworks/tier-design.md) | Designing loyalty tiers (Bronze→Platinum, status, decay) |
| [reference/frameworks/reward-economics.md](reference/frameworks/reward-economics.md) | Earn/burn ratios, breakage, liability accounting |
| [reference/frameworks/redemption-design.md](reference/frameworks/redemption-design.md) | Burn UX, friction, fraud, partner liability |

### Reference domain primers (`reference/domains/`)

| File | Topic |
|---|---|
| [reference/domains/loyalty-economics.md](reference/domains/loyalty-economics.md) | Unit economics of loyalty programs |
| [reference/domains/embedded-fintech.md](reference/domains/embedded-fintech.md) | B2B2C cashback, payment rails, settlement |
| [reference/domains/enterprise-gtm.md](reference/domains/enterprise-gtm.md) | 9-month enterprise sales, MSAs, anchor land-and-expand |
| [reference/domains/merchant-ops.md](reference/domains/merchant-ops.md) | Merchant onboarding, support, cost-to-serve |
| [reference/domains/data-personalisation.md](reference/domains/data-personalisation.md) | First-party data, consent, segmentation, ML personalisation |
| [reference/domains/mena-sme-merchant-economics.md](reference/domains/mena-sme-merchant-economics.md) | UAE/KSA SME marketing budgets, MDR-share willingness, comparable-mechanic benchmarks (Talabat, Entertainer, MAF SHARE) — input to Killer Assumption #1 |

### Reference regulatory primers (`reference/regulatory/`)

| File | Topic |
|---|---|
| [reference/regulatory/cbuae-svf.md](reference/regulatory/cbuae-svf.md) | UAE CBUAE Stored Value Facilities |
| [reference/regulatory/cbuae-rps.md](reference/regulatory/cbuae-rps.md) | UAE CBUAE Retail Payment Services |
| [reference/regulatory/ksa-sama.md](reference/regulatory/ksa-sama.md) | KSA SAMA payment regulations |
| [reference/regulatory/egypt-cbe.md](reference/regulatory/egypt-cbe.md) | Egypt CBE payment systems law |
| [reference/regulatory/open-finance-mena.md](reference/regulatory/open-finance-mena.md) | UAE / KSA open finance & open banking |
| [reference/regulatory/kyc-aml.md](reference/regulatory/kyc-aml.md) | KYC / AML in MENA loyalty / cashback |
| [reference/regulatory/uae-psp-candidates.md](reference/regulatory/uae-psp-candidates.md) | CBUAE-licensed PSP candidates outside Network International (Magnati, Checkout.com, PayTabs, Telr, Stripe, Geidea KSA-primary) |

### Reference comparables (`reference/comparables/`)

| File | Company | Tier |
|---|---|---|
| [reference/comparables/bilt.md](reference/comparables/bilt.md) | Bilt Rewards (US) | Indirect |
| [reference/comparables/rakuten.md](reference/comparables/rakuten.md) | Rakuten (Japan / global) | Indirect |
| [reference/comparables/entertainer.md](reference/comparables/entertainer.md) | The Entertainer (UAE) | Indirect |
| [reference/comparables/collinson.md](reference/comparables/collinson.md) | Collinson Group / Priority Pass (UK / global) | Indirect |
| [reference/comparables/sprive.md](reference/comparables/sprive.md) | Sprive (UK) | Substitute |
| [reference/comparables/priohub.md](reference/comparables/priohub.md) | PrioHub (Emirates Group JV) | n/a (supply partner) |
| [reference/comparables/paypal-honey.md](reference/comparables/paypal-honey.md) | PayPal Honey (US / global) | Substitute |
| [reference/comparables/mena-competitors.md](reference/comparables/mena-competitors.md) | MENA Competitors — e& Smiles, Careem, stc Qitaf, MAF SHARE, Noon, ADNOC | multiple (per-entity) |
| [reference/comparables/uae-bank-loyalty.md](reference/comparables/uae-bank-loyalty.md) | UAE Bank Loyalty — Mashreq Vantage/Salaam, FAB Rewards, ADCB TouchPoints, Emirates NBD Skywards, RAKBank, ADIB × Etihad Guest | Indirect |
| [reference/comparables/ksa-bank-loyalty.md](reference/comparables/ksa-bank-loyalty.md) | KSA Bank Loyalty — Al Rajhi Mokafaa, SNB LAK, SAB ICSAB+, Riyad Hassad, Alinma akthr | Indirect |
| [reference/comparables/red-operator-loyalty.md](reference/comparables/red-operator-loyalty.md) | RED Operator Loyalty — Aldar Darna, Emaar U by Emaar, Sobha ONE, ROSHN Living, NEOM, Diriyah, Red Sea Global | Indirect |

### Reference case studies (`reference/case-studies/`)

| Case | Files | Why studied |
|---|---|---|
| [reference/case-studies/amos/](reference/case-studies/amos/) | 8 files: company-overview, damac-deal, pipeline, tech-stack, regulatory-clearance, merchant-network, ai-support-economics, seed-round | UAE/GCC merchant-funded loyalty operator. Studied for its anchor strategy (DAMAC), regulatory clearance via NI/CBUAE, AI cost-to-serve disruption, and seed valuation comp. **Not the user's own venture.** |

---

## `decisions/` — the user's structured decision log

Every major decision the user makes is logged here with: question, options considered, verdict, reasoning, related KB references, status (open / locked / revised). Aref reads these to maintain continuity across sessions and detect contradictions with prior decisions.

Filename pattern: `decisions/<YYYY-MM-DD>-<slug>.md`.

---

## `digests/` — generated market intelligence

Generated by `/aref-refresh` and the weekly schedule. Filenames `weekly-digest-YYYY-MM-DD.md` and `comp-refresh-YYYY-MM-DD.md`.
