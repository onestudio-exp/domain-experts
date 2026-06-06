---
name: domain-upgrade
description: Audit and uplevel an EXISTING domain expert agent in Claude Code. Reads the agent file, audits it against the framework's 11 dimensions (incl. Domain-vs-Project framing — flags agents coupled to a single product — and Persona homage — offers to rebuild an abstract agent in homage to a real domain figure), walks the user through each recommended change one at a time with tested defaults, then overwrites the agent with the upleveled version plus a KB scaffold and starter prompts if missing. Use when the user wants to uplevel / refit / audit / upgrade an EXISTING agent to fit domain-expert practice. Do NOT use to create a new agent (that's domain-creator).
---

# /domain-upgrade

Audit and uplevel an existing domain expert agent.

Read the agent, audit it against the framework's **11 dimensions**, walk the user
through each recommended change one at a time, then regenerate the agent (plus a KB
scaffold and starter prompts if they don't exist).

## Shared framework assets (read from the sibling `domain-creator` skill)

This skill **upgrades agents onto the same framework `domain-creator` builds them
with** — so it reads the shared assets from that sibling skill directory rather than
carrying drifting copies:

```
../domain-creator/spine/SPINE.md                  # invariant prose + schema catalog (compile target)
../domain-creator/references/agent-template.md    # the agent template (delta layer)
../domain-creator/references/CONTRACT.md          # frontmatter / hub contract
../domain-creator/templates/kb/                   # KB scaffold templates (INDEX.md.tmpl, seed stubs)
../domain-creator/SKILL.md                        # create-mode phases referenced below
```

Both skills ship together in the `domain-experts` plugin, so the sibling path resolves
in every install mode (plugin cache and clone+`./setup` alike). When a step below says
*"run Phase 1.5"* or *"match the Phase 9 scaffold"*, that phase lives in
`../domain-creator/SKILL.md` — open it and follow it inline.

## When to invoke

- User wants to uplevel / refit / audit an EXISTING agent to fit domain-expert practice.
- User has a draft agent and wants to restart cleanly with framework structure.
- An agent was compiled against an older spine (`spine_version` lower than the current
  `../domain-creator/spine/SPINE.md` frontmatter) and needs recompiling.

## When NOT to invoke

- User wants to **create a new agent** → use `domain-creator`.
- User wants to **talk to** an agent in a browser UI → use `domain-chat`.
- User is upgrading a non-domain agent (coding, ops, integration) — this skill is scoped to domain expert agents only.

## How to run

1. **Ask one question per turn.** Wait for the answer. Then ask the next.
2. **Use defaults.** Most changes have a tested default. Show it. Let the user type one keyword to accept.
3. **Show progress.** After each answer, restate what you captured in one short line.
4. **Use short sentences.** Many users are not English-native. One idea per sentence. Simple verbs.
5. **Describe options by shape, not by author.** Patterns are named by structure (e.g., "5-part schema"), never by which agent uses them.
6. **Show drafts before saving.** Never auto-save. The user must say `save`.
7. **Tables for data, code blocks for shapes.** If the user is picking a row, render a markdown table (RTL-safe). If you're showing a template or an output shape, use a code block. Same presentation rules as `domain-creator` — see its "Question template" section for the exact `**Q… / Default / Override**` format every defaulted question uses.

## Step 1 — Locate the agent

**Q1**

Where's the agent? You have two options:

```
path     — give me the full path to the .md file
slug     — give me just the slug, I'll search common locations
```

→ Type a path or a slug.

If slug, search in this order (first match wins; if multiple, list and ask):

```
1. <cwd>/.claude/agents/<slug>.md                                    # project override
2. <cwd>/agents/<slug>.md                                             # local-build
3. ~/.claude/agents/<slug>.md                                         # user-scoped agent
4. ~/.claude/plugins/cache/*/<slug>/*/agents/<slug>.md                # installed plugin (slug = plugin name)
5. ~/.claude/plugins/cache/*/*/*/agents/<slug>.md                     # installed plugin (slug ≠ plugin name)
6. ~/.claude/plugins/marketplaces/*/plugins/<slug>/agents/<slug>.md   # marketplace source, multi-plugin
7. ~/.claude/plugins/marketplaces/*/agents/<slug>.md                   # marketplace source, single-plugin
```

Cache paths are 4 levels deep: `<marketplace>/<plugin>/<version>/agents/`. The version dir is dynamic per install — always glob with `*`.

Capture: `existing_path`, `existing_content` (full file text).

Also probe for sibling artifacts (used in audit):

```
  agents/<slug>-knowledge/        →  capture exists / not exists
  examples/<slug>-starter-prompts.yaml   →  capture exists / not exists
```

## Step 2 — Run the audit

Read the file. Parse YAML frontmatter and body. For each of these **11 dimensions**, classify:

- ✓ **aligned** — present and matches framework
- ⚠ **partial** — present but doesn't match the recommended pattern
- ✗ **missing** — not declared

Dimensions:

```
 1. Identity            slug · display_name · bilingual display name (frontmatter)
 2. Domain              one-liner · geo + language scope ·
                        PROFESSIONAL DOMAIN-LABEL CONVENTION (named practice band +
                        geography-as-modifier + sub-topics — see domain-creator
                        Phase 0.5 Step 0.5.5)
 3. Primary user        role · context · example question
 4. Categories          declared canonical categories (decision_support, etc.)
 5. Output schemas      verdict vocab · response sections · confidence vocab · review schema · etc.
 6. Knowledge           KB structure · live source · memory scope ·
                        HARVESTED KNOWLEDGE (is frameworks/ populated with cited domain
                        canon? is there a sources/official-sources.md live index? — the
                        domain-creator Phase 6 Q6d harvest). A KB with empty folders
                        = ✗ on this sub-check.
 7. Hard rules          out of scope · anti-fabrication
 8. Behavior            pressure-test default
 9. Tools / model       frontmatter tools · model · memory: scope
10. Domain-vs-project   framing leads with a domain (not a product) ·
                        Reference implementation framed as one example ·
                        Comparable peers section listed ·
                        no code-level coupling in body
11. Persona            is the agent built in homage to a real domain figure? (see
                        auto-checks G–I below). An agent with NO persona is NOT a defect
                        — `abstract` is valid. Flag only INCONSISTENT persona handling:
                        a figure named in the body but no `persona:` frontmatter block,
                        a persona with no cited works/profile, or a missing homage
                        disclosure / fabricated-quote guard.
+ Spine version         frontmatter `spine_version` vs the current spine's — older or
                        absent ⇒ flag "compiled against a stale spine; recompile".
+ KB scaffold           does agents/<slug>-knowledge/ exist (with INDEX.md manifest)
+ Starter prompts       does examples/<slug>-starter-prompts.yaml exist
```

**Dimension 10 — auto-checks (regex / structural):**

Run all of these against the file. Any flag → mark dimension 10 as ⚠ or ✗.

```
A. Description leads with a product
   regex on `description:` line — flag if matches:
     /\bfor [A-Z][A-Za-z0-9 ]+\b/         e.g. "for <ProductName>"
     /\b[A-Z][A-Za-z0-9]+ (PM|product manager|expert)\b/  e.g. "<ProductName> expert"
   → ✗ if leads-with-product detected.

B. Persona subtitle binds identity to a venture
   scan for "Operating Persona" / "Project Persona" / "<Venture> Persona"
   in the first 30 lines of the body.
   → ⚠ "subtitle couples identity to one venture; drop or rephrase."

C. Code-level coupling in body
   regex flags (count any 3+ matches as ✗, 1–2 as ⚠):
     - File paths:        /\bapp\/|backend\/|frontend\/|src\/[A-Za-z]/
     - Class names:       /\b[A-Z][a-zA-Z]+(Service|Controller|Repository|Provider|Interface)\b/
     - Commit hashes:     /\b[0-9a-f]{7,40}\b/
     - ORM model refs:    /\bModel:|Migration:|Schema:.*\b/i
   → ⚠/✗ "agent body references a specific codebase; abstract to category-level
     terms or move to a separate ## Reference implementation section."

D. Missing comparable peers
   scan for an `## Comparable peers` (or `## Comparables` / `## Category benchmarks`)
   section in the body.
   → ✗ if absent. *Strongest single signal that the agent is product-coupled.*

E. Missing reference implementation framing
   if a venture name appears in description AND there's no `## Reference implementation`
   section, the venture IS the agent's identity → ⚠.

F. Multi-purpose role
   if the body has a "two layers" / "two jobs" structure where one job is
   domain-expert and the other is "code reviewer" / "codebase auditor" /
   "implementation auditor" → ⚠ "split into two agents; this skill is scoped
   to domain experts only."
```

If the agent has zero issues across A–F: dimension 10 is ✓ aligned. Otherwise enumerate findings in the audit report (see format below) so the user knows exactly which lines triggered each flag.

**Dimension 11 — Persona auto-checks (structural):**

A missing persona is **not** a defect — `abstract` agents are valid and common. These
checks fire only on **inconsistent** persona handling, or to **offer** the homage
upgrade. Run all three.

```
G. Persona declared but incomplete
   if frontmatter has a `persona:` block OR the body says "homage / inspired by
   <Name>" — verify the full contract is present:
     · `# Who you are` carries the homage paragraph (first-person + one-time disclosure)
     · the "one line you never cross" (no fabricated quote/stat as the figure's record)
     · a cited profile at <slug>-knowledge/persona/<figure>-profile.md
   → ⚠ for each missing piece. "persona declared but the homage contract is partial."

H. Figure named in body but no persona block
   if a real person's name appears as the agent's identity/voice in the first 30 lines
   but there is NO `persona:` frontmatter block → ⚠ "the agent already speaks as a real
   figure but isn't declared as a homage persona; formalize it (frontmatter + contract)."

I. Abstract agent — offer (do not flag)
   if no persona signal at all → dimension 11 is ✓ (valid abstract agent). Surface a
   single non-blocking OFFER in the report: "This agent is abstract. Want to rebuild it
   in homage to a real domain figure? (runs domain-creator Phase 1.5 persona
   discovery)." Never auto-add a persona — it changes the agent's identity, so it's the
   user's explicit call. NOTE: if the audit ALSO recommends an identity change, this
   offer becomes the FIRST Step 3 question (persona determines the name — see Step 3
   ordering), and the report should say so next to the offer.
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
   ⚠ KB folders exist but empty — no harvested frameworks, no sources/ index
   → Recommend: add memory: project + KB scaffold dir + run the domain-creator
     Phase 6 Q6d knowledge-harvest workflow to populate frameworks/ +
     sources/official-sources.md

7. Hard rules
   ⚠ out-of-scope present in body, not formalized
   ✗ no explicit anti-fabrication rule
   → Recommend: add hybrid anti-fab rule

8. Behavior
   ✓ "challenge weak ideas" rule present

9. Tools / model
   ✓ tools list OK
   ⚠ no `memory:` field — recommend adding `memory: project`

10. Domain-vs-project framing
    ⚠ description leads with "for <ProductName>" — couples agent to one venture
    ✗ no `## Comparable peers` section — agent has no category to reason against
    ⚠ body references specific class `WhatsAppMessageService.php:42`
    → Recommend: reframe description domain-first; add Reference implementation
      + Comparable peers sections; abstract code-level references to category
      terms.

11. Persona
    ✓ abstract agent (valid) — no real-figure persona declared
    💡 OFFER: rebuild in homage to a real domain figure? (runs domain-creator
       Phase 1.5 discovery)
    [or, when inconsistent:]
    ⚠ body speaks as "<Figure Name>" but no `persona:` frontmatter block
    ⚠ persona declared but no cited profile + no fabricated-quote guard
    → Recommend: formalize the homage contract (frontmatter + disclosure + profile)

──────────────────────────────────────────────

Spine: spine_version 1 (current) ✓   [or: ✗ absent — pre-spine agent; recompile]

Sibling files:
   ✗ KB scaffold missing       → will create agents/<slug>-knowledge/ (with INDEX.md)
   ✗ Starter prompts missing   → will generate from claimed categories
```

## Step 3 — Walk through changes one by one

After the audit, walk the user through each recommended change INDIVIDUALLY. One question per turn. Use the same `default-with-WHY` question template as `domain-creator` (see its "Question template" section). Single-keystroke acceptance.

**Ordering — persona BEFORE identity.** Mirror create mode's order (domain → persona →
identity). Whenever the audit recommends ANY identity change (dimension 1: rename, new
display name, decoupling a project slug), the **dimension 11 persona offer is the FIRST
question** — before identity. The framework's signature move is building the agent in
homage to a **real domain figure**, and the figure *determines* the name (creator
Phase 2 derives slug + display name + Arabic name from the figure). Proposing an
abstract name first and offering a persona last buries the offer and names an agent
you'd immediately rename. So:

1. Persona offer (dimension 11) — accepted → run Phase 1.5 inline, then identity is
   *derived* from the figure (one-tap confirm, creator Phase 2 derivation rules).
2. Identity (dimension 1) — only if the persona was declined: propose the abstract
   rename then.
3. All remaining changes in dimension order (2–10), then sibling files.

If the audit recommends no identity change, the persona offer keeps its natural
position at dimension 11.

**For each recommended change**, ask ONE question. Two dimensions are handled specially:

- **Dimension 11 (Persona)** — present it as an **offer** (the recommended default when
  identity is changing anyway), not a routine change, because adopting a real-figure
  persona changes the agent's identity (and may rename it). If the user accepts, run
  **domain-creator Phase 1.5 Persona Discovery** inline (search → 3 candidates → pick /
  custom / composite), then fold the result into the rewrite. If they decline, the
  agent stays abstract — no change.
- **Dimension 6 harvest** — if the user accepts populating the KB, run the
  **domain-creator Phase 6 Q6d knowledge-harvest workflow** inline and write its outputs
  into the rewrite's KB.

For all other dimensions, ask ONE question:

```
**Change <N> of <total>: <short title>**

Current state in the agent:
  <excerpt from the existing file, OR "not declared">

**✨ Default — <recommended new value>**

```
<aligned shape — code block>
```

*<one-line why this is recommended FOR THIS AGENT, not generic>*

**Override:**

```
<keyword>  — <short alt>
skip       — leave the agent's current state alone
```

→ Type `default`, an override keyword, or `skip`.
```

Behavioral rules during Step 3:

- **One change per turn.** Wait for the user's answer. Then move to the next change.
- **Show progress.** After each answer, briefly: *"Got it — change N: <decision>. Next…"*
- **Tailor the WHY to this agent.** Don't use generic boilerplate. The WHY should reference what the agent already does (e.g., *"Your agent already deflects out-of-scope politely — declaring `pressure_test_default = wait-until-asked` formalizes the current behavior"*).
- **Skip is a real option.** If the user types `skip`, that change is dropped. The existing value stays.
- **Don't bulk-accept by default.** No "type `all` to accept everything" — every change earns its keystroke.

After ALL changes processed, show a compact summary on one screen:

```
**Summary of changes** (X accepted · Y skipped)

✓ Change 1 — Add "Who you serve" section          → accepted (default: VB C-level team)
✓ Change 2 — Declare canonical categories          → accepted (default: reference_lookup, educational_explainer)
✗ Change 3 — Add memory: project                   → skipped
✓ Change 4 — Formalize confidence vocab            → accepted (override: existing five-state — no change)
...
```

Then ask:

```
Type `go` to generate the rewrite, or `back <N>` to revisit one change.
```

## Step 4 — Generate the rewrite (3 files)

Produce all 3 framework outputs, even if some already exist:

**File 1 — agent definition** *(overwrite)*
- Use `../domain-creator/references/agent-template.md` compiled against
  `../domain-creator/spine/SPINE.md` (follow the spine's "Composition rules"; resolve
  every `{{spine:<name>}}` marker; wrap injected regions in
  `<!-- BEGIN SPINE (generated — do not edit) -->` … `<!-- END SPINE -->`; stamp the
  spine's `spine_version` into the agent frontmatter). Frontmatter fields follow
  `../domain-creator/references/CONTRACT.md`.
- Merge: existing aligned values + accepted changes from Step 3.
- Preserve any custom body content from the existing agent that doesn't map to a framework section by appending under `## Custom additions` near the end of the file. Don't silently drop content.

**File 2 — KB scaffold** *(create only if missing; match the canonical create-mode scaffold — do NOT use a different shape for upgrade)*
- If `agents/<slug>-knowledge/` doesn't exist, generate the **same scaffold as
  domain-creator's Phase 9**: an indexable `INDEX.md` manifest (from
  `../domain-creator/templates/kb/INDEX.md.tmpl`) + `README.md` + one folder per
  *derived* canonical category (from `regulations`, `frameworks`, `market-data`,
  `cultural-context`, `vendor-playbooks`, `experience`), plus the seed stubs for any
  category that has a template under `../domain-creator/templates/kb/`.
- If the user accepted **dimension 11 (persona)**, also create `persona/` with the cited `<figure>-profile.md`.
- If the user accepted the **dimension 6 harvest**, also create `sources/official-sources.md` (live index) and populate `frameworks/` from the Q6d workflow output.
- If the KB already exists, leave existing files alone — only ADD missing pieces (never overwrite populated KB).

**File 3 — starter prompts** *(create or extend)*
- If `examples/<slug>-starter-prompts.yaml` doesn't exist, generate from claimed categories: 1–2 prompts per category + 2–3 refusal tests (format per domain-creator's "Output assembly" section, incl. the two persona tests when a persona is adopted).
- If it exists, MERGE: keep existing prompts (they are real-usage gold), add prompts only for categories not yet covered. Mark any new prompts with `# generated by domain-upgrade` comment.

