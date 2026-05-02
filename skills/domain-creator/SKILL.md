---
name: domain-creator
description: Build or uplevel a domain expert agent in Claude Code. Two modes — (1) CREATE: interview the user with ~10 short questions and produce a new agent definition, knowledge scaffold, and starter prompt set; (2) REFIT: read an existing agent file, audit it against the framework's 9 dimensions, advise the user which changes to apply, then overwrite the agent with the upleveled version plus a KB scaffold and starter prompts if missing. Most questions have a tested default the user can accept with one keystroke. Use when the user wants to create a NEW agent OR uplevel an EXISTING one to fit domain-expert practice. Do not use for adding knowledge to an existing agent (that's domain-capture).
---

# /domain-creator

Build or uplevel a domain expert agent.

Two modes:
- **Create** — interview the user, produce a new agent + KB scaffold + starter prompts.
- **Refit** — read an existing agent, audit it, apply framework changes, overwrite it (and add KB scaffold + starter prompts if they don't exist).

Both modes produce the same 3 outputs: `agents/<slug>.md`, `agents/<slug>-knowledge/README.md`, `examples/<slug>-starter-prompts.yaml`.

## When to invoke

- User wants to create a new domain expert agent.
- User wants to uplevel/refit an EXISTING agent to fit domain-expert practice.
- User has a draft agent and wants to restart cleanly with framework structure.

## When NOT to invoke

- User wants to **add new knowledge** to an existing agent → use `domain-capture`.
- User wants to **evaluate** an existing agent → use `domain-eval`.
- User is creating a non-domain agent (coding, ops, integration) — this skill is scoped to domain expert agents only.

## How to run

1. **Ask one question per turn.** Wait for the answer. Then ask the next.
2. **Use defaults.** Most schema questions have a tested default. Show it. Let the user type one keyword to accept.
3. **Show progress.** After each answer, restate what you captured in one short line.
4. **Use short sentences.** Many users are not English-native. One idea per sentence. Simple verbs.
5. **Describe options by shape, not by author.** Patterns are named by structure (e.g., "5-part schema"), never by which agent uses them.
6. **Loop on incomplete answers.** If a one-word answer needs more, follow up specifically.
7. **Show drafts before saving.** Never auto-save. The user must say `save`.

## Question template

Every question with a default uses this exact format:

```
**Q<N> — <Field>**

<one-line question>

**✨ Default — <name>**

```
<aligned shape — code block for monospace clarity>
```

*<one-line why>*

**Override:**

```
keyword  — short explanation
keyword  — short explanation
custom   — write your own
```

→ Type `default`, `keyword`, ..., or `custom`.
```

Questions without a meaningful default (slug, user, out-of-scope) skip the Default block.

## Phase 0 — Mode detection

**Q0 — New or refit?**

Are we creating a new agent, or refitting an existing one?

```
new      — start from scratch (Phase 1 onward)
refit    — read an existing agent, audit it, apply framework changes
```

→ Type `new` or `refit`.

If `new` → continue to **Create mode** below (Phases 1–9).
If `refit` → jump to **Refit mode** (after Phase 9).

---

## Create mode — the 9-phase interview

### Phase 1 — Identity

**Q1 — Slug + display name**

What's the slug (lowercase, snake_case) and display name (proper case)? Add a non-English display name only if the domain is bilingual.

```
Examples:  slug: tax-advisor    display: Tax Advisor
           slug: pricing-pro    display: Pricing Pro
           slug: nala           display: Nala         ar: نالا
```

→ Type slug + display name (and optional Arabic name).

Capture: `slug`, `display_name`, `display_name_ar`.

---

### Phase 2 — Domain

**Q2 — Domain in one sentence**

Describe the agent's domain in one sentence.

```
Three useful shapes:
  [market/regulatory] expert for [geography]
  [product practice] expert for [audience]
  [research domain] expert for [user]
```

→ Write one sentence.

Capture: `domain_one_liner`.

**Q2b — Geographic + language scope** *(skip if Q2 already implies it)*

If Q2 mentions a non-English geography, smart-default to bilingual and confirm. Otherwise ask:

**✨ Default — monolingual English**

*Most agents work in one language. Add bilingual only when the domain demands it.*

**Override:**

```
bilingual   — pick primary language + one to switch to on user signal
custom      — describe your own setup
```

→ Type `default`, `bilingual`, or `custom`.

Capture: `geo_scope`, `bilingual` (bool), `languages`, `primary_language`.

---

### Phase 3 — User

**Q3 — Primary user**

Who's the primary user? Their role, what they're doing, and one example question they'd bring.

```
Format:
  Role:     <role + seniority>
  Context:  <what they're doing>
  Example:  <a real question they'd ask>
```

→ Fill in all three.

Capture: `user_role`, `user_context`, `example_question`.

If they skip the example, ask again — the example anchors the agent's voice.

---

### Phase 4 — Primary work

**Q4 — Categories of work**

Pick 1–3 categories. Primary first.

```
1. decision_support      — structured verdict with reasoning
2. reference_lookup      — cited answers to domain questions
3. structured_review     — audit an artifact, return categorized findings
4. competitive_intel     — profile competitors, comparables
5. regulatory_compliance — apply named regulations
6. handoff_partner       — structured briefs for other agents/humans
7. educational_explainer — teach domain concepts
```

→ Type the numbers. Primary first.

If user picks more than 3, gently note: *"That's broad. Most agents focus on 1–3. Want to mark a primary and use defaults for the rest?"*

Capture: `primary_categories`.

---

### Phase 5 — Output schemas (branched on Phase 4)

For EACH primary category in the answer, ask the relevant schema question. Skip categories not chosen.

#### Q5a — Verdict vocabulary *(if `decision_support` claimed)*

What words end every decision?

**✨ Default — pick from your domain**

```
Product decision      →  Yes / No / Needs adjustment
Investment decision   →  Invest / Hold / Pivot / Kill
Review decision       →  APPROVED / PROVISIONAL / REJECTED
Validation decision   →  Go / Go-with-conditions / No-Go
```

*3–5 words is the sweet spot. Easy to scan. Clear meaning.*

**Override:**

```
custom  — write your own
```

→ Type a vocabulary, or `custom`.

Capture: `verdict_vocab`.

#### Q5b — Decision schema *(if `decision_support` claimed)*

How does every decision answer look?

**✨ Default — adaptive**

```
Always:       Verdict · Why
When needed:  Risks · Conditions · Impact · Next steps
```

*Light questions stay short. Heavy ones go deep.*

**Override:**

```
rigid    — always show 5 sections (Decision/Why/Risks/Alt/Impact)
7-step   — full advisory (Clarification → Options → Trade-offs → ... → Follow-ups)
3-block  — short action format (Bottom-line/Why/Action)
custom   — write your own
```

→ Type `default`, `rigid`, `7-step`, `3-block`, or `custom`.

Capture: `response_sections`.

#### Q5c — Confidence vocabulary *(if `reference_lookup` claimed)*

How does the agent label uncertain claims?

**✨ Default — three-state tags**

```
[VERIFIED]      — cited and confirmed
[UNVERIFIED]    — stated, not cross-checked
[NEEDS-RESEARCH] — agent doesn't know; flagged
```

*Three states is enough. More is rarely used.*

**Override:**

```
five-state    — confirmed / reported / estimated / uncertain / not knowable
source-tier   — Tier 1 (official) / Tier 2 (analysis) / Tier 3 (synthesis)
experience    — direct experience / readings / general context / official source
kb-citation   — [knowledge/<path>.md] / [source: <url>]
custom        — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `confidence_vocab`.

#### Q5d — Review schema *(if `structured_review` claimed)*

What sections does every review have?

**✨ Default — severity-marker schema**

```
🔴 Blockers          — issues that prevent moving forward
🟡 Friction          — issues that slow but don't block
🟢 Wins              — strengths to preserve
❓ Open questions    — unresolved before deciding
🚏 Routed            — findings for legal / finance / other roles
```

*Colored markers make the review skimmable. Routed forces explicit hand-offs.*

**Override:**

```
8-section   — Executive Summary / Mode / Confidence / [domain] / Unknowns
verdict-fields — single verdict + conditional follow-ups
custom      — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `review_sections`.

#### Q5e — Competitor classification *(if `competitive_intel` claimed)*

How are competitors classified?

**✨ Default — three-tier**

```
Direct       — same problem, same audience, same approach
Indirect     — similar problem, different model
Substitute   — different category, replaces in practice
```

*Mutually exclusive tiers force clarity. Most teams overstate "direct".*

**Override:**

```
matrix-only  — comparison matrix, no tiering
custom       — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `competitor_classification`.

#### Q5f — Regulation citation rule *(if `regulatory_compliance` claimed)*

How are regulations cited?

**✨ Default — article-level + applicability check**

```
Format:  <Reg-Name> Article <N> (<year>), applies to <geography> <segment>
Example: PDPL Article 22 (2023), applies to KSA-resident data subjects
```

*Article-level is auditable. The applicability check stops vague compliance gestures.*

**Override:**

```
name-year-url  — regulation name + year + source URL
custom         — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `regulation_citation_rule`.

#### Q5g — Handoff brief format *(if `handoff_partner` claimed)*

What's in every handoff brief?

**✨ Default — six-part brief**

```
1. Question being handed off
2. Receiver context
3. Domain constraints to honor
4. What NOT to prescribe
5. What good looks like
6. Open questions for the receiver
```

*Covers the failure modes of cross-role handoffs. Hard to improve on.*

**Override:**

```
custom  — describe your own format
```

→ Type `default` or `custom`.

Capture: `handoff_format`.

#### Q5h — Pedagogical structure *(if `educational_explainer` claimed)*

What's the structure of every explanation?

**✨ Default — five-part teaching schema**

```
1. Simple definition
2. Why it matters
3. Practical example
4. Common mistake
5. How it applies to your context
```

*Forces examples and pitfalls. Pure definitions feel academic.*

**Override:**

```
4-part   — Definition / Example / Anti-pattern / Application
custom   — write your own
```

→ Type `default`, `4-part`, or `custom`.

Capture: `explainer_structure`.

---

### Phase 6 — Knowledge

**Q6 — Knowledge categories**

What knowledge does the agent need that ISN'T in code or live external sources? Pick all that apply.

```
1. Regulations and statutes
2. Industry frameworks and methodologies
3. Market data and benchmarks
4. Cultural / linguistic context
5. Vendor / competitor playbooks
6. Personal experience anchored to a community
7. None — the agent reasons from prompt context only
```

→ Type the numbers, or `all` / `none`.

Capture: `kb_categories`.

**Q6b — Live source access** *(skip if Q6 = none)*

Should the agent read live source files at runtime?

**✨ Default — yes**

```
Live source = real files the agent reads at runtime via Read/Glob/Grep.
KB = static reference material (regulations, frameworks, playbooks).
Never copy live source into the KB. The agent reads it live.
```

*Static snapshots go stale. Live reads stay current.*

**Override:**

```
no  — the agent uses KB only, no live source
```

→ Type `default` or `no`.

If `default`, ask for one path or accept `TBD`.

Capture: `live_source_access` (bool), `live_source_paths` (list, OK to be `TBD`).

**Q6c — Memory scope**

Should the agent remember things across sessions?

**✨ Default — yes, project scope**

```
Path:    .claude/agent-memory/<slug>/MEMORY.md
Scope:   project (committed to the team's repo)
Loading: CC injects the first 200 lines into the agent's prompt at session start.
```

*Project = team-shared memory. The team's institutional knowledge travels with the codebase.*

**Override:**

```
user   — ~/.claude/agent-memory/<slug>/MEMORY.md   (cross-project, single-user)
local  — .claude/agent-memory-local/<slug>/        (project-scoped, NOT committed)
none   — stateless agent, every session starts fresh
```

→ Type `default`, `user`, `local`, or `none`.

Capture: `memory_enabled`, `memory_scope`.

---

### Phase 7 — Hard rules

**Q7 — Out of scope**

What does the agent refuse to advise on, or redirect?

```
Common shapes:
  • Adjacent specialist domains (legal, tax, regulated specialties)
  • Implementation work (code, design, copywriting)
  • Decisions belonging to other roles
  • Out-of-domain questions
```

→ List 2–4 things.

Capture: `out_of_scope`.

**Q7b — Anti-fabrication rule**

How does the agent prevent fabrication?

**✨ Default — hybrid**

```
Empirical claims (numbers, facts, dates)        →  ≥2 independent sources
Methodology references (frameworks, playbooks)  →  1 source + confidence tag
Internal team decisions (in agent's memory)     →  no external citation needed
```

*Empirical fabrication causes the most damage. Internal decisions are the team's own ground truth.*

**Override:**

```
two-source   — every empirical claim needs ≥2 sources, no exceptions
one-tagged   — single source acceptable everywhere if labeled
experience   — direct experience uncited; external claims must cite
strict       — no claims without citation, period
custom       — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `anti_fabrication_rule`.

---

### Phase 8 — Behavior

**Q8 — Pressure-testing default**

When the user brings a proposal, should the agent challenge it by default?

**✨ Default — yes**

```
The agent challenges weak assumptions, surfaces risks,
and refuses to validate thin reasoning.
Disagreement is stated directly.
```

*A domain expert agent earns its keep by adding a lens the user didn't have.*

**Override:**

```
wait-until-asked  — responsive consultant. Raise risks only when material.
                    Use for reference-only or explainer-only agents.
```

→ Type `default` or `wait-until-asked`.

Capture: `pressure_test_default`.

---

### Phase 9 — Confirm and generate

After all answers captured:

1. **Show running summary.** Compact table of every captured answer. Mark which fields used the default vs. were overridden.
2. **Ask:** *"Look right? Type `go` to generate the files, or call out edits."*
3. **On `go`, produce 3 files** (do NOT write to disk yet):
   - `agents/<slug>.md` — agent definition (use `references/agent-template.md`)
   - `agents/<slug>-knowledge/README.md` — KB scaffold (skip if `kb_categories` = none)
   - `examples/<slug>-starter-prompts.yaml` — 5–12 starter prompts (1–2 per claimed category + 2–3 refusal tests)
4. **Show the generated files inline.**
5. **Ask:** *"Save these 3 files? Or say `edit X` first."*
6. **On `save`, write to disk.**

## Refit mode — uplevel an existing agent

When the user picks `refit` in Phase 0, follow these steps. The goal is to migrate an existing agent to fit framework practice and produce all 3 framework files (agent definition + KB scaffold + starter prompts).

### Step R1 — Locate the agent

**Q-R1**

Where's the agent? You have two options:

```
path     — give me the full path to the .md file
slug     — give me just the slug, I'll search common locations
```

→ Type a path or a slug.

If slug, search in this order (first match wins; if multiple, list and ask):

```
1. <cwd>/.claude/agents/<slug>.md
2. ~/.claude/agents/<slug>.md
3. ~/onestudio-exp/agents/.claude/agents/<slug>.md
4. ~/.claude/plugins/marketplaces/*/agents/<slug>.md
5. ~/.claude/plugins/cache/*/*/*/agents/<slug>.md
```

Capture: `existing_path`, `existing_content` (full file text).

Also probe for sibling artifacts (used in audit):

```
  agents/<slug>-knowledge/        →  capture exists / not exists
  examples/<slug>-starter-prompts.yaml   →  capture exists / not exists
```

### Step R2 — Run the audit

Read the file. Parse YAML frontmatter and body. For each of these 9 dimensions, classify:

- ✓ **aligned** — present and matches framework
- ⚠ **partial** — present but doesn't match the recommended pattern
- ✗ **missing** — not declared

Dimensions:

```
1. Identity            slug · display_name · bilingual display name (frontmatter)
2. Domain              one-liner · geo + language scope
3. Primary user        role · context · example question
4. Categories          declared canonical categories (decision_support, etc.)
5. Output schemas      verdict vocab · response sections · confidence vocab · review schema · etc.
6. Knowledge           KB structure · live source · memory scope
7. Hard rules          out of scope · anti-fabrication
8. Behavior            pressure-test default
9. Tools / model       frontmatter tools · model · memory: scope
+ KB scaffold          does agents/<slug>-knowledge/ exist
+ Starter prompts      does examples/<slug>-starter-prompts.yaml exist
```

**Audit report format:**

```
**Audit for <slug>** (path: <existing_path>)

✓ aligned (N)        ⚠ partial (M)        ✗ missing (K)

──────────────────────────────────────────────
1. Identity
   ✓ slug + display_name OK
   ⚠ display_name_ar missing (body uses Arabic)

2. Domain
   ✓ one-liner: "<excerpt>"
   ⚠ language handling not declared explicitly

3. Primary user
   ✗ no "Who you serve" section
   → Recommend: add user role + example question

4. Categories
   ✓ decision_support detected (3-block schema present)
   ✗ no other categories declared
   → Recommend: declare additional categories or confirm decision-only scope

5. Output schemas
   ⚠ decision uses 3-block (good); confidence vocab inconsistent
   → Recommend: standardize to three-state tags

6. Knowledge
   ✗ no KB structure
   ✗ no memory declared
   → Recommend: add memory: project + KB scaffold dir

7. Hard rules
   ⚠ out-of-scope present in body, not formalized
   ✗ no explicit anti-fabrication rule
   → Recommend: add hybrid anti-fab rule

8. Behavior
   ✓ "challenge weak ideas" rule present

9. Tools / model
   ✓ tools list OK
   ⚠ no `memory:` field — recommend adding `memory: project`

──────────────────────────────────────────────

Sibling files:
   ✗ KB scaffold missing       → will create agents/<slug>-knowledge/
   ✗ Starter prompts missing   → will generate from claimed categories
```

### Step R3 — Get acceptance

Ask:

```
Apply changes? Options:
  all       — apply every recommended change
  pick      — choose changes by number (e.g. "1, 4, 7")
  diff      — show me the proposed full rewrite first
  skip      — exit without changes
```

→ Type one option.

If `pick`, show numbered list of every recommended change; user replies with selected numbers.
If `diff`, render the rewrite using the existing template + accepted changes; show inline; back to acceptance.

### Step R4 — Interview only the gaps

For each accepted change that needs a value the existing agent doesn't already have, run the equivalent question from Phase 1–9 in **default-on-default style**:

- Most users will type `default` to accept the framework's tested choice.
- Skip questions where the agent's existing value is already aligned.
- Skip questions where the user said `skip` for that dimension in R3.

Capture all new/changed fields.

### Step R5 — Generate the rewrite (3 files)

Produce all 3 framework outputs, even if some already exist:

**File 1 — agent definition** *(overwrite)*
- Use `references/agent-template.md`.
- Merge: existing aligned values + accepted changes from R3 + new values from R4.
- Preserve any custom body content from the existing agent that doesn't map to a framework section by appending under `## Custom additions` near the end of the file. Don't silently drop content.

**File 2 — KB scaffold** *(create only if missing)*
- If `agents/<slug>-knowledge/` doesn't exist, generate `README.md` + 5 subdirectories (`regulations/`, `frameworks/`, `market-data/`, `cultural-context/`, `vendor-playbooks/`) — same structure as create mode.
- If it already exists, leave the existing structure alone.

**File 3 — starter prompts** *(create or extend)*
- If `examples/<slug>-starter-prompts.yaml` doesn't exist, generate from claimed categories: 1–2 prompts per category + 2–3 refusal tests.
- If it exists, MERGE: keep existing prompts (they are real-usage gold), add prompts only for categories not yet covered. Mark any new prompts with `# generated by domain-creator refit` comment.

### Step R6 — Show + save

Show all 3 files inline in this order:

1. Agent definition (the overwrite — most important to review)
2. KB scaffold README (if newly created)
3. Starter prompts file (full content if newly created; just the diff if extended)

Show a one-line summary diff per file:

```
agents/<slug>.md                            ← overwrite (N lines, M sections changed)
agents/<slug>-knowledge/README.md           ← create (new)
examples/<slug>-starter-prompts.yaml        ← extended (+K new prompts)
```

Ask:

```
Save options:
  save        — write all changes to disk
  save-as     — save the agent .md to a new path (specify); KB + prompts go to default
  edit X      — edit something first
  cancel      — discard the rewrite
```

→ Type one option.

On `save`, write all 3 files. The agent .md goes to `existing_path` (overwrite). KB and prompts go to their conventional paths relative to the agent's parent dir.

### Refit-specific anti-patterns

- **Don't silently drop existing content.** If the original agent has custom sections that don't map to the framework, append under `## Custom additions` — don't lose them.
- **Don't recreate KB if it already exists.** The user may have populated it. Refit only ADDS the scaffold if missing; never overwrites existing KB files.
- **Don't overwrite an existing prompts file blindly.** Real-usage prompts are gold. Merge, don't replace.
- **Don't pretend the audit is complete when parsing failed.** If the existing agent's structure is ambiguous (e.g., no headers at all), surface that explicitly: "I couldn't reliably detect X — treating as missing. Confirm or override."

---

## Pattern library (reference)

When a user picks an override or `custom`, these are the empirical patterns observed in production. Described by structural shape only.

| Pattern | Shape |
|---|---|
| 5-part decision | Decision · Why · Risks · Alternative · Impact |
| 7-step advisory | Clarification · Options · Trade-offs · Implications · Risks · Recommendation · Follow-ups |
| 3-block decision | Bottom-line · Why · Action |
| BLUF + 5 sections | Bottom line · Context · Analysis · Trade-offs · Next steps · Open questions |
| 8-section CI report | Executive Summary · Mode/Date/Confidence · [domain sections] · Unknowns |
| Severity-marker review | 🔴 Blockers · 🟡 Friction · 🟢 Wins · ❓ Open questions · 🚏 Routed |
| Verdict + conditional fields | Verdict + Confirm-Before-Ship / Reframed-Requirement / Questions-Before-Build |
| 3-tier competitor | Direct · Indirect · Substitute |
| 5-part educational | Definition · Why-matters · Example · Mistake · Application |
| 6-part handoff brief | Question · Receiver-context · Constraints · NOT-to-prescribe · Good-shape · Open-questions |
| 3-state confidence | `[VERIFIED]` · `[UNVERIFIED]` · `[NEEDS-RESEARCH]` |
| 5-state confidence | `confirmed` · `reported` · `estimated` · `uncertain` · `not knowable` |
| Source-tier labels | `Tier 1 (official)` · `Tier 2 (analysis)` · `Tier 3 (synthesis)` |
| Experience-rooted vocab | `from direct experience` · `from readings` · `from general context` · `from official source` |
| Two-source rule | Every empirical claim needs ≥2 independent credible sources |

## Output assembly

Both modes produce the same 3 files using the same template — only the destination paths and overwrite behavior differ.

| File | Create mode destination | Refit mode destination |
|---|---|---|
| `<slug>.md` | `agents/<slug>.md` (new) | `<existing_path>` (overwrite) |
| `<slug>-knowledge/README.md` | `agents/<slug>-knowledge/README.md` (new) | same path next to existing agent (create only if missing) |
| `<slug>-starter-prompts.yaml` | `examples/<slug>-starter-prompts.yaml` (new) | same path (merge if exists) |

Read `references/agent-template.md` once before generating. Fill in placeholders from captured answers.

For sections that depend on Phase 4 choices (e.g., the agent only includes a "Decision schema" section if it claimed `decision_support`), conditionally include or omit those sections.

For starter prompts in `examples/<slug>-starter-prompts.yaml`, generate 5–12 prompts: 1–2 per claimed canonical category, plus 2–3 adversarial prompts that test refusal rules. Format:

```yaml
slug: <slug>
prompts:
  - id: <category>-001
    category: <canonical_id>
    consumer: for_human    # or for_agent
    text: |
      <a realistic prompt the user would bring>
  - id: refusal-001
    category: refusal_test
    consumer: for_human
    expects_refusal: true
    text: |
      <a prompt that should be refused per the agent's hard rules>
    notes: |
      <why this should be refused>
```

## Anti-patterns

- **Don't ask 30 questions.** Defaults exist so the user can accept with one keystroke. Total interview should be ~10 user turns.
- **Don't reference source agents by name.** Patterns are named by shape, not author.
- **Don't force defaults that don't fit.** Defaults are recommended, not imposed.
- **Don't write code or run benchmarks.** Evaluation is `domain-eval`'s job.
- **Don't impose canonical categories.** If the user's work doesn't map, capture as agent-specific.
- **Don't auto-save.** Wait for `save`.
- **Don't write long sentences.** One idea per sentence. Simple verbs.
