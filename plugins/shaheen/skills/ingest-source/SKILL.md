---
name: ingest-source
description: Use when the team adds a source to .agent-db/raw/, asks Shaheen to ingest it, or asks for a wiki lint/audit. Page-type-aware ingestion that maps content into typed wiki pages (sources, concepts, indicators, events, entities) following the schemas declared in this skill.
---

## Purpose

Turn a raw document in `.agent-db/raw/` — or a reusable web finding surfaced by [[question-answer]] — into validated, typed, interlinked wiki knowledge. Every fact ingested becomes one of the typed page kinds, and every page traces back to a registered source.

This skill is also how reusable findings from web retrieval are promoted into the wiki: when an answer relies on a web source likely to recur, save the document into `.agent-db/raw/` (or capture a stable URL + retrieval date), and run this skill so the next answer cites a wiki page instead of a fresh fetch.

Take it slowly. When unsure how to type or place content, ask the team.

## Persona contract

This skill runs *as Shaheen*. The signature, response shape, and tone discipline are canonical in `.claude/agents/shaheen.md` §2 "Response contract". Wiki maintenance is part of the role — the marker is `Operational`. Scope discipline lives in `.claude/agents/shaheen.md` §3.

## Page types

| Type | Folder | Purpose |
|---|---|---|
| **source** | `.agent-db/wiki/sources/` | New: one page per source — registry of where knowledge came from |
| **concept** | `.agent-db/wiki/concepts/` | Slow-changing canonical facts (institutions, structures, frameworks) |
| **indicator** | `.agent-db/wiki/indicators/` | Hybrid `.md` + `.yaml` cards for tracked metrics |
| **event** | `.agent-db/wiki/events/` | Atomic dated facts (one figure or decision per page) |
| **entity** | `.agent-db/wiki/entities/` | Organizations, ministries, vendors, named bodies |
| **brief** | `.agent-db/wiki/briefs/` | Recurring brief outputs (e.g. Opportunity Scout) |
| **question** | `.agent-db/wiki/questions/` | Captured Q&A — see [[questions/index]] |

Frontmatter schemas for each type are declared in §"Page schemas (new pages)" below.

## Sources — dual layout during grandfather period

The wiki keeps two complementary representations of source metadata while the team migrates:

- **`.agent-db/wiki/source-registry.yaml`** (legacy, single file) — the existing canonical list with `tier: public | government_held | third_party` (an *access* tier) and `used_for: [...]`. Stays the index.
- **`.agent-db/wiki/sources/<id>.md`** (new, one page per source) — adds a typed page with `authority: primary | secondary | tertiary` (an *authority* tier), `authority_domain`, `known_biases`, etc.

When this skill registers a new source (Step 3 below), it creates the `.md` page **and** appends a one-line entry to the yaml. When the team is ready to retrofit, the yaml will eventually become a generated index of the `.md` pages — but that migration is not part of this phase.

## Grandfather rule

The schema and citation discipline introduced on 2026-04-29 apply going forward. The ~50 existing wiki pages are grandfathered:

- They keep their current frontmatter-less, narrative format.
- They keep their existing `(source: filename.pdf)` citations.
- They still count as legitimate wiki pages — `[[wiki-links]]` to them resolve normally.
- The lint workflow flags them in a separate "tech-debt" list, not as failures.

Retrofitting an old page is opt-in. When the team is ready, they ask Shaheen to retrofit a specific page (or batch), and Shaheen applies the new schema + relabels citations through this skill.

## Ingest workflow

### Step 1 — Read the source

Read the full document at `.agent-db/raw/<filename>`. Do not skim. Note: dates, publishing institution, scope of coverage, methodology, any caveats the source flags itself.

### Step 2 — Discuss with the team before writing

Summarise key takeaways, flag what is relevant to **Qatar's economy specifically**, and propose:
- A `source-id` for the new `.agent-db/wiki/sources/<id>.md` page.
- The list of concept / indicator / event / entity pages this source will create or update.

Wait for team confirmation before writing pages. A single source typically touches 5–15 wiki pages — the check now prevents rewrites later.

### Step 3 — Register the source first

**No content from this source can be ingested before its registry entry exists.**

Create `.agent-db/wiki/sources/<source-id>.md` using `.agent-db/wiki/sources/_template.md`. Fill the frontmatter:

- `type: source`
- `id`, `name`, `publisher`
- `authority: primary | secondary | tertiary` (with rationale in body)
- `authority_domain` — what this source IS authoritative for, and what it is NOT
- `frequency`, `language`, `known_biases`, `last_checked`
- `url` (or `raw_file` if it lives in `.agent-db/raw/`)

Then add a one-line entry to `.agent-db/wiki/source-registry.yaml` so the existing canonical registry stays the index. The yaml entry remains the legacy index; the markdown page is the new authoritative metadata. (See §"Sources — dual layout during grandfather period" above.)

