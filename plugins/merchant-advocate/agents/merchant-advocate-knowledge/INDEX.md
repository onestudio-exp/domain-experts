---
title: Merchant Advocate Knowledge Index
last_updated: 2026-05-14
---

# Merchant Advocate Knowledge Base Index

Plugin-default KB for Merchant Advocate. Travels with the agent into any deployment.

```
merchant-advocate-knowledge/
├── frameworks/          ← UX heuristics (Krug, Nielsen, JTBD, Mom Test, AARRR)
├── cultural-context/    ← MENA / KSA shopping habits, dialect, payment, calendar
├── persona-library/     ← merchant persona archetypes (أم سارة, أبو فهد, محمد, ...)
├── anti-patterns/       ← MENA merchant-UX failure catalog
├── decisions/           ← structured decision log
└── INDEX.md             ← this file
```

## `frameworks/` — cite-ready UX heuristics

| File | Topic | Status |
|---|---|---|
| `frameworks/krug-5-second-test.md` | Steve Krug — 5-second test | scaffold |
| `frameworks/nielsen-10-heuristics.md` | Jakob Nielsen — 10 usability heuristics | scaffold |
| `frameworks/jtbd.md` | Jobs To Be Done framework | scaffold |
| `frameworks/mom-test.md` | The Mom Test (Rob Fitzpatrick) | scaffold |
| `frameworks/aarrr.md` | AARRR (Acquisition → Activation → Retention → Referral → Revenue) | scaffold |

## `cultural-context/` — MENA / KSA shopping reality

| File | Topic | Status |
|---|---|---|
| `cultural-context/ksa-shopping-habits.md` | Payment channels, delivery norms, mobile-first reality | scaffold |
| `cultural-context/dialect-register.md` | Najdi vs Hijazi vs Khaleeji vs MSA copy choices | scaffold |
| `cultural-context/calendar-aware-flows.md` | Hijri / Gregorian, Ramadan / Hajj / Eid impact on merchant flows | scaffold |
| `cultural-context/channel-expectations.md` | WhatsApp / Instagram / TikTok as primary merchant channels | scaffold |

## `persona-library/`

| File | Persona | Status |
|---|---|---|
| `persona-library/um-sara.md` | أم سارة — abaya/modest fashion, Instagram + dashboard | scaffold |
| `persona-library/abu-fahd.md` | أبو فهد — household goods, 200 orders/month, platform-migrator | scaffold |
| `persona-library/mohammed.md` | محمد — perfumes, TikTok ads, ROI-only | scaffold |
| `persona-library/sharikat-tamwinaat.md` | شركة تموينات — small grocery, employee operator, low-confidence | scaffold |
| `persona-library/noura.md` | نورة — home bakery, mobile-only, 10 min/day | scaffold |

## `anti-patterns/`

| File | Topic | Status |
|---|---|---|
| `anti-patterns/jargon-disguised-as-plain-language.md` | "Block", "Trigger", "Segment" used as if everyday Arabic | scaffold |
| `anti-patterns/defaults-that-decide-for-the-user.md` | Pre-selected radios, hidden empty states | scaffold |
| `anti-patterns/save-with-no-feedback.md` | Submit / Save with no confirmation, no "what happens next" | scaffold |
| `anti-patterns/translation-without-localization.md` | Literal EN→AR translation that doesn't read like Saudi speech | scaffold |

## `decisions/`

Plugin default empty; consuming projects accumulate their own.
