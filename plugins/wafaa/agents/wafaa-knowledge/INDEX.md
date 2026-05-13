---
title: Wafaa Knowledge Index
last_updated: 2026-05-14
---

# Wafaa Knowledge Base Index

This is the master index of canonical, human-curated knowledge for Wafaa. It is the plugin-default KB — the category-level substrate that travels with the agent into any venture deployment.

The KB is organised in two layers:

```
wafaa-knowledge/
├── playbooks/          ← reusable templates the user adapts per venture
├── reference/          ← independent benchmark + regulatory + framework material
│   ├── regulatory/     ← PDPL, ZATCA, Nazaha, FCPA, UK Bribery Act, UAE 31/2021
│   ├── frameworks/     ← governance-vs-marketplace, GAP, recipient experience
│   └── comparables/    ← Sendoso, Reachdesk, Loop & Tie, Postal, Alyce, Snappy, Entertainer, regional GCC
├── decisions/          ← structured decision log
├── glossary.md         ← domain terminology
├── sources.md          ← canonical source registry with retrieval dates
└── INDEX.md            ← this file
```

A separate **Tier 1** (`my-venture/`) lives in the consuming project's KB at `.claude/agents/wafaa-knowledge/my-venture/` and is authored by the venture team — it is **not** shipped with the plugin.

---

## `playbooks/` — reusable templates

Applicable templates the user can adapt for their corporate-gifting venture. Independent of any single comparable.

| File | Purpose | Status |
|---|---|---|
| `playbooks/gap-design.md` | Designing the Gift Acceptance Profile: recipient eligibility, per-recipient caps, decline-gracefully workflows, audit trail. | scaffold |
| `playbooks/anchor-onboarding.md` | Compliance-led GTM: getting the Compliance + Finance + IT trio aligned before procurement signs. | scaffold |
| `playbooks/recipient-experience.md` | Multi-channel delivery, name + dialect correctness, low-friction redemption, decline-gracefully UX. | scaffold |
| `playbooks/anti-bribery-audit.md` | Self-audit playbook for FCPA / Nazaha / UAE 31/2021 readiness. | scaffold |
| `playbooks/vendor-neutrality-positioning.md` | How to position a governance platform when competitors are marketplace-class. | scaffold |
| `playbooks/hijri-aware-scheduling.md` | Mapping Hijri events (Ramadan, Eid, National Days, Hajj, Mawlid) to gifting cadence. | scaffold |

Playbooks are SCAFFOLD on first use — Wafaa builds them in collaboration with the user as questions surface.

---

## `reference/regulatory/` — regulatory primers

| File | Topic | Status |
|---|---|---|
| `reference/regulatory/ksa-pdpl.md` | KSA Personal Data Protection Law — data residency, lawful basis, cross-border. | scaffold |
| `reference/regulatory/uae-pdpl.md` | UAE Federal PDPL — applicability, breach notification, DPO requirements. | scaffold |
| `reference/regulatory/zatca-phase2.md` | ZATCA Phase 2 e-invoicing (KSA) — FATOORA integration, taxpayer thresholds. | scaffold |
| `reference/regulatory/nazaha.md` | KSA Anti-Bribery Law (Nazaha) — public-official rules, declaration workflows, gift register. | scaffold |
| `reference/regulatory/uae-31-2021.md` | UAE Federal Decree-Law 31/2021 (anti-bribery) — applicability to commercial entities. | scaffold |
| `reference/regulatory/fcpa.md` | US Foreign Corrupt Practices Act — extra-territorial reach, books-and-records, anti-bribery provisions. | scaffold |
| `reference/regulatory/uk-bribery-act.md` | UK Bribery Act 2010 — corporate offence (s.7), adequate procedures defence. | scaffold |

---

## `reference/frameworks/` — domain frameworks

| File | Topic | Status |
|---|---|---|
| `reference/frameworks/governance-vs-marketplace.md` | Why governance compounds and marketplaces cap; how to position. | scaffold |
| `reference/frameworks/gap-mental-model.md` | Gift Acceptance Profile — the receiving-side moat explained. | scaffold |
| `reference/frameworks/per-recipient-caps.md` | Designing per-recipient caps by role (public official, executive, vendor partner). | scaffold |
| `reference/frameworks/recipient-experience-patterns.md` | Decline-gracefully, multi-channel delivery, redemption-friction. | scaffold |
| `reference/frameworks/dialect-register.md` | Najdi / Hijazi / Khaleeji dialect choices for recipient-experience copy. | scaffold |
| `reference/frameworks/hijri-gifting-calendar.md` | Ramadan, Eid Al-Fitr, Eid Al-Adha, KSA + UAE National Days, Hajj/Umrah, Mawlid. | scaffold |

---

## `reference/comparables/` — competitor profiles

| File | Company | Classification |
|---|---|---|
| `reference/comparables/sendoso.md` | Sendoso (US) | Marketplace-class |
| `reference/comparables/reachdesk.md` | Reachdesk (US/UK) | Marketplace-class |
| `reference/comparables/loop-and-tie.md` | Loop & Tie (US) | Marketplace-class |
| `reference/comparables/postal.md` | Postal (US) | Marketplace-class |
| `reference/comparables/alyce.md` | Alyce (US) | Marketplace-class |
| `reference/comparables/snappy.md` | Snappy (US) | Marketplace-class |
| `reference/comparables/entertainer.md` | The Entertainer (UAE) | Adjacent category (coalition rewards) |
| `reference/comparables/gcc-regional-houses.md` | Regional GCC gifting houses | Marketplace-class (supply-side incumbents) |

Each profile must declare a `Last verified:` date for specific feature/pricing claims.

---

## `decisions/`

Every major decision logged here with: question, options considered, verdict, reasoning, KB references, status. Filename: `decisions/<YYYY-MM-DD>-<slug>.md`.

This is shipped empty as plugin default; consuming projects accumulate their own decision history.