## Step 5 — Show + save

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

## Output destinations

| File | Destination |
|---|---|
| `<slug>.md` | `<existing_path>` (overwrite) |
| `<slug>-knowledge/INDEX.md` | next to the agent (create only if missing) |
| `<slug>-knowledge/README.md` | next to the agent (create only if missing) |
| `<slug>-knowledge/<cat>/<stub>.md` | seed-stub per category with a template under `../domain-creator/templates/kb/<cat>/` (create only if missing) |
| `<slug>-starter-prompts.yaml` | `examples/` next to the agent (merge if exists) |

## Anti-patterns

- **Don't name the agent before the persona decision.** If identity is changing, the
  persona offer comes FIRST and the name is derived from the chosen figure — proposing
  an abstract rename at change 1 and offering a real-figure persona at change 9 buries
  the framework's signature move and names an agent you'd immediately rename.
- **Don't silently drop existing content.** If the original agent has custom sections that don't map to the framework, append under `## Custom additions` — don't lose them.
- **Don't recreate KB if it already exists.** The user may have populated it. Upgrade only ADDS the scaffold if missing; never overwrites existing KB files.
- **Don't overwrite an existing prompts file blindly.** Real-usage prompts are gold. Merge, don't replace.
- **Don't pretend the audit is complete when parsing failed.** If the existing agent's structure is ambiguous (e.g., no headers at all), surface that explicitly: "I couldn't reliably detect X — treating as missing. Confirm or override."
- **Don't paper over project-coupling.** If dimension 10 fires hard (multiple code-level references, "Operating Persona" subtitle, missing Comparables, lead-with-product description), the agent is structurally a project agent — an upgrade alone won't fix it. Tell the user: "This needs a substantive reframe, not a patch. Re-answer domain-creator's Phase 2 domain-framing screen (parts 1–5: domain sentence + reference implementation + comparable peers) — I'll regenerate the body around the new framing instead of patching the old one."
- **Don't auto-add a persona.** Dimension 11 is an *offer*, never an automatic change — adopting a real figure rewrites the agent's identity (and may rename it). Only run domain-creator Phase 1.5 if the user explicitly accepts. An `abstract` agent passing every other dimension is fully aligned.
- **Don't scaffold the KB with a divergent shape.** Upgrade must emit the **same** canonical scaffold as domain-creator's create mode (INDEX.md manifest + derived category folders incl. `experience/`, + `persona/`/`sources/` when those features are accepted) — not a different layout. An upgrade that produces a different KB shape than create is a drift bug.
- **Don't fabricate harvested knowledge to fill an empty KB.** If the user accepts the dimension-6 harvest, run the real Q6d workflow — never hand-write frameworks/sources from memory. Empty stays empty until evidence exists.
- **Don't duplicate the spine or template into this skill.** They live in `../domain-creator/` on purpose — one source of truth. If you can't resolve the sibling path, say so; don't reconstruct the spine from memory.
