---
title: Ziad Knowledge Index
last_updated: 2026-05-14
---

# Ziad Knowledge Base Index

```
ziad-knowledge/
├── playbooks/          ← dossier preparation, source-credibility audit, sentiment-vs-stance, narrative-drift
├── reference/
│   ├── frameworks/     ← IC probability language, ACH, Red Team, Devil's Advocate (Heuer)
│   ├── sources/        ← 5-tier source registry
│   ├── methods/        ← entity extraction, timeline construction, dossier templates
│   └── comparables/    ← Recorded Future, Dataminr, GDELT, Factal, Janes, Stratfor/RANE, Eurasia, Soufan, ICG
├── decisions/
├── glossary.md
├── sources.md
└── INDEX.md
```

## `playbooks/`

| File | Purpose | Status |
|---|---|---|
| `playbooks/dossier-preparation.md` | 1-pager / 5-pager / 10-pager dossier templates and procedures | scaffold |
| `playbooks/source-credibility-audit.md` | Auditing a claim's source quality before trust | scaffold |
| `playbooks/sentiment-vs-stance.md` | Distinguishing verbal sentiment from political stance | scaffold |
| `playbooks/narrative-drift-tracking.md` | Same fact, divergent framing across outlets / over time | scaffold |
| `playbooks/pressure-test-procedure.md` | Pressure-testing an external analyst's assessment | scaffold |
| `playbooks/timeline-construction.md` | Chronology building from disparate sources with confidence per entry | scaffold |

## `reference/frameworks/`

| File | Topic | Status |
|---|---|---|
| `reference/frameworks/ic-probability-language.md` | Almost certain / Highly likely / Likely / Roughly even / Unlikely / Highly unlikely / Almost no chance | scaffold |
| `reference/frameworks/heuer-ach.md` | Analysis of Competing Hypotheses (Heuer) | scaffold |
| `reference/frameworks/red-team-devils-advocate.md` | Structured contrarian analysis | scaffold |
| `reference/frameworks/key-assumptions-check.md` | Surfacing and challenging key assumptions | scaffold |
| `reference/frameworks/indicators-warnings.md` | Indicator-and-warning analysis | scaffold |

## `reference/sources/`

| File | Tier | Status |
|---|---|---|
| `reference/sources/tier1-primary-official.md` | Government statements, treaty text, official spokespersons, court filings | scaffold |
| `reference/sources/tier2-analyst-grade.md` | RAND, ICG, Eurasia, RUSI, Carnegie, Reuters, AP, Janes | scaffold |
| `reference/sources/tier3-newsroom.md` | BBC, NYT, FT, Reuters, AP, Al-Jazeera, Asharq Al-Awsat | scaffold |
| `reference/sources/tier4-state-affiliated.md` | RT, TASS, Xinhua, IRNA, SPA, WAM | scaffold |
| `reference/sources/tier5-osint-social.md` | Verified social, leaked docs, on-the-ground video (corroborate before trust) | scaffold |

## `reference/methods/`

| File | Topic | Status |
|---|---|---|
| `reference/methods/entity-extraction.md` | People, organizations, places — disambiguation pitfalls | scaffold |
| `reference/methods/sentiment-vs-stance-method.md` | NLP and tradecraft approaches to separate the two | scaffold |
| `reference/methods/timeline-with-confidence.md` | Building chronologies that surface confidence per entry | scaffold |
| `reference/methods/dossier-templates.md` | 1/5/10-pager templates | scaffold |

## `reference/comparables/`

| File | Comparable | Notes |
|---|---|---|
| `reference/comparables/recorded-future.md` | Recorded Future |
| `reference/comparables/dataminr.md` | Dataminr |
| `reference/comparables/gdelt.md` | GDELT (academic / free) |
| `reference/comparables/factal.md` | Factal |
| `reference/comparables/janes.md` | Janes |
| `reference/comparables/stratfor-rane.md` | Stratfor / RANE |
| `reference/comparables/eurasia-group.md` | Eurasia Group |
| `reference/comparables/soufan-icg.md` | Soufan Center / International Crisis Group |
| `reference/comparables/media-monitoring-vendors.md` | Mediarithmics / Cision / Meltwater (broader, less analyst-grade) |
| `reference/comparables/bbc-monitoring-ose.md` | BBC Monitoring / Open Source Enterprise legacy |

## `decisions/`

Plugin default empty; consuming projects accumulate their own.
