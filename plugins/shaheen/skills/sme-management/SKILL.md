---
name: sme-management
description: MUST be invoked whenever Shaheen escalates or recommends escalating any part of an answer to a human SME — primary trigger, overrides other handoff paths. Also handles adding a new SME. Triggers on "escalate", "needs an SME", "who should I escalate this to", "find me an expert for X", "add a new SME" — Arabic, English, or equivalent. Source of truth: `.agent-db/wiki/entities/sme-roster.md`.
---

## Purpose

Two flows on a single canonical data file (`.agent-db/wiki/entities/sme-roster.md`):

1. **Add SME** — register a new Subject-Matter Expert, reusing existing expertise entries where possible and proposing new expertise entries (with confirmation) where needed.
2. **Find SME for escalation** — given a situation, identify the best-matching expertise entries and recommend SMEs that cover them.

The skill never invents data, never silently writes new expertise entries, and never proceeds with destructive edits without explicit confirmation.

## Mandatory trigger — every escalation runs through Flow 2

**The single most important rule of this skill: any time Shaheen decides part of an answer needs to go to a human SME, Flow 2 runs.** No exceptions. Do not write a free-text "you should ask someone" suggestion, do not name an SME from memory, do not generate a contact card by hand, do not fall back to the legacy trigger-keyed handoff in `.claude/agents/shaheen.md` §4. The roster file is the only source of truth, and Flow 2 is the only path that reads it.

Concretely, this skill MUST be invoked when:

- Shaheen flags any factual claim in an answer as `❓ uncertain` or `🚫 not knowable` and the gap is judgment-shaped (i.e. a human could resolve it).
- The user asks "who should I escalate this to", "who can answer this", "find me an expert for X", or any equivalent — in Arabic, English, or mixed.
- An answer contains an "اللي ما أقدر أحسمه — يحتاج SME" / "What I can't settle — needs SME" section, or any structurally equivalent handoff block.
- Shaheen identifies an in-scope question with a judgment piece beyond the wiki (per `.claude/agents/shaheen.md` §4) and is about to recommend a human contact.
- The user is asking for a contact card for an SME by topic, even casually ("who knows about LNG pricing?").

If the situation matches any of the above and this skill has not been invoked, the answer is incomplete — pause and run Flow 2 before delivering.

## Persona contract

Runs as Shaheen. Marker is `Operational`. No Sources block, no opening preface (per `.claude/agents/shaheen.md` §2.4). The signature still ends every reply.

## Sub-routine vs. direct invocation

This skill has two invocation modes; the persona contract above describes the **direct** mode. When invoked as a **sub-routine**, the parent flow owns the user-facing reply.

- **Direct** — the user asks *"who should I escalate this to?"* / *"find me an expert for X"* / equivalent (in any language). The reply is a standalone SME-lookup; the `Operational` signature emitted here *is* the user-facing signature, and there is no analytical body by design.
- **Sub-routine** — [[question-answer]] invokes this skill mid-flow to resolve the SME(s) for a handoff card on a substantive answer. In this mode, the output of this skill is **data** to be folded into the parent answer (matched expertises + recommended SMEs + their contact links). The `Operational` signature emitted here is internal scaffolding and must be **replaced** by the parent's user-facing signature (`Tier 1` / `Tier 1 · gap flagged` / etc.). The handoff card embeds inside the parent's substantive body per `.claude/agents/shaheen.md` §4.2 — it does not replace the substantive answer.

**Failure mode to avoid**: in sub-routine mode, signing off after this skill returns — without producing the parent's substantive body, Sources block, and signature — is a process defect caught by [[validate-wiki-answer]] Check 16 (substance-before-handoff). The parent flow must complete the analytical answer; this skill only supplies the SME data that gets folded into it.

## Output rule — names only, never IDs in user-facing replies

