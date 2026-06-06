---
name: learn-from-edits
description: Synthesize patterns from classified agent edits across one or more ventures, and produce a ranked list of proposed toolkit improvements with concrete evidence. Reads .telemetry/classified.jsonl, groups by category, applies a pattern-detection threshold (default ≥2 occurrences), invokes a synthesizer subagent per pattern, and emits a markdown report at .telemetry/learn-report-<date>.md. Output drives /domain-experts:propose-pr. Run weekly or before a toolkit release cycle.
---

# /domain-experts:learn-from-edits

Find patterns in classified telemetry. Three turns max for the typical case.

## When to invoke

- Weekly review: summarize what the team learned in the past week.
- Before a toolkit release: decide which patterns to ship.
- Manually: after a batch of classify-edit runs added new data.

## When NOT to invoke

- If `.telemetry/classified.jsonl` does not exist OR is empty → run `/domain-experts:classify-edit` first.
- If only one classified entry exists → noise. Patterns require at least `min-occurrences` data points (default 2).

## Prerequisites

1. `.telemetry/classified.jsonl` exists with ≥2 entries.
2. (Optional) Team-wide store exists under `<submodule>/telemetry/<venture>/classified.jsonl` for cross-venture patterns.

## How to run

1. **One pass per invocation.** Read all classified data in scope, group, detect, synthesize, write report.
2. **Idempotent on output.** Each report file is timestamped — re-running creates a new report, never overwrites.
3. **Honest thresholds.** Single-venture single-occurrence "patterns" are recorded but NOT surfaced as toolkit improvements — they're flagged as needing more evidence.

## Phase 1 — Load + scope

Default scope: read `<venture-root>/.telemetry/classified.jsonl`.

Optional flags:
- `--all-ventures` → also read `<submodule>/telemetry/*/classified.jsonl`
- `--since YYYY-MM-DD` → filter by `classified_at` timestamp
- `--min-occurrences N` → override default threshold (default: 2)
- `--venture <slug>` → filter to one venture only

Build an in-memory list of all qualifying classified entries.

If the list is empty or below threshold:
```
Not enough classified data to detect patterns.
   Entries loaded: {N}
   Threshold:      {min-occurrences}
Run /domain-experts:classify-edit on more edits first.
```
Exit cleanly.

## Phase 2 — Group + count

Group entries by `category` (using the exact category string — so `NEW: plugin_scaffolding_added` is distinct from `plugin_scaffolding_added`).

For each category, compute:
- `occurrence_count` — total entries
- `unique_ventures` — distinct `agent` values (or venture path if available)
- `unique_files` — distinct `file` paths
- `gap_strength` — share of entries with `is_toolkit_gap: true`

Categories meeting the threshold AND having `gap_strength >= 0.5` are "candidate patterns". Others are "weak signals" — recorded but not synthesized.

## Phase 3 — Per-pattern synthesis

For each candidate pattern:

1. **Build the synthesizer prompt.** Self-contained, no conversation context:

```
You are a synthesizer for a domain-expert-agent toolkit. You will analyze
a recurring edit pattern and propose a concrete toolkit improvement.

# The pattern

Category:           {{category}}
Occurrences:        {{count}}
Unique ventures:    {{venture_count}}
Gap strength:       {{gap_strength}}

Evidence (one classified edit per line):
{{for each entry:}}
- {{agent}} / {{file}} - {{reasoning}}

# Your task

1. Identify the ROOT CAUSE: what is the toolkit (specifically
   `domain-creator` / `agent-template.md` / `domain-eval`) missing
   that forced ventures to add this manually post-creation?
2. Propose a CONCRETE fix at the toolkit level (which file, which
   section, what change).
3. Suggest a PR title (one line, conventional commits style).
4. Assign a TIER:
   - tier-1-auto-promote: generic pattern, safe to add directly to template
   - tier-2-seed-stub: content is venture-specific but the SHAPE is automatable
   - tier-3-human-review: needs taste call on optional vs mandatory

# Output (markdown, no preamble)

## Root cause
{{one paragraph}}

## Proposed toolkit fix
{{file path, section, change description, 1-3 sentences}}

## Suggested PR title
{{title}}

## Tier
{{tier name}}
```

