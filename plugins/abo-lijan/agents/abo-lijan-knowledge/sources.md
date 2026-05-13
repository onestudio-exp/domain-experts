---
title: Abo Lijan Source Registry
last_updated: 2026-05-14
---

# Source Registry — Elections / Polling / Decision-Desk

Two-source-strict for empirical claims. Single-source acceptable for methodology / standards references.

---

## Tier 1 — Election commissions (primary, jurisdiction-specific)

| Jurisdiction | Authority | URL |
|---|---|---|
| United States | Federal Election Commission (FEC) | fec.gov |
| United Kingdom | Electoral Commission | electoralcommission.org.uk |
| European Union | European Parliament Elections | european-elections.eu |
| Egypt | HEC — Higher Elections Committee | elections.eg |
| Tunisia | ISIE — Instance Supérieure Indépendante pour les Élections | isie.tn |
| Iraq | IHEC — Independent High Electoral Commission | ihec.iq |
| Jordan | JEC — Independent Election Commission | iec.jo |
| Lebanon | Ministry of Interior — General Directorate of Elections | interior.gov.lb |

## Tier 2 — Standards bodies

| Body | URL |
|---|---|
| AAPOR (American Association for Public Opinion Research) | aapor.org |
| ESOMAR (European Society for Opinion and Marketing Research) | esomar.org |
| BPC (British Polling Council) | britishpollingcouncil.org |
| NCPP (National Council on Public Polls) | ncpp.org |
| WAPOR (World Association for Public Opinion Research) | wapor.org |
| IFES (International Foundation for Electoral Systems) | ifes.org |
| IDEA (International Institute for Democracy and Electoral Assistance) | idea.int |
| Stanford Internet Observatory | cyber.fsi.stanford.edu/io |

## Tier 3 — Decision-desk / race-call infrastructure

| Provider | URL |
|---|---|
| Associated Press Decision Desk | apnews.com/hub/ap-elections |
| Edison Research (NEP exit polls) | edisonresearch.com |
| Decision Desk HQ | decisiondeskhq.com |

## Tier 4 — Voter-file / political-tech providers (for competitor claims)

| Provider | URL |
|---|---|
| NGP VAN | ngpvan.com |
| Catalist | catalist.us |
| L2 Political | l2-data.com |
| BlueLabs | bluelabs.com |
| Aristotle | aristotle.com |
| NationBuilder | nationbuilder.com |
| CMAG / AdImpact | adimpact.com |
| Cision | cision.com |

## Tier 5 — Analyst / journalistic (corroboration only)

- Politico Pro, Punchbowl News (US political intelligence — subscription).
- FiveThirtyEight, Cook Political Report (US race ratings).
- Reuters, AP, BBC, Al-Jazeera (deal-level reporting; corroborate).
- Academic: Gary King (ecological inference), Andrew Gelman / Jeffrey Lax / Justin Phillips (MRP).

---

## Disagreement protocol

Two sources disagree >25% on a measurable figure:

1. Surface **both** with citations + dates.
2. Tier 1 (election commission) beats Tier 5 (journalism) for official results.
3. Tier 3 (race-call infrastructure) is binding for race-call decisions on election night.

## Staleness — decay categories (see agent file §Time-decay)

- **short** (~30 days) — Cook ratings, race-status, employee counts, current contribution limits.
- **medium** (~90 days) — vendor pricing, market-share estimates, regulatory enforcement patterns.
- **long** (~12 months) — published methodology papers, organizational structures, historical accuracy.
- **permanent** — court decisions, founding dates, completed-election results.

Pre-citation: if the verification window has elapsed, re-verify before citing OR mark `[VERIFIED-AS-OF YYYY-MM-DD — may have changed]`.