### Step 4 — Classify each piece of content

For each piece of content extracted from the source, decide its type:

- **concept** — slow-changing fact: an institution, a structural feature, a policy framework, a sector definition.
- **indicator** — a metric the source publishes regularly with consistent methodology. Indicator pages are *cards*, not data series — they describe the indicator itself. Hybrid `.md` + `.yaml`.
- **event** — a dated atomic fact: a specific reading, a specific decision, a specific release. **One event = one fact** for *new* event pages. Existing narrative event pages are grandfathered.
- **entity** — a named organization, ministry, company, or person.

When uncertain, ask the team.

### Step 5 — Apply the matching template

Use the `_template.md` (and `_template.yaml` for indicators) in the relevant folder. Fill all frontmatter fields per the schema in §"Page schemas (new pages)" below.

Naming:
- Sources: `<source-id>.md` — lowercase hyphenated.
- Concepts: `<concept-name>.md`.
- Indicators: `<indicator-name>.md` + `<indicator-name>.yaml`.
- Events (new): `event-YYYY-MM-DD-<short-slug>.md`.
- Entities: `<entity-name>.md`.

### Step 6 — Add wiki-links to connect the graph

Every event must link to:
- Its source (`source` frontmatter field, `[[source-id]]` in body).
- The indicator(s) it's a reading of, where applicable (`indicators_touched`).
- Any concepts it touches (`concepts_touched`).

Every indicator card must link to its publisher source, related indicators, and its latest event(s) under "Latest readings".

Every concept / entity page must link to sources used and related concepts / entities.

### Step 7 — Update the index

Open `.agent-db/wiki/index.md` and add one-line entries to the relevant sections. Format: `- [[page-id]] — one-line description · <bilingual keyword tags>`. The index is the smart-search front door for [[question-answer]], so every page touched here must be discoverable by Arabic and English keywords.

For events, only the most recent entries should appear in the index. Older events live in their files only and remain reachable via indicator pages.

### Step 8 — Append to the log

Append one line per page touched to `.agent-db/wiki/log.md`:

```
YYYY-MM-DD | <action> | <page-id> | <source-id>
```

Actions: `register-source` | `add-concept` | `add-indicator` | `add-event` | `add-entity` | `update`.

## Citation rules (new pages)

User-facing response citation format is canonical in `.claude/agents/shaheen.md` §2.3 "Citation labels and Sources block". The rules below apply to citations **inside `.agent-db/wiki/` page bodies**, which use a lighter inline style.

- Every factual claim in any page body carries a citation label:
  - `(wiki: [[source-id]])` for claims grounded in a registered wiki source.
  - `(authoritative: <url>, <publisher>, <date>)` for governmental / central-bank / multilateral claims.
  - `(general: <url>, <publisher>, <date>)` for research desks, analyst notes, reputable news.
- If two sources disagree, **note the contradiction explicitly**:
  1. Higher authority wins (`primary` > `secondary` > `tertiary`).
  2. On ties, more recent wins.
  3. On cross-authority contradiction, surface both.
- Claims with no source must be marked `<!-- NEEDS VERIFICATION -->` and listed in the next lint pass.

Old pages (grandfathered per §"Grandfather rule" above) still carry `(source: filename.pdf)` style — leave them as-is unless the team asks for a retrofit pass.

## Lint workflow

When the team asks to lint or audit, run all checks. Report findings as a numbered list with suggested fixes. Do not fix without team confirmation.

### Structural checks
- Every **new** page has valid YAML frontmatter matching its type's schema (per §"Page schemas (new pages)" below).
- Every **old** page is flagged in a separate "tech-debt" list — these are grandfathered, not failures.
- Every page name follows naming conventions.
- No orphan files in `.agent-db/wiki/` outside the typed folders + `index.md` + `log.md`.

### Reference integrity
- Every `[[wiki-link]]` resolves to an existing page.
- Every event's `source` frontmatter resolves to a `.agent-db/wiki/sources/` page (for new events).
- Every indicator's `publisher` resolves to a `.agent-db/wiki/sources/` page (for new indicators).
- No orphan sources (a source with zero references).

### Content checks
- Every indicator card has at least one event referencing it.
- No claim marked `NEEDS VERIFICATION` is older than the last lint pass without action.
- No contradictions between concept pages on the same topic.

### Freshness
- Flag indicator cards whose latest linked event is older than 2× the indicator's `frequency`.
- Flag sources whose `last_checked` is older than 6 months.

### Grandfather tech-debt list
- List every page that lacks the new YAML frontmatter, grouped by folder. This is the migration backlog — does not block anything, just shows where the new schema hasn't reached yet.

