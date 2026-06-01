---
name: domain-creator
description: Build or uplevel a domain expert agent in Claude Code. Three entry paths — (1) CREATE from scratch: interview the user with ~10 short questions and produce a new agent definition, knowledge scaffold, and starter prompt set; (2) CREATE with context-aware prefill: scan the venture for ALL useful context (PRD, README, CLAUDE.md, specs, plans, discovery docs — any markdown with strong signal density), let the user pick which files to merge, then propose answers for identity / domain / primary user / categories / reference implementation / comparable peers with per-field confidence and source citations — collapsing the interview to ~3 turns. Domain-widening enforced: the product described becomes the Reference Implementation, never the agent's identity; (3) REFIT: read an existing agent file, audit it against the framework's 10 dimensions (incl. Domain-vs-Project framing — flags agents coupled to a single product instead of a category), advise the user which changes to apply, then overwrite the agent with the upleveled version plus a KB scaffold and starter prompts if missing. Most questions have a tested default the user can accept with one keystroke. Use when the user wants to create a NEW agent (from blank or with context prefill) OR uplevel an EXISTING one to fit domain-expert practice. Do not use for adding knowledge to an existing agent (that's domain-capture).
---

# /domain-creator

Build or uplevel a domain expert agent.

Two modes, three entry paths:

- **Create — blank** — interview the user from scratch, produce a new agent + KB scaffold + starter prompts.
- **Create — with context-aware prefill** *(v0.6: replaces the PRD-only path)* — scan the venture for ALL useful context (PRD, README, CLAUDE.md, specs, plans, discovery docs, vision docs — any markdown with strong signal density), rank candidates, let the user pick which files to merge, then propose values for identity / domain / primary user / categories / reference implementation / comparable peers with **per-field confidence** and **source citations**. The user accepts or edits each field, then continues with output-schema questions only. **Domain-widening is enforced**: the product described becomes the Reference Implementation, never the agent's identity — the agent is built around the wider *category*.
- **Refit** — read an existing agent, audit it, apply framework changes, overwrite it (and add KB scaffold + starter prompts if they don't exist).

All paths produce the same 3 outputs: `agents/<slug>.md`, `agents/<slug>-knowledge/README.md`, `examples/<slug>-starter-prompts.yaml`.

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

If `new` → continue to **Phase 0.5 — Context Discovery & Synthesis** (below).
If `refit` → jump to **Refit mode** (after Phase 9).

---

## Phase 0.5 — Context Discovery & Synthesis *(v0.6 — replaces PRD-only prefill)*

Before launching the 10-turn interview, scan the venture for ALL useful context — not just a PRD. A typical OneStudio venture has signal scattered across `README.md`, `CLAUDE.md`, `docs/`, `specs/`, `plans/`, and discovery notes. Reading multiple sources at once produces a far richer prefill than locking onto one file.

This phase is **mode-gated to `new`**. If the user picked `refit` in Phase 0, skip directly to Refit mode.

The flow:

1. **Discover** candidate context files across the venture.
2. **Rank** them by signal density.
3. **Ask** the user which to read (all / top-N / pick / custom paths / skip).
4. **Read + synthesize** — extract candidate values, each with confidence + source citations.
5. **Enforce** domain-widening discipline.
6. **Present** a single proposal screen with per-field confidence colors.
7. **Resolve** — accept, edit, widen, narrow, verify, add source, or restart.

### Step 0.5.1 — Discover context candidates

Run a multi-path scan. For each `*.md` file in these locations, capture name + line count + last-modified:

```
Tier 1 (repo root):
  README.md · CLAUDE.md · AGENTS.md · VISION.md · prd.md · PRD.md

Tier 2 (common doc folders):
  docs/*.md         (all, not just one)
  specs/*.md
  plans/*.md
  discovery/*.md
  .github/copilot-instructions.md

Tier 3 (assistant context):
  .claude/CLAUDE.md   (note: read-only context, not for extraction)
```

Cap discovery at 20 candidates. If a folder contains > 8 markdown files, take only the 8 most-recently-modified.

**If zero candidates exist:** skip directly to Phase 1 — there is nothing to prefill from. Don't ask Q0.5.

### Step 0.5.2 — Rank by signal density

For each candidate, compute a score:

```
+ 3   filename contains: prd · vision · brief · spec · overview · architecture
+ 2   ≥ 5 markdown headings
+ 2   contains domain keywords (audience · user · scope · market · regulation ·
       compliance · jurisdiction · stakeholder · workflow · feature)
+ 2   filename is CLAUDE.md (high-signal: project rules + decisions)
+ 1   ≥ 200 lines
+ 1   last modified within 30 days
- 2   filename matches: CHANGELOG · LICENSE · CONTRIBUTING · CODE_OF_CONDUCT
```

Sort descending. Reject candidates with score < 2 (low signal). Keep top 10.

### Step 0.5.3 — Present + ask once

**Q0.5 — Read context from the venture?**

Show the ranked list with star-rating (★ per 2 score points, max 5):

```
I found these context candidates (ranked by signal density):

  [1] docs/prd.md                  ★★★★★  (PRD, 800 lines, 24 headings)
  [2] CLAUDE.md                    ★★★★    (project rules, 400 lines)
  [3] specs/00-foundation.md       ★★★★    (foundational spec, 600 lines)
  [4] docs/architecture.md         ★★★     (architecture, 320 lines)
  [5] README.md                    ★★       (readme, 180 lines)

How should I read?

  all       — read everything and synthesize (best quality, slowest)
  top-3     — read the top 3 only (balanced — recommended default)
  top-5     — read the top 5
  pick N,M  — list comma-separated indices (e.g. "1,2,4")
  custom    — give me a path I haven't discovered
  skip      — run the full interview, no prefill
```

→ Type one option.

If user types `custom`, ask for one path, verify it exists, append it to the list, and re-show this prompt.

If user types `skip` → jump to Phase 1.

Otherwise → continue to Step 0.5.4 with the selected set.

### Step 0.5.4 — Read + synthesize

Use the Read tool to load each selected file end-to-end. While reading, build an in-memory candidate map for each prefill field. **A single field may draw evidence from multiple files** — record every source.

Fields to extract:

```
slug                       kebab-case noun for the DOMAIN (NOT a product name)
display_name               proper-case domain name
display_name_ar            optional — only if any source contains Arabic
domain_one_liner           the WIDER category, never a specific product
geo_scope                  any geography mentioned (MENA, KSA, GCC, …)
bilingual + languages      true if any source is bilingual or names a non-English audience
primary_user               role + seniority (from user/audience/customer sections)
user_context               what they're doing (from use cases / scenarios)
example_question           a real question that user would bring to the agent
primary_categories         1–3 categories from Phase 4's canonical list
reference_implementation   the venture/product described in the sources (name, role, note)
comparable_peers           3–7 named peer companies in the same category
out_of_scope_hints         any "we won't do X" or "out of scope" language (for Phase 7)
```

For each extracted value, attach **confidence + sources[]**:

```yaml
domain_one_liner:
  value: "merchant-funded loyalty in MENA, focused on retention economics"
  confidence: high              # high | medium | low
  sources:
    - file: docs/prd.md
      lines: "4-12"
      quote: "We help MENA retailers fund cashback…"
    - file: CLAUDE.md
      lines: "§1"
      quote: "Loyalty platform serving regional brands"
  derived: false                # true if no direct quote; LLM inferred
```

**Confidence rules:**

- **high** — value extracted nearly verbatim from a quoted phrase in at least one source.
- **medium** — value synthesized across multiple sources, no single direct quote.
- **low** — value guessed or inferred without clear textual evidence (e.g. peers list with no source mentioning competitors).

### Step 0.5.5 — Enforce domain widening *(critical — unchanged from v0.5)*

The sources almost always describe ONE specific product. The agent's domain MUST be the wider category, never the product itself. Apply these checks **before showing the proposal**:

**Examples — required widening:**

```
Sources describe "Member Plus" (loyalty platform)
  ✗ domain: "Member Plus expert"
  ✓ domain: "merchant-funded loyalty in MENA"
  → Reference implementation: Member Plus
  → Peers: Bilt, Rakuten, Entertainer, Collinson, Sprive

Sources describe "RevXAI Auditor" (AI code reviewer)
  ✗ domain: "RevXAI expert"
  ✓ domain: "AI-assisted code review for rapid-prototype apps"
  → Reference implementation: RevXAI Auditor
  → Peers: Snyk, SonarQube, CodeRabbit, GreptileAI, DeepCode

Sources describe "TaxFlow" (bilingual GCC tax practice platform)
  ✗ domain: "TaxFlow expert"
  ✓ domain: "GCC tax compliance across VAT, CT, and Excise"
  → Reference implementation: TaxFlow
  → Peers: PwC ME, Deloitte ME, EY ME, KPMG ME, BDO ME
```

**Auto-checks (run before presenting):**

- `slug` MUST NOT contain a product name from any source.
- `domain_one_liner` MUST NOT begin with `for <ProductName>` or `<ProductName> expert`.
- `domain_one_liner` MUST describe a body of knowledge applicable to **multiple companies**.
- `comparable_peers` MUST list **≥3 named companies/products** that aren't the venture's subject.

If any check fails, **fix it silently before showing the user**. Don't show a draft you'd have to apologize for. Demote the field's confidence to `medium` after a domain-widening fix (the value is now LLM-synthesized, not directly extracted).

**Project-detection fallback:** if no peers can be found, the work is likely a *project*, not a *domain*. Surface explicitly:

> "I can't find a wider category for this — the sources read as one specific product without peers. A project-PM agent is a legitimate ask, but it's NOT what this skill produces. Want me to (a) push you to articulate the wider domain anyway, or (b) bail and recommend a generic Claude Code subagent with your CLAUDE.md as context?"

### Step 0.5.6 — Present the proposal

Show **one compact screen** with confidence colors. Use 🟢 (high), 🟡 (medium), 🔴 (low) markers.

```
**Proposed framing** — synthesized from N sources

  Field               Proposed                                       Conf.   Source
  ─────────────────   ───────────────────────────────────────────    ────    ──────
  Slug                gcc-tax-compliance                             🟢      derived
  Display name        GCC Tax Compliance · امتثال ضريبي خليجي         🟢      PRD title
  Domain              GCC tax compliance across VAT, CT, Excise        🟢      PRD §1, CLAUDE.md §1
  Geo / language      GCC, bilingual EN/AR                              🟢      PRD §2, CLAUDE.md §1
  Primary user        Tax advisors serving GCC clients                  🟡      derived from PRD §3
  User context        Filing VAT returns + advising on CT obligations   🟡      PRD §5–7
  Example question    "How do I treat reverse-charge VAT on imports     🟡      derived
                      between UAE and KSA?"
  Primary categories  regulatory_compliance, reference_lookup           🟢      PRD §1, §5
  Reference impl.     TaxFlow                                           🟢      PRD title
  Comparable peers    PwC ME, Deloitte ME, EY ME, KPMG ME, BDO ME       🔴      no source — guessed
  Out-of-scope hints  zakat (refused), personal tax advice              🟢      CLAUDE.md §3

**Notice:** sources describe one specific venture (TaxFlow). I framed the
agent around the WIDER category (GCC tax compliance) so any team in the
same space can use it. The venture becomes the Reference Implementation,
not the agent's identity.

⚠ Fields marked 🔴 need your review — I had no direct source for them.
   Run `verify-peers` to do a web search for stronger peer candidates.

Does this framing fit?

  yes               — accept all, jump to Phase 5 (output schemas)
  edit N            — edit field N
  verify-peers      — run web search to propose better peers (uses Firecrawl/Tavily)
  show-source N     — show full quoted evidence for field N
  add-source PATH   — feed me another file, re-synthesize
  too-narrow        — propose a broader domain framing
  too-wide          — propose a narrower domain framing
  restart           — drop the prefill, run the full interview from Phase 1
```

→ Type one option.

### Step 0.5.7 — Resolve the choice

- **`yes`** → capture every proposed value into the running answers, preserving each value's `confidence` and `sources[]` metadata. Mark each field's `origin` as `prefilled` in the running summary (so the user sees later which came from sources vs. typed vs. default). Jump to **Phase 5 — Output schemas**.

- **`edit N`** → ask for the new value for that field only. Update the running answers; set `origin: typed` and `confidence: high` (user-authored is authoritative). Re-display the table. Loop until the user types `yes`.

- **`verify-peers`** → use the available MCP web-search tool (Firecrawl `firecrawl_search` or Tavily) with a query derived from `domain_one_liner` + `geo_scope` (e.g. `"GCC tax compliance firms" comparable peers`). Propose 5–8 candidates with one-line descriptions. Ask the user to pick 3–7. Update `comparable_peers` with `confidence: high` and `sources: [<URL>...]`. Re-display the table. **Do not fabricate peers** — if web search is unavailable, say so and ask the user to provide names.

- **`show-source N`** → print the full quoted evidence for field N (file + lines + quote). Re-display the table after.

- **`add-source PATH`** → verify the path exists, append it to the read set, re-run Step 0.5.4 (synthesize) and Step 0.5.5 (widen). Re-display.

- **`too-narrow`** → re-extract with a wider lens (e.g. "GCC tax compliance" → "MENA regulatory & tax practice"). Re-run auto-checks. Re-display.

- **`too-wide`** → tighten the framing toward the actual specialty (e.g. "MENA fintech" → "merchant-funded loyalty in MENA"). Re-run auto-checks. Re-display.

- **`restart`** → drop the prefill entirely. Continue to Phase 1.

### Anti-patterns in Phase 0.5

- **Don't lock onto one file when more is available.** Always present the ranked list and let the user pick scope.
- **Don't fabricate sources.** If a field is `low` confidence (no source), label it that way — don't manufacture a citation.
- **Don't ever take a product name as the domain.** The product is the Reference Implementation. If you find yourself proposing it, stop and widen.
- **Don't skip the auto-checks.** They exist because LLM extraction will sometimes slip the product into the domain field.
- **Don't show the proposal if `comparable_peers` is empty.** That's the strongest single signal the framing is too narrow. Either widen first, or run `verify-peers` proactively before showing.
- **Don't ask 5 questions to verify the discovery.** One question (Q0.5 list selection), one synthesis pass, one proposal screen.
- **Don't lose the user's overrides.** Once they `edit N`, that field is theirs (`origin: typed`) — don't re-propose it on re-display, even after `add-source`.
- **Don't ignore confidence.** The 🔴 markers tell the user where to focus review. If you proceed without them, the value of confidence collapses.

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

**Q2.0 — Domain or project?** *(framing gate — must be answered first)*

Is this an agent for a DOMAIN, or for ONE specific product / venture?

```
domain   — a body of knowledge that applies to many companies
           (e.g., "merchant-funded loyalty in MENA", "GCC corporate
            gifting governance", "Iraqi K-12 education").
           Reference companies are EXAMPLES, not the agent's identity.

project  — a single product, codebase, or venture's PM work.
           (e.g., "the WhatsApp-Hero Laravel app PM", "Member Plus
            product manager", "RevXAI codebase auditor").
```

→ Type `domain` or `project`.

If `project`: stop. This skill is scoped to **domain experts**, not project agents. A project PM agent is legitimate but is a different shape — use a generic Claude Code subagent with the project's CLAUDE.md as context. Re-invoke this skill only if you can describe the work as a *domain* of which the project is one example.

If `domain`: capture `framing = domain` and continue. The rest of the skill assumes domain framing — every later section (description, Reference implementation, Comparable peers) reinforces it.

Capture: `framing` (must equal `domain` to proceed).

---

**Q2 — Domain in one sentence**

Describe the agent's domain in one sentence.

```
Three useful shapes:
  [market/regulatory] expert for [geography]
  [product practice] expert for [audience]
  [research domain] expert for [user]
```

**The reusability test:** would another company building in this same domain — not your venture — also benefit from this agent? If no, the framing is too narrow. Widen it.

**Anti-pattern (auto-flag):**
- Description leads with `for <ProductName>` or `<ProductName> expert` → reframe.
- Description names a single venture as the agent's purpose → reframe; the venture goes under "Reference implementation" later, not in the description.

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

**Q2c — Reference implementation** *(optional but recommended)*

Is there a venture or product where this domain expert is currently being applied? It will appear in the agent under a `## Reference implementation` section — framed as one example, not the agent's identity.

```
Format:
  Name:     <venture / product>
  Role:     <how the agent serves it — e.g., "advises the team's
            decisions" / "reviews PRDs" / "benchmarks competitors">
  Note:     <one line clarifying that this is one example, not the
            agent's identity>
```

→ Fill in, or type `none`.

Capture: `reference_implementation` (object or null).

**Q2d — Comparable peers / category benchmarks**

List 3–7 peer companies, products, or programs that operate in the same domain. These appear in the agent under `## Comparable peers` and signal that the agent reasons about a *category*, not one product.

```
Examples by domain:
  loyalty / cashback     →  Bilt, Rakuten, Entertainer, Collinson, Sprive
  K-12 education         →  IB, Cambridge, AERO, regional curricula bodies
  GCC gifting governance →  Wrap, Snappy, Reachdesk, Sendoso, regional vendors
  WhatsApp marketing     →  Wati, Gallabox, AiSensy, Twilio, Meta's own BSPs
```

If the user can't list any: that's a strong signal the agent is project-coupled, not a domain expert. Push back once: "Without comparables, the agent has no category to reason against. List 3 — even rough peers."

If still no peers after that one pushback: **return to Q2.0**. The user thought they had a domain but the inability to name 3 peers means it's actually a project. Re-evaluate. Don't paper over it by accepting an empty list — the agent's own eval (cross-venture applicability) will fail without peers, and downstream users will see a hollow shell.

→ List 3–7 names.

Capture: `comparable_peers` (list, must be non-empty to proceed).

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

These slugs are also the CONTRACT category vocabulary — they are emitted
verbatim into the agent frontmatter `categories:` list and become the hub's
`agents.skills`. Do not invent new slugs.

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
   - Emit `name_ar:` and `categories:` in frontmatter per `domain-experts/CONTRACT.md`.
     `categories` = the exact canonical slugs picked in Phase 4. These are how the
     OneStudio hub maps the agent losslessly — a missing/wrong category silently
     drops a skill from the hub.
4. **Show the generated files inline.**
5. **Ask:** *"Save these 3 files? Or say `edit X` first."*
6. **On `save`, write to disk.**

#### Handoff — register in the hub

The agent file is the source of truth. To put this expert in the OneStudio
hub, follow `domain-experts/PLAYBOOK.md`. One `register_my_venture` call
with `expert_spec` (the raw file texts) works for both a new venture and a
pre-existing stub — idempotent, no admin tools, no hand-transcription.

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

### Step R2 — Run the audit

Read the file. Parse YAML frontmatter and body. For each of these 10 dimensions, classify:

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
10. Domain-vs-project   framing leads with a domain (not a product) ·
                        Reference implementation framed as one example ·
                        Comparable peers section listed ·
                        no code-level coupling in body
+ KB scaffold           does agents/<slug>-knowledge/ exist
+ Starter prompts       does examples/<slug>-starter-prompts.yaml exist
```

**Dimension 10 — auto-checks (regex / structural):**

Run all of these against the file. Any flag → mark dimension 10 as ⚠ or ✗.

```
A. Description leads with a product
   regex on `description:` line — flag if matches:
     /\bfor [A-Z][A-Za-z0-9 ]+\b/         e.g. "for Member Plus"
     /\b[A-Z][A-Za-z0-9]+ (PM|product manager|expert)\b/  e.g. "WalletPlus expert"
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

If the agent has zero issues across A–F: ✓ aligned. Otherwise enumerate findings in the audit report (see format below) so the user knows exactly which lines triggered each flag.

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

10. Domain-vs-project framing
    ⚠ description leads with "for Member Plus" — couples agent to one venture
    ✗ no `## Comparable peers` section — agent has no category to reason against
    ⚠ body references specific class `WhatsAppMessageService.php:42`
    → Recommend: reframe description domain-first; add Reference implementation
      + Comparable peers sections; abstract code-level references to category
      terms.

──────────────────────────────────────────────

Sibling files:
   ✗ KB scaffold missing       → will create agents/<slug>-knowledge/
   ✗ Starter prompts missing   → will generate from claimed categories
```

### Step R3 — Walk through changes one by one

After the audit, walk the user through each recommended change INDIVIDUALLY. Same one-question-per-turn pattern as create mode. Same `default-with-WHY` template. Same single-keystroke acceptance.

**For each recommended change in the audit** (in order: dimensions 1–9, then sibling files), ask ONE question:

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

Behavioral rules during R3:

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

### Step R4 — Generate the rewrite (3 files)

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

### Step R5 — Show + save

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
- **Don't paper over project-coupling.** If dimension 10 fires hard (multiple code-level references, "Operating Persona" subtitle, missing Comparables, lead-with-product description), the agent is structurally a project agent — refit alone won't fix it. Tell the user: "This needs a substantive reframe, not a patch. Re-answer Phase 2 (domain framing) and Q2c–d (reference implementation + comparable peers) — I'll regenerate the body around the new framing instead of patching the old one."

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

- **Don't ask 30 questions.** Defaults exist so the user can accept with one keystroke. Total interview should be ~10 user turns (or ~3 turns via Phase 0.5 PRD prefill).
- **Don't take a PRD's product name as the domain.** A PRD describes one product; the agent's domain is the wider *category* that product lives in. The product is always the Reference Implementation, never the agent's identity. The auto-checks in Phase 0.5 enforce this — don't bypass them.
- **Don't reference source agents by name.** Patterns are named by shape, not author.
- **Don't force defaults that don't fit.** Defaults are recommended, not imposed.
- **Don't write code or run benchmarks.** Evaluation is `domain-eval`'s job.
- **Don't impose canonical categories.** If the user's work doesn't map, capture as agent-specific.
- **Don't auto-save.** Wait for `save`.
- **Don't write long sentences.** One idea per sentence. Simple verbs.
