# Agent-Spec Contract

The lossless mapping between a domain-experts agent file and the OneStudio
hub. `domain-creator` WRITES this; the hub's `app/lib/mcp/agent-spec.ts`
READS it. Changing one side without the other breaks the round-trip.

## Frontmatter (authoritative — emit all of these)

| Key | Required | Hub field | Notes |
|---|---|---|---|
| `name` | yes | `agents.id` | slug, `^[a-z][a-z0-9-]{1,38}[a-z0-9]$` |
| `description` | yes | `agents.description` (one-liner) | must NOT lead with a product name |
| `name_ar` | if persona has an Arabic name | `agents.name_ar` | **NEW** — previously inferred from `(…)` in description; emit explicitly |
| `categories` | yes | `agents.skills` | **NEW** — YAML list of canonical slugs (see below); previously inferred from work bullets |
| `tools` | yes | `agents.tools` | comma-separated |
| `memory` | yes | `agents.memory` | `project` \| `user` \| `local` \| `none` |
| `model` | optional | `agents.model` | `opus` \| `sonnet` \| `haiku` \| explicit id |

## Canonical categories

`decision_support`, `reference_lookup`, `structured_review`,
`competitive_intel`, `regulatory_compliance`, `handoff_partner`,
`educational_explainer`.

## Body sections consumed

| `# Heading` | Hub field |
|---|---|
| `Who you are` (first paragraph) | long description / body_description |
| `Your domain` (first line) | `agents.domain` |
| `Reference implementation` (first line) | reference_implementation (advisory) |
| `Comparable peers` (`**bold**` bullets) | comparable_peers (advisory) |

## KB & prompts

- `<slug>-knowledge/INDEX.md` frontmatter `last_updated:` → `agents.kb_last_built_at`.
- Top-level `├── dir/` entries in INDEX.md → `agents.kb_categories`.
- `examples/<slug>-starter-prompts.yaml` `- id:` count → `agents.starter_prompts_count`.

## Back-compat

Legacy files without `name_ar`/`categories` frontmatter still parse: the
hub falls back to extracting Arabic from `description` parens and mapping
work-bullet labels to canonical slugs. New files MUST emit them explicitly.
