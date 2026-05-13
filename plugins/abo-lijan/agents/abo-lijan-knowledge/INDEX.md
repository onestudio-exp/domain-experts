---
title: Abo Lijan Knowledge Index
last_updated: 2026-05-14
---

# Abo Lijan Knowledge Base Index

```
abo-lijan-knowledge/
├── playbooks/          ← decision-desk runbook, polling-methodology audit, integrity detection
├── reference/
│   ├── regulatory/     ← FEC, OFCOM, GDPR, MENA election commissions
│   ├── frameworks/     ← AAPOR, ESOMAR, BPC, IFES BRIDGE, IDEA Electoral System Design
│   └── comparables/    ← NGP VAN, Catalist, L2, Edison, DDHQ, BlueLabs, Aristotle, Nationbuilder
├── decisions/
├── watch.md            ← active watchlist (time-sensitive items)
├── verified-facts.md   ← cache of verified facts with decay tags
├── glossary.md
├── sources.md
└── INDEX.md
```

## `playbooks/`

| File | Purpose | Status |
|---|---|---|
| `playbooks/decision-desk-runbook.md` | Election-night decision-desk operational runbook (the 12-section playbook ported from source) | scaffold |
| `playbooks/polling-methodology-audit.md` | Auditing a poll's sample/mode/weighting/disclosure | scaffold |
| `playbooks/integrity-anomaly-detection.md` | Benford analysis, ecological inference, regression residuals | scaffold |
| `playbooks/regulatory-applicability-check.md` | Mapping a regulation to a specific (geography, segment) workflow | scaffold |
| `playbooks/kb-maintenance.md` | Self-maintenance protocol — quarterly audit, freshness classification | scaffold |

## `reference/regulatory/`

| File | Topic | Status |
|---|---|---|
| `reference/regulatory/fec.md` | US Federal Election Commission | scaffold |
| `reference/regulatory/ofcom-uk.md` | UK Office of Communications — broadcast embargo, exit-poll restrictions | scaffold |
| `reference/regulatory/gdpr-political-data.md` | GDPR Article 9 special-category data; political opinion processing | scaffold |
| `reference/regulatory/mena-election-commissions.md` | HEC Egypt, ISIE Tunisia, IHEC Iraq, others | scaffold |
| `reference/regulatory/eu-dsa.md` | EU Digital Services Act on disinformation / election integrity | scaffold |
| `reference/regulatory/exit-poll-blackouts.md` | Per-jurisdiction blackout windows | scaffold |

## `reference/frameworks/`

| File | Topic | Status |
|---|---|---|
| `reference/frameworks/aapor-standards.md` | AAPOR Code + Standards 1-3 + Transparency Initiative | scaffold |
| `reference/frameworks/esomar.md` | ESOMAR International Code on Market, Opinion and Social Research | scaffold |
| `reference/frameworks/bpc-rules.md` | British Polling Council Rules of Disclosure | scaffold |
| `reference/frameworks/ncpp-disclosure.md` | National Council on Public Polls principles | scaffold |
| `reference/frameworks/wapor-code.md` | World Association for Public Opinion Research | scaffold |
| `reference/frameworks/ifes-bridge.md` | IFES BRIDGE election administration competencies | scaffold |
| `reference/frameworks/idea-electoral-system-design.md` | International IDEA Handbook on electoral system design | scaffold |
| `reference/frameworks/decision-desk-thresholds.md` | Vote-share gap × outstanding vote × precinct mix | scaffold |
| `reference/frameworks/ecological-inference.md` | Gary King's framework + applications | scaffold |

## `reference/comparables/`

| File | Platform / Provider | Notes |
|---|---|---|
| `reference/comparables/ngp-van.md` | NGP VAN | Voter-file / campaign management |
| `reference/comparables/catalist.md` | Catalist | Voter-file provider |
| `reference/comparables/l2-political.md` | L2 Political | Voter-file provider |
| `reference/comparables/cmag.md` | CMAG / AdImpact | Political ad tracking |
| `reference/comparables/edison-research.md` | Edison Research | Exit polls + race calls |
| `reference/comparables/decision-desk-hq.md` | Decision Desk HQ | Independent race-call infrastructure |
| `reference/comparables/ap-decision-desk.md` | AP Decision Desk | Wire-service race calls |
| `reference/comparables/politico-pro.md` | Politico Pro | Political-intelligence subscription |
| `reference/comparables/fivethirtyeight.md` | FiveThirtyEight | Polling aggregation + analysis |
| `reference/comparables/cision.md` | Cision | Earned-media tracking |
| `reference/comparables/bluelabs.md` | BlueLabs | Political data science consultancy |
| `reference/comparables/nationbuilder.md` | NationBuilder | Campaign management |
| `reference/comparables/aristotle.md` | Aristotle | Campaign management + compliance |

## `watch.md` and `verified-facts.md`

These two files are part of Abo Lijan's source-of-truth discipline (see agent file §Time-decay). The plugin ships them empty; consuming projects populate as facts are verified and items are flagged for monitoring.

## `decisions/`

Plugin default empty.
