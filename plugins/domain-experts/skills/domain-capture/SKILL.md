---
name: domain-capture
description: Capture new evidence-backed knowledge into a domain expert agent in 3 short turns. Skill receives a claim, asks for the source, silently invokes the target agent to surface its current view, surfaces any conflict, picks the destination automatically (KB doc / memory / refused if live-source-class), and writes with citation + dated entry on confirm. Refuses content that should be read live (venture-specific data, source-file excerpts). Use when the agent has gone stale, when new evidence emerges, or when the team wants to teach the agent something new.
---

# /domain-capture

Grow a domain expert agent's knowledge with evidence. **3 turns** for the typical case.

## When to invoke

- Agent's understanding is out of date.
- New regulation / framework / market data has emerged.
- Team made a decision worth preserving across sessions.
- Correction needed (agent's prior view was wrong).
- Lesson from production work worth preserving.

## When NOT to invoke

- For creating an agent → `domain-creator`.
- For evaluating an agent → `domain-eval`.
- For content that lives in source files (a venture's current ARR, code state, dashboard data) → **do not capture**. Point the agent at the live source via `Read/Grep/Glob`. Static snapshots go stale within hours.

## How to run

1. **Aim for 3 turns.** (1) you ask, (2) you give source, (3) you confirm save.
2. **Don't ceremony-up the easy case.** Auto-decide classification + destination silently. Only surface them if there's a real choice to make.
3. **Loud on edge cases.** Conflict with the agent's view, missing source, live-source claims → explicit prompts.
4. **No silent writes.** The user must say `save` (or `keep`) before any file is touched.

## Turn 1 — Intake

User provides (or you ask for) the agent + the claim.

Silently, behind the scenes:

- Resolve agent path. Read frontmatter (memory scope, tools). Check for KB dir.
- Auto-classify the claim into one type:
  ```
  RULE          regulations, methodologies, market data, frameworks
  DECISION      team decisions, evolving thesis
  LESSON        learnings, corrected priors
  LIVE-SOURCE   venture-specific dynamic data → REFUSE
  ```
- If `LIVE-SOURCE`, show:
  > *"This is live-source data. Capturing creates a stale snapshot. Better: add the source path to the agent's live source list. Cancelling capture."*
  Exit.

Otherwise, ask **one question**:

```
**Source for this claim?**

  URL                    https://...
  Quote                  "<quote>" — Title, Author, Date
  Internal               from internal team meeting on YYYY-MM-DD
  Authoritative voice    stated by <person/role> on <date>
  no-source              capture with [UNVERIFIED] tag
```

→ Type a source, or `no-source`.

## Turn 2 — Validate against the agent

Silently invoke the target agent (Agent tool, `subagent_type: <slug>`):

```
"What's your current understanding of this topic? Do you have an existing
 view? Briefly. The user's claim:

 <claim>
 Source: <source>"
```

Compare the response to the claim. Three outcomes:

### ✓ Aligned — agent agrees or has no prior view

Show:

```
✓ Agent's view aligns with the claim.

  Type:        <RULE | DECISION | LESSON>
  Destination: <path>
  Confidence:  <[VERIFIED] | [UNVERIFIED]>

  → save  (or cancel)
```

→ Type `save` or `cancel`.

### ⚠ Conflict — agent disagrees or is skeptical

Show:

```
⚠ Conflict — agent's view differs.

  You said:     <claim, 1 line>
  Agent's view: <2-4 line substantive excerpt of disagreement>

  → keep    save with [UNVERIFIED] tag and a 'user-overridden' note
  → refine  restate the claim more precisely; loop back to Turn 2
  → drop    cancel; agent's view stands
```

→ Type one option.

### ✗ Live-source flagged (caught at Turn 2 if missed earlier)

```
✗ Agent classified this as live-source data — refusing capture.
  Better: add the source path to the agent's live source list.
```

Exit.

## Turn 3 — Save

When the user types `save` or `keep`:

1. Pick destination automatically. State it inline; don't ask.

```
RULE       → <kb_dir>/<subdir>/<topic-slug>.md
              Subdir picked from agent's KB structure (regulations /
              frameworks / market-data / cultural-context / vendor-playbooks).
              Append if file exists, create if not.

DECISION   → .claude/agent-memory/<slug>/project_<topic>.md
LESSON     → .claude/agent-memory/<slug>/reference_<topic>.md
CORRECTION → .claude/agent-memory/<slug>/feedback_<topic>.md
              All three add a one-line entry in MEMORY.md.
```

2. Render the entry:

```markdown
## <YYYY-MM-DD> — <topic-slug>

**Claim:** <one-line claim>
**Type:** <RULE | DECISION | LESSON | CORRECTION>
**Confidence:** <[VERIFIED] | [UNVERIFIED]>
**Source:** <citation>
**Captured:** <date> via domain-capture

<optional 2-4 lines of context>
```

3. Write to disk. Confirm:

```
✓ Captured to <path>.
  Index updated: MEMORY.md (+1 entry).
  Agent picks this up on next session.
```

## Anti-patterns

- **Don't ceremony-up the easy case.** Auto-pick destination, classification, file format. Only prompt the user when there's actual ambiguity.
- **Don't capture live-source.** Refuse inline and point at the source.
- **Don't capture without source unless the user explicitly says `no-source`** — and then tag `[UNVERIFIED]`.
- **Don't silently overwrite.** If the destination has a contradicting prior entry, show it before writing.
- **Don't write before the user confirms.** `save` or `keep` is the only trigger.
- **Don't bloat MEMORY.md.** One line per index entry, ~150 chars max, pointing to the typed file when more detail is needed.
- **Don't dump full documents.** Capture the CLAIM + SOURCE pointer, not the source's full content.
