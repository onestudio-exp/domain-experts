---
title: Fekri Knowledge Index
last_updated: 2026-05-14
---

# Fekri Knowledge Base Index

This is the master index of canonical, human-curated knowledge for Fekri — the plugin-default KB that travels with the agent into any venture deployment.

```
fekri-knowledge/
├── playbooks/            ← reusable templates the user adapts per venture
├── reference/
│   ├── curriculum/       ← Iraqi G6-G12 by track + Wazari structure
│   ├── pedagogy/         ← Iraqi classroom realities + comparative pedagogy
│   ├── personas/         ← expandable detail on the six personas + uncovered segments
│   └── comparables/      ← Noon, Almentor, Edraak, Madrasa.org, Khan Arabic, Iraqi MoE portal
├── decisions/            ← structured decision log
├── glossary.md           ← Iraqi education vocabulary
├── sources.md            ← canonical source registry
└── INDEX.md              ← this file
```

A separate **Tier 1** (`my-venture/`) lives in the consuming project's KB at `.claude/agents/fekri-knowledge/my-venture/` and is authored by the venture team — it is **not** shipped with the plugin.

---

## `playbooks/` — reusable templates

| File | Purpose | Status |
|---|---|---|
| `playbooks/persona-mapping.md` | How to map any design or decision against the six personas; declare served/hurt/neutral. | scaffold |
| `playbooks/pedagogical-review.md` | Reviewing content or UX for fit to Iraqi pedagogy (rote vs active learning, scaffolding, repetition). | scaffold |
| `playbooks/wazari-prep-audit.md` | Auditing exam-prep features against Stance 7 (patterns are a double-edged sword). | scaffold |
| `playbooks/content-tone-calibration.md` | Tone, vocabulary, dialect register for Iraqi K-12 audiences. | scaffold |
| `playbooks/role-detection-response.md` | Detecting PM/UX/Content/Architect role from context and applying the right Output Contract. | scaffold |
| `playbooks/connectivity-tolerant-design.md` | Designing for the Iraqi electricity/internet reality (Stance 6). | scaffold |

Playbooks are SCAFFOLD on first use — Fekri builds them in collaboration with the user as questions surface.

---

## `reference/curriculum/`

| File | Topic | Status |
|---|---|---|
| `reference/curriculum/g6-g9-overview.md` | Intermediate stage (متوسط) — subjects, scope, transition pressure. | scaffold |
| `reference/curriculum/g10-g12-scientific.md` | علمي track G10-G12: math, physics, chemistry, biology emphasis. | scaffold |
| `reference/curriculum/g10-g12-literary.md` | ادبي track G10-G12: Arabic, English, social studies, philosophy. | scaffold |
| `reference/curriculum/g10-g12-applied.md` | تطبيقي track G10-G12: more recently introduced; positioning. | scaffold |
| `reference/curriculum/g10-g12-vocational.md` | مهني track G10-G12: technical/trade specializations; social perception. | scaffold |
| `reference/curriculum/wazari-structure.md` | Wazari (ministerial) examination — structure, scoring, pressure points, pattern history. | scaffold |
| `reference/curriculum/ministerial-changes.md` | Trajectory of curriculum reform; what's changed in the last decade. | scaffold |

## `reference/pedagogy/`

| File | Topic | Status |
|---|---|---|
| `reference/pedagogy/iraqi-classroom-reality.md` | What classroom teaching actually looks like in Iraq — rote, memorization, teacher authority, scaffolding gaps. | scaffold |
| `reference/pedagogy/comparative-gulf.md` | Comparison with KSA, UAE, Qatar systems — what differs in pressure, tracking, exam design. | scaffold |
| `reference/pedagogy/comparative-malaysia.md` | Malaysia's exploration-track / gap-year model as one approach to Stance 5. | scaffold |
| `reference/pedagogy/active-vs-passive.md` | When active learning works in Iraqi context, when it backfires. | scaffold |
| `reference/pedagogy/teacher-time-economics.md` | The 5-minute-budget reality (Stance 10) — what teachers can actually adopt. | scaffold |

## `reference/personas/`

The six personas live inline in `fekri.md`. This directory holds *expansions* and *sub-segments* — religious minorities, students with disabilities, rural / displaced / diaspora students who don't fit the six core personas.

| File | Topic | Status |
|---|---|---|
| `reference/personas/uncovered-segments.md` | What the six personas don't cover; how to flag those segments honestly. | scaffold |
| `reference/personas/iraqi-teacher-personas.md` | Teacher personas (the under-paid majority vs the academic minority); parallels the student model. | scaffold |

## `reference/comparables/`

| File | Operator | Notes |
|---|---|---|
| `reference/comparables/noon-academy.md` | Noon Academy (KSA, expanded to Iraq) | Marketplace-class regional scale player. |
| `reference/comparables/almentor.md` | Almentor (Egypt, regional) | Adult learning + K-12 supplementary. |
| `reference/comparables/edraak.md` | Edraak (Jordan / Queen Rania Foundation) | Free Arabic MOOC + K-12. |
| `reference/comparables/madrasa-org.md` | Madrasa.org (UAE / MBR Foundation) | Free Arabic STEM K-12. |
| `reference/comparables/khan-academy-arabic.md` | Khan Academy Arabic | Global model adapted; benchmark. |
| `reference/comparables/iraq-moe-portal.md` | Iraqi Ministry of Education e-learning portal | Public sector, scale + reach, weak product. |
| `reference/comparables/wazari-prep-iraq.md` | Iraqi-native Wazari-prep platforms | Local-only, varying quality. |

Each profile must declare a `Last verified:` date for specific feature/pricing claims.

---

## `decisions/`

Every major decision logged here with: question, options considered, verdict, reasoning, KB references, status. Filename: `decisions/<YYYY-MM-DD>-<slug>.md`.

Shipped empty as plugin default; consuming projects accumulate their own decision history.
