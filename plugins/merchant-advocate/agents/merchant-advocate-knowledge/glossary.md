---
title: Merchant Advocate Glossary
last_updated: 2026-05-14
---

# Merchant UX (MENA / KSA) — Glossary

Domain vocabulary used by Merchant Advocate.

## Labels (confidence)

- **`[OBSERVED-IN-CODE]`** — directly read from a file/string/route. Cite `file:line`.
- **`[HEURISTIC-ANCHORED]`** — tied to a named heuristic (Krug, Nielsen, JTBD, Mom Test, AARRR).
- **`[HYPOTHESIS]`** — UX inference; needs user validation before treated as fact.

## Review schema sections

- **🔴 Blockers** — user cannot succeed.
- **🟡 Friction** — user succeeds but suffers.
- **🟢 Wins** — do not regress these.
- **📋 Persona walkthrough** — step-by-step narration as the persona.
- **❓ Open questions for the team** — things that depend on real user data.
- **🚏 Routed elsewhere** — visual / design-system / engineering findings.

## Heuristics shorthand

- **Krug** — Steve Krug, *Don't Make Me Think* (5-second test, scannability).
- **Nielsen 10** — Jakob Nielsen's 10 usability heuristics.
- **JTBD** — Jobs To Be Done.
- **Mom Test** — Rob Fitzpatrick's interviewing framework (avoid leading questions).
- **AARRR** — Acquisition → Activation → Retention → Referral → Revenue (Dave McClure).

## KSA / MENA terms

- **أم سارة / أبو فهد** — illustrative archetype names; nominal persona patterns.
- **Khaleeji / Najdi / Hijazi** — Gulf dialect registers; choice signals KSA-region specificity.
- **MSA** — Modern Standard Arabic; formal but reads cold in merchant UI.
- **مدفوع / مكتمل / قيد المعالجة** — order states; consistency of these labels across screens matters.

## Anti-pattern shorthand

- **Jargon-disguised-as-plain-language** — using English-derived terms ("trigger", "segment", "block") as if they were colloquial Arabic.
- **Defaults that decide for the user** — pre-selected options that aren't neutral.
- **Save with no feedback** — submit / publish / send with no confirmation or verifiable outcome.
- **Translation without localization** — literal EN→AR that doesn't read like Saudi speech.

---

*See `frameworks/` for cite-ready heuristic summaries, `persona-library/` for the merchant archetypes, `anti-patterns/` for the failure catalog.*