## Rules

- Never modify anything in `.agent-db/raw/` — it is immutable.
- Always update `.agent-db/wiki/index.md` and `.agent-db/wiki/log.md` after changes.
- Page IDs are lowercase, hyphenated, no spaces.
- Write in clear plain language — define jargon on first use, link to a concept page on second mention.
- When uncertain how to type a piece of content, ask the team.
- A draft new page should pass the structural and reference-integrity checks before being committed.
- The skill response (when run) ends with the canonical Shaheen signature, marker `Operational`.

---

## Page schemas (new pages)

These schemas apply to **new pages created after 2026-04-29**. Existing pages are grandfathered (see §"Grandfather rule" above). The lint workflow flags ungrandfathered pages as a tech-debt list, not as failures.

All new pages start with YAML frontmatter and end with the standard wiki page format (Summary / Sources / Last updated / body / Related pages).

### Source page (`.agent-db/wiki/sources/<id>.md`)

```yaml
---
type: source
id: <source-id>                 # lowercase, hyphenated
name: <human-readable name>
publisher: <institution>
authority: primary | secondary | tertiary
authority_domain: [<domain>, <domain>, ...]   # what this source IS authoritative for
access_tier: public | government_held | third_party | not_available
url: <canonical url, or omit if raw_file is set>
raw_file: <path under .agent-db/raw/, or omit>
frequency: <ad-hoc | daily | weekly | monthly | quarterly | annual>
language: <en | ar | en+ar>
known_biases: <one-line>
last_checked: YYYY-MM-DD
---
```

Body sections: `## Tier rationale`, `## Authority domain`, `## Access notes`, `## Related pages`.

### Concept page (`.agent-db/wiki/concepts/<name>.md`)

```yaml
---
type: concept
id: <concept-name>
title: <human-readable title>
related_concepts: [<concept-id>, ...]
related_indicators: [<indicator-id>, ...]
related_entities: [<entity-id>, ...]
sources: [<source-id>, ...]            # registered source IDs
last_updated: YYYY-MM-DD
---
```

### Indicator page (`.agent-db/wiki/indicators/<name>.md` + `.yaml`)

The hybrid format already in use. The `.md` adds frontmatter:

```yaml
---
type: indicator
id: <indicator-name>
title: <human-readable title>
publisher: <source-id>                  # must resolve to .agent-db/wiki/sources/
frequency: <daily | monthly | quarterly | annual>
unit: <% YoY | USD/bbl | EUR/MWh | index | ...>
typical_range: <e.g. "1–4%">
classification: leading | coincident | development
related_indicators: [<id>, ...]
last_updated: YYYY-MM-DD
---
```

The `.yaml` keeps the existing structured schema. The `.md` body keeps the human-readable card.

### Event page (`.agent-db/wiki/events/event-YYYY-MM-DD-<slug>.md`)

```yaml
---
type: event
id: event-YYYY-MM-DD-<slug>
date: YYYY-MM-DD
title: <human-readable title>
fact: <one-sentence atomic fact>        # one event = one fact
source: <source-id>                     # must resolve to .agent-db/wiki/sources/
indicators_touched: [<indicator-id>, ...]
concepts_touched: [<concept-id>, ...]
entities_touched: [<entity-id>, ...]
confidence: confirmed | reported | estimated | uncertain
last_updated: YYYY-MM-DD
---
```

Body: a few paragraphs of context, links to surrounding events, the figure or decision in clear prose. **One event = one fact** for new pages; an indicator release with three figures becomes three event pages.

### Entity page (`.agent-db/wiki/entities/<name>.md`)

```yaml
---
type: entity
id: <entity-name>
title: <human-readable title>
kind: ministry | central_bank | swf | soe | regulator | vendor | programme | person
country: qatar | gcc | international
related_concepts: [<id>, ...]
related_entities: [<id>, ...]
sources: [<source-id>, ...]
last_updated: YYYY-MM-DD
---
```

### Brief page (`.agent-db/wiki/briefs/<name>.md`)

Briefs are recurring outputs (e.g. Opportunity Scout). Frontmatter optional but recommended:

```yaml
---
type: brief
id: <brief-id>
title: <human-readable title>
cadence: weekly | monthly | ad-hoc
language: en | ar | en+ar
last_updated: YYYY-MM-DD
---
```

### Question page (`.agent-db/wiki/questions/YYYY-MM-DD-<slug>.md`)

```yaml
---
type: question
id: <YYYY-MM-DD-slug>
question: <the question as asked>
asked_by: <team | user>
answered_by: shaheen | <human-sme-name>
date: YYYY-MM-DD
related_concepts: [<id>, ...]
related_indicators: [<id>, ...]
sources: [<source-id>, ...]
last_updated: YYYY-MM-DD
---
```
