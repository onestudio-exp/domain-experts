---
name: classify-edit
description: Classify post-creation edits to a domain expert agent against a fixed taxonomy of toolkit-gap types. Reads .telemetry/edits.jsonl captured by the post-commit hook, dispatches each unclassified edit to a blind subagent for classification, and appends results to .telemetry/classified.jsonl. Output drives /domain-experts:learn-from-edits and surfaces toolkit improvement opportunities.
---

# /domain-experts:classify-edit

Classify captured agent edits into the toolkit-gap taxonomy. Three turns max for the typical case.

## When to invoke

- After the post-commit telemetry hook has captured one or more edits (`.telemetry/edits.jsonl`).
- Manually, to retroactively classify a backlog of edits.
- As part of a periodic team review.

## When NOT to invoke

- If `.telemetry/edits.jsonl` does not exist → user has not installed the hook (`scripts/install-telemetry-hook.{ps1,sh}`).
- If there are no unclassified entries → nothing to do; redirect user to `/domain-experts:learn-from-edits` to synthesize patterns.

## Prerequisites

1. Telemetry hook installed (`scripts/install-telemetry-hook` was run in the venture).
2. At least one commit touching an agent file has happened.

## How to run

1. **One pass per invocation.** Read the JSONL, find unclassified entries, classify each, write results.
2. **Idempotent.** Skip entries already in `classified.jsonl` (match on `edit_id`).
3. **Blind classifier.** Each edit is sent to a fresh `general-purpose` subagent with NO conversation context — only the edit metadata + the taxonomy.
4. **Conservative.** If an edit doesn't fit the existing taxonomy, the classifier may propose a NEW category. Don't force a fit.

## Phase 1 — Locate inputs

Read `<venture-root>/.telemetry/edits.jsonl`. Each line is a JSON object captured by the post-commit hook:

```jsonl
{"edit_id":"abc1234_<path>","agent":"burhan","file":".claude/plugins/burhan/agents/burhan-knowledge/INDEX.md","kind":"kb_file","change_type":"added","commit":"...","commit_msg":"...","author":"...","timestamp":"...","classified":false}
```

Read `<venture-root>/.telemetry/classified.jsonl` if it exists. Build a set of already-classified `edit_id`s.

Compute the unclassified queue (entries in `edits.jsonl` whose `edit_id` is NOT in the classified set).

If the queue is empty:
```
No unclassified edits. Run /domain-experts:learn-from-edits to synthesize
patterns from {N} classified edits.
```
Exit cleanly.

If the queue has >100 entries:
```
WARNING: {count} unclassified edits queued. Classifying all may cost
~${count * 0.40} in LLM tokens. Proceed? [yes / first-10 / cancel]
```

## Phase 2 — Per-edit classification

For each unclassified entry:

1. **Fetch the diff.** Use `git show <commit> -- <file>` to retrieve the actual change content. Truncate to first 200 lines if larger.

2. **Construct the blind classifier prompt.** Self-contained, no conversation context. Template:

```
You are a blind classifier for a domain-expert-agent toolkit improvement
system. You will classify ONE edit signal.

# Taxonomy (canonical 11+ categories)

1. structural_section_added       - new section/heading in agent body
2. capability_tool_added           - tool added to frontmatter tools:
3. kb_file_added                   - new file in <slug>-knowledge/
4. refusal_rule_added              - bullet in Hard rules section
5. confidence_vocab_modified       - confidence vocab changed/extended
6. voice_persona_rewritten         - Who-you-are section rewritten
7. schema_extension                - output schema changed
8. frontmatter_metadata_added      - new frontmatter field (e.g., position)
9. plugin_scaffolding_added        - file outside agent + KB (README, manifests, INDEX)
10. operating_manual_sections      - research loop, tool failover, output format
11. discoverability_keywords_added - description: field expanded with routing keywords

You MAY propose a NEW category if none fits. Be conservative.

# Edit to classify

agent:        {{agent}}
file:         {{file}}
kind:         {{kind}}
change_type:  {{change_type}}
commit_msg:   {{commit_msg}}

Diff:
{{diff_excerpt}}

# Output (JSON only, no prose)

{
  "category": "<from taxonomy OR a NEW category name>",
  "confidence": "high | medium | low",
  "is_toolkit_gap": true | false,
  "reasoning": "<one sentence>",
  "proposed_new_category": "<name>" | null
}
```

3. **Invoke blind subagent.** Use Agent tool with `subagent_type: general-purpose`. Capture the JSON response.

4. **Validate the response.** Must be valid JSON with all 5 fields. If invalid, retry once. If still invalid, mark as `category: "unparseable"` and continue.

5. **Append to classified.jsonl.** One line per edit:

```jsonl
{"edit_id":"<orig>","agent":"<orig>","category":"...","confidence":"...","is_toolkit_gap":true,"reasoning":"...","proposed_new_category":null,"classified_at":"<ISO timestamp>"}
```

## Phase 3 — Summarize

After the queue is processed, print a short summary:

```
=== Classification complete ===

Total classified this run:  N
By category:
  capability_tool_added       3
  kb_file_added               2
  structural_section_added    2
  NEW: plugin_scaffolding     1   (1 instance)
  NEW: discoverability_keys   1   (1 instance)

Toolkit gaps detected:        7 / 8 entries
Confidence breakdown:         high=6  medium=2  low=0

NEW categories proposed (review and consider adding to taxonomy):
  - plugin_scaffolding_added: 1 occurrence (T4-style)
  - discoverability_keywords_added: 1 occurrence (T12-style)

Run /domain-experts:learn-from-edits to detect patterns across all
classified edits ({total} in store).
```

## Cost guard

- 1 classify call ≈ 5–10k tokens output, 30–40k tokens input. Roughly $0.30–$0.45 per edit.
- Batched processing: classify up to 10 edits per `learn-from-edits` window to keep cost predictable.
- Refuses runs > 100 unclassified entries without explicit confirmation.

## Anti-patterns

- **Do NOT classify edits the user has already manually classified.** Respect the idempotency check.
- **Do NOT expose more than the edit diff to the classifier.** No conversation context, no other files, no prior classifications.
- **Do NOT auto-add NEW categories to the taxonomy.** Surface them in the summary; humans decide whether to promote them.
- **Do NOT process toolkit-internal edits.** The hook already filters them out; but if any sneak through, skip with `category: "toolkit_self_edit"`.

## What this skill does NOT do

- Aggregate patterns across multiple edits → that is `/domain-experts:learn-from-edits`.
- Open PRs for proposed improvements → that is `/domain-experts:propose-pr`.
- Auto-modify the toolkit → no skill should ever do that without human review.

## Example invocation

```
User: /domain-experts:classify-edit

Skill:
  Reading .telemetry/edits.jsonl ... found 3 unclassified entries.
  Reading .telemetry/classified.jsonl ... 0 already classified.
  Queue: 3 edits.

  Classifying edit 1/3 (burhan, agents/burhan-knowledge/INDEX.md)...
  -> category: NEW: hub_metadata_file  | confidence: high  | gap: true

  Classifying edit 2/3 (burhan, agents/burhan.md)...
  -> category: frontmatter_metadata_added  | confidence: high  | gap: true

  Classifying edit 3/3 (burhan, README.md)...
  -> category: NEW: plugin_scaffolding_added  | confidence: high  | gap: true

  Appended 3 entries to .telemetry/classified.jsonl.

  === Summary ===
  Toolkit gaps: 3/3
  NEW categories proposed: hub_metadata_file, plugin_scaffolding_added

  Next: /domain-experts:learn-from-edits to detect patterns.
```
