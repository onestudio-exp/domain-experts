---
name: harvester-curate
description: Use to persist a triaged item via the store contract -- dedupe by normalized URL, file under its topic, refresh the topic index.md and digest.md.
---

# Harvester Curate

Persists the triaged item to the store, deduplicates by normalized URL, and regenerates the topic-level index and digest files. Runs after `harvester-triage` returns.

Store contract reference: `../../references/store-contract.md`. Default store root: `.harvester/knowledge/`.

## Input

The full triage output from the previous step, including the fetch fields:

```json
{
  "url":            "<original URL>",
  "title":          "<title>",
  "sourceType":     "<sourceType>",
  "ogImageUrl":     "<ogImageUrl or null>",
  "summary":        "...",
  "why_it_matters": "...",
  "next_moves":     ["..."],
  "suggested_tags": ["..."],
  "confidence":     "low" | "medium" | "high"
}
```

## Procedure

### Step 1 -- dedupe check

Call `findByUrl(normalizedUrl)` with the normalized form of `url` (see `url-normalize.ts` in the contract directory).

- If a matching item is returned: decide whether to skip or merge.
  - Skip: if the existing item is already triaged and the new content adds nothing.
  - Merge: if the existing item has empty or partial content and the new fetch improved it. Update fields in place via `putItem` and preserve `createdAt`.
- If no match: proceed to step 2.

### Step 2 -- persist

Build a `HarvesterItem` from the triage output (see field definitions in `store-contract.md`). Required fields:

| HarvesterItem field | Source                         |
| ------------------- | ------------------------------ |
| `url`               | normalized URL                 |
| `urlOriginal`       | original URL                   |
| `status`            | `"triaged"`                    |
| `title`             | from triage                    |
| `summary`           | from triage                    |
| `whyItMatters`      | `why_it_matters` from triage   |
| `nextMoves`         | `next_moves` from triage       |
| `tags`              | `suggested_tags` from triage   |
| `routing.topic`     | derived from `suggested_tags` or user-supplied topic slug |

Call `putItem(item)`. Store the returned ID.

### Step 3 -- call announce

Call `announce(item)` after a successful `putItem`. The default `FileStore` is a no-op. Integrations override this to push notifications or feed entries -- do not skip the call.

### Step 4 -- regenerate topic index

Get the topic slug from `item.routing.topic`. If null, use `_inbox`.

Call `listItems({ topic })` to retrieve all items for this topic in reverse-chronological order.

Write or overwrite `<topic>/index.md` as a rolling list:

```markdown
# <topic> -- Index

_Last updated: <ISO timestamp>_

| Title | URL | Date | Confidence |
| ----- | --- | ---- | ---------- |
| <title> | <url> | <createdAt date> | <confidence> |
...
```

One row per item, newest first.

### Step 5 -- regenerate topic digest

Using the same `listItems` result, write or overwrite `<topic>/digest.md` as a roll-up human-readable summary:

```markdown
# <topic> -- Digest

_<item count> items. Last updated: <ISO timestamp>._

## Recent additions

For each item (newest first, up to 10):
- **<title>** (<date>) -- <summary>
  Why it matters: <why_it_matters>
  Next moves: <next_moves joined by "; ">
```

Regenerate from scratch on every curate call -- do not append.

## File layout (FileStore default)

```
.harvester/
  knowledge/
    <topic>/
      items/
        <id>.json      -- one HarvesterItem per file (written by store)
      index.md         -- regenerated here (rolling list)
      digest.md        -- regenerated here (roll-up summary)
    _inbox/
      items/
        <id>.json      -- items with no topic assigned
```

The `.harvester/` directory is gitignored and local to the workspace. Never commit it.

## Handoff

Curate is the final step in the pipeline. On completion, report the item ID and topic to the caller:

```
Curated: <id> -> <topic> (<url>)
```

If the item was a duplicate and was skipped, report:

```
Duplicate: <existing-id> already exists for <normalized-url> -- skipped
```
