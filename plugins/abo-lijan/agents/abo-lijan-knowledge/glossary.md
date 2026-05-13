---
title: Abo Lijan Glossary
last_updated: 2026-05-14
---

# Elections / Polling / Decision-Desk — Glossary

## Electoral systems

- **FPTP** — First-Past-The-Post (single-member plurality). US House districts, UK constituencies.
- **PR** — Proportional Representation. Most EU parliaments.
- **MMP** — Mixed-Member Proportional. Germany, New Zealand.
- **Two-round** — French presidential model.
- **STV** — Single Transferable Vote. Ireland, Malta, Australian Senate.
- **Caucus** — pre-primary delegate-selection meeting (Iowa, Nevada).
- **Primary** — pre-general candidate-selection election.

## Polling methodology

- **MoE (Margin of Error)** — statistical sampling error band, typically 95% confidence.
- **Design effect** — variance inflation from weighting / clustering.
- **Likely-voter screen** — questions filtering respondents to those likely to vote.
- **MRP** — Multilevel Regression with Post-stratification.
- **Bayesian aggregation** — combining multiple polls with prior beliefs.
- **Sample frame** — universe from which respondents are drawn (RDD, voter file, online panel).
- **Mode** — phone (live / IVR), online, mail, face-to-face.
- **Weighting** — adjusting sample to match population demographics (age, sex, region, party).

## Race-call discipline

- **Decision desk threshold** — vote-share gap × outstanding-vote × precinct-mix combination required to call.
- **Outstanding vote** — votes not yet reported.
- **Precinct mix** — partisan lean of unreported precincts.
- **Patience under pressure** — call only when threshold is met; never call on partial results.

## Integrity & anomaly detection

- **Ecological inference** — inferring individual-level behavior from aggregate data (Gary King).
- **Benford analysis** — first-digit distribution test for data fabrication.
- **Regression residuals** — outliers in expected vs observed turnout / vote share.
- **Turnout outlier** — precinct with implausible turnout relative to demographic / historical baseline.
- **Disinformation pattern** — coordinated inauthentic behavior detection.

## Confidence tags

- **`[VERIFIED]`** — sourced; ≥2 independent credible sources.
- **`[UNVERIFIED]`** — domain knowledge / pattern; not directly sourced.
- **`[NEEDS-RESEARCH]`** — uncertain; offer to research.
- **`[COMPUTED]`** — derived (e.g., MoE calculated from sample size; vote-share-gap computed from reported figures).

## Decay categories (time-decay discipline)

- **`decay: short`** — re-verify every ~30 days (Cook ratings, employee counts, race status).
- **`decay: medium`** — re-verify every ~90 days (vendor pricing, market-share estimates).
- **`decay: long`** — re-verify every ~12 months (methodology papers, organizational structures).
- **`decay: permanent`** — verified once; structural fact (court decisions, completed-election results).

## Regulatory bodies

- **FEC** — US Federal Election Commission (campaign finance).
- **FCC** — US Federal Communications Commission (broadcast).
- **OFCOM** — UK Office of Communications (broadcast embargo, exit-poll publication restrictions).
- **EU DSA** — Digital Services Act (disinformation / election integrity).
- **MENA election commissions** — HEC (Egypt), ISIE (Tunisia), IHEC (Iraq), JEC (Jordan).

## Standards bodies

- **AAPOR** — American Association for Public Opinion Research.
- **ESOMAR** — European Society for Opinion and Marketing Research.
- **BPC** — British Polling Council.
- **NCPP** — National Council on Public Polls (US).
- **WAPOR** — World Association for Public Opinion Research.
- **IFES** — International Foundation for Electoral Systems.
- **IDEA** — International Institute for Democracy and Electoral Assistance.

---

*See `sources.md` for the canonical source registry.*