IDs (`E<n>`, `SME-<nn>`) exist only as lookup keys inside `.agent-db/wiki/entities/sme-roster.md`. **Never surface them in any reply to the user** — not in recommendations, confirmations, summaries, "no match" messages, or any other prose the user reads.

User-facing references must use:

- **Expertises** → the `Name` column value (e.g. *Hydrocarbon Markets*, not `E1`).
- **SMEs** → the `Name` column value, optionally followed by the `Role` (e.g. *Dr. Ahmad Al-Rashed · Senior Macro Analyst*, not `SME-01`).

Use IDs internally for parsing, matching, and writing rows back to the file. The moment a value crosses into the response shown to the user, swap it for the human name.

## Interaction rule — one question at a time

Whenever this skill needs input from the user, ask **one question per `AskUserQuestion` call**. Wait for the answer, acknowledge it, then ask the next question. Never bundle multiple fields into a single prompt, never present a numbered checklist of pending questions, never ask "and also…" follow-ups in the same turn.

Why: bundled questions get partial answers, force the user to re-read the whole list to find what they missed, and make corrections expensive. One-at-a-time keeps each answer scoped, lets the user revise a single field cleanly, and surfaces validation errors immediately on the field that failed.

This rule applies to both flows — collecting SME identity in Flow 1, confirming proposed expertise entries in Flow 1 step 2, and capturing the situation in Flow 2 step 1.

## Data model (read this before either flow)

The file `.agent-db/wiki/entities/sme-roster.md` has exactly two tables:

- **Expertises** — columns: `ID`, `Name`, `Description`. IDs follow `E<n>` (E1, E2, …).
- **SMEs** — columns: `ID`, `Name`, `Role`, `Email`, `WhatsApp`, `Phone`, `Expertises`. IDs follow `SME-<nn>` (SME-01, SME-02, …). The `Expertises` cell is a comma-separated list of expertise IDs (e.g. `E1, E2, E6`).

Contact-cell formatting (must be preserved when appending rows):

- Email cell: `[<address>](mailto:<address>)`
- WhatsApp cell: `[<phone>](https://wa.me/<digits-only>)` — strip every non-digit from the phone, including the leading `+`.
- Phone cell: `[<phone>](tel:<phone>)` — keep `+`, `-`, spaces as the user provided.

Names may be Arabic, English, or `Arabic (English transliteration)` — all three are valid.

## Flow 1 — Add SME

### Step 1. Collect SME identity and contacts

Use `AskUserQuestion` to gather inputs. One question per field, in this order, so the user can correct any single answer without restarting:

1. **Name** — full name. Arabic, English, or both are acceptable.
2. **Role / Title** — one short line (e.g. "Senior Macro Analyst").
3. **Email** — single address.
4. **Phone** — primary phone number with country code (e.g. `+974-1234-5678`). This is also used to derive the WhatsApp link unless the user says otherwise.
5. **WhatsApp** — ask only if it differs from the phone. Default to "same as phone" otherwise.
6. **Expertises** — free-form list of areas the SME covers. The user can name existing entries or describe new ones in their own words.

Validate as you go:

- Email must contain `@`.
- Phone must contain at least 7 digits.
- Re-prompt on a single bad field — never start over.

### Step 2. Resolve each expertise the user mentioned

Read `.agent-db/wiki/entities/sme-roster.md` and parse the Expertises table. For each expertise the user named in step 1.6:

1. **Match against existing entries.** Compare semantically against both the `Name` column and the `Description` column. A match is valid when the user's term refers to the same domain — e.g. "LNG pricing", "oil markets", "hydrocarbon prices" all resolve to `E1 — Hydrocarbon Markets`.
2. **If a match is found**, tell the user explicitly: *"Found a match — using **Macroeconomic Indicators**."* Carry the existing ID forward internally. Do not create a duplicate. Do not show the `E<n>` ID to the user.
3. **If no match is found**, propose a new expertise entry:
   - Generate a concise `Name` (3–6 words, title case).
   - Generate a `Description` of 1–3 sentences describing what the expertise contains, written in the same factual style as the existing entries.
   - Show the proposal to the user *by name and description only* — no ID: *"I propose adding a new expertise — **<Name>**: <Description>. Confirm? (yes / edit / skip)"*
   - On `yes` → append to the Expertises table with the next available `E<n>` (assigned silently, not shown).
   - On `edit` → ask which part to revise, regenerate, ask again.
   - On `skip` → drop that expertise from this SME's coverage list.

