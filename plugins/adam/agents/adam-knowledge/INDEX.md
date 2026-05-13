---
title: Adam Knowledge Index
last_updated: 2026-05-14
---

# Adam Knowledge Base Index

```
adam-knowledge/
├── playbooks/          ← mode-specific procedures, customer-voice, viability scoring
├── reference/
│   ├── frameworks/     ← competitor classification, comparison matrix, gap analysis
│   ├── comparables/    ← Crunchbase, CB Insights, G2, Klue, Kompyte — peer CI systems
│   └── domain-profiles/  ← SaaS / e-commerce / B2B / HR / EdTech lens parameters
├── decisions/          ← structured decision log
├── glossary.md
├── sources.md
└── INDEX.md
```

Note: Adam ships with **agent-side skills** in the source repo (`skills/customer-voice/`, `skills/classify-competitors/`, etc.). In the plugin layout, those skills can be installed alongside as `skills/<name>/` if/when the team chooses to bundle them. For now this plugin ships the agent definition + KB scaffolding.

## `playbooks/`

| File | Purpose | Status |
|---|---|---|
| `playbooks/mode-a-idea-validation.md` | Step-by-step Mode A procedure with viability scoring table | scaffold |
| `playbooks/mode-b-competitor-discovery.md` | Mode B procedure incl. Customer Voice subsection | scaffold |
| `playbooks/mode-c-competitor-monitoring.md` | Mode C procedure for tracking moves over time | scaffold |
| `playbooks/customer-voice-sourcing.md` | Pulling verbatim quotes from G2/Capterra/Trustpilot/Reddit/App Stores | scaffold |
| `playbooks/viability-scoring.md` | Mode A score table (5-criteria viability matrix) | scaffold |
| `playbooks/comparison-matrix-building.md` | Feature × product grid with ✓ / ✗ / ~ | scaffold |
| `playbooks/customer-domain-detection.md` | Identifying the right domain lens to apply | scaffold |

## `reference/frameworks/`

| File | Topic | Status |
|---|---|---|
| `reference/frameworks/competitor-tiering.md` | Direct / Indirect / Substitute definitions + edge cases | scaffold |
| `reference/frameworks/comparison-matrix.md` | Building a feature × product grid that reads at a glance | scaffold |
| `reference/frameworks/gap-analysis.md` | Identifying market gaps from competitor coverage | scaffold |
| `reference/frameworks/recommendation-traceability.md` | Linking every recommendation to a finding | scaffold |
| `reference/frameworks/confidence-vs-inferred-ratio.md` | When ≥30% INFERRED forces a confidence drop | scaffold |

## `reference/comparables/`

| File | Peer | Notes |
|---|---|---|
| `reference/comparables/crunchbase-cbinsights.md` | Crunchbase / CB Insights | Funded-company databases |
| `reference/comparables/g2-capterra-trustpilot.md` | G2 / Capterra / Trustpilot | Review aggregators (Customer Voice source) |
| `reference/comparables/owler-similarweb-sensor-tower.md` | Owler / SimilarWeb / Sensor Tower | Competitive signals |
| `reference/comparables/klue-kompyte-crayon.md` | Klue / Kompyte / Crayon | Sales / marketing enablement tools |
| `reference/comparables/in-house-analyst-teams.md` | In-house analyst teams | Most common substitute |

## `reference/domain-profiles/`

| File | Domain | Status |
|---|---|---|
| `reference/domain-profiles/saas.md` | SaaS — ARR, NRR, PLG, free tier mechanics, expansion revenue | scaffold |
| `reference/domain-profiles/ecommerce.md` | E-commerce — AOV, repeat rate, CAC, channel mix | scaffold |
| `reference/domain-profiles/b2b-sales-gtm.md` | B2B Sales/GTM — sales cycle length, MQL/SQL, ABM | scaffold |
| `reference/domain-profiles/hr-talent.md` | HR & Talent — time-to-hire, candidate experience | scaffold |
| `reference/domain-profiles/edtech.md` | EdTech — engagement, completion rate, learner outcomes | scaffold |
| `reference/domain-profiles/custom-domain.md` | Custom Domain mode — explicit assumptions + confidence drop | scaffold |

## `decisions/`

Plugin default empty.
