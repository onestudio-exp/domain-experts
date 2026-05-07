---
title: Decisions — structured decision log
last_updated: 2026-05-05
status: empty
---

# `decisions/` — your structured decision log

Every major venture decision the user makes is logged here. Aref reads this before rendering any Verdict-mode answer to:

1. **Maintain continuity** across sessions — Aref doesn't re-derive the same answer twice
2. **Detect contradictions** — if the current question would override a prior decision, Aref surfaces the conflict explicitly
3. **Track status** — open / locked / revised — so the user can audit their own decision trail

## Filename convention

```
decisions/<YYYY-MM-DD>-<short-slug>.md
```

Example: `decisions/2026-05-12-first-anchor-target.md`

## Required structure per decision

```markdown
---
date: YYYY-MM-DD
slug: <short-slug>
status: open | locked | revised
verdict: Proceed | Hold | Reconsider | Reject | Pending
revisits: <date or condition>
---

## Question
<the specific decision being made>

## Options considered
1. <option A> — pro / con / cited evidence
2. <option B> — pro / con / cited evidence
3. <option C> — pro / con / cited evidence

## Verdict
<Proceed / Hold / etc.>

## Why
<reasoning, anchored in cited KB or comparable evidence>

## Conditions to revisit
<explicit triggers that would flip the verdict>

## Related KB
- [knowledge/my-venture/<file>.md]
- [knowledge/reference/<file>.md]
- [vector: <source>, ingested YYYY-MM-DD]

## Updates
| Date | Status change | Why |
|---|---|---|
```

## How decisions get created

- **Manually:** the user writes a decision file directly when they want to lock a call.
- **Via `/aref-decide <question>`:** Aref drives a structured decision session and writes the file at the end (with user confirmation).
- **As output of `/aref-stress`:** the third pass (synthesis) suggests writing the verdict to `decisions/` if it's locking.

## Status

The folder is empty on first session. Decisions accumulate as the venture matures.