2. **Invoke synthesizer subagent.** Use Agent tool with `subagent_type: general-purpose`. Capture the markdown response.

3. **Append to report.** Format the response as a numbered section in the final report.

## Phase 4 — Write report

Save to `<venture-root>/.telemetry/learn-report-<YYYY-MM-DD>.md`:

```markdown
# Learn-from-edits report - {{date}}

**Source:** {{N}} classified entries from {{V}} venture(s)
**Threshold:** ≥{{min-occurrences}} occurrences per pattern
**Patterns surfaced:** {{P}}
**Weak signals (need more evidence):** {{W}}

---

## Strong patterns

### Pattern 1: {{category}}
**Occurrences:** {{count}} ({{venture_count}} venture(s))
**Gap strength:** {{gap_strength}}

{{synthesizer output: root cause / proposed fix / PR title / tier}}

**Evidence:**
- {{agent}} / {{file}} - "{{reasoning}}"
- ...

**Next:** Run `/domain-experts:propose-pr --pattern 1 --report {{report-path}}`

---

### Pattern 2: ...

---

## Weak signals (single-venture / single-occurrence)

These were observed but lack the cross-venture evidence to justify a
toolkit change. Watch for repetition.

- {{category}}: {{count}} occurrence(s) in {{venture(s)}}
- ...
```

## Phase 5 — Summarize on stdout

Short summary the user sees in their terminal:

```
=== Learn report generated ===

Path:               .telemetry/learn-report-2026-05-25.md
Patterns surfaced:  3
Weak signals:       2
Strong patterns broken down:
   1. plugin_scaffolding_added       (5 occ, 1 venture, tier-1)
   2. operating_manual_sections      (3 occ, 1 venture, tier-1)
   3. kb_file_added                  (2 occ, 1 venture, tier-2)

Next: /domain-experts:propose-pr --pattern 1
   (drafts a PR for the highest-priority pattern)
```

## Pattern-detection rules

A pattern is "strong" only if:
- `occurrence_count >= min-occurrences` (default 2), AND
- `gap_strength >= 0.5` (majority of entries flagged as toolkit gaps), AND
- Either `unique_ventures >= 2` OR `--single-venture-ok` flag was passed

**Single-venture single-occurrence patterns are intentionally suppressed.** They are recorded as weak signals to detect later repetition.

For a solo developer scenario (one venture), use `--single-venture-ok` to bypass the cross-venture requirement — useful when bootstrapping the system or when one venture has rich enough edit history to show real patterns alone.

## Anti-patterns

- **Do NOT auto-promote weak signals.** If only one venture flagged it, it might be venture-specific taste, not a universal gap.
- **Do NOT modify the toolkit directly.** This skill only proposes — `/domain-experts:propose-pr` is what generates the actual PR.
- **Do NOT silently drop weak signals.** They go in the report under "Weak signals" so they're visible for future runs.
- **Do NOT exceed 5 patterns in one report.** If more candidates exist, surface the top 5 by gap_strength × occurrence_count and note "{X more weaker patterns omitted — re-run with --threshold lower".

## What this skill does NOT do

- Classify edits → that is `/domain-experts:classify-edit`.
- Open PRs → that is `/domain-experts:propose-pr`.
- Modify any toolkit file.

## Example invocation

```
User: /domain-experts:learn-from-edits --single-venture-ok

Skill:
  Loading .telemetry/classified.jsonl ... 14 entries
  Grouping by category ... 6 categories
  Applying threshold (≥2 occurrences, ≥0.5 gap strength) ...

  3 patterns qualify, 2 weak signals.

  Synthesizing pattern 1/3 (plugin_scaffolding_added, 5 occ)...
  Synthesizing pattern 2/3 (operating_manual_sections, 3 occ)...
  Synthesizing pattern 3/3 (kb_file_added, 2 occ)...

  Writing .telemetry/learn-report-2026-05-25.md ... done.

  === Summary ===
  3 strong patterns surfaced. Top pattern: plugin_scaffolding_added.
  Next: /domain-experts:propose-pr --pattern 1
```