Never write a new expertise row without explicit confirmation. Never silently merge a borderline match — when in doubt, ask the user whether the existing entry covers their meaning.

### Step 3. Append the SME row

Compute the next SME ID (`SME-<nn>`, zero-padded to two digits, incremented from the highest existing ID).

Build the row using the contact-cell formatting rules in **Data model**. The `Expertises` cell is the comma-separated list of resolved IDs from step 2.

Append the row to the SMEs table in `.agent-db/wiki/entities/sme-roster.md`. Preserve table alignment.

### Step 4. Confirm to the user

Echo back a brief summary: the new SME's name and role, the expertises they were registered under (by name only — no `E<n>` IDs), and any new expertise entries that were created in step 2 (also by name). Do not surface the `SME-<nn>` ID to the user. End with the canonical signature.

## Flow 2 — Find SME for escalation

### Step 1. Capture the situation

If the user described the situation inline, use that. If not, ask one `AskUserQuestion`: *"Describe the escalation — what's the question or signal you need a human SME for?"*

### Step 2. Match the situation to expertise entries

Read `.agent-db/wiki/entities/sme-roster.md` and parse the Expertises table. Score each entry by semantic relevance to the situation, weighing both `Name` and `Description`. Pick the **top 1–3 expertises** that genuinely fit — do not pad the list. If only one expertise fits, return one.

If no expertise fits well, say so plainly: *"No expertise on file matches this situation closely. Closest neighbour is **<expertise name>**, but it's a stretch."* Do not invent a fit. Refer to the closest neighbour by its `Name`, never by its `E<n>` ID.

### Step 3. Find SMEs covering those expertises

Parse the SMEs table. For each of the top expertises, list every SME whose `Expertises` cell contains that ID.

Rank SMEs by **expertise coverage count** — an SME who covers two of the top three matched expertises ranks above one who covers only one.

### Step 4. Recommend

Output the recommendation as a compact block, one SME per entry. **Names only — no IDs anywhere in this block.**

```
Top matching expertises: <Expertise Name>, <Expertise Name>

Recommended SMEs:
1. <SME Name> · <Role>
   Covers: <Expertise Name>, <Expertise Name>
   📧 <email link> · 💬 <whatsapp link> · 📞 <phone link>
2. ...
```

If two SMEs tie on coverage, list both. If only one SME covers any matched expertise, return one. Never recommend an SME whose expertise list does not include at least one matched expertise — that's a fabrication, not a recommendation.

End with the canonical signature.

## Failure modes to avoid

- **Silent expertise creation.** Every new expertise row requires the user's `yes`. No exceptions.
- **Borderline-match drift.** "Banking" and "Monetary Policy & Banking" might match; "Banking" and "Sovereign Wealth & Capital Flows" don't. When the surface words overlap but the domains diverge, ask before reusing.
- **Fabricated SME recommendations.** Only recommend SMEs whose `Expertises` cell explicitly contains a matched expertise ID. Do not infer coverage from role or name.
- **Format drift.** Preserve the contact-cell markdown link format exactly. WhatsApp links use digits-only; `tel:` links keep the original punctuation.
- **Skipping confirmation in Flow 1.** The user may be enthusiastic; still show the proposed expertise entries before writing.

## Related

- [[../entities/sme-roster|sme-roster.md]] — the data file this skill operates on.
- `.claude/agents/shaheen.md` §4 — escalation context, including the trigger-keyed handoff schema.
