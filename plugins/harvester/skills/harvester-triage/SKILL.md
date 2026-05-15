---
name: harvester-triage
description: Use after fetch to turn raw content into a structured item. Applies prompts/triage.md and returns {summary, why_it_matters, next_moves[], suggested_tags[], confidence}.
---

# Harvester Triage

Converts the raw fetch result into a structured brief. Runs immediately after `harvester-fetch` (or `harvester-browser`) returns.

## Input

The fetch struct from the previous step:

```json
{
  "content":    "<body text; may be empty>",
  "title":      "<page title or null>",
  "sourceType": "<youtube | linkedin | twitter | article | unknown>",
  "ogImageUrl": "<cover image URL or null>"
}
```

Also needed: the original `url` submitted by the user.

## Procedure

1. Load the triage prompt file at `../../prompts/triage.md` (relative to this skill file).

2. Fill in the placeholders in that file's `# USER` section:

   | Placeholder            | Value                                                    |
   | ---------------------- | -------------------------------------------------------- |
   | `{{url}}`              | The original URL                                         |
   | `{{title}}`            | `title` from fetch (use empty string if null)            |
   | `{{source_type}}`      | `sourceType` from fetch                                  |
   | `{{content_is_partial}}` | `true` if `content` is empty or truncated; else `false` |
   | `{{body}}`             | `content` from fetch                                     |

3. Follow the `# SYSTEM` instructions in `triage.md` exactly. Do not add prose around the output.

4. Emit the JSON item exactly as specified in `triage.md`:

```json
{
  "summary":        "<2-3 sentence TL;DR>",
  "why_it_matters": "<2-3 sentences>",
  "next_moves":     ["<imperative step>", "..."],
  "suggested_tags": ["<tag>", "..."],
  "confidence":     "low" | "medium" | "high"
}
```

5. Attach the original `url`, `title`, `sourceType`, and `ogImageUrl` from the fetch step to the output so the curate step has everything it needs.

## When content is partial or empty

If `content` is blank, say so in the `summary` field (per the prompt instructions: "If only metadata is available (no body), say so in the summary."). Fill `confidence` as `"low"`. Still emit a complete JSON object -- do not skip fields.

## Handoff

Pass the full triage output plus the fetch fields to `harvester-curate`:

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
