---
name: domain-capture
description: Capture new evidence-backed knowledge into a domain expert agent. Takes a claim from the user (a fact, a correction, a decision, a lesson), invokes the target agent to surface its current understanding, requires source or evidence, debates contradictions, and writes the captured knowledge to the right place — KB doc, memory file, or rarely the agent's definition — with citation and a dated entry. Refuses to capture content that should be read live (venture-specific data, source-file excerpts). Use when the agent has gone stale, when new evidence emerges, or when the team wants to teach the agent something new.
---

# /domain-capture

Grow a domain expert agent's knowledge with evidence. Don't let it invent.

## When to invoke

- The agent's understanding is out of date.
- New regulation / framework / market data has emerged.
- The team made a decision worth preserving across sessions.
- A correction is needed (the agent's prior view was wrong).
- A lesson from production work is worth preserving.

## When NOT to invoke

- For creating an agent → `domain-creator`.
- For evaluating an agent → `domain-eval`.
- For content that lives in source files (a venture's current ARR, code state, dashboard data) → **do not capture**. Point the agent at the live source via `Read/Grep/Glob` instead. *Static snapshots go stale within hours.*

## How to run

1. **Ask one question per turn.** Wait for the answer. Never batch.
2. **Use defaults.** Destination + structure questions have defaults. Single-keystroke acceptance.
3. **Refuse without evidence.** No source / no citation = no capture. Ask again or accept user override (with the override logged).
4. **Surface contradictions.** If the agent's current view disagrees with the user's claim, show the conflict and resolve before writing.
5. **Don't silently overwrite.** If existing knowledge would be replaced, show the existing version and ask.
6. **Don't write to disk before explicit confirmation.**

## Phase 1 — Locate target agent

**Q1 — Agent**

Where's the agent you're teaching?

**✨ Default — slug + search common locations**

```
1. <cwd>/.claude/agents/<slug>.md
2. ~/.claude/agents/<slug>.md
3. ~/onestudio-exp/agents/.claude/agents/<slug>.md
4. ~/onestudio-exp/agents/domain-experts/agents/<slug>.md
5. ~/.claude/plugins/marketplaces/*/agents/<slug>.md
```

→ Type a slug or full path.

Capture: `agent_path`, `agent_body`, `agent_frontmatter`, `kb_dir` (if exists), `memory_scope` (from frontmatter `memory:` field).

## Phase 2 — Intake the claim

**Q2 — What are you teaching the agent?**

```
Examples by shape:
  • Fact / new info  →  "Atomic now operates 4 funds with sector specialization"
  • Correction       →  "My earlier framing of X was wrong — actually Y"
  • Decision         →  "We've decided Fund III will be DIFC ICR"
  • Lesson           →  "Founder-fit interviews work better at week 4 than week 2"
```

→ Write the claim in 1–3 sentences.

Capture: `raw_claim`.

## Phase 3 — Classify the claim

Auto-classify the claim into one of these types. Show the classification + WHY. Let user override.

```
RULE          regulations, methodologies, market data, frameworks
              → goes to KB topic file

DECISION      team decisions, evolving thesis, choices made
              → goes to memory (project-shared if agent's memory: project)

LESSON        learnings from work, corrected priors, things-we-now-know
              → goes to memory

LIVE-SOURCE   venture-specific dynamic data (ARR, code state, dashboards)
              → REFUSE. Tell the user this should be live-read, not captured.

UNKNOWN       can't classify cleanly
              → ask the user
```

**Q3 — Classification confirm**

> "I read this as a `<type>` claim. Sound right? `<one-line why>`"

```
default  — accept the classification
override — type rule / decision / lesson / live-source / unknown
```

→ Type `default` or an override.

## Phase 4 — Refuse live-source claims

If classified `LIVE-SOURCE`:

> "This looks like dynamic, source-anchored data. Capturing it would create a stale snapshot. Better paths:
>
> ```
> 1. Add the source file/path to the agent's live source list (in <agent>.md)
> 2. Add a 'how to fetch this' note to the KB instead of the value itself
> ```
>
> → Type `point-to-source` (I'll help you add the path), `add-note` (I'll capture a fetch-recipe), or `cancel` (skip)."

If `cancel`, exit. If `point-to-source` or `add-note`, branch (these are simpler edit flows; reuse the destination + write logic from Phase 8–9).

## Phase 5 — Surface agent's current view

Invoke the target agent and ask its current understanding. Use the Agent tool with `subagent_type: <slug>`. Pass:

```
"What's your current understanding of this topic? Do you have an existing
 view? Briefly. The user is bringing a new claim:

 <raw_claim>"
```

Capture: `agent_view`.

## Phase 6 — Resolve contradiction

Compare `raw_claim` to `agent_view`. Three branches:

### Branch 6A — Agent agrees (or has no prior view)

Skip to Phase 7. Note: *"Agent has no contradiction. Proceeding to evidence."*

### Branch 6B — Agent disagrees

Show the contradiction:

```
**Conflict detected.**

You said:        <raw_claim>
Agent's view:    <agent_view excerpt, ~200 chars>

This contradicts the agent's current understanding.
```

**Q6 — How to resolve?**

```
override     — your claim wins; capture as a corrected prior. (Requires evidence.)
withdraw     — drop the claim; agent's view stands.
discuss      — ask the agent for its reasoning before deciding.
```

→ Type one option.

If `discuss`, invoke the agent again asking for its sources/reasoning. Loop back to Q6.

### Branch 6C — Agent partially agrees / nuanced

Surface the nuance. Ask user to refine the claim. Loop back to Phase 2 with refined claim.

## Phase 7 — Require evidence

**Q7 — Source / evidence**

What's the source for this claim?

```
Format examples:
  • URL                 →  https://example.com/article
  • Document quote      →  "<quote>" — Document Title, Author, Date
  • Direct experience   →  "from internal team meeting on YYYY-MM-DD"
  • Authoritative voice →  "stated by <person/role> on <date>"
```

→ Provide a source.

If user types `no-source`:

> "No source = no capture. Two options:
>
> ```
> override-confirm  — capture without source. Will be tagged [UNVERIFIED]
>                     and the user accepting risk is logged.
> withdraw          — drop the claim.
> ```
>
> → Type one."

Capture: `source` (or marker `[user-overridden]`).

Apply the agent's declared anti-fabrication rule (parsed from agent body):

```
two-source rule  →  require ≥2 sources for empirical claims
hybrid rule      →  ≥2 for empirical, 1 + tag for methodology, none for internal
strict rule      →  every claim must cite
```

If the user's evidence doesn't satisfy the agent's declared rule, flag it. Capture proceeds with `[UNVERIFIED]` tag.

## Phase 8 — Decide destination

Auto-decide based on classification + agent's structure. Show user the proposed destination + WHY.

```
RULE → KB topic file
  Default location:  <kb_dir>/<subdir>/<topic-slug>.md
  Subdir picked from kb_categories (regulations / frameworks / market-data /
  cultural-context / vendor-playbooks). If the right file exists, append.
  If not, create.

DECISION / LESSON → memory
  Default location:  .claude/agent-memory/<slug>/MEMORY.md
                   + a typed file at .claude/agent-memory/<slug>/<type>_<topic>.md
                     (e.g., project_fund-iii-vehicle-choice.md)
  MEMORY.md gets a one-line index entry pointing to the typed file.

CORRECTION → memory (corrected-priors)
  Default location:  .claude/agent-memory/<slug>/feedback_<topic>.md
                   + index entry in MEMORY.md

DECLARATION CHANGE (rare) → frontmatter
  Only when the claim explicitly changes a declared rule (e.g., "the verdict
  vocab should now also include 'Watch'"). Surface this as a high-bar change.
```

**Q8 — Destination confirm**

> "Capture proposal:
>
> ```
> File:    <path>
> Action:  create | append | update
> ```
>
> *Why this destination:* `<one-line>`"

```
default     — write to the proposed path
elsewhere   — specify a different path
cancel      — abort
```

→ Type one option.

## Phase 9 — Show + write

Render the captured entry. Standard format:

```markdown
## <YYYY-MM-DD> — <topic-slug>

**Claim:** <one-line claim>

**Type:** <RULE | DECISION | LESSON | CORRECTION>

**Confidence:** <[VERIFIED] | [UNVERIFIED] | [user-overridden]>

**Source:** <citation>

**Captured by:** domain-capture · <user-name-or-anonymous>

<optional 2–4 lines of detail / context>
```

Show inline. Show one-line summary diff:

```
<file>           ← create | append | update (N lines)
MEMORY.md        ← +1 index entry (if applicable)
```

**Q9 — Save?**

```
save     — write to disk
edit     — adjust something first
cancel   — discard
```

→ Type one option.

On `save`:
1. Write the typed file (create or append).
2. If destination was memory, also update MEMORY.md with a one-line index entry pointing to the typed file. Format:
   ```
   - [<topic>](<typed-file-name>) — <one-line hook>
   ```
3. Confirm: *"Captured to `<file>`. Agent will load this on next session."*

## Anti-patterns

- **Don't capture live-source content.** A venture's current ARR doesn't belong in a static KB. Refuse and point at the source.
- **Don't capture without a source.** Override is allowed but must be tagged `[UNVERIFIED]` so future readers see the lower-confidence flag.
- **Don't silently overwrite.** If the destination file already has a contradicting claim, show the existing entry and ask user to resolve.
- **Don't write before user confirms.** Phase 9 is the only place files get touched.
- **Don't dump full documents.** Capture the CLAIM + SOURCE pointer, not the source's full content. Keep entries scannable.
- **Don't bloat MEMORY.md.** It's an index. One line per entry, ~150 chars max, pointing to a typed file when more detail is needed.
